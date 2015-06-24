//
//  Login.swift
//  Our Story
//
//  Created by Christian S. on 23/06/15.
//  Copyright (c) 2015 mc2. All rights reserved.
//

import Foundation
import Parse

class FacebookLogin {
        
    init() {
    
    }
    
    func login(completionClosure: (user: PFUser, error: NSError?) -> Void){
        
        let permissions = ["public_profile", "email", "user_friends"]
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) {
            (user: PFUser?, error: NSError?) -> Void in
            completionClosure(user: user!, error: error)
        }
    }
    
    
    func returnUserData(completionClosure: (name: NSString?, email: NSString?, error: NSError?) -> Void) {
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                println("Error: \(error)")
            }
            else
            {
                println("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                println("User fetched Name is: \(userName)")
                let userEmail : NSString = result.valueForKey("email") as! NSString
                println("User fetched Email is: \(userEmail)")
                completionClosure(name: result.valueForKey("name") as? NSString, email: result.valueForKey("email") as? NSString, error: error )
            }
        })
    }

}