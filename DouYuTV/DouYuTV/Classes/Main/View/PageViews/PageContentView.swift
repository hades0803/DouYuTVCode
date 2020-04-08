//
//  PageContentView.swift
//  DouYuTV
//
//  Created by 段忠明 on 2020/4/8.
//  Copyright © 2020 段忠明. All rights reserved.
//

import UIKit

class PageContentView: UIView {
    
    //定义属性
    private var childVcs : [UIViewController]
    private var parentViewController : UIViewController
    //自定义构造函数
    init(frame: CGRect, childVcs : [UIViewController], parentViewController : UIViewController) {
        
        self.childVcs = childVcs
        self.parentViewController = parentViewController
        
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
