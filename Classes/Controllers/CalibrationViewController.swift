//
//  CalibrationViewController.swift
//  GraviT
//
//  Created by 이재복 on 2016. 4. 21..
//  Copyright © 2016년 slowslipper. All rights reserved.
//

import UIKit
import CoreMotion

class CalibrationViewController: UIViewController {
    
    var motionManager = CMMotionManager()
    var gravityQueue: [(Double, Double, Double)] = []
    var circleColor: UIColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let viewSize = self.view.frame.size
        let defaultButtonSize: CGFloat = 80.0
        let completeButtonSize: CGFloat = 180.0
        let buttonMargin: CGFloat = 10.0
        var frame = CGRectZero
        
        let buttonTitleFont = UIFont(name: "AvenirNextCondensed-UltraLight", size: defaultButtonSize * 0.5)
        
        // Cancel button
        frame.origin.x = buttonMargin
        frame.origin.y = viewSize.height - defaultButtonSize - buttonMargin
        frame.size.width = defaultButtonSize
        frame.size.height = defaultButtonSize
        let buttonCancel = UIButton(frame: frame)
        buttonCancel.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        buttonCancel.layer.cornerRadius = defaultButtonSize * 0.5
        buttonCancel.titleLabel!.font = buttonTitleFont
        let titleCancel = NSMutableAttributedString(string: "Cancel")
        titleCancel.addAttribute(NSKernAttributeName, value: CGFloat(-2.0), range: NSRange(location: 0, length: titleCancel.length))
        titleCancel.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSRange(location: 0, length: titleCancel.length))
        buttonCancel.setAttributedTitle(titleCancel, forState: .Normal)
        buttonCancel.addTarget(self, action: #selector(cancelButtonDidSelect), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(buttonCancel)
        
        frame.size.width = 200
        frame.size.height = 200
        
        let centerView = UIView(frame: frame)
        centerView.backgroundColor = self.circleColor
        centerView.layer.cornerRadius = 100
        centerView.center = self.view.center
        
//        let progressView = UIImageView(frame: frame)
//        progressView.image = UIImage(named: "progress.png")
//        progressView.center = self.view.center
        
        frame = centerView.frame
//        frame.origin.x += 10.0
//        frame.origin.y += 50.0
        
        let weightView = UIView(frame: frame)
        weightView.backgroundColor = self.circleColor
        weightView.layer.cornerRadius = 100
        
        self.view.addSubview(weightView)
        self.view.addSubview(centerView)
//        self.view.addSubview(progressView)
        
        
        // Complete button
        frame.size.width = completeButtonSize
        frame.size.height = completeButtonSize
        let buttonComplete = UIButton(frame: frame)
        buttonComplete.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        buttonComplete.layer.cornerRadius = completeButtonSize * 0.5
        buttonComplete.titleLabel!.font = buttonTitleFont
        let titleComplete = NSMutableAttributedString(string: "Complete")
        titleComplete.addAttribute(NSKernAttributeName, value: CGFloat(-2.0), range: NSRange(location: 0, length: titleComplete.length))
        titleComplete.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSRange(location: 0, length: titleComplete.length))
        buttonComplete.setAttributedTitle(titleComplete, forState: .Normal)
        buttonComplete.addTarget(self, action: #selector(completeButtonDidSelect), forControlEvents: .TouchUpInside)
        buttonComplete.center = self.view.center
        
        self.view.addSubview(buttonComplete)
        
        
        if self.motionManager.deviceMotionAvailable {
            
            self.motionManager.deviceMotionUpdateInterval = 0.05
            
            let queue = NSOperationQueue.mainQueue()
            
            self.motionManager.startDeviceMotionUpdatesToQueue(queue, withHandler: { (data: CMDeviceMotion?, error: NSError?) in
                
                if let data: CMDeviceMotion = data {
                    
                    let x = data.gravity.x
                    let y = data.gravity.y
                    let z = data.gravity.z
                    
                    let g = 100.0
                    let s = CGFloat(z)
                    let transformPosition = CGAffineTransformMakeTranslation(CGFloat(x * g), -CGFloat(y * g))
                    let transformScale = CGAffineTransformMakeScale(s, s)
                    weightView.transform = CGAffineTransformConcat(transformScale, transformPosition)
                    
                    
                    self.gravityQueue.append((x, y, z))
//                    print(x, y, z)
                    
                    if self.gravityQueue.count > 10 {
                        
                        let lastIndex = self.gravityQueue.count - 1
                        let firstIndex = lastIndex - 10
                        var maxGravity: (Double, Double, Double) = self.gravityQueue[firstIndex]
                        var minGravity: (Double, Double, Double) = maxGravity
                        
                        for index in (firstIndex + 1)...lastIndex {
                            
                            let gravity = self.gravityQueue[index]
                            
                            if gravity.0 > maxGravity.0 {
                                maxGravity.0 = gravity.0
                            } else if gravity.0 < minGravity.0 {
                                minGravity.0 = gravity.0
                            }
                            
                            if gravity.1 > maxGravity.1 {
                                maxGravity.1 = gravity.1
                            } else if gravity.1 < minGravity.1 {
                                minGravity.1 = gravity.1
                            }
                            
                            if gravity.2 > maxGravity.2 {
                                maxGravity.2 = gravity.2
                            } else if gravity.2 < minGravity.2 {
                                minGravity.2 = gravity.2
                            }
                            
                        }
                        
                        let distance: (Double, Double, Double) = (maxGravity.0 - minGravity.0, maxGravity.1 - minGravity.1, maxGravity.2 - minGravity.2)
                        
                        let stableValue = sqrt(pow(distance.0, 2) + pow(distance.1, 2) + pow(distance.2, 2))
                        
                        var color = UIColor.blackColor()
                        if stableValue < 0.1 {
                            // Stable
                            color = UIColor.init(red: 77 / 255, green: 255 / 255, blue: 127 / 255, alpha: 0.8)
                        } else {
                            // Unstable
                            color = UIColor.init(red: 255 / 255, green: 0 / 255, blue: 102 / 255, alpha: 0.8)                        }
                        color = color.colorWithAlphaComponent(0.8)
                        
                        if self.circleColor != color {
                            self.circleColor = color
                            UIView.animateWithDuration(0.5, animations: { 
                                centerView.backgroundColor = color
                                weightView.backgroundColor = color
                            })
                        }
                        
                        print(stableValue)
                    }
                }
            })
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.motionManager.stopDeviceMotionUpdates()
        
    }
    
    func completeButtonDidSelect() {
        
        let index = self.gravityQueue.count - 10
        let gravity = self.gravityQueue[index]
        let x = gravity.0
        let y = gravity.1
        let z = gravity.2
        NSUserDefaults.standardUserDefaults().setDouble(atan2(x, y), forKey: "calibrationRotationZ")
        NSUserDefaults.standardUserDefaults().setDouble(atan2(z, y), forKey: "calibrationRotationX")
        NSUserDefaults.standardUserDefaults().setDouble(atan2(x, z), forKey: "calibrationRotationY")
        
        self.cancelButtonDidSelect()
        
    }
    
    func cancelButtonDidSelect() {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
}
