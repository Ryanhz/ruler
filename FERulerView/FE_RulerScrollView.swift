//
//  FE_RulerScrollView.swift
//  RulerView
//
//  Created by hzf on 2017/5/15.
//  Copyright © 2017年 hzf. All rights reserved.
//

import UIKit

class FE_RulerScrollView: UIScrollView {

    fileprivate var rulerImage: UIImage!
    var minNumber: Int = 0 {
        didSet{
            resetSubview()
        }
    }
    var maxNumber: Int = 100 {
        didSet{
           resetSubview()
        }
    }
    //一个尺子表示的大小
    var multiple: Int = 10 {
        didSet{
            resetSubview()
        }
    }
    var orientationType: RulerOrientation = .horizontal{
        didSet{
            resetSubview()
        }
    }
    var titleColor: UIColor = UIColor.gray {
        willSet{
            if titleColor == newValue {
                return
            }
            setTitleTextColor(color: newValue, font: nil)
        }
    }
    
    //显示刻度的lable的字体大小
    var titleFont: CGFloat = 12 {
        willSet {
            
            setTitleTextColor(color: nil, font: newValue)
        }
    }
    
    let imageSpaceToLable: CGFloat = 10 //刻度距离文字的距离
    
    var isReverseValue: Bool = false {
        didSet{
            resetSubview()
        }
    }
    
    init(_ minNumber: Int, maxNumber: Int, orientation:RulerOrientation, multiple: Int, isReverseValue: Bool) {
    
        super.init(frame: CGRect.zero)
        
        self.minNumber = minNumber
        self.maxNumber = maxNumber
        self.multiple = multiple
        self.orientationType = orientation
        self.isReverseValue = isReverseValue
        setup()
        resetSubview()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        resetSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupRuleImageView(){
        
        let rulerImageCount = abs(maxNumber - minNumber) / multiple
        
        for i in 0...rulerImageCount  {
            
            let rulerImageView = UIImageView(image: rulerImage)
            rulerImageView.tag = i
            self.addSubview(rulerImageView)
            
            var text = ""
            if isReverseValue {
                text = "\(maxNumber - i * multiple)"
            } else {
                text = "\(minNumber + i * multiple)"
            }
            
            let rulerLabel = UILabel()
            rulerLabel.textAlignment = .center
            rulerLabel.text = text
            rulerLabel.textColor = titleColor
            rulerLabel.font = UIFont.systemFont(ofSize: titleFont)
            self.addSubview(rulerLabel)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var centerPoint: CGPoint = CGPoint(x: 0, y: 0)
        var rulerImageViewW: CGFloat = 0
        var rulerImageViewH: CGFloat = 0
        for sub in self.subviews {
            
            if sub is UIImageView {
                
                rulerImageViewW=sub.frame.size.width;
                rulerImageViewH=sub.frame.size.height;
                
                let rulerImageViewX = (orientationType == .horizontal) ? rulerImageViewW * CGFloat(sub.tag) : 0
                let rulerImageViewY = (orientationType == .horizontal) ? 0 : rulerImageViewH * CGFloat(sub.tag)
                
                sub.frame = CGRect(x: rulerImageViewX, y: rulerImageViewY, width: rulerImageViewW, height: rulerImageViewH)
                centerPoint = sub.center
                
            } else if sub is UILabel {
                
                var rulerLableX: CGFloat = 0
                var rulerLableY: CGFloat = 0
                var rulerLableW: CGFloat = 0
                var rulerLableH: CGFloat = 0
                
                if orientationType == .horizontal {
                    rulerLableW = 60;
                    rulerLableH = 20;
                    rulerLableX = centerPoint.x - rulerLableW / 2;
                    rulerLableY = rulerImageViewH + imageSpaceToLable;
                } else {
                    rulerLableW = 60;
                    rulerLableH = 60;
                    rulerLableX = rulerImageViewW - imageSpaceToLable;
                    rulerLableY = centerPoint.y - rulerLableH / 2;
                    print(centerPoint)
                }
                sub.frame = CGRect(x: rulerLableX, y: rulerLableY, width: rulerLableW, height: rulerLableH)
                
            }

        }
    }
    
    func setup() {
        self.canCancelContentTouches = false
        self.backgroundColor = UIColor.clear
        self.indicatorStyle = .white
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.bounces = true
        self.isScrollEnabled = true
        self.isPagingEnabled = false
        self.decelerationRate = 0.7
        self.clipsToBounds = false
    }
    
    func resetSubview() {
        let rulerImageCount = CGFloat(abs(maxNumber - minNumber)/multiple + 1)
        
        if orientationType == .horizontal { //水平
            rulerImage = UIImage(named: resourceImagesRooturl + "ruler_weight")
            self.contentSize = CGSize(width: rulerImage.size.width * rulerImageCount, height: self.frame.size.height)
        } else {
            
            rulerImage = UIImage(named: resourceImagesRooturl + "ruler_height")
            self.contentSize = CGSize(width: self.frame.size.width, height: rulerImage.size.height * rulerImageCount)
        }
        clearSubviews()
        setupRuleImageView()
    }
    
    func clearSubviews(){
        
        for sub in self.subviews {
            guard sub is UIImageView || sub is UILabel else {
                continue
            }
            sub.removeFromSuperview()
        }
    }
    
    func setTitleTextColor(color: UIColor?, font: CGFloat?) {
        for sub in self.subviews {
            guard sub is UILabel else {
                continue
            }
            
            let label = sub as! UILabel
            if let textColor = color {
                label.textColor = textColor
            }
            
            if let textFont = font {
                label.font = UIFont.systemFont(ofSize: textFont)
            }
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
