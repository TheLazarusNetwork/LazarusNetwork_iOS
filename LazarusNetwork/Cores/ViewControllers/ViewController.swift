//
//  ViewController.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 01.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

protocol ViewController: class, DefaultProgressContainig {
    var presenter: Presenter! { get set }
}

protocol ViewControllerWithDefinedPresenter: ViewController {
    associatedtype CurrentPresenter
}

extension ViewControllerWithDefinedPresenter {
    var currentPresenter: CurrentPresenter {
        return presenter as! CurrentPresenter
    }
}

extension ViewController {
    func show(alertWithMessage message: String, andTitle title: String = .empty) {
        guard let controller = self as? UIViewController else {
            return
        }
        DispatchQueue.main.async {
            let alert = AlertView(withTitle: title, andContent: message)
            
            alert.add(
                AlertViewAction(
                    buttonName: Constants.Strings.ok
                )
            )
            alert.present(on: controller)
        }
    }
}
