//
//  UIBarButtonItem-Extension.swift
//  DouYuTV
//
//  Created by 段忠明 on 2020/4/6.
//  Copyright © 2020 段忠明. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    /*
    class func createItem(imageName : String, highImageName : String, size : CGSize) -> UIBarButtonItem {
        
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.setImage(UIImage(named: highImageName), for: .highlighted)
        btn.frame = CGRect(origin: CGPoint.zero, size: size)
        
        return UIBarButtonItem(customView: btn)
    }
    */
    
    //便利构造函数：1、convenience开头 2、在构造函数中必须明确调用一个设计的构造函数（self）
    convenience init(imageName : String, highImageName : String, size : CGSize) {
        
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.setImage(UIImage(named: highImageName), for: .highlighted)
        btn.frame = CGRect(origin: CGPoint.zero, size: size)
        
        self.init(customView : btn)
    }
}
