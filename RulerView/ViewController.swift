//
//  ViewController.swift
//  RulerView
//
//  Created by hzf on 2017/5/16.
//  Copyright © 2017年 hzf. All rights reserved.
//

import UIKit
import FERulerView

class ViewController: UIViewController {
    
    var label: UILabel!
    var rulerView: FE_RulerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rulerView = FE_RulerView(10, maxNumber: 100, orientation: .horizontal, multiple: 10, isReverseValue: false)
        
        rulerView.frame = CGRect(x: 50, y: 100, width: 300, height: 100)
        self.view.addSubview(rulerView)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

