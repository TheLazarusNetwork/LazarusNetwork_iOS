//
//  AddDomainConfigurator.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 07.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

class AddDomainConfigurator: BaseConfigurator {
    var email: String = ""
    
    override func generateController() -> UIViewController {
        let controllerType: Controllers = .addDomain

        guard let viewController = ControllerCreationFabric.default.controller(for: controllerType) as? AddDomainController else {
            return UIViewController()
        }
        
        let presenter = AddDomainPresenter(with: AddDomainModel(with: email))
        viewController.presenter = presenter
        presenter.controller = viewController
        presenter.close = { [weak viewController] in
            viewController?.navigationController?.popViewController(animated: true)
        }
        
        return viewController
    }
}
