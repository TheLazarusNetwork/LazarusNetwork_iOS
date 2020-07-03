//
//  RegistrationPresenter.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 03.07.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

protocol RegistrationPresentable: Presenter {
    var controller: RegistrationViewControllable? { get set }
    
    var onRegistered: Model.StringOptionalHandler { get set }
    
    func registerSelected(userName: String, email: String, password: String)
}

class RegistrationPresenter: RegistrationPresentable {
    weak var controller: RegistrationViewControllable?
    
    var onRegistered: Model.StringOptionalHandler = nil
    
    private let model: LoginModellable
    
    init(with model: LoginModellable) {
        self.model = model
    }
    
    func viewLoaded() {
        controller?.populateFields()
    }
    
    func registerSelected(userName: String, email: String, password: String) {
        controller?.showWaitingDialog()
        guard !userName.isEmpty else {
            controller?.removeWaitingDialog()
            controller?.show(alertWithMessage: Constants.Strings.emptyUserName,
                             andTitle: Constants.Strings.errorTitle)
            return
        }
        guard !email.isEmpty else {
            controller?.removeWaitingDialog()
            controller?.show(alertWithMessage: Constants.Strings.emptyEmail,
                             andTitle: Constants.Strings.errorTitle)
            return
        }
        
        guard !password.isEmpty else {
            controller?.removeWaitingDialog()
            controller?.show(alertWithMessage: Constants.Strings.emptyPassword,
                             andTitle: Constants.Strings.errorTitle)
            return
        }
       
        guard validateEmail(email: email) else {
           controller?.removeWaitingDialog()
           controller?.show(alertWithMessage: Constants.Strings.invalidEmail,
                            andTitle: Constants.Strings.errorTitle)
           return
       }
        model.register(userName: userName, email: email, password: password)
    }
    
    func validateEmail(email: String) -> Bool {
           let emailRegEx = "(?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}
