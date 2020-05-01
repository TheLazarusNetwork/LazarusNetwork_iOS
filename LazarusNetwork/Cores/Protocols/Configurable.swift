//
//  Configurable.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 01.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

protocol Configurable: class {
    var controller: UIViewController { get }
    
    func generateController() -> UIViewController
}

extension Configurable {
    var controller: UIViewController {
        return preparedController()
    }
    
    private func preparedController() -> UIViewController {
        let createdController = generateController()

        guard let canBeEmbeddedItem = self as? NavigationControllerEmbedding, canBeEmbeddedItem.isFirstInFlow == true else {
            return createdController
        }
        
        let navigationController = BaseNavigationViewController(rootViewController: createdController)
        navigationController.navigationBar.isHidden = true
        
        return navigationController
    }
}
