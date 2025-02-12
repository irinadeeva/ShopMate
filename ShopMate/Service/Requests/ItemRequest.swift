//
//  ItemRequest.swift
//  ShopMate
//
//  Created by Irina Deeva on 12/02/25.
//

import Foundation

struct ItemRequest: NetworkRequest {
  var dto: Data?

  var httpMethod: HttpMethod { .get }

  var endpoint = "\(RequestConstants.baseURL)/api/v1/products"
}
