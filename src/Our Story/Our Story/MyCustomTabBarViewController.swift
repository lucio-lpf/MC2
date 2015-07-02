
//
//  MyCustomTabBarViewController.swift
//  Our Story
//
//  Created by Lúcio Pereira Franco on 02/07/15.
//  Copyright (c) 2015 mc2. All rights reserved.
//

import UIKit

class MyCustomTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let pvc : AnyObject = UIStoryboard(name: "Profile", bundle: nil).instantiateInitialViewController()
        self.viewControllers?.append(pvc)
        
    }

}
