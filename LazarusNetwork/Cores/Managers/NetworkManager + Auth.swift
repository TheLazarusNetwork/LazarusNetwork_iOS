//
//  NetworkManager + Auth.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 03.07.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import Foundation
#import <CommonCrypto/CommonDigest.h>

extension NetworkManager {

    func register(userName: String,
                  email: String,
                  password: String,
                  completion: @escaping (ResultType, DomainResponse?) -> Void) {
        guard ReachabilityManager.isConnectedToNetwork() else {
            completion(.error(Constants.Strings.noConnection), nil)
            return
        }
        let resultPart = Constants.Strings.endPointURL + "auth/sign-up"
        guard let url = URL(string: resultPart) else {
            completion(.error(Constants.Strings.endPointError), nil)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.POST.rawValue
        let passData = sha256(data: Data(password.utf8))
        let parameters: [String: Any] = [
            "username": userName,
            "email": email,
            "password": passData
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            request.httpBody = jsonData
            request.setValue("\(jsonData.count)", forHTTPHeaderField: "Content-Length")
        }catch {
            completion(.error(error.localizedDescription), nil)
            fatalError("Error during jsonSerialization - \(error)")
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {
                    completion(.error(error?.localizedDescription ?? ""), nil)
                    return
            }
            
            guard (200 ... 299) ~= response.statusCode else {
                completion(.error(Constants.Strings.serverError), nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                guard let dateFormatter = self?.dateFormatter else {
                    completion(.error(Constants.Strings.parsingError), nil)
                    return
                }
                
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
//                let domainResponse: DomainCreateResponse = try decoder.decode(DomainCreateResponse.self, from: data)
//                completion(.success, domainResponse.domain)
            } catch {
                completion(.error(error.localizedDescription), nil)
                fatalError("Error during Parsing DomainTypeResponse - \(error)")
            }
        }
        task.resume()
    }
    
    func sha256(data: Data) -> Data {
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
        }
        return Data(hash)
    }
}
