import UIKit

public enum MainFactory {
    static func make() -> UIViewController {
        let service = MainService(networking: Networking())
        let presenter = MainPresenter()
        let interactor = MainInteractor(presenter: presenter, service: service)
        let mainView = MainView(interactor)
        let viewController = MainViewController(mainView)
        presenter.mainView = mainView
        return viewController
    }
}
