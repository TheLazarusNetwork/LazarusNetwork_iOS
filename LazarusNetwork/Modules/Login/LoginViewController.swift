//
//  LoginViewController.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 01.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

protocol LoginViewControllable: ViewController {
    
}

class LoginViewController: BaseViewController {
    @IBOutlet weak var containerScrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var logInButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUiComponents()
    }
    
    @IBAction func logInButtonSelected(_ sender: Any) {
        let credentionals = Credentionals(login: loginTextField.text ?? "", password: passwordTextField.text ?? "")
        currentPresenter.loginSelected(type: .existedUser, credentials: credentionals)
    }
    
    @IBAction func loginAsNewUserSelected(_ sender: UIButton) {
        let credentionals = Credentionals(login: loginTextField.text ?? "",
                                          password: passwordTextField.text ?? "")
        currentPresenter.loginSelected(type: .newUser, credentials: credentionals)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideKeyboardWhenTappedAround()
    }
    
    private func configureUiComponents() {
        
    }
}

extension LoginViewController: LoginViewControllable {
}

extension LoginViewController: ViewControllerWithDefinedPresenter {
    typealias CurrentPresenter = LoginPresentable
}

