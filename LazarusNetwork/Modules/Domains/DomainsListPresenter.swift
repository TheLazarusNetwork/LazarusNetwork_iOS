//
//  DomainsListPresenter.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 02.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

extension Constants.Strings {
    static let domainListTitle = "Domains".localized
    static let noConnection = "No internet connection".localized
    static let errorTitle = "Error".localized
    static let ok = "Ok".localized
}

protocol DomainsListPresentable: Presenter {
    var controller: DomainsListViewControllable? { get set }
    
    var itemsCount: Int { get }
    func fill(item: PlainModelFillable, atIndex index: Int)
    func item(selectedAtIndex index: Int)
    
    func addDomainSelected()
    
    var onGotoDetail: (() -> Void)? { get set }
    var onAddDomain: (() -> Void)? { get set }
}

class DomainsListPresenter: DomainsListPresentable {
    weak var controller: DomainsListViewControllable?
    
    var onGotoDetail: (() -> Void)?
    var onAddDomain: (() -> Void)?
    
    private let model: DomainsListModellable
    
    init(with model: DomainsListModellable) {
        self.model = model
    }
    
    func viewLoaded() {
        controller?.setTitle(title: Constants.Strings.domainListTitle)
    }
    
    func viewWillAppear() {
        controller?.showWaitingDialog()
        model.loadDomains { [weak self] result in
            self?.controller?.removeWaitingDialog()
            switch result {
            case .error(let error):
                self?.controller?.show(alertWithMessage: error,
                                       andTitle: Constants.Strings.errorTitle)
                
            case .emptySuccess(let message):
                self?.controller?.updateMainInfo(message: message)
                
            case .success:
                self?.controller?.reloadTable()
            }
        }
    }
    
    var itemsCount: Int {
        return model.domainsList.count
    }
    
    func fill(item: PlainModelFillable, atIndex index: Int) {
        guard model.domainsList.indices.contains(index) else {
            return
        }
        
        item.fill(with: model.domainsList[index])
    }
    
    func item(selectedAtIndex index: Int) {
        onGotoDetail?()
    }
    
    func addDomainSelected() {
        onAddDomain?()
    }
}
