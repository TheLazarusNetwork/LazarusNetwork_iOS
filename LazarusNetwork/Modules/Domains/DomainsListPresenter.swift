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
    static let configFileError = "Unable to load config file".localized

    static let ok = "Ok".localized
}

protocol DomainsListPresentable: Presenter {
    var controller: DomainsListViewControllable? { get set }
    
    var itemsCount: Int { get }
    func fill(item: PlainModelFillable, atIndex index: Int)
    func item(selectedAtIndex index: Int)
    
    func addDomainSelected()
    
    var onGotoDetail: ((Domain) -> Void)? { get set }
    var onAddDomain: (() -> Void)? { get set }
}

class DomainsListPresenter: DomainsListPresentable {
    weak var controller: DomainsListViewControllable?
    
    var onGotoDetail: ((Domain) -> Void)?
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
        model.loadDomains { [weak self] domainResponce, result in
            self?.controller?.removeWaitingDialog()
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .error(let error):
                strongSelf.controller?.show(alertWithMessage: error,
                                       andTitle: Constants.Strings.errorTitle)
                
            case .emptySuccess(let message):
                strongSelf.controller?.updateMainInfo(message: message)
                
            case .success:
                if (strongSelf.model.domainsList.isEmpty) {
                    strongSelf.controller?.updateMainInfo(message: domainResponce?.message ?? .empty)
                    return
                }
                if (strongSelf.model.domainsList.count) > 0 {
                    strongSelf.controller?.hideMainInfo()
                }
                strongSelf.controller?.reloadTable()
                if (strongSelf.model.domainsList.count) > 2 {
                    strongSelf.controller?.hideAddDomainButton()
                }
            case .none:
                break
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
        guard model.domainsList.indices.contains(index) else {
            return
        }
        
        onGotoDetail?(model.domainsList[index].domain)
    }
    
    func addDomainSelected() {
        onAddDomain?()
    }
}
