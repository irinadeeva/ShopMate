//
//  ItemDetailInteractor.swift
//  Super easy dev
//
//  Created by Irina Deeva on 11/02/25
//

protocol ItemDetailInteractorProtocol: AnyObject {
}

class ItemDetailInteractor: ItemDetailInteractorProtocol {
    weak var presenter: ItemDetailPresenterProtocol?
}
