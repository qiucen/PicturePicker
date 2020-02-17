//
//  UIColor+Extension.swift
//  Weibo01
//
//  Created by 韦秋岑 on 2020/2/16.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func randomColor() -> UIColor {
        
        // 生成 0 ～ 255
        let r = CGFloat(arc4random() % 256) / 255
        let g = CGFloat(arc4random() % 256) / 255
        let b = CGFloat(arc4random() % 256) / 255
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}
