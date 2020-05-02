//
//  DomainTableViewCell.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 02.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

struct DomainCellPlainModel: PlainModel {
    let name: String
    
    init(_ domain: Domain) {
        self.name = domain.domainName
    }
}

class DomainTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
}

extension DomainTableViewCell: PlainModelFillable {
    func fill(with model: PlainModel) {
        guard let model = model as? DomainCellPlainModel else {
            return
        }
        
        nameLabel.text = model.name
    }
}
