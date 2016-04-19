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
    var forceView = UIView()
    var horizonFrontLayer = CALayer()
    var horizonBackLayer = CALayer()
    var buttonPlay: UIButton?
    var buttonPause: UIButton?
    var labelAcceleration: UILabel = UILabel()
    var lineTitle = ""
//    var locationFixAchieved = false
    var rotationX: CGFloat = 0.0
    var rotationZ: CGFloat = 0.0
    var accelerationX: CGFloat = 0.0
    var accelerationY: CGFloat = 0.0
    var accelerationZ: CGFloat = 0.0
    var distanceAll = 0
    var horizonViewDistanceY: CGFloat = 0.0
    var timerAccelerationValueUpdate: NSTimer?
    let accelerationValueUpdateInterval: NSTimeInterval = 0.2
    var dots: [Dot] = []
    var location: (Double, Double)?
    
    
    var labelTrace: UILabel = UILabel()
    
    
//    let frontColor = UIColor.init(red: 255 / 255, green: 202 / 255, blue: 42 / 255, alpha: 1.0)
//    let frontColor = UIColor.init(red: 255 / 255, green: 185 / 255, blue: 36 / 255, alpha: 1.0)
//    let frontColor = UIColor.init(red: 0 / 255, green: 125 / 255, blue: 196 / 255, alpha: 1.0)
    let frontColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
//    let backColor = UIColor.init(red: 19 / 255, green: 26 / 255, blue: 93 / 255, alpha: 1.0)
//    let backColor = UIColor.init(red: 30 / 255, green: 30 / 255, blue: 35 / 255, alpha: 1.0)
    let backColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
//    let forceColor = UIColor.init(red: 223 / 255, green: 50 / 255, blue: 103 / 255, alpha: 1.0)
    //    let forceColor = UIColor.init(red: 240 / 255, green: 17 / 255, blue: 83 / 255, alpha: 1.0)
//    let forceColor = UIColor.init(red: 255 / 255, green: 0 / 255, blue: 0 / 255, alpha: 1.0)
//    let forceColor = UIColor.blackColor().colorWithAlphaComponent(1)
    let forceColor = UIColor.init(red: 236 / 255, green: 6 / 255, blue: 6 / 255, alpha: 1.0)
//    let centerColor = UIColor.init(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 0.1)
//    var horizonViewRotation: CGFloat = 0.0
//    var timer: NSTimer?
    
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
        
//        self.horizonFrontView.layer.allowsEdgeAntialiasing = true
        self.horizonFrontView.frame = frame
        self.horizonFrontView.center = self.gyroContainer!.center
        
//        self.horizonBackView.layer.allowsEdgeAntialiasing = true
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
        self.forceView.frame = frame
        self.forceView.backgroundColor = self.forceColor
        self.forceView.layer.cornerRadius = 120
        self.forceView.center = self.gyroContainer!.center
        
        self.labelAcceleration.frame = frame
        self.labelAcceleration.textColor = UIColor.whiteColor()
        self.labelAcceleration.font = labelAccelerationFont
        self.labelAcceleration.textAlignment = .Center
        self.labelAcceleration.text = "0"
        self.labelAcceleration.center = self.gyroContainer!.center
        
//        frame.size.width = 200
//        frame.size.height = 200
//        let centerView = UIView(frame: frame)
//        centerView.backgroundColor = self.centerColor
//        centerView.layer.cornerRadius = 100
//        centerView.center = self.gyroContainer!.center
        
        
        
        
        // For debug trace
        frame.origin.x = 100.0
        frame.size.width = viewSize.width
        frame.size.height = 200
        frame.origin.y = viewSize.height - frame.size.height
        
        self.labelTrace.frame = frame
        self.labelTrace.backgroundColor = UIColor.blackColor()
        self.labelTrace.textColor = UIColor.greenColor()
        self.labelTrace.font = UIFont(name: "AvenirNextCondensed-UltraLight", size: 16)
        self.labelTrace.textAlignment = .Left
        self.labelTrace.text = "..."
        self.labelTrace.numberOfLines = 0
        
        
        
        
        self.gyroContainer!.addSubview(self.horizonFrontView)
        self.gyroContainer!.addSubview(self.horizonBackView)
        self.gyroContainer!.addSubview(self.forceView)
//        self.gyroContainer!.addSubview(centerView)
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
    
    func trace(message: String) {
        self.labelTrace.text = message
    }
    
    override func viewWillAppear(animated: Bool) {
//        if self.isRunning && self.timer == nil {
//            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(redrawGyroView), userInfo: nil, repeats: true)
//        }
        if self.isRunning && self.timerAccelerationValueUpdate == nil {
            self.timerAccelerationValueUpdate = NSTimer.scheduledTimerWithTimeInterval(self.accelerationValueUpdateInterval, target: self, selector: #selector(updateAccelerationLabel), userInfo: nil, repeats: true)
        }
    }

    override func viewWillDisappear(animated: Bool) {
//        self.timer?.invalidate()
//        self.timer = nil
        self.motionManager.stopAccelerometerUpdates()
        self.timerAccelerationValueUpdate?.invalidate()
        self.timerAccelerationValueUpdate = nil
    }
    
    func redrawGyroView(dx distanceX: CGFloat, dy distanceY: CGFloat, dz distanceZ: CGFloat) {
        let distaneHorizonY = CGFloat((CGFloat(M_PI * 0.5) - abs(self.rotationX)) * 50.0)
        self.horizonViewDistanceY = self.horizonViewDistanceY + 0.3 * (distaneHorizonY - self.horizonViewDistanceY)
        self.horizonFrontLayer.frame.origin.y = -self.horizonViewDistanceY
        self.horizonBackLayer.frame.origin.y = self.horizonViewDistanceY
        
        let transformRotation = CGAffineTransformMakeRotation(self.rotationZ)
        let scale = 1.0 - distanceZ
        
        let transformScale = CGAffineTransformMakeScale(scale, scale)
        var center = self.gyroContainer!.center
        center.x += distanceX * 300
        center.y -= distanceY * 300
        
        self.distanceAll = Int((abs(distanceX) + abs(distanceY) + abs(distanceZ)) * 100)
        
        UIView.animateWithDuration(0.2) {
            self.forceView.transform = transformScale
            self.forceView.center = center
        }
        UIView.animateWithDuration(0.5) {
            self.horizonFrontView.transform = transformRotation
            self.horizonBackView.transform = transformRotation
        }
        
//        let distaneHorizonY = CGFloat((CGFloat(M_PI) - abs(self.rotationX)) * 100.0)
//        self.horizonViewDistanceY = self.horizonViewDistanceY + 0.1 * (distaneHorizonY - self.horizonViewDistanceY)
//        print("redrawGyroView", distaneHorizonY, self.rotationX, self.rotationZ)
//        let frontTransform = CGAffineTransformMake(cos(-self.rotationZ), -sin(-self.rotationZ), sin(-self.rotationZ), cos(-self.rotationZ), 0.0, -self.horizonViewDistanceY)
//        let backTransform = CGAffineTransformMake(cos(-self.rotationZ), -sin(-self.rotationZ), sin(-self.rotationZ), cos(-self.rotationZ), 0.0, self.horizonViewDistanceY)
//        UIView.animateWithDuration(0.2) {
//            self.horizonFrontView.transform = frontTransform
//            self.horizonBackView.transform = backTransform
//        }
    }
    
    func updateAccelerationLabel() {
        self.labelAcceleration.text = "\(self.distanceAll)"
    }
    
    func startButtonDidSelect() {
        print("startButtonDidSelect")
        self.isRunning = true
        self.buttonPlay!.hidden = self.isRunning
        self.gyroContainer!.hidden = !self.isRunning
        
//        let realm = try! Realm()
//        
//        let model = Line()
//        model.title = (self.title)!
        
//        if self.timer == nil {
//            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(redrawGyroView), userInfo: nil, repeats: true)
//        }
        
        if self.isRunning && self.timerAccelerationValueUpdate == nil {
            self.timerAccelerationValueUpdate = NSTimer.scheduledTimerWithTimeInterval(self.accelerationValueUpdateInterval, target: self, selector: #selector(updateAccelerationLabel), userInfo: nil, repeats: true)
        }
        
        // Gyro setting
        if self.motionManager.gyroAvailable {
//            self.motionManager.gyroUpdateInterval = 0.25
            
            self.motionManager.accelerometerUpdateInterval = 0.01
//            self.motionManager.startGyroUpdates()
            
            let queue = NSOperationQueue.mainQueue()
            self.motionManager.startAccelerometerUpdatesToQueue(queue, withHandler: { (data: CMAccelerometerData?, error: NSError?) in
                self.rotationX = CGFloat(-atan2(data!.acceleration.y, data!.acceleration.z))
                self.rotationZ = CGFloat(atan2(data!.acceleration.x, data!.acceleration.y))
                
                let accelerationX = CGFloat((data?.acceleration.x)!)
                let distanceX = accelerationX - self.accelerationX
                self.accelerationX = accelerationX
                
                let accelerationY = CGFloat((data?.acceleration.y)!)
                let distanceY = accelerationY - self.accelerationY
                self.accelerationY = accelerationY
                
                let accelerationZ = CGFloat((data?.acceleration.z)!)
                let distanceZ = accelerationZ - self.accelerationZ
                self.accelerationZ = accelerationZ
                
                self.redrawGyroView(dx: distanceX, dy: distanceY, dz: distanceZ)
                
                let dot = Dot()
                dot.vectorX = Float(accelerationX)
                dot.vectorY = Float(accelerationY)
                dot.vectorZ = Float(accelerationZ)
                if self.location != nil {
                    dot.latitude = self.location!.0
                    dot.longitude = self.location!.1
                }
                
                self.dots.append(dot)
//                
//                .53686
//                .53696
                self.trace("Lat: \(dot.latitude)\nLang: \(dot.longitude)\nx: \(dot.vectorX)\ny: \(dot.vectorY)\nz: \(dot.vectorZ)")
            })
        }
        
        self.locationManager!.requestWhenInUseAuthorization();
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            self.locationManager!.requestWhenInUseAuthorization()
        }
        if CLLocationManager.locationServicesEnabled() {
            print("Location service enabled");
            self.locationManager!.delegate = self
            self.locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager!.startUpdatingLocation()
            self.locationManager!.startUpdatingHeading()
        }
        else{
            print("Location service disabled");
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("locationManager didFailWithError")
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("locationManager didUpdateLocations")
//        if self.locationFixAchieved == false {
//            self.locationFixAchieved = true
            let location = locations.last
            self.location = ((location?.coordinate.latitude)!, (location?.coordinate.longitude)!)
            
//            let lat = self.location?.0
        
//            print("Lat: \(self.location?.0) : \(lat)")
//        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("locationManager didChangeAuthorizationStatus")
        
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
            manager.startUpdatingLocation()
            // ...
        }
        
        switch status {
        case .NotDetermined:
            print(".NotDetermined")
            break
            
        case .AuthorizedAlways:
            print(".AuthorizedAlways")
            break
            
        case .Denied:
            print(".Denied")
            break
            
        case .AuthorizedWhenInUse:
            print(".AuthorizedWhenInUse")
            break
            
        case .Restricted:
            print(".Restricted")
            break
            
        default:
            print("Unhandled authorization status")
            break
            
        }
    }
    
    func stopButtonDidSelect() {
        print("stopButtonDidSelect")
        
        let realm = try! Realm()
        
        let line = Line()
        line.title = self.lineTitle
        line.dots.appendContentsOf(self.dots)
//        line.dots.append(self.dots[0])
        
        try! realm.write {
            realm.add(line)
        }
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}
