//
//  UITextField+.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/07/10.
//

import UIKit

extension UITextField {
    var textToInt: Int {
        let text = self.text
        let int = text.flatMap{ Int($0) } ?? 0
        return int
    }
}
