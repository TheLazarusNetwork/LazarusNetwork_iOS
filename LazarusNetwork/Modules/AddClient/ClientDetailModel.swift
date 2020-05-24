//
//  ClientDetailModel.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 17.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import Foundation

protocol ClientDetailModellable: Model {
    var client: VPNClient? { get set }
    func createClient(clientName: String,
                      clientEmail: String,
                      enable: Bool,
                      allowedIPs:[String],
                      address:[String],
                      completion: @escaping ((ResultType, VPNClient?) -> Void))
    
    func updateClient(completion: @escaping ((ResultType) -> Void))
}

class ClientDetailModel: ClientDetailModellable {
    let domain: Domain
    var client: VPNClient?

    init(with domain: Domain, client: VPNClient?) {
        self.domain = domain
        self.client = client
    }
    
    func createClient(clientName: String,
                      clientEmail: String,
                      enable: Bool,
                      allowedIPs:[String],
                      address:[String],
                      completion: @escaping ((ResultType, VPNClient?) -> Void)) {
        NetworkManager.shared.createClient(clientName: clientName,
                                           clientEmail: clientEmail,
                                           enable: enable,
                                           allowedIPs: allowedIPs,
                                           address: address,
                                           domainUUID: domain.domainUUID) { result, value in
                                            completion(result, value)
        }
    }
    
    func updateClient(completion: @escaping ((ResultType) -> Void)) {
        guard let client = client else { return }
        NetworkManager.shared.updateClient(for: domain.domainUUID, client: client) { result in
            completion(result)
        }
    }
}
