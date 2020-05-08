//
//  SelectableViewModel.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 08.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import Foundation

protocol SelectableViewDelegate: class {
    func selectedItem(item: String)
}

enum SelectableViewType {
    case singleSelection
    case multiselection
}

class SelectableViewModel {
    let type: SelectableViewType
    let title: String
    let items: [SelectableItemModel]
    weak var delegate: SelectableViewDelegate?
    
    init(with type: SelectableViewType,
         title: String,
         items: [SelectableItemModel],
         delegate: SelectableViewDelegate?) {
        self.title = title
        self.type = type
        self.items = items
        self.delegate = delegate
    }
}
