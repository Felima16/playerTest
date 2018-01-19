//
//  UICollorExtension.swift
//  PlayerTest
//
//  Created by Fernanda de Lima on 19/01/2018.
//  Copyright © 2018 Empresinha. All rights reserved.
//

import UIKit

extension UIColor {
    static var random: UIColor {
        get {
            let hue = CGFloat(Double(arc4random() % 360) / 360.0) // 0.0 to 1.0
            let saturation: CGFloat = 0.7
            let brightness: CGFloat = 0.8
            return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
        }
    }
}
