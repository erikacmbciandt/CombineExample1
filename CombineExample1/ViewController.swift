//
//  ViewController.swift
//  CombineExample1
//
//  Created by Erika C. Matesz Bueno on 02/09/22.
//

import Combine
import UIKit

class ViewController: UIViewController {

    // MARK: Published Properties

    @Published private var acceptedTerms = false
    @Published private var acceptedPrivacy = false
    @Published private var name = ""

    // MARK: Properties

    private var buttonSubscriber: AnyCancellable?

    private var validToSubmit: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest3($acceptedTerms, $acceptedPrivacy, $name)
            .map { terms, privacy, name in
                return terms && privacy && !name.isEmpty
            }
            .eraseToAnyPublisher()
    }

    // MARK: UI Elements

    private lazy var termsLabel: UILabel = {
        let element = UILabel()
        element.translatesAutoresizingMaskIntoConstraints = false
        element.text = "Aceito os termos de uso do app"
        element.adjustsFontSizeToFitWidth = true
        element.textAlignment = .left
        return element
    }()

    private lazy var termsSwitch: UISwitch = {
        let element = UISwitch()
        element.translatesAutoresizingMaskIntoConstraints = false
        element.addTarget(self, action: (#selector(didAcceptedTerms)), for: .touchUpInside)
        return element
    }()

    private lazy var privacyLabel: UILabel = {
        let element = UILabel()
        element.translatesAutoresizingMaskIntoConstraints = false
        element.text = "Aceito a política de privacidade"
        element.adjustsFontSizeToFitWidth = true
        element.textAlignment = .left
        return element
    }()

    private lazy var privacySwitch: UISwitch = {
        let element = UISwitch()
        element.translatesAutoresizingMaskIntoConstraints = false
        element.addTarget(self, action: (#selector(didAcceptedPrivacy)), for: .touchUpInside)
        return element
    }()

    private lazy var nameTextField: UITextField = {
        let element = UITextField()
        element.translatesAutoresizingMaskIntoConstraints = false
        element.placeholder = "Digite seu nome"
        element.borderStyle = .line
        element.addTarget(self, action: (#selector(didNameChange)), for: .editingChanged)
        return element
    }()

    private lazy var submitButton: UIButton = {
        let element = UIButton()
        element.translatesAutoresizingMaskIntoConstraints = false
        element.setTitle("Enviar", for: .normal)
        element.setTitleColor(.blue, for: .normal)
        element.setTitleColor(.green, for: .highlighted)
        element.setTitleColor(.darkGray, for: .disabled)
        element.addTarget(self, action: (#selector(submit)), for: .touchUpInside)
        return element
    }()

    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindSubscriberToPublisher()
    }

    // MARK: Methods

    private func setupUI() {
        view.backgroundColor = .systemGray6

        view.addSubview(termsLabel)
        view.addSubview(termsSwitch)
        view.addSubview(privacyLabel)
        view.addSubview(privacySwitch)
        view.addSubview(nameTextField)
        view.addSubview(submitButton)

        termsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        termsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        termsLabel.trailingAnchor.constraint(equalTo: termsSwitch.leadingAnchor, constant: -10).isActive = true
        termsLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        termsLabel.widthAnchor.constraint(equalToConstant: 220).isActive = true

        termsSwitch.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        termsSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        termsSwitch.leadingAnchor.constraint(equalTo: termsLabel.trailingAnchor, constant: 10).isActive = true

        privacyLabel.topAnchor.constraint(equalTo: termsLabel.bottomAnchor, constant: 10).isActive = true
        privacyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        privacyLabel.trailingAnchor.constraint(equalTo: privacySwitch.leadingAnchor, constant: -10).isActive = true
        privacyLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        privacyLabel.widthAnchor.constraint(equalToConstant: 220).isActive = true

        privacySwitch.topAnchor.constraint(equalTo: termsLabel.bottomAnchor, constant: 10).isActive = true
        privacySwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        privacySwitch.leadingAnchor.constraint(equalTo: privacyLabel.trailingAnchor, constant: 10).isActive = true

        nameTextField.topAnchor.constraint(equalTo: privacyLabel.bottomAnchor, constant: 15).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true

        submitButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 15).isActive = true
        submitButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
        submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    private func bindSubscriberToPublisher() {
        buttonSubscriber = validToSubmit
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: submitButton)
    }

    @objc private func didAcceptedTerms() {
        acceptedTerms = termsSwitch.isOn
    }

    @objc private func didAcceptedPrivacy() {
        acceptedPrivacy = privacySwitch.isOn
    }

    @objc private func didNameChange() {
        name = nameTextField.text ?? ""
    }

    @objc private func submit() {
        print("O botão foi clicado e o nome é \(name).")
    }

}
