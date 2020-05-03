//
//  DomainTableViewCell.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 02.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

extension Constants.Strings {
    static let name = "name".localized
    static let type = "type".localized
    static let created = "created".localized

}

struct DomainCellPlainModel: PlainModel {
    let name: String
    let type: String
    let date: String
    let status: Status
    
    init(_ domain: Domain) {
        self.name = domain.domainName
        self.type = domain.domainType
        let df = DateFormatter()
        df.dateFormat = "DD-Mon-YYYY"
        self.date = df.string(from: domain.createdAt)
        self.status = domain.domainStatus
    }
}

class DomainTableViewCell: UITableViewCell {
    @IBOutlet weak var nametitleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typetitleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var datetitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var statusView: UIView!
}

extension DomainTableViewCell: PlainModelFillable {
    func fill(with model: PlainModel) {
        guard let model = model as? DomainCellPlainModel else {
            return
        }
        
        nametitleLabel.text = Constants.Strings.name
        typetitleLabel.text = Constants.Strings.type
        datetitleLabel.text = Constants.Strings.created

        nameLabel.text = model.name
        typeLabel.text = model.type
        dateLabel.text = model.date
        switch model.status {
        case .online:
            statusView.backgroundColor = UIColor.systemGreen
        default:
            statusView.backgroundColor = UIColor.systemGray
            
        }
    }
}
