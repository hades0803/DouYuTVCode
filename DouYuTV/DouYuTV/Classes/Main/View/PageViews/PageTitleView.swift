//
//  PageTitleView.swift
//  DouYuTV
//
//  Created by 段忠明 on 2020/4/7.
//  Copyright © 2020 段忠明. All rights reserved.
//

import UIKit

//定义协议
protocol PageTitleViewDelegate : class {
    func pageTitleView(titleView : PageTitleView, selectIndex index : Int)
}

//定义常量
private let kScrollLineH : CGFloat = 2
private let kNormalColor : (CGFloat, CGFloat, CGFloat) = (85,85,85)
private let kSelectColor : (CGFloat, CGFloat, CGFloat) = (255,128,0)

//定义类
class PageTitleView: UIView {

    //MARK: - 定义属性
    private var currentIndex : Int = 0
    private var titles : [String]
    weak var delegate : PageTitleViewDelegate?
    
    //懒加载属性
    private lazy var titleLabels : [UILabel] = [UILabel]()
    private lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        return scrollView
    }()
    
    private lazy var scrollLine : UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = .orange
        return scrollLine
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
        addSubview(scrollView)
        scrollView.frame = bounds
        
        //添加title对应的label
        setupTitleLabel()
        
        //设置底线和滚动的滑块
        setupBottomMenuAndScrllLine()
    }
    
    private func setupTitleLabel() {
        //确定label的一些frame的值
        let labelW : CGFloat = frame.width / CGFloat(titles.count)
        let labelH : CGFloat = frame.height - kScrollLineH
        let labelY : CGFloat =  0
        
        for (index, value) in titles.enumerated() {
            //创建UILabel
            let label = UILabel()
            
            //设置label的属性
            label.text = value
            label.tag = index
            label.font = .systemFont(ofSize: 16.0)
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            label.textAlignment = .center
            
            //设置label的frame
            
            let labelX : CGFloat = labelW * CGFloat(index)
           
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
            //将label添加到scrollView上
            scrollView.addSubview(label)
            titleLabels.append(label)
            
            //给Label添加手势
            label.isUserInteractionEnabled = true;
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClick(tapGes:)))
            label.addGestureRecognizer(tapGes)
        }
    }
    
    private func setupBottomMenuAndScrllLine() {
        //添加底线
        let bottomLine = UIView()
        bottomLine.backgroundColor = .lightGray
        let lineH : CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        addSubview(bottomLine)
        
        //获取第一个label
        guard let firstLabel = titleLabels.first else {return}
        firstLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        
        //添加scrollLine
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - kScrollLineH, width: firstLabel.frame.width, height: kScrollLineH)
    }
}

//监听Label的点击
extension PageTitleView {
    @objc private func titleLabelClick(tapGes : UITapGestureRecognizer) {
        //获取当前label的下标值
        guard let currentLabel = tapGes.view as? UILabel else { return }
        
        //获取之前的label
        let oldLabel = titleLabels[currentIndex]
        
        //切换文字颜色
        currentLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        oldLabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        
        //保存最新label的下标值
        currentIndex = currentLabel.tag
        
        //滚动条位置发生变化
        let scrollLineX = CGFloat(currentLabel.tag) * scrollLine.frame.width
        UIView.animate(withDuration: 0.15) {
            self.scrollLine.frame.origin.x = scrollLineX
        }
        
        //通知代理
        delegate?.pageTitleView(titleView: self, selectIndex: currentIndex)
    }
}

//暴露的方法
extension PageTitleView {
    func setTitleWithProgress(progress : CGFloat, sourceIndex : Int, targetIndex : Int) {
        //取出sourceLabel/targetLabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        //处理滑块的逻辑
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveTotalX * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        
        //颜色的渐变（复杂）
        // 1、取出变化的范围
        let colorDelta = (kSelectColor.0 - kNormalColor.0, kSelectColor.1 - kNormalColor.1, kSelectColor.2 - kNormalColor.2)
        // 2、变化sourceLabel
        sourceLabel.textColor = UIColor(r: kSelectColor.0 - colorDelta.0 * progress, g: kSelectColor.1 - colorDelta.1 * progress, b: kSelectColor.2 - colorDelta.2 * progress)
        // 3、变化targetLabel
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * progress, g: kNormalColor.1 + colorDelta.1 * progress, b: kNormalColor.2 + colorDelta.2 * progress)
        
        //记录最新的index
        currentIndex = targetIndex
        
    }
}
