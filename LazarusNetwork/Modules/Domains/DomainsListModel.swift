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
    
    func loadDomains(handler: @escaping DataRequestHandler<DomainResponse>)
}

class DomainsListModel: DomainsListModellable {
    var domainsList: [DomainCellPlainModel] = .init()
    let email: String
    let token: String

    let manager: DomainFacadeProtocol
    
    init(manager: DomainFacadeProtocol, email: String, token: String) {
        self.email = email
        self.token = token
        self.manager = manager
    }
    
    func loadDomains(handler: @escaping DataRequestHandler<DomainResponse>) {
        guard let domainsRequest = FetchDomainsRequest(token: token, email: email).createRequest() else {
            handler(nil, .error(Constants.Strings.endPointError))
            return
        }
        manager.send(request: domainsRequest) { domainResponse, result in
            handler(domainResponse, result)
        }
    }
    
    func prepareModels(domains: [Domain]) {
        domainsList = domains.compactMap( { DomainCellPlainModel($0) } )
    }
}
