//
//  AddDomainModel.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 07.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import Foundation

protocol AddDomainModellable: Model {
    var plans:[String] { get set }
    var regions:[String] { get set }
    
    func loadPlansAndRegions(completion: @escaping (String)->Void)
    func createDomain(domainName: String,
                      email: String,
                      plan: String,
                      region: String,
                      completion: @escaping (ResultType, Domain?) -> Void)
}

class AddDomainModel: AddDomainModellable {
    var plans:[String] = []
    var regions:[String] = []
    
    let adminEmail: String
    let uuid: String
    
    init(with email: String) {
        self.adminEmail = email
        self.uuid = UUID().uuidString
    }
    
    func loadPlansAndRegions(completion: @escaping (String)->Void) {
        let downloadGroup = DispatchGroup()
        var errorString = ""
        downloadGroup.enter()
        NetworkManager.shared.fetchDomainPlans { [weak self] (result, value) in
            switch result {
            case .error(let error):
                errorString += error
                
            case .success:
                self?.plans = self?.generateArray(from: value ?? .empty) ?? []
                
            default:
                self?.plans = []
            }
            downloadGroup.leave()
        }
        downloadGroup.enter()
        NetworkManager.shared.fetchDomainRegions { [weak self] (result, value) in
            switch result {
            case .error(let error):
                errorString += error
                
            case .success:
                self?.regions = self?.generateArray(from: value ?? .empty) ?? []
                
            default:
                self?.regions = []
            }
            downloadGroup.leave()
        }
        
        downloadGroup.notify(queue: DispatchQueue.main) {
            completion(errorString)
        }
    }
    
    func generateArray(from text: String) -> [String]? {
        var parsedText = text.replacingOccurrences(of: "[", with: "", options: NSString.CompareOptions.literal, range: nil)
        parsedText = parsedText.replacingOccurrences(of: "]", with: "", options: NSString.CompareOptions.literal, range: nil)
        parsedText = parsedText.replacingOccurrences(of: "\'", with: "", options: NSString.CompareOptions.literal, range: nil)
        return parsedText.components(separatedBy: ", ")
    }
    
    func createDomain(domainName: String,
                      email: String,
                      plan: String,
                      region: String,
                      completion: @escaping (ResultType, Domain?) -> Void) {
        NetworkManager.shared.createDomain(domainName: domainName,
                                           email: email,
                                           plan: plan,
                                           region: region,
                                           adminEmail: adminEmail,
                                           uuid: uuid) { (result, value) in
                                            completion(result, value)
        }
    }
}
