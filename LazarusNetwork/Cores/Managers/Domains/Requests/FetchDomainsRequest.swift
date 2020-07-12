//
//  FetchDomainsRequest.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 12.07.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import Foundation

class FetchDomainsRequest: PRequest {
    var token: String
    var email: String

    init(token: String, email: String) {
        self.token = token
        self.email = email
    }
    
    func composeUrl() -> String {
        return "\(Constants.Strings.endPointURL)domain/admin/?email=\(email)"
    }
    
    func createRequest() -> URLRequest? {
        guard let url = URL(string: composeUrl()) else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.GET.rawValue
        request.addValue(token, forHTTPHeaderField: "auth_token")
        
        return request
    }
}
