//
//  HomeViewController.swift
//  DouYuTV
//
//  Created by 段忠明 on 2020/4/6.
//  Copyright © 2020 段忠明. All rights reserved.
//

import UIKit

private let kTitleViewH : CGFloat = 40

class HomeViewController: UIViewController {

    //MARK: - 懒加载属性
    private lazy var pageTitleView : PageTitleView = {
        let titleFrame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH, width: kScreenW, height: kTitleViewH)
        let titles = ["推荐","游戏","娱乐","趣玩"];
        let titleView = PageTitleView(frame: titleFrame, titles: titles)
        titleView.backgroundColor = .purple
        return titleView
    }()
    
    //MARK: - 系统函数
    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置UI界面
        setupUI()
    }
    
    
}


//MARK:- 设置UI界面
extension HomeViewController {
    private func setupUI() {
        //1. 设置导航栏
        setupNavigationBar()
        
        //MARK: - 添加TitleView
        self.view.addSubview(pageTitleView)
    }
    
    private func setupNavigationBar() {
        
        //1.设置左侧的Item
        let logoBtn = UIButton()
        logoBtn.setImage(UIImage(named: "logo"), for: .normal)
        logoBtn.sizeToFit()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoBtn)
         
        //2.设置右侧的Item
        let size = CGSize(width: 40, height: 40)
        
        let historyItem = UIBarButtonItem(imageName: "image_my_history", highImageName: "Image_my_history_click", size: size)
        let searchItem = UIBarButtonItem(imageName: "btn_search", highImageName: "btn_search_clicked", size: size)
        let qrcodeItem = UIBarButtonItem(imageName: "Image_scan", highImageName: "Image_scan_click", size: size)
        navigationItem.rightBarButtonItems = [historyItem, searchItem, qrcodeItem]
    }
}
