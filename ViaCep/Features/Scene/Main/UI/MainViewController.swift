import UIKit

public final class MainViewController: UIViewController {
    private let main: MainView
    
    init(_ main: MainView) {
        self.main = main
        super.init(nibName: nil, bundle: nil)
    }
    
    public override func loadView() {
        super.loadView()
        view = main
      
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAlert()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainViewController {
    private func showAlert() {
        main.alert = { [weak self] cep in
            guard self != nil else { return }
            let alert = UIAlertController(
                title: "Olá, tudo bem?",
                message: "Este CEP não existe ou é um CEP invádo. Por favor, tente novamente!",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "FECHAR", style: .default))
            self?.present(alert, animated: true)
        }
    }
}
