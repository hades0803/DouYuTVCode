//
//  MainViewController.swift
//  DouYuTV
//
//  Created by 段忠明 on 2020/4/2.
//  Copyright © 2020 段忠明. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addChildVC(StoryName: "Home")
        addChildVC(StoryName: "Live")
        addChildVC(StoryName: "Follow")
        addChildVC(StoryName: "Profile")
        
    }
    
    private func addChildVC(StoryName : String) {
        
        //1、通过storyboard获取控制器
        let childVC = UIStoryboard(name: StoryName, bundle: nil).instantiateInitialViewController()!
        
        //2、将childVC作为子控制器
        addChild(childVC)
    }
}
