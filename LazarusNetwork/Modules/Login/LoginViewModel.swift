//
//  LoginViewModel.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 01.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import Foundation

protocol LoginModellable: Model {
    func register(userName: String, email: String, password: String)
}

class LoginModel: LoginModellable {
    func register(userName: String, email: String, password: String) {
        NetworkManager.shared.register(userName: userName, email: email, password: password) { result ,_ in
            
        }
    }
}
