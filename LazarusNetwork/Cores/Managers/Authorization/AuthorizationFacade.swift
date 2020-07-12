//
//  AuthorizationFacade.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 12.07.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import Foundation

protocol AuthorizationFacadeProtocol {
    func send(request: URLRequest, handler: @escaping DataRequestHandler<User>)
}

class AuthorizationFacade: AuthorizationFacadeProtocol {
    func send(request: URLRequest, handler: @escaping DataRequestHandler<User>) {
        RequestManager.shared.send(request: request, success: { (data) in
            guard let data = data else {
                return
            }
            do {
                let clientResponse: User = try JSONDecoder().decode(User.self, from: data)
                switch clientResponse.result {
                case .success:
                    handler(clientResponse, .success)

                case .failure:
                    handler(nil, .error(clientResponse.message ?? .empty))
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
