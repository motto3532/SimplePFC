//
//  UITextField+.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/07/19.
//

import UIKit

extension UITextField {
    func configure(onlyNumberPad: Bool) {
        
        self.backgroundColor = .white
        self.textColor = .black
        
        if onlyNumberPad {
            self.keyboardType = UIKeyboardType.numberPad
            self.textAlignment = .center
        }
    }
}
