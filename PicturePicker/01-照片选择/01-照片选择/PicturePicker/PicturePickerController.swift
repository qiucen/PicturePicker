//
//  PicturePickerController.swift
//  01-照片选择
//
//  Created by 韦秋岑 on 2020/2/16.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import UIKit

/// 可重用 cell
private let PicturePickerCellId = "PicturePickerCellId"

/// 最大选择照片数量
private let PicturePickerMaxCount = 9


/// 照片选择控制器
class PicturePickerController: UICollectionViewController {
    
    /// 配图数组
    lazy var pictures = [UIImage]()
    
    /// 当前用户选中的照片索引
    private var selectedIndex = 0

    // MARK: - 构造函数
    init() {
        super.init(collectionViewLayout: PicturePickerLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 在 collectionViewController 中，collectionView != view
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // 注册可重用 cell
        self.collectionView!.register(PicturePickerCell.self, forCellWithReuseIdentifier: PicturePickerCellId)

    }
    
    // MARK: - 照片选择器布局
    private class PicturePickerLayout: UICollectionViewFlowLayout {
        override func prepare() {
            super.prepare()
            
            // iOS 9.0以后，尤其是 iPad 支持 分屏，不建议过分依赖 UIScreen 作为布局参照！
            let count: CGFloat = 4
            // scale 就是 点，@3x 这个玩意
            let margin = UIScreen.main.scale * 4
            let w = ((collectionView?.bounds.width)! - (count + 1) * margin) / count
            
            itemSize = CGSize(width: w, height: w)
            sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: 0, right: margin)
            minimumLineSpacing = margin
            minimumInteritemSpacing = margin
        }
    }



}

// MARK: UICollectionViewDataSource
extension PicturePickerController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 保证末尾有一个 '加号' 按钮，如果达到上限，则不显示 '加号' 按钮
        return pictures.count + (pictures.count == PicturePickerMaxCount ? 0 : 1)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PicturePickerCellId, for: indexPath) as! PicturePickerCell
        
        // 设置图像
        cell.image = (indexPath.item < pictures.count) ? pictures[indexPath.item] : nil
        
        // 设置代理
        cell.pictureDelegate = self
        
        return cell
    }
}

// MARK: - PicturePickerCellDelegate
extension PicturePickerController: PicturePickerCellDelegate {
    fileprivate func picturePickerCellDidAdd(cell: PicturePickerCell) {
        // 判断是否允许访问相册
        /**
            camera 相机
            photoLibrary 保存的照片(可以删除) + 同步的照片(不允许删除)
            savedPhotosAlbum 保存的照片 / 屏幕截图 / 拍照
         */
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            print("无法访问照片库")
            return
        }
        
        // 记录当前用户选中的照片索引
        selectedIndex = collectionView.indexPath(for: cell)?.item ?? 0
        
        // 显示照片选择器
        let picker = UIImagePickerController()
        
        // 设置代理
        picker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        // 允许编辑 - 可能会用到
//        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
        
    }
    
    fileprivate func picturePickerCellDidRemove(cell: PicturePickerCell) {
        
        // 1. 获取照片索引 - 最后加上 ! 强行解包获取
        let indexPath = collectionView.indexPath(for: cell)!
        
        // 2. 判断索引是否超出上限 - 因为只能删除当前选中的照片，超出上限则不能删除
        if indexPath.item >= pictures.count {
            return
        }
        
        // 3. 删除数据
        pictures.remove(at: indexPath.item)
        
        // 4. 动画刷新视图
        collectionView.deleteItems(at: [indexPath])
        
    }
    
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension PicturePickerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /// 照片选择完成
    /// - Parameters:
    ///   - picker: 照片选择控制器
    ///   - info: info字典
    ///   - 一旦实现代理方法，必须自己 dismiss
    ///   - picker.allowsEditing = true
    ///   - 适用于头像选择
    ///   - UIImagePickerControllerEditedImage
    /**
     ///    如果使用 cocos2dx 开发一个空白的模版游戏，内存大概是 70m，iOS的空白应用程序，大概是 19m，仅供参考
     ///    一般的应用程序，内存在 100m 左右都是可以接受的！再高就需要注意！也不一定，但是内存肯定不能过多占用，否则会出问题
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let scaleImage = image.scaleToWith(width: 600)
        
        
        // 将图像添加到数组
        // 判断当前选中的索引是否超出数组上限 - 超出就在后面追加，否则就替换当前选中的图片
        if selectedIndex >= pictures.count {
            pictures.append(scaleImage)
        }else {
            pictures[selectedIndex] = scaleImage
        }
        // 刷新视图
        collectionView.reloadData()
        
        // 释放控制器
        dismiss(animated: true, completion: nil)
    }
}

/// PicturePickerCellDelegate 代理
/// 如果协议中包含 optional 的函数，协议以及函数需要使用 @objc 修饰
@objc
private protocol PicturePickerCellDelegate: NSObjectProtocol {
    
    /// 添加照片
    @objc optional func picturePickerCellDidAdd(cell: PicturePickerCell)
    /// 删除照片
    @objc optional func picturePickerCellDidRemove(cell: PicturePickerCell)
}

/// 照片选择 cell - private 修饰类，内部的一切都是私有的
private class PicturePickerCell: UICollectionViewCell {
    
    /// 照片选择代理
    weak var pictureDelegate: PicturePickerCellDelegate?
    
    var image: UIImage? {
        didSet {
            addButton.setImage(image ?? UIImage(named: "compose_pic_add"), for: .normal)
            // 隐藏删除按钮 - image == nil 就是新增按钮
            removeButton.isHidden = (image == nil)
        }
    }
    
    // MARK: - 监听方法
    @objc func addPic() {
        pictureDelegate?.picturePickerCellDidAdd?(cell: self)
    }
    
    @objc func removePic() {
        pictureDelegate?.picturePickerCellDidRemove?(cell: self)
    }
    
    
    // MARK: - 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 设置控件
    private func setupUI() {
        // 1. 添加控件
        contentView.addSubview(addButton)
        contentView.addSubview(removeButton)
        
        // 2. 设置布局
        addButton.frame = bounds
        removeButton.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.right.equalTo(contentView.snp.right)
        }
        
        // 3. 监听方法
        addButton.addTarget(self, action: #selector(addPic), for: .touchUpInside)
        removeButton.addTarget(self, action: #selector(removePic), for: .touchUpInside)
        
        // 4. 设置填充模式
        addButton.imageView?.contentMode = .scaleAspectFill
        
    }

    
    // MARK: - 懒加载控件
    /// 添加按钮
    private lazy var addButton = UIButton(imageName: "compose_pic_add", backImageName: nil)
    /// 删除按钮
    private lazy var removeButton = UIButton(imageName: "compose_photo_close", backImageName: nil)
}
