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
    static let emptyPassword = "Password field cant be empty".localized
    static let loginFailed = "User name or password fields are incorrect".localized

}

enum LoginType {
    case existedUser
    case newUser
}

protocol LoginPresentable: Presenter {
    var controller: LoginViewControllable? { get set }
    
    var onLoggedIn: Model.StringOptionalHandler { get set }
    
    func loginSelected(type: LoginType, credentials: Credentionals)
}

class LogInPresenter: LoginPresentable {
    weak var controller: LoginViewControllable?
    
    var onLoggedIn: Model.StringOptionalHandler = nil
    
    private let model: LoginModellable
    
    init(with model: LoginModellable) {
        self.model = model
    }
    
    func viewLoaded() {
        
    }
    
    func loginSelected(type: LoginType, credentials: Credentionals) {
        guard !credentials.login.isEmpty else {
            controller?.show(alertWithMessage: Constants.Strings.emptyUserName,
                             andTitle: Constants.Strings.errorTitle)
            return
        }
        guard !credentials.password.isEmpty else {
            controller?.show(alertWithMessage: Constants.Strings.emptyPassword,
                             andTitle: Constants.Strings.errorTitle)
            return
        }
        
        guard validate(credentials: credentials) else {
            controller?.show(alertWithMessage: Constants.Strings.emptyPassword,
                             andTitle: Constants.Strings.errorTitle)
            return
        }
        
        onLoggedIn?(credentials.login)
    }
    
    func validate(credentials: Credentionals) -> Bool {
        return true
    }
}
