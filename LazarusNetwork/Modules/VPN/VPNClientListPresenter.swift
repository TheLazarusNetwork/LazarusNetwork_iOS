//
//  VPNClientListPresenter.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 08.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

extension Constants.Strings {
    static let vpnClientListTitle = "Clients".localized
    
    static let successUpdatingClient = "Client %@ was updated".localized
    static let successDeletingClient = "Client was deleted".localized
    static let successCreatingClient = "Client %@ was created".localized
}

protocol VPNClientListPresentable: Presenter {
    var controller: VPNClientListViewControllable? { get set }
    
    var itemsCount: Int { get }
    func fill(item: PlainModelFillable, atIndex index: Int)
    func item(selectedAtIndex index: Int)
    func addClientSelected()

//    var onGotoDetail: ((Domain) -> Void)? { get set }
    var onAddClient: (() -> Void)? { get set }
}

class VPNClientListPresenter: VPNClientListPresentable {
    weak var controller: VPNClientListViewControllable?
    
//    var onGotoDetail: ((Domain) -> Void)?
    var onAddClient: (() -> Void)?
    
    private let model: VPNClientListModel
    
    init(with model: VPNClientListModel) {
        self.model = model
    }
    
    func viewLoaded() {
        controller?.setTitle(title: Constants.Strings.vpnClientListTitle)
    }
    
    func viewWillAppear() {
        loadClients()
    }
    
    func loadClients() {
        controller?.showWaitingDialog()
        model.loadClients { [weak self] result in
            self?.controller?.removeWaitingDialog()
            switch result {
            case .error(let error):
                self?.controller?.show(alertWithMessage: error,
                                       andTitle: Constants.Strings.errorTitle)
                
            case .emptySuccess(let message):
                self?.controller?.updateMainInfo(message: message)
                
                self?.controller?.show(alertWithMessage: "error",
                                       andTitle: Constants.Strings.errorTitle)
                
            case .success:
                self?.controller?.reloadTable()
                if (self?.model.clientsList.count ?? 0) > 5 {
                    self?.controller?.hideAddClientButton()
                }
            }
        }
    }
    
    var itemsCount: Int {
        return model.clientsList.count
    }
    
    func fill(item: PlainModelFillable, atIndex index: Int) {
        guard model.clientsList.indices.contains(index) else {
            return
        }
        var itemModel = model.clientsList[index]
        itemModel.delegate = self
        item.fill(with: itemModel)
    }
    
    func item(selectedAtIndex index: Int) {
        guard model.clientsList.indices.contains(index) else {
            return
        }
        
    }
    
    func addClientSelected() {
        onAddClient?()
    }
}

extension VPNClientListPresenter: ClientCellDelegate {
    func updateClient(_ client: VPNClient) {
        controller?.showWaitingDialog()
        model.updateClient(client) { [weak self] result in
            self?.controller?.removeWaitingDialog()
            self?.loadClients()
            switch result {
            case .error(let error):
                self?.controller?.show(alertWithMessage: error, andTitle: Constants.Strings.errorTitle)
                
            case .emptySuccess(_), .success:
                let message = Constants.Strings.successUpdatingClient.replacingOccurrences(of: "%@", with: client.name, options: NSString.CompareOptions.literal, range: nil)
                self?.controller?.show(alertWithMessage: message, andTitle: Constants.Strings.successCreatingTitle)
            }
        }
    }
    
    func deleteClient(_ id: String) {
        controller?.showWaitingDialog()
        model.deleteClient(id, completion: { [weak self] result in
            self?.controller?.removeWaitingDialog()
            switch result {
            case .error(let error):
                self?.controller?.show(alertWithMessage: error, andTitle: Constants.Strings.errorTitle)
                
            case .emptySuccess(_), .success:
                self?.loadClients()
                self?.controller?.show(alertWithMessage: Constants.Strings.successDeletingClient,
                                       andTitle: Constants.Strings.successCreatingTitle)
            }
        })
    }
    
    func downloadClient() {
        
    }
    
    func mailClient() {
        
    }
}
