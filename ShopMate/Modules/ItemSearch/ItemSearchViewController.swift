//
//  ItemSearchViewController.swift
//  Super easy dev
//
//  Created by Irina Deeva on 11/02/25
//

import UIKit

protocol ItemSearchViewProtocol: AnyObject {
}

class ItemSearchViewController: UIViewController {
    // MARK: - Public
    var presenter: ItemSearchPresenterProtocol?

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
}

// MARK: - Private functions
private extension ItemSearchViewController {
    func initialize() {
    }
}

// MARK: - ItemSearchViewProtocol
extension ItemSearchViewController: ItemSearchViewProtocol {
}
