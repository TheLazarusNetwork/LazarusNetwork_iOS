//
//  LoginViewPresenter.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 01.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

protocol LoginPresentable: Presenter {
    var controller: LoginViewControllable? { get set }
    
    var onLoggedIn: Model.EmptyOptionalHandler { get set }
}

class LogInPresenter: LoginPresentable {
    weak var controller: LoginViewControllable?
    
    var onLoggedIn: Model.EmptyOptionalHandler = nil
    
    private let model: LoginModellable
    
    init(with model: LoginModellable) {
        self.model = model
    }
    
    func viewLoaded() {
    }
}
