//
//  Extensions.swift
//  Sunny
//
//  Created by Kobsonauta on 14/08/2020.
//  Copyright © 2020 Kacper Harasim. All rights reserved.
//

import UIKit

extension Double {
    var roundedCelcius: String {
        return String(format: "%.f", self) + "°C"
    }
}

extension UIColor {
    private struct Key {
        static let clientMain = "client_dark_gray"
    }

    static var clientMain: UIColor {
        get {
            return UIColor(named: UIColor.Key.clientMain) ?? UIColor.clear
        }
    }

    static var clientWhite: UIColor {
        get {
            return UIColor.white
        }
    }
}

extension UIFont {
    private struct Key {
        static let bold = "Alegreya-Bold"
        static let regular = "Alegreya-Regular"
    }

    static var clientBold: UIFont {
        get {
            return UIFont(name: UIFont.Key.bold, size: 18.0) ?? UIFont.boldSystemFont(ofSize: 18.0)
        }
    }

    static var clientRegular: UIFont {
        get {
            return UIFont(name: UIFont.Key.regular, size: 18.0) ?? UIFont.systemFont(ofSize: 18.0)
        }
    }
}

protocol Reusable {}

extension UITableViewCell: Reusable {}

extension Reusable where Self: UITableViewCell {
    static var reuseID: String {
        return String(describing: self)
    }
}
