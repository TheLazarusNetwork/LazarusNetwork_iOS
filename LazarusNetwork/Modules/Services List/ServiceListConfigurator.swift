//
//  ServiceListConfigurator.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 08.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

class ServiceListConfigurator: BaseConfigurator {
    var domain: Domain?
    
    override func generateController() -> UIViewController {
        let controllerType: Controllers = .serviceList

        guard let viewController = ControllerCreationFabric.default.controller(for: controllerType) as? ServiceListViewController, let domain = domain else {
            return UIViewController()
        }
        
        let presenter = ServiceListPresenter(with: domain)
        viewController.presenter = presenter
        presenter.controller = viewController
        
        presenter.onGotoVPN = { [weak viewController, domain] in
            
        }
        
        presenter.onGotoFireWall = { [weak viewController, domain] in
            
        }
        
        return viewController
    }
}

