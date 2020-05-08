//
//  ServiceTableViewCell.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 08.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

struct ServiceCellPlainModel: PlainModel {
    let name: String
    let serviceType: Services
    
    init(_ service: Services) {
        self.name = service.title
        self.serviceType = service
    }
}

class ServiceTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
}

extension ServiceTableViewCell: PlainModelFillable {
    func fill(with model: PlainModel) {
        guard let model = model as? ServiceCellPlainModel else {
            return
        }
        
        titleLabel.text = model.name
    }
}
