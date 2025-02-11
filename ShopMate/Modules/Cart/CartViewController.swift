//
//  CartViewController.swift
//  Super easy dev
//
//  Created by Irina Deeva on 11/02/25
//

import UIKit

protocol CartViewProtocol: AnyObject {
}

class CartViewController: UIViewController {
    // MARK: - Public
    var presenter: CartPresenterProtocol?

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
}

// MARK: - Private functions
private extension CartViewController {
    func initialize() {
    }
}

// MARK: - CartViewProtocol
extension CartViewController: CartViewProtocol {
}
