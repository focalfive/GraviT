//
//  ExploreLineViewController.swift
//  GraviT
//
//  Created by 이재복 on 2016. 4. 17..
//  Copyright © 2016년 slowslipper. All rights reserved.
//

import UIKit

class ExploreLineViewController: UIViewController {
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let viewSize = self.view.frame.size
        let buttonSize: CGFloat = 80.0
        let buttonMargin: CGFloat = 10.0
        var frame = CGRectZero
        
        let buttonTitleFont = UIFont(name: "AvenirNextCondensed-UltraLight", size: buttonSize * 0.5)
        
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
        
    }
    
    func cancelButtonDidSelect() {
        print("cancelButtonDidSelect")
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
