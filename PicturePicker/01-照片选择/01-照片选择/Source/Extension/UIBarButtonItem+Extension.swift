//
//  UIBarButtonItem+Extension.swift
//  Weibo01
//
//  Created by 韦秋岑 on 2020/2/13.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    /// 便利构造函数
    /// - Parameters:
    ///   - imageName: 图像名
    ///   - target: 监听对象
    ///   - actionName: 监听图像名
    convenience init(imageName: String, target: Any?, actionName: String?) {
        let button = UIButton(imageName: imageName, higlitedImage: nil)
        // 判断 actionName
        if actionName != nil {
            button.addTarget(target, action: Selector(actionName ?? ""), for: .touchUpInside)
        }
        self.init(customView: button)
    }
    
}
