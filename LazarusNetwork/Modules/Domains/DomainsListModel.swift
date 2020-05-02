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
    
    func loadDomains(completion: @escaping ((ResultType) -> Void)) {
        NetworkManager.shared.loadAllDomains() { [weak self] result, domains in
            switch result {
            case .error(_):
                completion(result)
            case .success:
                guard let domains = domains else {
                    completion(result)
                    return
                }
                self?.prepareModels(domains:domains)
                completion(result)
            }
            
        }
    }
    
    func prepareModels(domains: [Domain]) {
        domainsList = domains.compactMap( { DomainCellPlainModel($0) } )
    }
}
