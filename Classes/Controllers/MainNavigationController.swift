//
//  MainNavigationController.swift
//  GraviT
//
//  Created by 이재복 on 2016. 4. 13..
//  Copyright © 2016년 slowslipper. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {
    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        print("initWithCoder")
//    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        print("initWithRootViewController")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        print("initWithNibAndBundle")
        self.navigationBar.hidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}