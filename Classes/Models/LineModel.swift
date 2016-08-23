//
//  LineModel.swift
//  GraviT
//
//  Created by 이재복 on 2016. 4. 13..
//  Copyright © 2016년 slowslipper. All rights reserved.
//

import Foundation
import RealmSwift

class Dot: Object {
    dynamic var latitude: Double = 0.0
    dynamic var longitude: Double = 0.0
    dynamic var vectorX: Float = 0.0
    dynamic var vectorY: Float = 0.0
    dynamic var vectorZ: Float = 0.0
    dynamic var date: NSDate!
    
}

class Line: Object {
    dynamic var id = NSUUID().UUIDString
    dynamic var title = ""
    dynamic var isClosed = false
    dynamic var createDate = NSDate()
    dynamic var startDate: NSDate?
    dynamic var endDate: NSDate?
    let dots = List<Dot>()
}
