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
        
        let presenter = RegistrationPresenter(with: LoginModel())
        viewController.presenter = presenter
        presenter.controller = viewController
        
        presenter.onRegistered = { [weak viewController] domain in
            viewController?.removeWaitingDialog()
            let configurator = DomainsListConfigurator()
//            configurator.email = email
            guard let navigationController = viewController?.navigationController else {
                return
            }
            DispatchQueue.main.async {
                navigationController.pushViewController(configurator.controller, animated: true)
            }
        }
        
        return viewController
    }
}
