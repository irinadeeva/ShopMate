import UIKit
import ProgressHUD

protocol LoadingView {
  var activityIndicator: UIActivityIndicatorView { get }
  func showLoading()
  func hideLoading()
}

extension LoadingView {
  func showLoading() {
    DispatchQueue.main.async {
      activityIndicator.startAnimating()
    }
  }
  
  func hideLoading() {
    DispatchQueue.main.async {
      activityIndicator.stopAnimating()
    }
  }
}

extension LoadingView {
  private static var window: UIWindow? {
    return UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap { $0.windows }
      .first { $0.isKeyWindow }
  }
  
  func showLoadingAndBlockUI() {
    DispatchQueue.main.async {
      Self.window?.isUserInteractionEnabled = false
      self.activityIndicator.startAnimating()
    }
  }
  
  func hideLoadingAndUnblockUI() {
    DispatchQueue.main.async {
      Self.window?.isUserInteractionEnabled = true
      self.activityIndicator.stopAnimating()
    }
  }
}
