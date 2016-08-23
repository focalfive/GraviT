//
//  ExploreLineViewController.swift
//  GraviT
//
//  Created by 이재복 on 2016. 4. 17..
//  Copyright © 2016년 slowslipper. All rights reserved.
//

import UIKit

class ExploreLineViewController: UIViewController {
    
    var data: Line! = nil
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let viewSize = self.view.frame.size
        let buttonSize: CGFloat = 80.0
        let buttonMargin: CGFloat = 10.0
        var frame = CGRectZero
        
        let buttonTitleFont = UIFont(name: "AvenirNextCondensed-UltraLight", size: buttonSize * 0.5)
        let labelFont = UIFont(name: "AvenirNextCondensed-UltraLight", size: 100)
        
        // Cancel button
        frame.origin.x = buttonMargin
        frame.origin.y = viewSize.height - buttonSize - buttonMargin
        frame.size.width = buttonSize
        frame.size.height = buttonSize
        let buttonCancel = UIButton(frame: frame)
        buttonCancel.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        buttonCancel.layer.cornerRadius = buttonSize * 0.5
        buttonCancel.titleLabel!.font = buttonTitleFont
        let titleCancel = NSMutableAttributedString(string: "Cancel")
        titleCancel.addAttribute(NSKernAttributeName, value: CGFloat(-2.0), range: NSRange(location: 0, length: titleCancel.length))
        titleCancel.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSRange(location: 0, length: titleCancel.length))
        buttonCancel.setAttributedTitle(titleCancel, forState: .Normal)
        buttonCancel.addTarget(self, action: #selector(cancelButtonDidSelect), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(buttonCancel)
        
        frame.origin.x = 0
        frame.origin.y = 100
        frame.size.width = viewSize.width
        frame.size.height = viewSize.height - 200
        
        let labelAcceleration = UILabel(frame: frame)
        labelAcceleration.textColor = UIColor.blackColor()
        labelAcceleration.font = labelFont
        labelAcceleration.textAlignment = .Center
        labelAcceleration.text = "\(self.data!.dots.count)"
        
        self.view.addSubview(labelAcceleration)
    }
    
    func cancelButtonDidSelect() {
        print("cancelButtonDidSelect")
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
