//
//  PageTitleView.swift
//  DouYuTV
//
//  Created by 段忠明 on 2020/4/7.
//  Copyright © 2020 段忠明. All rights reserved.
//

import UIKit

class PageTitleView: UIView {

    //MARK: - 定义属性
    private var titles : [String]
    
    //懒加载属性
    private lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        return scrollView
    }()
    
    //MARK: - 自定义构造函数
    init(frame: CGRect, titles : [String]) {
        self.titles = titles
        
        super.init(frame: frame)
        
        //设置UI界面
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//设置UI界面
extension PageTitleView {
    private func setupUI() {
        //添加UIScrollView
    }
}
