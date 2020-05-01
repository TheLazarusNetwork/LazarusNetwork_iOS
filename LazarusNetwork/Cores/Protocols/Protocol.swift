//
//  Protocol.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 01.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import Foundation

protocol Presenter: class {
    func viewLoaded()
    
    func viewWillAppear()
    func viewWillDisappear()
}

extension Presenter {
    func viewLoaded() { }
    
    func viewWillAppear() { }
    func viewWillDisappear() { }
}
