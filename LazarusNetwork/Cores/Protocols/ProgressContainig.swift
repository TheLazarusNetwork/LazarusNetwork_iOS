//
//  ProgressContainig.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 01.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

protocol DefaultProgressContainig {
    func showHud()
    func showHud(withText text: String?)
    
    func hideHud()
}

extension UIWindow: DefaultProgressContainig {}

extension DefaultProgressContainig {
    func configureHud() {
        
    }
}

extension DefaultProgressContainig {
    func showHud() {
        DispatchQueue.main.async {
                self.showHud(withText: nil)
        }
    }
    
    func showHud(withText text: String?) {
        DispatchQueue.main.async {
            UIApplication.shared.beginIgnoringInteractionEvents()
            
        }
    }
    
    func hideHud() {
        DispatchQueue.main.async {
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
}
