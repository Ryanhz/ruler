//
//  FE_RulerView.swift
//  RulerView
//
//  Created by hzf on 2017/5/15.
//  Copyright © 2017年 hzf. All rights reserved.
//

import UIKit

public protocol FE_RulerViewDelegate: NSObjectProtocol {
    func rulerView(rulerView: FE_RulerView, valueChange value: CGFloat)
}

public enum RulerOrientation: Int {
    case horizontal = 0, vertical
}

public class FE_RulerView: UIView {
    
    let ruleImage = UIImage(named: resourceImagesRooturl + "ruler_weight")
    
    var rulerScrollView: FE_RulerScrollView!
    fileprivate var pointerView: UIView!
    
    public var isRound: Bool = false
    //红色指针的高度
    public var pointViewH: CGFloat = 23
    
    //RulerScrollView的宽度或高度
    public let rulerViewWOH: CGFloat = 1.2
    
    public weak var delegate: FE_RulerViewDelegate?
    
    public var isReverseValue: Bool = true {
        willSet{
            if isReverseValue == newValue {
                return
            }
            rulerScrollView.isReverseValue = newValue
        }
    }
    
   public var minNumber: Int = 10 {
        willSet{
            if minNumber == newValue {
                return
            }
            rulerScrollView.minNumber = newValue
        }
    }
    public var maxNumber: Int = 100 {
        willSet{
            if maxNumber == newValue {
                return
            }
            rulerScrollView.maxNumber = newValue
        }
    }
    
    /// 一个尺子能表示的大小
    public var multiple: Int = 10{
        willSet{
            if multiple == newValue {
                return
            }
            rulerScrollView.multiple = newValue
        }
    }
    public var titleColor: UIColor = UIColor.gray {
        willSet{
            if titleColor == newValue {
                return
            }
            rulerScrollView.titleColor = newValue
        }
    }
    
    public var titleFont: CGFloat = 12 {
        willSet{
            if titleFont == newValue {
                return
            }
            rulerScrollView.titleFont = newValue
        }
    }
    
    public var orientationType: RulerOrientation = .horizontal {
        didSet{
            if orientationType == oldValue {
                return
            }
            rulerScrollView.orientationType = orientationType
//            layoutSubviews()
            layoutIfNeeded()
        }
    }
    

    public var defaultValue: CGFloat = 0 {
        willSet{
            //获取每个表格的长度
            let formlength = ruleImage!.size.width / CGFloat(multiple)
            let gapValue=(newValue - CGFloat(minNumber) + CGFloat(multiple)/2) * formlength
            
            if orientationType == .horizontal {
                
                var contentOffset_x: CGFloat = 0
                
                if isReverseValue {
                    contentOffset_x = rulerScrollView.contentSize.width - gapValue
                } else {
                    contentOffset_x = gapValue
                }
                
                rulerScrollView.contentOffset = CGPoint(x: contentOffset_x, y: 0)
                
            } else {
                
                var contentOffset_y: CGFloat = 0
                
                if isReverseValue {
                    contentOffset_y = rulerScrollView.contentSize.height - gapValue
                } else {
                    contentOffset_y = gapValue
                }
                
                rulerScrollView.contentOffset = CGPoint(x: 0, y: contentOffset_y)
            }
            
        }
    }

    public init(_ minNumber: Int, maxNumber: Int, orientation:RulerOrientation, multiple: Int, isReverseValue: Bool) {
        
        super.init(frame: CGRect.zero)
        self.minNumber = minNumber
        self.maxNumber = maxNumber
        self.orientationType = orientation
        self.multiple = multiple
        self.isReverseValue = isReverseValue
        setupSubviews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
       setupSubviews()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if orientationType == .horizontal {
            
            let pointerViewW = rulerViewWOH
            let pointerViewH = pointViewH
            let pointerViewX = (self.frame.size.width - pointerViewW) / 2
            let pointerViewY: CGFloat = 0;
            pointerView.frame = CGRect(x: pointerViewX, y: pointerViewY, width: pointerViewW, height: pointerViewH)

            rulerScrollView.frame = CGRect(x: self.frame.size.width/2, y: 0, width: rulerViewWOH, height: self.frame.size.height)
            
        } else {
            
            let pointerViewW = pointViewH
            let pointerViewH = rulerViewWOH
            let pointerViewX: CGFloat = 0
            let pointerViewY = (self.frame.size.height - pointerViewH)/2
            pointerView.frame=CGRect(x: pointerViewX, y: pointerViewY, width: pointerViewW, height: pointerViewH);
            rulerScrollView.frame=CGRect(x: 0, y: self.frame.size.height/2, width: self.frame.size.width, height: rulerViewWOH)
        }
        
    }
    
    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view is FE_RulerView {
            return rulerScrollView
        } else {
            return view
        }
    }

    func setupSubviews(){
        self.clipsToBounds = true
        rulerScrollView = FE_RulerScrollView.init(minNumber, maxNumber: maxNumber, orientation: self.orientationType, multiple: multiple, isReverseValue: isReverseValue)
        rulerScrollView.delegate = self
        self.addSubview(rulerScrollView)
        
        pointerView = UIView()
        pointerView.backgroundColor = UIColor.red
        self.addSubview(pointerView)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}


extension FE_RulerView: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //获取每个表格的长度
        let formlength = ruleImage!.size.width / CGFloat(multiple)
        //指针指向的刻度
        var value: CGFloat = 0
        
        //滑动的刻度值
        var scrollValue: CGFloat = 0
        
        var contentOffsetValue: CGFloat = 0
        
        if orientationType == .horizontal {
            contentOffsetValue = scrollView.contentOffset.x
        } else {
            contentOffsetValue = scrollView.contentOffset.y
        }
        
        scrollValue = (contentOffsetValue / formlength) - CGFloat(multiple)/2
        if isRound {
            
            if isReverseValue {
                value = CGFloat(maxNumber) - round(scrollValue)
            } else {
                value = CGFloat(minNumber) + round(scrollValue)
            }
        } else {
            
            if isReverseValue {
                value = CGFloat(maxNumber) - scrollValue
            } else {
               value = CGFloat(minNumber) + scrollValue
            }
        }
        
        self.delegate?.rulerView(rulerView: self, valueChange: value)
        
    }
    
}

