//
//  PageContentView.swift
//  DouYuTV
//
//  Created by 段忠明 on 2020/4/8.
//  Copyright © 2020 段忠明. All rights reserved.
//

import UIKit

protocol PageContentViewDelegate : class {
    func pageContentView(contetView : PageContentView, progress : CGFloat, sourceIndex : Int, targetIndex : Int)
}

private let contentCellID = "contentCellID"

class PageContentView: UIView {
    
    //定义属性
    private var childVcs : [UIViewController]
    private weak var parentViewController : UIViewController?
    private var startOffsetX : CGFloat = 0
    private var isForbidScrollDelegate : Bool = false
    weak var delegate : PageContentViewDelegate?
    
    //懒加载属性
    private lazy var collectionView : UICollectionView = {[weak self] in
        //创建layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        //创建UICollectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout:layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: contentCellID)
        
        return collectionView
    }()
    
    //自定义构造函数
    init(frame: CGRect, childVcs : [UIViewController], parentViewController : UIViewController?) {
        
        self.childVcs = childVcs
        self.parentViewController = parentViewController
        
        super.init(frame: frame)
        
        //设置UI
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//设置UI界面
extension PageContentView {
    private func setupUI() {
        //将所有子控制器添加到父控制器里
        for childVc in childVcs {
            parentViewController?.addChild(childVc)
        }
        
        //添加UICollectionView，用于在cell中存放控制器的View
        addSubview(collectionView)
        collectionView.frame = bounds
        
        
    }
}

//遵守UICollectionViewDataSource协议
extension PageContentView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: contentCellID, for: indexPath)
        
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        //给cell设置内容
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        
        return  cell
    }
    
}

//遵守UICollectionViewDelegate协议
extension PageContentView : UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        isForbidScrollDelegate = false
        
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if isForbidScrollDelegate {
            return
        }
        
        //定义获取我们需要的数据
        var progress : CGFloat = 0
        var sourceIndex : Int = 0
        var targetIndex : Int = 0
        
        //判断是左滑还是右滑
        let currentOfsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        if currentOfsetX > startOffsetX {
            //左滑
            //计算progress
            progress = currentOfsetX / scrollViewW - floor(currentOfsetX / scrollViewW)
            
            //计算sourceIndex
            sourceIndex = Int(currentOfsetX / scrollViewW)
            
            //计算targetIndex
            targetIndex = sourceIndex + 1
            if targetIndex >= childVcs.count {
                targetIndex = childVcs.count - 1
            }
            
            //完全滑过去
            if currentOfsetX - startOffsetX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
        } else {
            //右滑
            //计算progress
            progress = 1 - currentOfsetX / scrollViewW - floor(currentOfsetX / scrollViewW)
            
            //计算targetIndex
            targetIndex = Int(currentOfsetX / scrollViewW)
            
            //计算sourceIndex
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVcs.count - 1 {
                sourceIndex = childVcs.count - 1
            }
        }
        
        //将progress、sourceIndex、targetIndex传递给titleView
        delegate?.pageContentView(contetView: self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}

//对外暴露的方法
extension PageContentView {
    func setCurrentIndex(currentIndex : Int) {
        
        //记录需要禁止执行代理方法
        isForbidScrollDelegate = true
        
        //滚动到正确的位置
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
}
