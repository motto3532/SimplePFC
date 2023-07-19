//
//  UIView+.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/07/19.
//

import UIKit

extension UIView {
    func setCornerRadius() {
        self.layer.cornerRadius = 30.0
        self.clipsToBounds = true
    }
}
