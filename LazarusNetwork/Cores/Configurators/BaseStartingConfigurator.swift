//
//  BaseStartingConfigurator.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 01.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

class BaseConfiguratorContainingControllerType: BaseConfigurator {
    let controllerType: ControllerCreationable
    
    init(with type: ControllerCreationable) {
        controllerType = type
    }
}
