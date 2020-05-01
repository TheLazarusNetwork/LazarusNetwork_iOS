//
//  StartUpFlowType.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 01.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import Foundation

enum StartUpFlowType: Int {
    case firstTime
    case loggedOutWithUser
    case loggedOut
    case loggedIn
}

extension StartUpFlowType: ControllerCreationable {
    var controllerIdentifier: String {
        switch self {
        case .loggedOutWithUser, .loggedOut, .firstTime:
            return "LoginViewController"
            
        default:
            return .empty
        }
    }
    var storyboardIdentifier: String {
        return "Main"
    }
}
