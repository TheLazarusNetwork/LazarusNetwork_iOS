//
//  LoginViewModel.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 01.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import Foundation

protocol LoginModellable: Model {
    func register(userName: String, email: String, password: String, handler: @escaping DataRequestHandler<User>)
    func loginWithSocial(token: String, provider: LoginProvider, handler: @escaping DataRequestHandler<User>)
    func login(email: String, password: String, handler: @escaping DataRequestHandler<User>)
    
    func validateEmail(email: String) -> Bool
}

class LoginModel: LoginModellable {
    let manager: AuthorizationFacadeProtocol
    
    init(manager: AuthorizationFacadeProtocol) {
        self.manager = manager
    }
    
    func register(userName: String, email: String, password: String, handler: @escaping DataRequestHandler<User>) {
        guard let userRegisterRequest = UseRegisterRequest(userName: userName, email: email, password: password).createRequest() else {
            handler(nil, .error(Constants.Strings.endPointError))
            return
        }
        manager.send(request: userRegisterRequest) { (user, result) in
            handler(user, result)
        }
    }
    
    func loginWithSocial(token: String, provider: LoginProvider, handler: @escaping DataRequestHandler<User>) {
        guard let userSocialRequest = UserSocialLoginRequest(token: token, provider: provider).createRequest() else {
            handler(nil, .error(Constants.Strings.endPointError))
            return
        }
        manager.send(request: userSocialRequest) { (user, result) in
            handler(user, result)
        }
    }
    
    func login(email: String, password: String, handler: @escaping DataRequestHandler<User>) {
        guard let userSocialRequest = UserLoginRequest(email: email, password: password).createRequest() else {
            handler(nil, .error(Constants.Strings.endPointError))
            return
        }
        manager.send(request: userSocialRequest) { (user, result) in
            handler(user, result)
        }
    }
    
    func validateEmail(email: String) -> Bool {
           let emailRegEx = "(?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}
