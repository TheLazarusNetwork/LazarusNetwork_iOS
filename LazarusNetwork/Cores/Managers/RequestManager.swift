//
//  RequestManager.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 12.07.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import Foundation
import CommonCrypto

typealias DataRequestHandler <T> = (T?, ResultType?) -> Void

extension Constants.Strings {
    static let endPointURL = "https://app.lazarus.network/api/v1/"
    static let httpEndPointURL = "http://app.lazarus.network/api/v1/domain/admin/?email=shachindra.spidey@gmail.com"

    static let temporaryEndPointURL = "http://sg01.lazarus.network:9080/api/v1.0/"
    static let errorFetching = "Error fetching".localized
    static let serverError = "Server side error".localized
    static let endPointError = "Url parsing error".localized
    static let parsingError = "Parsing error".localized
}

extension Constants.Strings {
    struct DateFormat {
        static let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    }
}

enum HTTPMethod:String {
    case POST
    case GET
    case PATCH
    case DELETE
}

enum ResultType {
    case success
    case emptySuccess(String)
    case error(String)
}

class RequestManager {
    static let shared = RequestManager()
    
    func send(request: URLRequest, success: ((Data?) -> Void)!, failure: ((ResultType) -> Void)!) {
        guard ReachabilityManager.isConnectedToNetwork() else {
            failure(.error(Constants.Strings.noConnection))
            return
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {
                    failure(.error(error?.localizedDescription ?? ""))
                    return
            }
            
            guard (200 ... 299) ~= response.statusCode else {
                failure(.error(Constants.Strings.serverError))
                return
            }
            
            success(data)
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
