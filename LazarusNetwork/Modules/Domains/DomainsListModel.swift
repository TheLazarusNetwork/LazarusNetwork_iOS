//
//  DomainsListModel.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 02.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import Foundation

protocol DomainsListModellable: Model {
    var domainsList: [DomainCellPlainModel] { get }
    
    func loadDomains(completion: @escaping ((ResultType) -> Void))
}

class DomainsListModel: DomainsListModellable {
    var domainsList: [DomainCellPlainModel] = .init()
    let email: String
    
    init(with email: String) {
        self.email = email
    }
    
    func loadDomains(completion: @escaping ((ResultType) -> Void)) {
        NetworkManager.shared.loadAllDomains(email: email) { [weak self] result, domainsResult in
            switch result {
            case .error(_):
                completion(result)
            case .success:
                guard let domainsResult = domainsResult else {
                    completion(result)
                    return
                }
                guard let _ = domainsResult.total else {
                    completion(.emptySuccess(domainsResult.message))
                    return
                }
                
                guard let domains = domainsResult.domain else {
                    completion(.emptySuccess(domainsResult.message))
                    return
                }
                
                self?.prepareModels(domains:domains)
                completion(result)
                
            default:
                completion(result)
            }
            
        }
    }
    
    func prepareModels(domains: [Domain]) {
        domainsList = domains.compactMap( { DomainCellPlainModel($0) } )
    }
}
