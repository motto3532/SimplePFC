//
//  UIView+.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/07/19.
//

import UIKit

//このエクステンションいらんかも
extension UIView {
    func setCornerRadius(cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        //丸角の外側に描画された内容が表示されないようにする(画像とか)
        self.clipsToBounds = true
    }
}
