import Foundation

public protocol MainInteracting {
    func displayCep(_ cep: String)
    func clearText() -> String?
}

public final class MainInteractor {
    
    private let presenter: MainPresenting
    private let service: MainServicing
    
    public init(presenter: MainPresenting, service: MainServicing) {
        self.presenter = presenter
        self.service = service
    }
}

extension MainInteractor: MainInteracting {
    public func displayCep(_ cep: String) {
        service.fetchDataCep(cep) { [weak self] result in
            switch result {
            case let .success(cep):
                self?.presenter.presentCep(cep)
            case let .failure(error):
                self?.presenter.displayError(
                    error.localizedDescription
                )
            }
        }
    }
    
    public func clearText() -> String? {
        return nil
    }
}
