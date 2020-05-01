//
//  ControllerCreationFabric.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 01.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

protocol ControllerCreationable {
    var controllerIdentifier: String { get }
    var storyboardIdentifier: String { get }
}

class ControllerCreationFabric {
    static let `default` = ControllerCreationFabric()
    
    var launchViewController: UIViewController? {
        let launchScreenName = "LaunchScreen"
        
        return UIStoryboard(name: launchScreenName, bundle: nil).instantiateInitialViewController()
    }
    
    func controller(for type: ControllerCreationable) -> UIViewController {
        let storyboard = UIStoryboard(name: type.storyboardIdentifier, bundle: nil)
        
        return storyboard.instantiateViewController(withIdentifier: type.controllerIdentifier)
    }
}
