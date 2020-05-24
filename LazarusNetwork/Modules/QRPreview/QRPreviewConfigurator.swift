//
//  QRPreviewConfigurator.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 24.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

class QRPreviewConfigurator: BaseConfigurator {
    var qrString: String = .empty

    override func generateController() -> UIViewController {
        let controllerType: Controllers = .qrPreview

        guard let viewController = ControllerCreationFabric.default.controller(for: controllerType) as? QRPreviewViewController else {
            return UIViewController()
        }
        
        let presenter = QRPreviewPresenter(qrString)
        viewController.presenter = presenter
        presenter.controller = viewController
        
        presenter.close = { [weak viewController] in
            viewController?.dismiss(animated: true, completion: nil)
        }
        return viewController
    }
}
