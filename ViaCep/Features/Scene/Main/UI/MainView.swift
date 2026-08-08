import UIKit

public protocol MainViewProtocol: AnyObject {
    func didPresentCep(_ cep: DataCep)
    func didShowErrorMessage(_ message: String)
}

public final class MainView: UIView {
    public enum Layout {}
    private var interactor: MainInteracting
    public var alert: ((String) -> Void)?
    
    private lazy var stackViewContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .fill
        stack.setCustomSpacing(30, after: searchCepButton)
        return stack
    }()
    
    public lazy var inputedCepTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Digite um cep válido"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.accessibilityIdentifier = "inputedCepTextField"
        return textField
    }()
    
    public lazy var searchCepButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Buscar Cep", for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 8
        button.accessibilityIdentifier = "searchCepButton"
        button.addTarget(self, action: #selector(didSearchCep), for: .touchUpInside)
        return button
    }()
    
    lazy var logradouroLabel = makeLabel()
    lazy var bairroLabel = makeLabel()
    lazy var localidadeLabel = makeLabel()
    
    init(_ interactor: MainInteracting) {
        self.interactor = interactor
        super.init(frame: .null)
        buildViews()
        pin()
        extraConfig()
    }
    
    required init?(coder: NSCoder) { nil }
}

extension MainView {
    @objc
    private func didSearchCep() {
        searchCep()
    }
}

extension MainView {
    private func makeLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .boldSystemFont(ofSize: Layout.Size.constant)
        return label
    }
    
    public func didClearText() {
        logradouroLabel.text = ""
        bairroLabel.text = ""
        localidadeLabel.text = ""
    }
    
    func searchCep() {
        if let cep = inputedCepTextField.text {
            interactor.displayCep(cep)
            inputedCepTextField.text = ""
        }
    }
    
    private func didDisplayCep(_ cep: DataCep) {
        DispatchQueue.main.async { [weak self] in
            guard self != nil else { return }
            self?.logradouroLabel.text = "Logradouro: \(cep.logradouro)"
            self?.bairroLabel.text = "Bairro: \(cep.bairro)"
            self?.localidadeLabel.text = "Localidade: \(cep.localidade)"
        }
    }
}

extension MainView: MainViewProtocol {
    public func didPresentCep(_ cep: DataCep) {
        didDisplayCep(cep)
    }
    
    public func didShowErrorMessage(_ message: String) {
        DispatchQueue.main.async { [weak self] in
            guard self != nil else { return }
            self?.didClearText()
            self?.alert?(message)
        }
    }
}

extension MainView {
    private func buildViews() {
        [inputedCepTextField,
         searchCepButton,
         logradouroLabel,
         bairroLabel,
         localidadeLabel
        ].forEach { subViews in
            stackViewContainer.addArrangedSubview(subViews)
        }
        stackViewContainer.setCustomSpacing(30, after: searchCepButton)
        addSubview(stackViewContainer)
    }
    
    private func pin() {
        NSLayoutConstraint.pin([
            stackViewContainer.topAnchor.constraint(
                equalToSystemSpacingBelow: safeAreaLayoutGuide.topAnchor,
                multiplier: 1.0
            ),
            
            stackViewContainer.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: Layout.Size.constant
            ),
            
            stackViewContainer.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor,
                constant: -Layout.Size.constant
            ),
            
            searchCepButton.heightAnchor.constraint(
                equalToConstant: Layout.Size.height
            ),
            
            inputedCepTextField.heightAnchor.constraint(
                equalToConstant: Layout.Size.textFieldHeight
            )
        ])
    }
    
    func extraConfig() {
        backgroundColor = .systemBackground
    }
}

private extension MainView.Layout {
    enum Size {
        static let constant: CGFloat = 16
        static let height: CGFloat = 40
        static let textFieldHeight: CGFloat = 60
        
        static let colors: UIColor = .init(
            red: 210/255,
            green: 210/255,
            blue: 210/255,
            alpha: 1.0
        )
    }
}
