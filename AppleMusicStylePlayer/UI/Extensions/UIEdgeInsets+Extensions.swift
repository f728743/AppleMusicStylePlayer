//
//  UIEdgeInsets+Extensions.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 01.12.2024.
//

import SwiftUI

extension UIEdgeInsets {
    var edgeInsets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}
