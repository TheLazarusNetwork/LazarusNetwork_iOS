//
//  SelectableItemTableViewCell.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 08.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

class SelectableItemTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkMarkImageView: UIImageView!
    
    func configure(with model: SelectableItemModel) {
        nameLabel.text = model.name
        checkMarkImageView.isHidden = !model.isSelected
    }
    
    @objc func selectMe() {
        checkMarkImageView.isHidden = !checkMarkImageView.isHidden
    }
    
    @objc func deselectMe() {
        checkMarkImageView.isHidden = true
    }
}
