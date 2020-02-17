//
//  UIButton+Extension.swift
//  Weibo01
//
//  Created by 韦秋岑 on 2020/1/16.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import UIKit

extension UIButton {
    
    ///  便利 构造函数
    /// - Parameters:
    ///   - imageName: 图像名称
    ///   - backImageName: 背景图像名称
    ///   - 备注：如果图像名称使用 " "，会报 [framework] CUICatalog: Invalid asset name supplied: '' 错误
    convenience init(imageName: String, backImageName: String?) {
        self.init()
        setImage(UIImage(named: imageName), for: .normal)
        setImage(UIImage(named: imageName + "_back"), for: .highlighted)
        if let backImageName = backImageName {
            setBackgroundImage(UIImage(named: backImageName), for: .normal)
            setBackgroundImage(UIImage(named: backImageName), for: .highlighted)
        }
        // 一定要设置 btn 的 frame
        sizeToFit()
    }
    
    /// 遍利构造函数
    /// - Parameters:
    ///   - imageName: 图像名称
    ///   - higlitedImage: 高亮图像名称
    ///   - 备注：如果图像名称使用 " "，会报 [framework] CUICatalog: Invalid asset name supplied: '' 错误
    convenience init(imageName: String, higlitedImage: String?) {
        self.init()
        setImage(UIImage(named: imageName), for: .normal)
        setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        if let higlitedImage = higlitedImage {
            setBackgroundImage(UIImage(named: higlitedImage), for: .normal)
            setBackgroundImage(UIImage(named: higlitedImage), for: .highlighted)
        }
        sizeToFit()
    }
    
    /// 便利构造函数
    /// - Parameters:
    ///   - title: title
    ///   - color: color
    ///   - backImageName: 背景图片
    ///   - return: UIbutton
    convenience init(title: String, color: UIColor, backImageName: String) {
        self.init()
        setTitle(title, for:.normal)
        setTitleColor(color, for: .normal)
        setBackgroundImage(UIImage(named: backImageName), for: .normal)
        sizeToFit()
    }
    
    /// 便利构造函数
    /// - Parameters:
    ///   - title: title
    ///   - color: color
    ///   - imageName: 背景图片
    ///   - fontSize: 字体大小
    ///   - backColor: 背景颜色
    convenience init(title: String, fontSize: CGFloat, color: UIColor, imageName: String?, backColor: UIColor? = nil) {
        self.init()
        
        setTitle(title, for:.normal)
        setTitleColor(color, for: .normal)
        if let imageName = imageName {
            setImage(UIImage(named: imageName), for: .normal)
        }
        // 设置背景颜色
        backgroundColor = backColor
        titleLabel?.font = .systemFont(ofSize: fontSize)
        sizeToFit()
    }
}
