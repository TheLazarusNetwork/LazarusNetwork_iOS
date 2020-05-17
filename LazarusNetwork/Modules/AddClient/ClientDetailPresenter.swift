//
//  ClientDetailPresenter.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 17.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

extension Constants.Strings {
    static let addClientTitle = "Create client".localized
    static let editClientTitle = "Edit client".localized
    static let clientNameTitle = "Client friendly name".localized
    static let clientEmailTitle = "Client email".localized
    static let clientIPTitle = "Client IP will be chosen from these networks".localized
    static let allowedIPsTitle = "Allowed IPs".localized
    static let enableClientTitle = "Enable client after creation".localized
    static let ignoreKeepaliveTitle = "Ignore global persistent keepalive: NO".localized
    
    static let submitButtonTitle = "SUBMIT".localized
    static let cancelButtonTitle = "CANCEL".localized
}

protocol ClientDetailPresentable: Presenter {
    var controller: ClientDetailViewControllable? { get set }
    func updateClientName(_ name: String)
    func updateEmail(_ email: String)
    func enabledClientStatusChanged(_ status: Bool)
    func ignoreKeepaliveStatusChanged(_ status: Bool)

    func closeScreen()
    func save()
}

class ClientDetailPresenter: ClientDetailPresentable {
    weak var controller: ClientDetailViewControllable?
    private var model: ClientDetailModellable
    var mode: ClientDetailMode = .create
    
    var clientName: String = .empty
    var clientEmail: String = .empty
    var clientIP: String = "10.0.0.1/24"
    var allowedIPs: [String] = ["0.0.0.0/0", "::/0"]
    var enableClient = true
    var ignoreKeepalive = true
    var close: (() -> Void)?

    init(with model: ClientDetailModellable) {
        self.model = model
    }
    
    func viewLoaded() {
        controller?.setTitle(title: mode == .create ? Constants.Strings.addClientTitle : Constants.Strings.editClientTitle)
        controller?.updateTitles(name: Constants.Strings.clientNameTitle,
                                 email: Constants.Strings.clientEmailTitle,
                                 clientIP: Constants.Strings.clientIPTitle,
                                 allowedIPs: Constants.Strings.allowedIPsTitle,
                                 enableClient: Constants.Strings.enableClientTitle,
                                 ignoreKeepalive: Constants.Strings.ignoreKeepaliveTitle)
        if mode == .update {
            populateCurrentData(client: model.client)
        }
        
        controller?.populateWithData(name: clientName,
                                     email: clientEmail,
                                     clientIP: "10.0/0/1/24",
                                     allowedIPs: "0.0.0.0/0",
                                     isEnabled: true,
                                     isIgnore: false)
    }
    
    func populateCurrentData(client: VPNClient?) {
        guard let client = client else { return }
        
        clientName = client.name
        clientEmail = client.email
        clientIP = client.address.first ?? .empty
        allowedIPs = client.allowedIPs
        enableClient = client.enable
    }
    
    
    
    func updateClientName(_ name: String) {
        clientName = name
    }
    
    func updateEmail(_ email: String) {
        self.clientEmail = email
    }
    
    func enabledClientStatusChanged(_ status: Bool) {
        enableClient = status
    }
    
    func ignoreKeepaliveStatusChanged(_ status: Bool) {
        ignoreKeepalive = status
    }
    
    func closeScreen() {
        close?()
    }
    
    func save() {
        guard validate(clientName: clientName, email: clientEmail) else {
            return
        }
        controller?.showWaitingDialog()
        
        switch mode {
        case .create:
            model.createClient(clientName: clientName,
                               clientEmail: clientEmail,
                               enable: enableClient,
                               allowedIPs: allowedIPs,
                               address: [clientIP]) { [weak self] result, value in
                                self?.controller?.removeWaitingDialog()
                                switch result {
                                case .error(let error):
                                    self?.controller?.show(alertWithMessage: error, andTitle: Constants.Strings.errorTitle)
                                    
                                case .emptySuccess(_), .success:
                                    let message = Constants.Strings.successCreatingClient.replacingOccurrences(of: "%@",
                                                                                                               with: value?.name ?? .empty, options: NSString.CompareOptions.literal, range: nil)
                                    self?.controller?.showSuccessMessage(message: message, title: Constants.Strings.successCreatingTitle)
                                }
            }
        case .update:
            updateClientDataWithFreshVaues()
            model.updateClient { [weak self] result in
                self?.controller?.removeWaitingDialog()
                switch result {
                case .error(let error):
                    self?.controller?.show(alertWithMessage: error, andTitle: Constants.Strings.errorTitle)
                    
                case .emptySuccess(_), .success:
                    let message = Constants.Strings.successUpdatingClient.replacingOccurrences(of: "%@",
                                                                                               with: self?.clientName ?? .empty, options: NSString.CompareOptions.literal, range: nil)
                    self?.controller?.showSuccessMessage(message: message, title: Constants.Strings.successCreatingTitle)
                }
            }
        }
    }
    
    func updateClientDataWithFreshVaues() {
        model.client?.name = clientName
        model.client?.email = clientEmail
        model.client?.enable = enableClient
    }
    
    func validate(clientName: String, email: String) -> Bool {
        var errors: [AddDomainErrorType] = []
        if clientName.isEmpty {
            errors.append(.name)
        }
        
        if email.isEmpty {
            errors.append(.email)
        }
        
        controller?.show(errors: errors)
        return errors.count == 0
    }
}
