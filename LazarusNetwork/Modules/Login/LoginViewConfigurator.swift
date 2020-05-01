//
//  LoginViewConfigurator.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 01.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

class LogInConfigurator: BaseConfiguratorContainingControllerType {
    let isLoadedWithPrefilledControllers: Bool
    
    private let type: ControllerCreationable
    
    init(isLoadedWithPrefilledControllers: Bool = true) {
        self.isLoadedWithPrefilledControllers = isLoadedWithPrefilledControllers
        
        type = StartUpFlowType.loggedOut

        super.init(with: type)
        
        isFirstInFlow = true
    }
    
    override func generateController() -> UIViewController {
        guard let createdController = ControllerCreationFabric.default.controller(for: controllerType) as? LoginViewController else {
            return UIViewController()
        }

        let model = LoginModel()
        let presenter = LogInPresenter(with: model)
        
        presenter.controller = createdController
        createdController.presenter = presenter
        
        presenter.onLoggedIn = { [weak createdController] in
//            UserSettingsManager.shared.currentUserSettings.isLoggedIn = true
//            UserSettingsManager.shared.currentUserWasLoggedIn()
//
//            let tabBarConfigurator = TabBarConfigurator()
//            tabBarConfigurator.isFirstInFlow = false
//
//            guard let navigationController = createdController?.navigationController else {
//                Log.assertionFailure("Corrupted logic")
//                return
//            }
//
//            navigationController.setViewControllers([tabBarConfigurator.controller], animated: true)
        }
//        presenter.onFaqSelected = { [weak createdController] in
//            let configurator = ContactSupportConfigurator()
//
//            createdController?.navigationController?.pushViewController(configurator.controller, animated: true)
//        }
        
        return createdController
    }
}

