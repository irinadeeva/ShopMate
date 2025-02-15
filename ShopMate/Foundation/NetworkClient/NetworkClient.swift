import Foundation

enum NetworkClientError: Error, ErrorWithMessage {
  case httpStatusCode(Int)
  case urlRequestError(Error)
  case urlSessionError
  case parsingError
  
  var message: String {
    switch self {
    case .httpStatusCode(let code):
      return "Network error: HTTP status \(code)"
    case .urlRequestError(let urlError):
      return "Request error: \(urlError.localizedDescription)"
    case .urlSessionError:
      return "Connection error: please check your internet"
    case .parsingError:
      return "Data parsing error: please try again"
    }
  }
}

protocol NetworkClient {
  @discardableResult
  func send(request: NetworkRequest,
            completionQueue: DispatchQueue,
            onResponse: @escaping (Result<Data, Error>) -> Void) -> NetworkTask?
  
  @discardableResult
  func send<T: Decodable>(request: NetworkRequest,
                          type: T.Type,
                          completionQueue: DispatchQueue,
                          onResponse: @escaping (Result<T, Error>) -> Void) -> NetworkTask?
}

extension NetworkClient {
  
  @discardableResult
  func send(request: NetworkRequest,
            onResponse: @escaping (Result<Data, Error>) -> Void) -> NetworkTask? {
    send(request: request, completionQueue: .main, onResponse: onResponse)
  }
  
  @discardableResult
  func send<T: Decodable>(request: NetworkRequest,
                          type: T.Type,
                          onResponse: @escaping (Result<T, Error>) -> Void) -> NetworkTask? {
    send(request: request, type: type, completionQueue: .main, onResponse: onResponse)
  }
}

struct DefaultNetworkClient: NetworkClient {
  private let session: URLSession
  private let decoder: JSONDecoder
  private let encoder: JSONEncoder
  
  init(session: URLSession = URLSession.shared,
       decoder: JSONDecoder = JSONDecoder(),
       encoder: JSONEncoder = JSONEncoder()) {
    self.session = session
    self.decoder = decoder
    self.encoder = encoder
  }
  
  @discardableResult
  func send(
    request: NetworkRequest,
    completionQueue: DispatchQueue,
    onResponse: @escaping (Result<Data, Error>) -> Void
  ) -> NetworkTask? {
    let onResponse: (Result<Data, Error>) -> Void = { result in
      completionQueue.async {
        onResponse(result)
      }
    }
    guard let urlRequest = create(request: request) else { return nil }
    
    let task = session.dataTask(with: urlRequest) { data, response, error in
      guard let response = response as? HTTPURLResponse else {
        onResponse(.failure(NetworkClientError.urlSessionError))
        return
      }
      
      guard 200 ..< 300 ~= response.statusCode else {
        onResponse(.failure(NetworkClientError.httpStatusCode(response.statusCode)))
        return
      }
      
      if let data = data {
        onResponse(.success(data))
        return
      } else if let error = error {
        onResponse(.failure(NetworkClientError.urlRequestError(error)))
        return
      } else {
        assertionFailure("Unexpected condition!")
        return
      }
    }
    
    task.resume()
    
    return DefaultNetworkTask(dataTask: task)
  }
  
  @discardableResult
  func send<T: Decodable>(
    request: NetworkRequest,
    type: T.Type,
    completionQueue: DispatchQueue,
    onResponse: @escaping (Result<T, Error>) -> Void
  ) -> NetworkTask? {
    return send(request: request, completionQueue: completionQueue) { result in
      switch result {
      case let .success(data):
        self.parse(data: data, type: type, onResponse: onResponse)
      case let .failure(error):
        onResponse(.failure(error))
      }
    }
  }
  
  private func create(request: NetworkRequest) -> URLRequest? {
    
    guard var urlComponents = URLComponents(string: request.endpoint) else { return nil }
    
    if !request.queryItems.isEmpty {
      urlComponents.queryItems = request.queryItems
    }
    
    guard let url = urlComponents.url else { return nil }
    
    var urlRequest = URLRequest(url: url)
    
    urlRequest.httpMethod = request.httpMethod.rawValue
    
    return urlRequest
  }
  
  private func parse<T: Decodable>(data: Data, type _: T.Type, onResponse: @escaping (Result<T, Error>) -> Void) {
    do {
      let response = try decoder.decode(T.self, from: data)
      onResponse(.success(response))
    } catch {
      onResponse(.failure(NetworkClientError.parsingError))
    }
  }
}
