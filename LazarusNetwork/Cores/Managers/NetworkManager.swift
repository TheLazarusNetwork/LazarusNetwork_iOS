//
//  NetworkManager.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 02.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import Foundation

extension Constants.Strings {
    static let endPointURL = "https://api.lznet.co/api/v1/"
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
}

enum ResultType {
    case success
    case emptySuccess(String)
    case error(String)
}

class NetworkManager {
    static let shared = NetworkManager()
    
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.Strings.DateFormat.dateFormat
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter
    }
    
    func loadAllDomains(email: String, completion: @escaping (ResultType, DomainResponse?) -> Void) {
        guard ReachabilityManager.isConnectedToNetwork() else {
            completion(.error(Constants.Strings.noConnection), nil)
            return
        }
        let resultPart = Constants.Strings.endPointURL + "domain/admin/\(email)"
        guard let url = URL(string: resultPart) else {
            completion(.error(Constants.Strings.endPointError), nil)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.GET.rawValue
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
                let domains: DomainResponse = try decoder.decode(DomainResponse.self, from: data)
                completion(.success, domains)
            } catch {
                completion(.error(error.localizedDescription), nil)
                fatalError("Error during Parsing ResponseStruct - \(error)")
            }
        }
        task.resume()
    }
}
