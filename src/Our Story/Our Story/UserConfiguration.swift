//
//  UserConfiguration.swift
//  Our Story
//
//  Created by Christian S. on 30/06/15.
//  Copyright (c) 2015 mc2. All rights reserved.
//

import Foundation
import Parse

class UserConfiguration {
    
    
    
    func changeStoryStyle(newStyle: String, completion: (Bool) -> Void) {
        var user = PFUser.currentUser()
        if let user = user {
            user["storyStyle"] = newStyle
            user.saveInBackgroundWithBlock({ (success, err) -> Void in
                completion(success)
            })
        }
    }
    
    
}