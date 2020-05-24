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
    static let successEmailingClient = "Client config for %@ was sent".localized
    static let successDownloadingClient = "Client config was downloaded".localized
    static let errorDownloadingClientConfig = "Unable to download client config for %@".localized
    static let clientConfigAlreadyExist = "Client config already exist".localized
}

protocol VPNClientListPresentable: Presenter {
    var controller: VPNClientListViewControllable? { get set }
    
    var itemsCount: Int { get }
    func fill(item: PlainModelFillable, atIndex index: Int)
    func item(selectedAtIndex index: Int)
    func addClientSelected()

    var onGotoDetail: ((Domain, VPNClient) -> Void)? { get set }
    var onAddClient: (() -> Void)? { get set }
    var onQRPreview: ((String?) -> Void)? { get set }

}

class VPNClientListPresenter: VPNClientListPresentable {
    weak var controller: VPNClientListViewControllable?
    
    var onGotoDetail: ((Domain, VPNClient) -> Void)?
    var onAddClient: (() -> Void)?
    var onQRPreview: ((String?) -> Void)?
    
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
        
        onGotoDetail?(model.domain, model.clients[index])
    }
    
    func addClientSelected() {
        onAddClient?()
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func saveQRToFile(_ qrCode: String, clientId: String, clientName: String) {
        let fileName = "\(clientId).conf"
        let path = getDocumentsDirectory().appendingPathComponent(fileName)
        if FileManager.default.fileExists(atPath: path.absoluteString) {
            controller?.show(alertWithMessage: Constants.Strings.clientConfigAlreadyExist,
                             andTitle: Constants.Strings.errorTitle)
            return
        }
        
        do {
            try qrCode.write(to: path, atomically: true, encoding: .utf8)
            controller?.show(alertWithMessage: Constants.Strings.successDownloadingClient,
                             andTitle: Constants.Strings.successCreatingTitle)
        } catch {
            print(error.localizedDescription)
            let message = Constants.Strings.errorDownloadingClientConfig.replacingOccurrences(of: "%@", with: clientName, options: NSString.CompareOptions.literal, range: nil)
            controller?.show(alertWithMessage: message,
                             andTitle: Constants.Strings.errorTitle)
        }
    }
}

extension VPNClientListPresenter: ClientCellDelegate {
    func updateClient(_ client: VPNClient) {
        onGotoDetail?(model.domain, client)
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
    
    func downloadClient(_ client: VPNClient) {
        controller?.showWaitingDialog()
        model.loadQRCode(client.id, completion: { [weak self] result, qrCode in
            self?.controller?.removeWaitingDialog()
            switch result {
            case .error(let error):
                self?.controller?.show(alertWithMessage: error, andTitle: Constants.Strings.errorTitle)
                
            case .emptySuccess(_), .success:
                guard let qrCode = qrCode else {
                    self?.controller?.show(alertWithMessage: Constants.Strings.configFileError,
                                           andTitle: Constants.Strings.errorTitle)
                    return
                }
                self?.saveQRToFile(qrCode, clientId: client.id, clientName: client.name)
            }
        })
    }
    
    func mailClient(_ client: VPNClient) {
        controller?.showWaitingDialog()
        model.mailClientConfig(client.id, completion: { [weak self] result in
            self?.controller?.removeWaitingDialog()
            switch result {
            case .error(let error):
                self?.controller?.show(alertWithMessage: error, andTitle: Constants.Strings.errorTitle)
                
            case .emptySuccess(_), .success:
                let message = Constants.Strings.successEmailingClient.replacingOccurrences(of: "%@", with: client.name, options: NSString.CompareOptions.literal, range: nil)
                self?.controller?.show(alertWithMessage: message,
                                       andTitle: Constants.Strings.successCreatingTitle)
            }
        })
    }
    
    func qrImagePressed(_ client: VPNClient) {
        controller?.showWaitingDialog()
        model.loadQRCode(client.id, completion: { [weak self] result, qrCode in
            self?.controller?.removeWaitingDialog()
            switch result {
            case .error(let error):
                self?.controller?.show(alertWithMessage: error, andTitle: Constants.Strings.errorTitle)
                
            case .emptySuccess(_), .success:
                self?.onQRPreview?(qrCode)
            }
        })
    }
}
