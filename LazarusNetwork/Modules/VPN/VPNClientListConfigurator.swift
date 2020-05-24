//
//  VPNClientListConfigurator.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 08.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

class VPNClientListConfigurator: BaseConfigurator {
    var domain: Domain?
    
    override func generateController() -> UIViewController {
        let controllerType: Controllers = .vpnClientList

        guard let viewController = ControllerCreationFabric.default.controller(for: controllerType) as? VPNClientListViewController, let domain = domain else {
            return UIViewController()
        }
        
        let presenter = VPNClientListPresenter(with: VPNClientListModel(with: domain))
        viewController.presenter = presenter
        presenter.controller = viewController
        
        presenter.onAddClient = { [weak viewController] in
            let configurator = ClientDetailConfigurator()
            configurator.mode = .create
            configurator.domain = domain
            guard let navigationController = viewController?.navigationController else {
                return
            }
            DispatchQueue.main.async {
                navigationController.pushViewController(configurator.controller, animated: true)
            }
        }
        
        presenter.onGotoDetail = { [weak viewController] domain, client in
            let configurator = ClientDetailConfigurator()
            configurator.mode = .update
            configurator.domain = domain
            configurator.client = client

            guard let navigationController = viewController?.navigationController else {
                return
            }
            DispatchQueue.main.async {
                navigationController.pushViewController(configurator.controller, animated: true)
            }
        }
        
        presenter.onQRPreview = { [weak viewController] qrString in
            let configurator = QRPreviewConfigurator()
            configurator.qrString = qrString ?? .empty

            DispatchQueue.main.async {
                let controller = configurator.controller
                controller.modalPresentationStyle = .overFullScreen
                controller.modalTransitionStyle = .flipHorizontal
                viewController?.present(controller, animated: true, completion: nil)
            }
        }
        
        return viewController
    }
}
