//
//  RegistrationConfigurator.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 03.07.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

class RegistrationConfigurator: BaseConfigurator {
    
    override func generateController() -> UIViewController {
        let controllerType: Controllers = .registration

        guard let viewController = ControllerCreationFabric.default.controller(for: controllerType) as? RegistrationViewController else {
            return UIViewController()
        }
        
        let presenter = RegistrationPresenter(with: LoginModel(manager: AuthorizationFacade()))
        viewController.presenter = presenter
        presenter.controller = viewController
        
        presenter.onRegistered = { [weak viewController] in
            DispatchQueue.main.async {
                guard let navigationController = viewController?.navigationController else {
                    return
                }
                navigationController.popViewController(animated: true)
            }
        }
        
        return viewController
    }
}
