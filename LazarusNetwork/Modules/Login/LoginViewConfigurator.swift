//
//  LoginViewConfigurator.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 01.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

class LogInConfigurator: BaseConfiguratorContainingControllerType {
    let isLoadedWithPrefilledControllers: Bool
    
    private let type: ControllerCreationable
    
    init(isLoadedWithPrefilledControllers: Bool = true) {
        self.isLoadedWithPrefilledControllers = isLoadedWithPrefilledControllers
        
        type = StartUpFlowType.loggedOut

        super.init(with: type)
        
        isFirstInFlow = true
    }
    
    override func generateController() -> UIViewController {
        guard let createdController = ControllerCreationFabric.default.controller(for: controllerType) as? LoginViewController else {
            return UIViewController()
        }
        
        let model = LoginModel()
        let presenter = LogInPresenter(with: model)
        
        presenter.controller = createdController
        createdController.presenter = presenter
        
        presenter.onLoggedIn = { [weak createdController] email in
            createdController?.removeWaitingDialog()
            let configurator = DomainsListConfigurator()
            configurator.email = email
            guard let navigationController = createdController?.navigationController else {
                return
            }
            DispatchQueue.main.async {
                navigationController.pushViewController(configurator.controller, animated: true)
            }
        }
        
        presenter.onRegister = { [weak createdController] in
            createdController?.removeWaitingDialog()
            let configurator = RegistrationConfigurator()
            guard let navigationController = createdController?.navigationController else {
                return
            }
            DispatchQueue.main.async {
                navigationController.pushViewController(configurator.controller, animated: true)
            }
        }
        
        return createdController
    }
}

