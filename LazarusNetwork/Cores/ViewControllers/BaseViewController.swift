//
//  BaseViewController.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 01.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController,  ViewController {
    var presenter: Presenter!
    @IBOutlet weak var navigationBar: NavigationBar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateNavigationBarUI()
        
        guard presenter != nil else {
            return
        }
        
        presenter.viewLoaded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard presenter != nil else {
            return
        }
        
        presenter.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard presenter != nil else {
            return
        }
        
        presenter.viewWillDisappear()
    }
    
    private func updateNavigationBarUI() {
        if navigationBar?.isBackModeEnabled == true {
            let hasItemsInsStack = navigationController?.viewControllers.count ?? .one > .one
            navigationBar?.isLeftButtonDisabled = !hasItemsInsStack
        }
    }
}

extension BaseViewController: NavigationBarDelegate {
    func leftActionSelected(with owner: Any) {
        guard let navigationController = navigationController else {
            dismiss(animated: true)
            return
        }
        
        navigationController.popViewController(animated: true)
    }
}

