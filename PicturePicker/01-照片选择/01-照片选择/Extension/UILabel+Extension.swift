//
//  UILabel+Extension.swift
//  Weibo01
//
//  Created by 韦秋岑 on 2020/1/17.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import UIKit

extension UILabel {
    
    /// 便利构造函数
    /// - Parameters:
    ///   - title: title
    ///   - color: color，默认深灰色
    ///   - fontSize: size，默认14号字
    ///   - screenInset: screenInset，相对于屏幕左右的缩进，居中显示，如果设置，则左对齐
    ///   - 参数后面的值是参数的默认值，如果不传递，就使用默认值
    convenience init(title: String, color: UIColor = .darkGray, fontSize: CGFloat = 14, screenInset: CGFloat = 0) {
        self.init()
        text = title
        // 界面设计上，避免使用纯黑色
        textColor = color
        font = UIFont.systemFont(ofSize: fontSize)
        
        numberOfLines = 0
        if screenInset == 0 {
            textAlignment = NSTextAlignment.center
        }else {
            // 设置换行高度 - 一定要设置 preferredMaxLayoutWidth 这个属性
            preferredMaxLayoutWidth = UIScreen.main.bounds.width - 2 * screenInset
            textAlignment = .left
        }
        sizeToFit()
    }
}
