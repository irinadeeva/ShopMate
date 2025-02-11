//
//  ItemSearchInteractor.swift
//  Super easy dev
//
//  Created by Irina Deeva on 11/02/25
//

protocol ItemSearchInteractorProtocol: AnyObject {
}

class ItemSearchInteractor: ItemSearchInteractorProtocol {
    weak var presenter: ItemSearchPresenterProtocol?
}
