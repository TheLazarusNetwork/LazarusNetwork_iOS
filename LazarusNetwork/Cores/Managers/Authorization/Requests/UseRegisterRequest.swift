//
//  UseRegisterRequest.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 12.07.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import Foundation

class UseRegisterRequest: PRequest {
    var userName: String
    var email: String
    var password: String

    init(userName: String, email: String, password: String) {
        self.userName = userName
        self.email = email
        self.password = password
    }
    
    func composeUrl() -> String {
        return "\(Constants.Strings.endPointURL)auth/sign-up"
    }
    
    func createRequest() -> URLRequest? {
        guard let url = URL(string: composeUrl()) else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.POST.rawValue
        let parameters: [String: Any] = [
            "username": userName,
            "email": email,
            "password": password
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            request.httpBody = jsonData
            request.setValue("\(jsonData.count)", forHTTPHeaderField: "Content-Length")
        } catch {
            fatalError("Error during jsonSerialization - \(error)")
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
}
