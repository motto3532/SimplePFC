//
//  UILabel+.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/07/19.
//

import UIKit

extension UILabel {
    func setBorder() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = 20.0
        self.clipsToBounds = true
    }
}
