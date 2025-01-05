//
//  UIScreen+Extensions.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 20.11.2024.
//

import UIKit

extension UIScreen {
    static var deviceCornerRadius: CGFloat {
        main.value(forKey: "_displayCornerRadius") as? CGFloat ?? 0
    }
    
    static var hairlineWidth: CGFloat {
        1 / main.scale
    }
}
