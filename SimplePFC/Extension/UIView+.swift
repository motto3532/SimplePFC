//
//  UIView+.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/07/19.
//

import UIKit

extension UIView {
    func setCornerRadius(cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
}
