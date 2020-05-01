//
//  BaseConfigurator.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 01.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

class BaseConfigurator: Configurable, NavigationControllerEmbedding {
    var isFirstInFlow: Bool = false
    var createWithPrefilling: Bool = true
    
    func generateController() -> UIViewController {
        return UIViewController()
    }
}
