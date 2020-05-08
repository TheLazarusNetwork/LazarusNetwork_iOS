//
//  ServiceListPresenter.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 08.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

extension Constants.Strings {
    static let serviceListTitle = "Services".localized
}

enum Services: CaseIterable {
    case vpn
    case firewall
    case stream
    case chat
}

extension Services {
    var title: String {
        switch self {
        case .vpn:
            return "VPN".localized
            
        case .firewall:
            return "Firewall".localized
            
        case .stream:
            return "Stream".localized
            
        case .chat:
            return "Chat".localized
        }
    }
}

protocol ServiceListPresentable: Presenter {
    var controller: ServiceListViewControllable? { get set }
    
    var itemsCount: Int { get }
    func fill(item: PlainModelFillable, atIndex index: Int)
    func item(selectedAtIndex index: Int)
    
    var onGotoVPN: (() -> Void)? { get set }
    var onGotoFireWall: (() -> Void)? { get set }
}

class ServiceListPresenter: ServiceListPresentable {
    weak var controller: ServiceListViewControllable?
    
    let domain: Domain
    var itemModels:[ServiceCellPlainModel]

    var onGotoVPN: (() -> Void)?
    var onGotoFireWall: (() -> Void)?
    
    
    init(with domain: Domain) {
        self.domain = domain
        itemModels = []
        generateModels()
    }
    
    func viewLoaded() {
        controller?.setTitle(title: Constants.Strings.serviceListTitle)
    }
    
    func viewWillAppear() {
        controller?.reloadTable()
    }
    
    var itemsCount: Int {
        return itemModels.count
    }
    
    func fill(item: PlainModelFillable, atIndex index: Int) {
        guard itemModels.indices.contains(index) else {
            return
        }
        
        item.fill(with: itemModels[index])
    }
    
    func item(selectedAtIndex index: Int) {
        //        onGotoDetail?()
    }
    
    private func generateModels() {
        itemModels = Services.allCases.compactMap{ ServiceCellPlainModel($0) }
    }
}

