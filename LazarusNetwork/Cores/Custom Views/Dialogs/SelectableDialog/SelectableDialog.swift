//
//  SelectableDialog.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 08.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

class SelectableDialog: UIView, OnControllerPresentable {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectableView: SelectableIView!
    @IBOutlet weak var okButton: UIButton!
    
    var completion: (([String]?) -> Void)?
    
    var title: String = .empty
    var itemModels:[SelectableItemModel] = []
    var selectedItems: [String] = []
    var selectionType: SelectableViewType = .singleSelection
    
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
    
    init(with title: String,
         type: SelectableViewType,
         models: [SelectableItemModel],
         completion:(([String]?) -> Void)?) {
        self.init()
        self.title = title
        self.itemModels = models
        self.completion = completion
        self.selectionType = type
        
        titleLabel.text = title
        selectableView.configure(with: generateModel())
        enableOrDisableOkButton()
    }
    
    func enableOrDisableOkButton() {
        okButton.isEnabled = selectedItems.count > 0
        if selectedItems.count > 0 {
            okButton.backgroundColor = UIColor.init(named: "DarkGreyColor")
        } else {
            okButton.backgroundColor = UIColor.init(named: "DarkGreyColor")?.withAlphaComponent(0.7)
        }
    }
    
    @IBAction func cancelSelected(_ sender: Any) {
        completion?(nil)
        removeFromSuperview()
    }
    
    @IBAction func okSelected(_ sender: Any) {
        completion?(selectedItems)
        removeFromSuperview()
    }
    
    private func generateModel() -> SelectableViewModel {
        return SelectableViewModel(with: selectionType,
                                   title: .empty,
                                   items: itemModels,
                                   delegate: self)
    }
}

extension SelectableDialog: SelectableViewDelegate {
    func selectedItem(item: String) {
        selectedItems = []
        if !item.isEmpty {
            selectedItems.append(item)
        }
        enableOrDisableOkButton()
    }
}
