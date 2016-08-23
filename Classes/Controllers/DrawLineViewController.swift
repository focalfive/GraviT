//
//  DrawLineViewController.swift
//  GraviT
//
//  Created by 이재복 on 2016. 4. 14..
//  Copyright © 2016년 slowslipper. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation
import RealmSwift

class DrawLineViewController: UIViewController, CLLocationManagerDelegate {
    
    var motionManager = CMMotionManager()
    var locationManager: CLLocationManager?
    var gyroContainer: UIView?
    var horizonFrontView = UIView()
    var horizonBackView = UIView()
    var forceXView = UIView()
    var forceYView = UIView()
    var horizonFrontLayer = CALayer()
    var horizonBackLayer = CALayer()
    var buttonPlay: UIButton?
    var buttonPause: UIButton?
    var labelAcceleration: UILabel = UILabel()
    var lineTitle = ""
    var rotationX: CGFloat = 0.0
    var rotationZ: CGFloat = 0.0
    var accelerationX: Double = 0.0
    var accelerationY: Double = 0.0
    var accelerationZ: Double = 0.0
    var distanceAll = 0
    var horizonViewDistanceY: CGFloat = 0.0
    var timerAccelerationValueUpdate: NSTimer?
    let accelerationValueUpdateInterval: NSTimeInterval = 0.2
    var dots: [Dot] = []
    var location: (Double, Double)?
    var count: UInt = 0
    
    
    var labelTrace: UILabel = UILabel()
    
    
    let frontColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
    let backColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
    var colorLeft = UIColor.init(red: 0 / 255, green: 150 / 255, blue: 255 / 255, alpha: 1.0)
    var colorRight = UIColor.init(red: 255 / 255, green: 0 / 255, blue: 102 / 255, alpha: 1.0)
    var colorTop = UIColor.init(red: 77 / 255, green: 255 / 255, blue: 127 / 255, alpha: 1.0)
    var colorBottom = UIColor.init(red: 255 / 255, green: 232 / 255, blue: 77 / 255, alpha: 1.0)
    var forceXColor = UIColor.blackColor()
    var forceYColor = UIColor.blackColor()
    
    var isRunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let viewSize = self.view.frame.size
        let startButtonSize: CGFloat = 500.0
        let buttonSize: CGFloat = 80.0
        let buttonMargin: CGFloat = 10.0
        let horizonWidth: CGFloat = floor(max(viewSize.width, viewSize.height) * 2.0)
        var frame = CGRectZero
        
        let buttonTitleFont = UIFont(name: "AvenirNextCondensed-UltraLight", size: buttonSize * 0.5)
//        let labelAccelerationFont = UIFont(name: "AvenirNextCondensed-UltraLight", size: 100)
        let labelAccelerationFont = UIFont(name: "Avenir-Heavy", size: 70)

        
        // Gyro view
        frame.size = viewSize
        self.gyroContainer = UIView(frame: frame)
        self.gyroContainer!.hidden = !self.isRunning
        self.view.addSubview(self.gyroContainer!)
        
        // Horizon view
        frame.size.width = horizonWidth
        frame.size.height = horizonWidth
        frame.origin.x = (viewSize.width - horizonWidth) * 0.5
        frame.origin.y = viewSize.height * 0.5
        
        self.horizonFrontView.frame = frame
        self.horizonFrontView.center = self.gyroContainer!.center
        
        self.horizonBackView.frame = frame
        self.horizonBackView.center = self.gyroContainer!.center
        
        frame.origin = CGPointZero
        frame.size.height = horizonWidth * 0.5
        
        self.horizonFrontLayer.allowsEdgeAntialiasing = true
        self.horizonFrontLayer.frame = frame
        self.horizonFrontLayer.backgroundColor = self.frontColor.CGColor
        self.horizonFrontView.layer.addSublayer(self.horizonFrontLayer)
        
        self.horizonBackLayer = CALayer()
        self.horizonBackLayer.allowsEdgeAntialiasing = true
        self.horizonBackLayer.frame = frame
        self.horizonBackLayer.backgroundColor = self.backColor.CGColor
        self.horizonBackView.layer.addSublayer(self.horizonBackLayer)
        
        frame.size.width = 240
        frame.size.height = 240
        self.forceXView.frame = frame
        self.forceXView.backgroundColor = self.forceXColor
        self.forceXView.layer.cornerRadius = 120
        self.forceXView.center = self.gyroContainer!.center
        
        self.forceYView.frame = frame
        self.forceYView.backgroundColor = self.forceYColor
        self.forceYView.layer.cornerRadius = 120
        self.forceYView.center = self.gyroContainer!.center
        
        let centerView = UIView(frame: frame)
        centerView.backgroundColor = UIColor.blackColor()
        centerView.layer.cornerRadius = 120
        centerView.center = self.gyroContainer!.center
        
        self.labelAcceleration.frame = frame
        self.labelAcceleration.textColor = UIColor.whiteColor()
        self.labelAcceleration.font = labelAccelerationFont
        self.labelAcceleration.textAlignment = .Center
        self.labelAcceleration.text = "0"
        self.labelAcceleration.center = self.gyroContainer!.center
        
//        // For debug trace
//        frame.origin.x = 100.0
//        frame.size.width = viewSize.width
//        frame.size.height = 200
//        frame.origin.y = viewSize.height - frame.size.height
//        
//        self.labelTrace.frame = frame
//        self.labelTrace.backgroundColor = UIColor.blackColor()
//        self.labelTrace.textColor = UIColor.greenColor()
//        self.labelTrace.font = UIFont(name: "AvenirNextCondensed-UltraLight", size: 16)
//        self.labelTrace.textAlignment = .Left
//        self.labelTrace.text = "..."
//        self.labelTrace.numberOfLines = 0
        
        self.gyroContainer!.addSubview(self.horizonFrontView)
        self.gyroContainer!.addSubview(self.horizonBackView)
        self.gyroContainer!.addSubview(self.forceXView)
        self.gyroContainer!.addSubview(self.forceYView)
        self.gyroContainer!.addSubview(centerView)
        self.gyroContainer!.addSubview(self.labelAcceleration)
        self.gyroContainer!.addSubview(self.labelTrace)
        
        // Play button
        frame.origin.x = (viewSize.width - startButtonSize) * 0.5
        frame.origin.y = (viewSize.height - startButtonSize) * 0.5
        frame.size.width = startButtonSize
        frame.size.height = startButtonSize
        self.buttonPlay = UIButton(frame: frame)
        self.buttonPlay!.backgroundColor = UIColor.redColor()//.colorWithAlphaComponent(0.8)
        self.buttonPlay!.layer.cornerRadius = startButtonSize * 0.5
        self.buttonPlay!.titleLabel!.font = buttonTitleFont
        let titlePlay = NSMutableAttributedString(string: "Start")
        titlePlay.addAttribute(NSKernAttributeName, value: CGFloat(-2.0), range: NSRange(location: 0, length: titlePlay.length))
        titlePlay.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSRange(location: 0, length: titlePlay.length))
        self.buttonPlay!.setAttributedTitle(titlePlay, forState: .Normal)
        self.buttonPlay!.addTarget(self, action: #selector(startButtonDidSelect), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(self.buttonPlay!)
        
        // Stop button
        frame.origin.x = buttonMargin
        frame.origin.y = viewSize.height - buttonSize - buttonMargin
        frame.size.width = buttonSize
        frame.size.height = buttonSize
        let buttonStop = UIButton(frame: frame)
        buttonStop.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        buttonStop.layer.cornerRadius = buttonSize * 0.5
        buttonStop.titleLabel!.font = buttonTitleFont
        let titleStop = NSMutableAttributedString(string: "Stop")
        titleStop.addAttribute(NSKernAttributeName, value: CGFloat(-2.0), range: NSRange(location: 0, length: titleStop.length))
        titleStop.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSRange(location: 0, length: titleStop.length))
        buttonStop.setAttributedTitle(titleStop, forState: .Normal)
        buttonStop.addTarget(self, action: #selector(stopButtonDidSelect), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(buttonStop)
        
        
        self.locationManager = CLLocationManager()
    }
    
//    func trace(message: String) {
//        self.labelTrace.text = message
//    }
    
    override func viewWillAppear(animated: Bool) {
        if self.isRunning && self.timerAccelerationValueUpdate == nil {
            self.timerAccelerationValueUpdate = NSTimer.scheduledTimerWithTimeInterval(self.accelerationValueUpdateInterval, target: self, selector: #selector(updateAccelerationLabel), userInfo: nil, repeats: true)
        }
    }

    override func viewWillDisappear(animated: Bool) {
        self.motionManager.stopDeviceMotionUpdates()
        self.timerAccelerationValueUpdate?.invalidate()
        self.timerAccelerationValueUpdate = nil
    }
    
    func redrawGyroView(dx distanceX: Double, dy distanceY: Double, dz distanceZ: Double) {
        
        self.horizonViewDistanceY = CGFloat((CGFloat(M_PI * 0.5) - abs(self.rotationX)) * 50.0)
        self.horizonFrontLayer.frame.origin.y = -self.horizonViewDistanceY
        self.horizonBackLayer.frame.origin.y = self.horizonViewDistanceY
        
        let transformRotation = CGAffineTransformMakeRotation(self.rotationZ)
        let transformRotationLabel = CGAffineTransformMakeRotation(self.rotationZ + CGFloat(M_PI))
        let scale = CGFloat(1.0 - distanceZ * 0.5)
        
        let gravity = CGFloat(100.0)
        let transformScale = CGAffineTransformMakeScale(scale, scale)
        var centerX = self.gyroContainer!.center
        var centerY = centerX
        centerX.x += CGFloat(distanceX) * gravity
        centerY.y -= CGFloat(distanceY) * gravity
        self.forceXColor = distanceX < 0.0 ? self.colorLeft : self.colorRight
        self.forceYColor = distanceY > 0.0 ? self.colorTop : self.colorBottom
        
        self.distanceAll = Int((abs(distanceX) + abs(distanceY) + abs(distanceZ)) * 100)
        
        UIView.animateWithDuration(0.2) {
            self.forceXView.transform = transformScale
            self.forceXView.center = centerX
            self.forceXView.backgroundColor = self.forceXColor
            self.forceYView.transform = transformScale
            self.forceYView.center = centerY
            self.forceYView.backgroundColor = self.forceYColor
        }
        
//        UIView.animateWithDuration(0.05) {
            self.horizonFrontView.transform = transformRotation
            self.horizonBackView.transform = transformRotation
            self.labelAcceleration.transform = transformRotationLabel
//        }
    }
    
    func updateAccelerationLabel() {
        self.labelAcceleration.text = "\(self.distanceAll)"
    }
    
    func startButtonDidSelect() {
        print("startButtonDidSelect")
        
        UIApplication.sharedApplication().idleTimerDisabled = true
        
        self.isRunning = true
        self.buttonPlay!.hidden = self.isRunning
        self.gyroContainer!.hidden = !self.isRunning
        
        if self.isRunning && self.timerAccelerationValueUpdate == nil {
            self.timerAccelerationValueUpdate = NSTimer.scheduledTimerWithTimeInterval(self.accelerationValueUpdateInterval, target: self, selector: #selector(updateAccelerationLabel), userInfo: nil, repeats: true)
        }
        
        // Gyro setting
        if self.motionManager.gyroAvailable {
            let activeInterval = 0.05
            let recordDivider: UInt = 20
            let backgroundInterval = activeInterval * Double(recordDivider)
//            self.motionManager.accelerometerUpdateInterval = 1.0
            self.motionManager.deviceMotionUpdateInterval = activeInterval
            
            let queue = NSOperationQueue()//.mainQueue()
            
            self.motionManager.startDeviceMotionUpdatesToQueue(queue, withHandler: { (data: CMDeviceMotion?, error: NSError?) in
                if let data: CMDeviceMotion = data {
                    
                    let appIsActive = UIApplication.sharedApplication().applicationState == .Active
                    
                    let accelerationX = data.userAcceleration.x
                    let accelerationY = data.userAcceleration.y
                    let accelerationZ = data.userAcceleration.z
                    
                    let distanceX = accelerationX - self.accelerationX
                    self.accelerationX = accelerationX
                    
                    let distanceY = accelerationY - self.accelerationY
                    self.accelerationY = accelerationY
                    
                    let distanceZ = accelerationZ - self.accelerationZ
                    self.accelerationZ = accelerationZ
                    
                    if !appIsActive || self.count % recordDivider == 0 {
                        
                        let dot = Dot()
                        dot.vectorX = Float(accelerationX)
                        dot.vectorY = Float(accelerationY)
                        dot.vectorZ = Float(accelerationZ)
                        dot.date = NSDate()
                        
                        if self.location != nil {
                            dot.latitude = self.location!.0
                            dot.longitude = self.location!.1
                        }
                        
                        self.dots.append(dot)
//                        print("append dot: \(self.dots.count)")
                    }
                    self.count += 1
                    
                    
                    
                    if appIsActive {
//                        self.motionManager.deviceMotionUpdateInterval = 0.01
                        self.motionManager.deviceMotionUpdateInterval = activeInterval
                        
                        let gravityX = data.gravity.x
                        let gravityY = data.gravity.y
                        let gravityZ = data.gravity.z
                        
//                        let calibrationRotationX = NSUserDefaults.standardUserDefaults().doubleForKey("calibrationRotationX") ?? 0.0
//                        let calibrationRotationZ = NSUserDefaults.standardUserDefaults().doubleForKey("calibrationRotationZ") ?? 0.0
                        
//                        self.rotationX = CGFloat(-(atan2(gravityY, gravityZ) - calibrationRotationX))
//                        self.rotationZ = CGFloat(atan2(gravityX, gravityY) - calibrationRotationZ)
                        self.rotationX = CGFloat(-atan2(gravityY, gravityZ))
                        self.rotationZ = CGFloat(atan2(gravityX, gravityY))
                        
//                        print(atan2(gravityZ, gravityY))
//                        print(gravityX, gravityY, gravityZ, )
                        dispatch_async(dispatch_get_main_queue()){
                            self.redrawGyroView(dx: distanceX, dy: distanceY, dz: distanceZ)
                            var lat = 0.0
                            var lang = 0.0
                            if let location: (Double, Double) = self.location {
                                lat = location.0
                                lang = location.1
                            }
//                            self.trace("Lat: \(lat)\nLang: \(lang)\nx: \(accelerationX)\ny: \(accelerationY)\nz: \(accelerationZ)\nCount: \(self.dots.count)")
                        }
                    } else {
//                        self.motionManager.deviceMotionUpdateInterval = 0.1
                        self.motionManager.deviceMotionUpdateInterval = backgroundInterval
                    }
                }
            })
        }
        
//        if CLLocationManager.authorizationStatus() == .NotDetermined {
//            self.locationManager!.requestAlwaysAuthorization()
//        }
        
        if #available(iOS 9.0, *) {
            self.locationManager?.allowsBackgroundLocationUpdates = true
        } else {
            // Fallback on earlier versions
        }
        
        self.locationManager!.delegate = self
        self.locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        
        switch CLLocationManager.authorizationStatus() {
        case .AuthorizedAlways:
            print("AuthorizedAlways")
//            self.locationManager!.startUpdatingHeading()
            self.locationManager!.startUpdatingLocation()
        case .NotDetermined:
            self.locationManager?.requestAlwaysAuthorization()
        case .AuthorizedWhenInUse, .Restricted, .Denied:
            let alertController = UIAlertController(
                title: "Background Location Access Disabled",
                message: "In order to be notified about adorable kittens near you, please open this app's settings and set location access to 'Always'.",
                preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
            }
            alertController.addAction(openAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("locationManager didFailWithError")
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
//            self.locationManager!.startUpdatingHeading()
            self.locationManager!.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("locationManager didUpdateLocations")
        let location = locations.last
        self.location = ((location?.coordinate.latitude)!, (location?.coordinate.longitude)!)
        
//        if UIApplication.sharedApplication().applicationState != .Active {
//            print("Background")
//            self.motionManager.stopDeviceMotionUpdates()
//            let queue = NSOperationQueue()
//            self.motionManager.startDeviceMotionUpdatesToQueue(queue, withHandler: { (data: CMDeviceMotion?, error: NSError?) in
//                if let data: CMDeviceMotion = data {
//                    let gravityX = data.gravity.x
//                    let gravityY = data.gravity.y
//                    let gravityZ = data.gravity.z
//                    
//                    print(gravityX, gravityY, gravityZ)
//                }
//            })
//        }
    }
    
    func stopButtonDidSelect() {
        print("stopButtonDidSelect")
        
        let realm = try! Realm()
        
        let line = Line()
        line.title = self.lineTitle
        line.dots.appendContentsOf(self.dots)
        
        try! realm.write {
            realm.add(line)
        }
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}
