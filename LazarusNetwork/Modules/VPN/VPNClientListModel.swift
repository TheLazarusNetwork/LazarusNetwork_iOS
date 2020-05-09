//
//  VPNClientListModel.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 08.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import Foundation

protocol VPNClientListModellable: Model {
    var clientsList: [ClientCellPlainModel] { get }
    
    func loadClients(completion: @escaping ((ResultType) -> Void))
    
    func updateClient(_ client: VPNClient, completion: @escaping ((ResultType) -> Void))
    func deleteClient(_ id: String, completion: @escaping ((ResultType) -> Void))
}

class VPNClientListModel: VPNClientListModellable {
    var clientsList: [ClientCellPlainModel] = .init()
    let domain: Domain
    
    init(with domain: Domain) {
        self.domain = domain
    }
    
    func loadClients(completion: @escaping ((ResultType) -> Void)) {
        NetworkManager.shared.fetchClients(for: domain.domainUUID) { [weak self] result, clientsResult in
            switch result {
            case .error(_):
                completion(result)
                
            case .success:
                guard let clientsResult = clientsResult else {
                    completion(result)
                    return
                }

                self?.prepareModels(clientsResult:clientsResult)
                completion(result)
                
            default:
                completion(result)
            }
            
        }
    }
    
    func updateClient(_ client: VPNClient, completion: @escaping ((ResultType) -> Void)) {
        NetworkManager.shared.updateClient(client) { result, message in
            completion(result)
        }
        
    }
    
    func deleteClient(_ id: String, completion: @escaping ((ResultType) -> Void)) {
        NetworkManager.shared.deleteClient(id) { result, message in
            completion(result)
        }
    }
    
    func prepareModels(clientsResult: [VPNClient]) {
        clientsList = clientsResult.compactMap( { ClientCellPlainModel($0) } )
    }
}
