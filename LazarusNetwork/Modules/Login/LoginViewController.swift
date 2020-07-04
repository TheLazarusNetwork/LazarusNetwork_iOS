//
//  LoginViewController.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 01.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit
import GoogleSignIn

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
        hideKeyboardWhenTappedAround()

        GIDSignIn.sharedInstance().clientID = Constants.googleUserId
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        passwordTextField.text = .empty
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
    
    private func configureUiComponents() {
        
    }
}

extension LoginViewController: LoginViewControllable {
}

extension LoginViewController: ViewControllerWithDefinedPresenter {
    typealias CurrentPresenter = LoginPresentable
}

extension LoginViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            removeWaitingDialog()
        } else {
            if let authToken = user.authentication.accessToken {
                currentPresenter.login(token: authToken, provider: .google)
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
      // Perform any operations when the user disconnects from app here.
      // ...
    }
}

