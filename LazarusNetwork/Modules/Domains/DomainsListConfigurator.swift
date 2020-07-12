//
//  DomainsListConfigurator.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 02.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

class DomainsListConfigurator: BaseConfigurator {
    var token: String = .empty
    var email: String = .empty

    override func generateController() -> UIViewController {
        let controllerType: Controllers = .domains

        guard let viewController = ControllerCreationFabric.default.controller(for: controllerType) as? DomainsListViewController else {
            return UIViewController()
        }
        
        let presenter = DomainsListPresenter(with: DomainsListModel(manager: DomainFacade(), email: email, token: token))
        viewController.presenter = presenter
        presenter.controller = viewController
        
        presenter.onGotoDetail = { [weak viewController] domain in
            let configurator = ServiceListConfigurator()
            configurator.domain = domain
            guard let navigationController = viewController?.navigationController else {
                return
            }
            DispatchQueue.main.async {
                navigationController.pushViewController(configurator.controller, animated: true)
            }
        }
        
        presenter.onAddDomain = { [weak viewController, token] in
            let configurator = AddDomainConfigurator()
            configurator.email = token
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
