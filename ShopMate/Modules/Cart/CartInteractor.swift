protocol CartInteractorProtocol: AnyObject {
}

class CartInteractor: CartInteractorProtocol {
    weak var presenter: CartPresenterProtocol?
}
