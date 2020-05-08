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
    
    func fetchDomainPlans(completion: @escaping (ResultType, String?) -> Void) {
        guard ReachabilityManager.isConnectedToNetwork() else {
            completion(.error(Constants.Strings.noConnection), nil)
            return
        }
        let resultPart = Constants.Strings.endPointURL + "network/plans"
        guard let url = URL(string: resultPart) else {
            completion(.error(Constants.Strings.endPointError), nil)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.GET.rawValue
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
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
                let domains: DomainTypeResponse = try decoder.decode(DomainTypeResponse.self, from: data)
                completion(.success, domains.types)
            } catch {
                completion(.error(error.localizedDescription), nil)
                fatalError("Error during Parsing DomainTypeResponse - \(error)")
            }
        }
        task.resume()
    }
    
    func fetchDomainRegions(completion: @escaping (ResultType, String?) -> Void) {
        guard ReachabilityManager.isConnectedToNetwork() else {
            completion(.error(Constants.Strings.noConnection), nil)
            return
        }
        let resultPart = Constants.Strings.endPointURL + "network/regions"
        guard let url = URL(string: resultPart) else {
            completion(.error(Constants.Strings.endPointError), nil)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.GET.rawValue
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
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
                let domains: DomainTypeResponse = try decoder.decode(DomainTypeResponse.self, from: data)
                completion(.success, domains.types)
            } catch {
                completion(.error(error.localizedDescription), nil)
                fatalError("Error during Parsing DomainTypeResponse - \(error)")
            }
        }
        task.resume()
    }
    
    func createDomain(domainName: String,
                    email: String,
                    plan: String,
                    region: String,
                    adminEmail: String,
                    uuid: String,
                    completion: @escaping (ResultType, Domain?) -> Void) {
        guard ReachabilityManager.isConnectedToNetwork() else {
            completion(.error(Constants.Strings.noConnection), nil)
            return
        }
        let resultPart = Constants.Strings.endPointURL + "domain"
        guard let url = URL(string: resultPart) else {
            completion(.error(Constants.Strings.endPointError), nil)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.POST.rawValue
        let parameters: [String: Any] = [
            "domain_uuid": uuid,
            "domain_name": domainName,
            "domain_type": plan,
            "domain_email": email,
            "domain_admin": adminEmail,
            "domain_region": region
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
                let domainResponse: DomainCreateResponse = try decoder.decode(DomainCreateResponse.self, from: data)
                completion(.success, domainResponse.domain)
            } catch {
                completion(.error(error.localizedDescription), nil)
                fatalError("Error during Parsing DomainTypeResponse - \(error)")
            }
        }
        task.resume()
    }
}

extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
