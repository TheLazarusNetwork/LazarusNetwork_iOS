//
//  Controllers.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 02.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

enum Controllers {
    case login
    case domains
    case addDomain
    case serviceList
}

extension Controllers: ControllerCreationable {
    var controllerIdentifier: String {
        switch self {
        case .login:
            return "LoginViewController"
            
        case .domains:
            return "DomainsListViewController"
            
        case .addDomain:
            return "AddDomainController"
            
        case .serviceList:
            return "ServiceListViewController"
        }
    }
    
    var storyboardIdentifier: String {
        return "Main"
    }
}

extension Controllers {
    var configurator: Configurable {
        switch self {
        case .login:
            return LogInConfigurator()
            
        case .domains:
            return DomainsListConfigurator()
            
        case .addDomain:
            return AddDomainConfigurator()
            
        case .serviceList:
            return DomainsListConfigurator()
        }
    }
}
