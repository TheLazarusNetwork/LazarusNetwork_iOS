//
//  Constants.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 01.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

struct Constants {
    struct Digits { }
    struct Strings { }
    struct Colors { }
    struct Error { }
    struct Fonts { }
}

extension Constants.Strings {
    static let dash = "-"
    static let dot = "."
    static let comma = ","
    static let bottomDash = "_"
    static let empty = ""
    static let notImplemented = "___NOT___IMPLEMENTED___"
    static let or = "or".localized
    static let space = " ".localized
    static let slash = "/".localized
    static let x = "x".localized
    static let XX = "XX".localized
    static let semicolon = ":".localized
    static let zero = "0"
    static let newline = "\n"
    static let mths = "mos".localized
    static let bulletPoint = "•"
    static let doesntApply = "does not apply".localized
}

extension Constants.Colors {
    static let GreyColor = UIColor(named: "GreyColor")
    static let DarkGreyColor = UIColor(named: "DarkGreyColor")
}
