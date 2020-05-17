//
//  ClientDetailConfigurator.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 17.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

enum ClientDetailMode {
    case create
    case update
}

class ClientDetailConfigurator: BaseConfigurator {
    var domain: Domain?
    var client: VPNClient?

    var mode: ClientDetailMode = .create

    override func generateController() -> UIViewController {
        let controllerType: Controllers = .addVpnClient

        guard let viewController = ControllerCreationFabric.default.controller(for: controllerType) as? ClientDetailViewController,
        let domain = domain else {
            return UIViewController()
        }
        
        let presenter = ClientDetailPresenter(with: ClientDetailModel(with: domain, client: client))
        viewController.presenter = presenter
        presenter.controller = viewController
        presenter.mode = mode
        presenter.close = { [weak viewController] in
            viewController?.navigationController?.popViewController(animated: true)
        }
        return viewController
    }
}
