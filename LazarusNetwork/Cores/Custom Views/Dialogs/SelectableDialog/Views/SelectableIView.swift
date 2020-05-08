//
//  SelectableIView.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 08.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

class SelectableIView: UIView {
    var model: SelectableViewModel!
    var selectedIndex: IndexPath!
    
    let cellIdentifier = SelectableItemTableViewCell.reuseIdentifier
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var itemsTableView: UITableView!
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupNib()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupNib()
    }
    
    public func loadNib() -> UIView {
         let bundle = Bundle(for: type(of: self))
         let nib = UINib(nibName: type(of: self).description().components(separatedBy: ".").last!, bundle: bundle)
         return nib.instantiate(withOwner: self, options: nil)[0] as! UIView
    }

    fileprivate func setupNib() {
        let view = self.loadNib()
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        let bindings = ["view": view]
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics:nil, views: bindings))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics:nil, views: bindings))
    }
    
    func configure(with model: SelectableViewModel) {
        self.model = model
        nameLabel.text = model.title
        itemsTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        itemsTableView.reloadData()
    }
}

extension SelectableIView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SelectableItemTableViewCell
        let itemModel = model.items[indexPath.row]
        
        cell?.configure(with: itemModel)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard model.items.count > 0 else {
            return
        }
        
        deselectAllModel(indexToExclude: indexPath.row)
        let selectedModel = model.items[indexPath.row]
        selectedIndex = indexPath
        selectedModel.isSelected = !selectedModel.isSelected
        model?.delegate?.selectedItem(item: selectedModel.isSelected ? selectedModel.name : .empty)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let cell = tableView.cellForRow(at: indexPath) as? SelectableItemTableViewCell else {
            return indexPath
        }
        if cell.responds(to: Selector("selectMe")) {
            cell.selectMe()
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
                guard let cell = tableView.cellForRow(at: indexPath) as? SelectableItemTableViewCell else {
            return indexPath
        }
        if cell.responds(to: Selector("deselectMe")) {
            cell.deselectMe()
        }
        return indexPath
    }
    
    func deselectAllModel(indexToExclude: Int) {
        var i = 0
        while i < model.items.count {
            if i != indexToExclude {
                let selectedModel = model.items[i]
                selectedModel.isSelected = false
            }
            i += 1
        }
    }
}
