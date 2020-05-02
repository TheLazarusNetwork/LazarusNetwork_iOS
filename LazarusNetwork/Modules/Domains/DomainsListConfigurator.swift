//
//  DomainsListConfigurator.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 02.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

class DomainsListConfigurator: BaseConfigurator {
    
    override func generateController() -> UIViewController {
        let controllerType: Controllers = .domains

        guard let viewController = ControllerCreationFabric.default.controller(for: controllerType) as? DomainsListViewController else {
            return UIViewController()
        }
        
        let presenter = DomainsListPresenter(with: DomainsListModel())
        viewController.presenter = presenter
        presenter.controller = viewController
        
        presenter.onGotoDetail = { [weak viewController] in

        }
        
        return viewController
    }
}
