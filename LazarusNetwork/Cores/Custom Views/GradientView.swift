//
//  GradientView.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 05.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

class GradientView: UIView {
    var gradienColors: [UIColor] = [] {
        didSet {
            update(colors: gradienColors)
        }
    }
    
    var gradienLocations: [Float] = [] {
        didSet {
            update(locations: gradienLocations)
        }
    }
    var currentLayer: CAGradientLayer? {
        return layer as? CAGradientLayer
    }
    
    override public class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    private func update(colors: [UIColor]) {
        currentLayer?.colors = colors.map { $0.cgColor }
    }
    
    private func update(locations: [Float]) {
        currentLayer?.locations = locations.map { NSNumber(value: $0) }
    }
}
