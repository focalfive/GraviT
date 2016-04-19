//
//  ViewController.swift
//  GraviT
//
//  Created by 이재복 on 2016. 4. 13..
//  Copyright © 2016년 slowslipper. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var eventListView: UITableView?
    var eventCollection: Results<Line>?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let viewSize = self.view.bounds.size
        var frame = CGRectZero
        let buttonSize: CGFloat = 80.0
        let buttonMargin: CGFloat = 10.0
        let buttonTitleFont = UIFont(name: "AvenirNextCondensed-UltraLight", size: buttonSize * 0.5)
        
        // Table view
        frame.size = viewSize
        self.eventListView = UITableView(frame: frame)
        self.eventListView?.dataSource = self
        self.eventListView?.delegate = self
        self.eventListView?.allowsSelection = true
        
        self.view.addSubview(self.eventListView!)
        
        // Start new button
        frame.origin.x = viewSize.width - buttonSize - buttonMargin
        frame.origin.y = viewSize.height - buttonSize - buttonMargin
        frame.size.width = buttonSize
        frame.size.height = buttonSize
        let buttonStart = UIButton(frame: frame)
        buttonStart.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        buttonStart.layer.cornerRadius = buttonSize * 0.5
        buttonStart.titleLabel!.font = buttonTitleFont
        let titleStart = NSMutableAttributedString(string: "Start")
        titleStart.addAttribute(NSKernAttributeName, value: CGFloat(-2.0), range: NSRange(location: 0, length: titleStart.length))
        titleStart.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSRange(location: 0, length: titleStart.length))
        buttonStart.setAttributedTitle(titleStart, forState: .Normal)
        buttonStart.addTarget(self, action: #selector(startButtonDidSelect), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(buttonStart)
    }
    
    override func viewWillAppear(animated: Bool) {
        print("viewWillAppear")
        
        let realm = try! Realm()
        self.eventCollection = realm.objects(Line).sorted("createDate", ascending: false)
        self.eventListView?.reloadData()
    }
    
    // Button handler
    func startButtonDidSelect() {
        print("startButtonDidSelect")
        self.navigationController?.pushViewController(MakeLineViewController(), animated: true)
    }
    
    // About table view
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let collection = self.eventCollection else {
            return 0
        }
        
        return collection.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellTitleFont = UIFont(name: "AvenirNextCondensed-UltraLight", size: 40.0)
        let cell = UITableViewCell()
        cell.textLabel!.font = cellTitleFont
        cell.textLabel!.text = self.eventCollection![indexPath.row].title
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let model = self.eventCollection![indexPath.row]
        let realm = try! Realm()
        
        try! realm.write {
            realm.delete(model)
        }
        
        self.eventListView?.reloadData()
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        print("willSelectRow - %d", indexPath.row)
        
        let exploreLineViewController = ExploreLineViewController()
        let model = self.eventCollection![indexPath.row]
        
        print("Model title: \(model.title), objectId: \(model.id), dotCount: \(model.dots.count)")
        
//        exploreLineViewController = model
        self.navigationController?.pushViewController(exploreLineViewController, animated: true)
        
        return nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

