//
//  ClientTableViewCell.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 09.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

extension Constants.Strings {
    static let createdTitle = "Created:".localized
    static let updatedTitle = "Updated:".localized
    static let deleteTitle = "Delete".localized
    static let editTitle = "Edit".localized
    static let downloadTitle = "Download".localized
    static let sendMailTitle = "Send mail".localized
}

protocol ClientCellDelegate: class {
    func updateClient(_ client: VPNClient)
    func deleteClient(_ id: String)
    func downloadClient()
    func mailClient()
}

struct ClientCellPlainModel: PlainModel {
    let name: String
    let email: String
    let createdTitle: String
    let updatedTitle: String

    let created: String
    let updated: String
    
    let ip: String
    
    let deleteTitle: String
    let editTitle: String
    
    let downloadTitle: String
    let sendMailTitle: String
    
    var isActive: Bool
    
    var client: VPNClient
    
    weak var delegate: ClientCellDelegate?
    
    init(_ client: VPNClient) {
        self.client = client
        self.name = client.name
        self.email = client.email
        self.createdTitle = Constants.Strings.createdTitle
        self.updatedTitle = Constants.Strings.updatedTitle
        self.deleteTitle = Constants.Strings.deleteTitle
        self.editTitle = Constants.Strings.editTitle
        self.downloadTitle = Constants.Strings.downloadTitle
        self.sendMailTitle = Constants.Strings.sendMailTitle
        
        self.isActive = client.enable
        self.ip = client.address.first ?? .empty
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yyyy HH:mm"
        self.created = df.string(from: client.created)
        self.updated = df.string(from: client.updated)
    }
}

class ClientTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var createdTitleLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!

    @IBOutlet weak var updatedTitleLabel: UILabel!
    @IBOutlet weak var updatedLabel: UILabel!
    
    @IBOutlet weak var ipLabel: UILabel!
    
    @IBOutlet weak var deleteTitleLabel: UILabel!
    @IBOutlet weak var editTitleLabel: UILabel!
    @IBOutlet weak var downloadTitleLabel: UILabel!
    @IBOutlet weak var sendMailTitleLabel: UILabel!

    @IBOutlet weak var enabledSwitch: UISwitch!
    
    @IBOutlet weak var contentBackgroundView: UIView!

    
    var model: ClientCellPlainModel!
    
    @IBAction func deletePressed(_ sender: UIButton) {
        model.delegate?.deleteClient(model.client.id)
    }

    @IBAction func editPressed(_ sender: UIButton) {
        model.delegate?.updateClient(model.client)
    }
    
    @IBAction func sendMailPressed(_ sender: UIButton) {

    }
    
    @IBAction func downloadPressed(_ sender: UIButton) {

    }
}

extension ClientTableViewCell: PlainModelFillable {
    func fill(with model: PlainModel) {
        guard let model = model as? ClientCellPlainModel else {
            return
        }
        
        self.model = model
        titleLabel.text = model.name
        emailLabel.text = model.email
        
        createdTitleLabel.text = model.createdTitle
        createdLabel.text = model.created
        updatedTitleLabel.text = model.updatedTitle
        updatedLabel.text = model.updated
        
        ipLabel.text = model.ip
        
        deleteTitleLabel.text = model.deleteTitle
        editTitleLabel.text = model.editTitle
        downloadTitleLabel.text = model.downloadTitle
        sendMailTitleLabel.text = model.sendMailTitle
        
        enabledSwitch.isOn = model.isActive
        
        contentBackgroundView.backgroundColor = model.isActive ? UIColor(named: "DarkBlue") : UIColor(named: "Orange")
        
        enabledSwitch.addTarget(self, action: #selector(stateChanged), for: .valueChanged)

    }
    
    @objc func stateChanged(switchState: UISwitch) {
        model.isActive = switchState.isOn
        contentBackgroundView.backgroundColor = model.isActive ? UIColor(named: "DarkBlue") : UIColor(named: "Orange")
        model.client.enable = switchState.isOn
        model.delegate?.updateClient(model.client)
    }
}
