//
//  OnControllerPresentable.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 05.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

extension Constants {
    static let animationDuration: Double = 0.3
}

protocol OnControllerPresentable: class { }

extension OnControllerPresentable where Self: UIView {
    func present(on controller: UIViewController? = nil, withAnimation flag: Bool = true) {
        if let controller = controller {
            present(on: controller, withAnimation: flag)
        } else {
            guard let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first else {
                return
            }
            
            present(on: window, withAnimation: flag)
        }
    }
    
    private func present(on viewController: UIViewController, withAnimation flag: Bool = true) {
        UIView.animate(withDuration: Constants.animationDuration) {
            viewController.view.addSubviewAndConnectToBounds(childView: self)
        }
    }
    
 private func present(on window: UIWindow, withAnimation flag: Bool = true) {
        UIView.animate(withDuration: Constants.animationDuration) {
            window.addSubviewAndConnectToBounds(childView: self)
        }
    }
}

