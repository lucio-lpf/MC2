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
}