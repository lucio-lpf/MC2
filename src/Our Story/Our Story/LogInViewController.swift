//
//  ViewController.swift
//  Our Story
//
//  Created by Wagner Santos on 6/22/15.
//  Copyright (c) 2015 mc2. All rights reserved.
//

import UIKit
import Parse

class LogInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        if ((PFUser.currentUser()) != nil){
            var storyboard: UIStoryboard = UIStoryboard(name: "Story", bundle: nil)
            var vc = storyboard.instantiateViewControllerWithIdentifier("MyCustomTabBarViewController") as! UITabBarController
            self.showViewController(vc, sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginButtonAction(sender: AnyObject) {

        var facebookLogin: FacebookLogin
        facebookLogin = FacebookLogin()
        facebookLogin.login { (user: PFUser?, error: NSError?) -> Void in
            
            if let user = user {
                if user.isNew {
                    println("User signed up and logged in through Facebook!")
                    println(PFUser.currentUser()?.objectId)
                } else {
                    println("User logged in through Facebook!")
                    println(PFUser.currentUser()?.objectId)
                
//                    facebookLogin.returnUserDataWithImage({ (name, email, image, error) -> Void in
//                        println(name)
//                        println(email)
//                        println(image)
//                    })
                }
                
                
            var storyboard: UIStoryboard = UIStoryboard(name: "Story", bundle: nil)
            var vc = storyboard.instantiateViewControllerWithIdentifier("MyCustomTabBarViewController") as! UITabBarController
            self.showViewController(vc, sender: self)
            } else {
                println("Uh oh. The user cancelled the Facebook login.")
            }
            
        }
        
        
    }

}

