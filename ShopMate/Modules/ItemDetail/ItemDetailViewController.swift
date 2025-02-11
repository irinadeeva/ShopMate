//
//  ItemDetailViewController.swift
//  Super easy dev
//
//  Created by Irina Deeva on 11/02/25
//

import UIKit

protocol ItemDetailViewProtocol: AnyObject {
}

class ItemDetailViewController: UIViewController {
    // MARK: - Public
    var presenter: ItemDetailPresenterProtocol?

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
}

// MARK: - Private functions
private extension ItemDetailViewController {
    func initialize() {
    }
}

// MARK: - ItemDetailViewProtocol
extension ItemDetailViewController: ItemDetailViewProtocol {
}
