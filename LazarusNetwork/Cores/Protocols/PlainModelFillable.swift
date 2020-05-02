//
//  PlainModelFillable.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 02.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import Foundation

protocol PlainModel { }

protocol PlainModelFillable {
    func fill(with model: PlainModel)
}
