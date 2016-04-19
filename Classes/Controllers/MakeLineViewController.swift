//
//  MakeLineViewController.swift
//  GraviT
//
//  Created by 이재복 on 2016. 4. 14..
//  Copyright © 2016년 slowslipper. All rights reserved.
//

import UIKit
import RealmSwift

class MakeLineViewController: UIViewController, UITextFieldDelegate {
    
    var textFieldTitle: UITextField?
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.whiteColor()
        
        let viewSize = self.view.frame.size
        let margin: CGFloat = 10.0
        let labelHeight: CGFloat = 100.0
        let buttonSize: CGFloat = 80.0
        let buttonMargin: CGFloat = 10.0
        var frame = CGRectZero
        
        let buttonTitleFont = UIFont(name: "AvenirNextCondensed-UltraLight", size: buttonSize * 0.5)
        let textFieldTitleFont = UIFont(name: "AvenirNextCondensed-UltraLight", size: labelHeight)
        
        // Title
        frame.origin.x = margin
        frame.origin.y = (viewSize.height - labelHeight) * 0.5
        frame.size.width = viewSize.width - margin * 2.0
        frame.size.height = labelHeight
        self.textFieldTitle = UITextField(frame: frame)
        self.textFieldTitle!.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        self.textFieldTitle!.font = textFieldTitleFont
        self.textFieldTitle!.textColor = UIColor.whiteColor()
        self.textFieldTitle!.delegate = self
        
        self.view.addSubview(self.textFieldTitle!)
        
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
        
        // OK button
        frame.origin.x = viewSize.width - buttonSize - buttonMargin
        frame.origin.y = viewSize.height - buttonSize - buttonMargin
        frame.size.width = buttonSize
        frame.size.height = buttonSize
        let buttonOK = UIButton(frame: frame)
        buttonOK.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        buttonOK.layer.cornerRadius = buttonSize * 0.5
        buttonOK.titleLabel!.font = buttonTitleFont
        let titleOK = NSMutableAttributedString(string: "OK")
        titleOK.addAttribute(NSKernAttributeName, value: CGFloat(-2.0), range: NSRange(location: 0, length: titleOK.length))
        titleOK.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSRange(location: 0, length: titleOK.length))
        buttonOK.setAttributedTitle(titleOK, forState: .Normal)
        buttonOK.addTarget(self, action: #selector(nextButtonDidSelect), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(buttonOK)
    }
    
    func cancelButtonDidSelect() {
        print("cancelButtonDidSelect")
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func nextButtonDidSelect() {
        print("nextButtonDidSelect")
        
//        let realm = try! Realm()
//        
//        let model = Line()
//        model.title = (self.textFieldTitle?.text)!
//        try! realm.write {
//            realm.add(model)
//        }
        
        let drawLineViewController = DrawLineViewController()
        drawLineViewController.lineTitle = (self.textFieldTitle?.text)!
//        drawLineViewController.data = model
        self.navigationController?.pushViewController(drawLineViewController, animated: true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.nextButtonDidSelect()
        return false
    }
    
}
