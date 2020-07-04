//
//  LoginViewPresenter.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 01.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

extension Constants.Strings {
    static let emptyUserName = "User name field cant be empty".localized
    static let emptyEmail = "Email field cant be empty".localized
    static let emptyPassword = "Password field cant be empty".localized
    static let invalidEmail = "Inserted email is invalid".localized
    static let loginFailed = "User name or password fields are incorrect".localized

}

extension Constants {
    static let googleUserId = "1061082168103-7cr35dnuf77l0imak0q5vc9u21bai666.apps.googleusercontent.com"
}

enum LoginType {
    case existedUser
    case newUser
}

enum LoginProvider {
    case google
    case facebook
}

protocol LoginPresentable: Presenter {
    var controller: LoginViewControllable? { get set }
    
    var onLoggedIn: Model.StringOptionalHandler { get set }
    var onRegister: Model.EmptyOptionalHandler { get set }

    func loginSelected(type: LoginType, credentials: Credentionals)
    func login(token: String, provider: LoginProvider)
}

class LogInPresenter: LoginPresentable {
    weak var controller: LoginViewControllable?
    
    var onLoggedIn: Model.StringOptionalHandler = nil
    var onRegister: Model.EmptyOptionalHandler = nil

    private let model: LoginModellable
    
    init(with model: LoginModellable) {
        self.model = model
    }
    
    func viewLoaded() {
    }
    
    func loginSelected(type: LoginType, credentials: Credentionals) {
        controller?.showWaitingDialog()
        switch type {
        case .existedUser:
            loginAsExistingUser(credentials: credentials)
            
        case .newUser:
            onRegister?()
        }
    }
    
    func loginAsExistingUser(credentials: Credentionals) {
        guard !credentials.login.isEmpty else {
            controller?.removeWaitingDialog()
            controller?.show(alertWithMessage: Constants.Strings.emptyUserName,
                             andTitle: Constants.Strings.errorTitle)
            return
        }
        guard !credentials.password.isEmpty else {
            controller?.removeWaitingDialog()
            controller?.show(alertWithMessage: Constants.Strings.emptyPassword,
                             andTitle: Constants.Strings.errorTitle)
            return
        }
        
        guard validate(credentials: credentials) else {
            controller?.removeWaitingDialog()
            controller?.show(alertWithMessage: Constants.Strings.emptyPassword,
                             andTitle: Constants.Strings.errorTitle)
            return
        }
        
        onLoggedIn?(credentials.login)
    }
    
    func login(token: String, provider: LoginProvider) {
        controller?.showWaitingDialog()
        model.loginWithSocial(token: token, provider: provider) { [weak self] in
            self?.controller?.removeWaitingDialog()
            self?.onLoggedIn?(.empty)

        }
    }
    
    func validate(credentials: Credentionals) -> Bool {
        return true
    }
}
