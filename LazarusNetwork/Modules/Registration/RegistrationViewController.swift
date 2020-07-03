//
//  RegistrationViewController.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 03.07.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

extension Constants.Strings {
    static let joinUsTitle = "Join Us".localized
    static let registerButtonTitle = "Register".localized
    static let userNameTitle = "Username".localized
    static let emailTitle = "E-mail".localized
    static let passwordTitle = "Password".localized
}

protocol RegistrationViewControllable: ViewController {
    func populateFields()
}

class RegistrationViewController: BaseViewController {
    @IBOutlet weak var containerScrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var joinUsLabel: UILabel!

    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideKeyboardWhenTappedAround()
    }
    
    func populateFields() {
        registerButton.titleLabel?.text = Constants.Strings.registerButtonTitle
        userNameLabel.text = Constants.Strings.userNameTitle
        emailLabel.text = Constants.Strings.emailTitle
        passwordLabel.text = Constants.Strings.passwordTitle
        joinUsLabel.text = Constants.Strings.joinUsTitle
        
        checkEnabledRegisterButton()
    }
    
    @IBAction func textFieldEditingChanged(_ sender: Any) {
        guard let sender = sender as? UITextField, let text = sender.text else {
            return
        }
        if sender == userNameTextField {
            userNameLabel.isHidden = !text.isEmpty
        } else if sender == emailTextField {
            emailLabel.isHidden = !text.isEmpty
        } else if sender == passwordTextField {
            passwordLabel.isHidden = !text.isEmpty
        }
        
        checkEnabledRegisterButton()
    }
    
    func checkEnabledRegisterButton() {
        guard let userBool = userNameTextField.text?.isEmpty,
            let emailBool = emailTextField.text?.isEmpty,
            let passwordBool = passwordTextField.text?.isEmpty else {
                return
        }
        registerButton.backgroundColor = registerButton.backgroundColor?.withAlphaComponent(!userBool && !emailBool && !passwordBool ? 1 : 0.5)
        registerButton.isEnabled = !userBool && !emailBool && !passwordBool
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        currentPresenter.registerSelected(userName: userNameTextField.text ?? "",
                                          email: emailTextField.text ?? "",
                                          password: passwordTextField.text ?? "")
    }
}

extension RegistrationViewController: RegistrationViewControllable {
    
}

extension RegistrationViewController: ViewControllerWithDefinedPresenter {
    typealias CurrentPresenter = RegistrationPresentable
}

extension RegistrationViewController: UITextFieldDelegate {
    
}
