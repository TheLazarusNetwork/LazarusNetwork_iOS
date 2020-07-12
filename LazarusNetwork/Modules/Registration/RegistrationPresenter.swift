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
    
    var onRegistered: Model.EmptyOptionalHandler { get set }
    
    func closeScreen()
    func registerSelected(userName: String, email: String, password: String)
}

class RegistrationPresenter: RegistrationPresentable {
    weak var controller: RegistrationViewControllable?
    
    var onRegistered: Model.EmptyOptionalHandler = nil
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
       
        guard model.validateEmail(email: email) else {
           controller?.removeWaitingDialog()
           controller?.show(alertWithMessage: Constants.Strings.invalidEmail,
                            andTitle: Constants.Strings.errorTitle)
           return
        }
        model.register(userName: userName, email: email, password: password) { [weak self] user, result in
            switch result {
            case .error(let error):
                self?.controller?.removeWaitingDialog()
                self?.controller?.show(alertWithMessage: error)
                break
                
            case .success, .emptySuccess, .none:
                self?.controller?.removeWaitingDialog()
                guard let message = user?.message else {
                    self?.controller?.show(alertWithMessage: Constants.Strings.smthWrong)
                    return
                }
                self?.controller?.showSuccessMessage(message: message, title: Constants.Strings.successCreatingTitle)
            }
        }
    }
    
    func closeScreen() {
        onRegistered?()
    }
}
