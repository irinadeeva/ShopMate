//
//  Item.swift
//  ShopMate
//
//  Created by Irina Deeva on 11/02/25.
//

import Foundation

struct Item: Decodable, Identifiable {
  let id: Int
  let title: String
  let price: Int
  let description: String
  let images: [String]
  let category: Category
}
