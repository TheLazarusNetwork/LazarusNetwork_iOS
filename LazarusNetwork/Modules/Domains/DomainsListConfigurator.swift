//
//  DomainsListConfigurator.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 02.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

class DomainsListConfigurator: BaseConfigurator {
    var email: String = ""
    
    override func generateController() -> UIViewController {
        let controllerType: Controllers = .domains

        guard let viewController = ControllerCreationFabric.default.controller(for: controllerType) as? DomainsListViewController else {
            return UIViewController()
        }
        
        let presenter = DomainsListPresenter(with: DomainsListModel(with: email))
        viewController.presenter = presenter
        presenter.controller = viewController
        
        presenter.onGotoDetail = { [weak viewController] in
            let configurator = AddDomainConfigurator()
            guard let navigationController = viewController?.navigationController else {
                return
            }
            DispatchQueue.main.async {
                navigationController.pushViewController(configurator.controller, animated: true)
            }
        }
        
        presenter.onAddDomain = { [weak viewController, email] in
            let configurator = AddDomainConfigurator()
            configurator.email = email
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
