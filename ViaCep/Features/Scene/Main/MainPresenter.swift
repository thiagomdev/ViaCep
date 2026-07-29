import UIKit

public protocol MainPresenting {
    func presentCep(_ cep: DataCep)
    func displayError(_ message: String)
}

public final class MainPresenter {
    public weak var mainView: MainViewProtocol?
    
    public init() {}
}

extension MainPresenter: MainPresenting {
    public func presentCep(_ cep: DataCep) {
        mainView?.didPresentCep(cep)
    }
    
    public func displayError(_ message: String) {
        mainView?.didShowErrorMessage(message)
    }
}
