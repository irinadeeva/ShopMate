//
//  CartInteractor.swift
//  Super easy dev
//
//  Created by Irina Deeva on 11/02/25
//

protocol CartInteractorProtocol: AnyObject {
}

class CartInteractor: CartInteractorProtocol {
    weak var presenter: CartPresenterProtocol?
}
