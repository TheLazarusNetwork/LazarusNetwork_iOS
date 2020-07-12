//
//  DomainFacade.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 12.07.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import Foundation

protocol DomainFacadeProtocol {
    func send(request: URLRequest, handler: @escaping DataRequestHandler<DomainResponse>)
}

class DomainFacade: DomainFacadeProtocol {
    func send(request: URLRequest, handler: @escaping DataRequestHandler<DomainResponse>) {
        RequestManager.shared.send(request: request, success: { (data) in
            guard let data = data else {
                return
            }
            do {
                let domainResponse: DomainResponse = try JSONDecoder().decode(DomainResponse.self, from: data)
                if domainResponse.status == 200 {
                    handler(domainResponse, .success)
                } else {
                    handler(nil, .error(domainResponse.message))
                }
            } catch {
                handler(nil, .error(error.localizedDescription))
                fatalError("Error during Parsing User - \(error)")
            }
        }) { (error) in
            handler(nil, error)
        }
    }
}
