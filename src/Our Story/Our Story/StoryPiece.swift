//
//  StoryPiece.swift
//  Our Story
//
//  Created by Wagner Santos on 6/24/15.
//  Copyright (c) 2015 mc2. All rights reserved.
//

import Parse

class StoryPiece: NSObject {
    
    static let parseClassName:String = "storyPieces"
    var text: String?
    var createdBy: PFUser?
    var createdAt: NSDate?

    
    
    func savestorypiece(storypiece: NSObject) -> (){
        var newobject = PFObject(className: "StoryPiece")
        newobject = storypiece as! PFObject
        newobject.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("Deu certo o salve :)")
            } else {
               print("Deu errado o salve : /(error)")
            }
        }
    }
    
    class func createStoryPiece(message:String) {
        print("StoryPiece: \(message)")
        var piece = PFObject(className: parseClassName)
        piece["text"] = message
        piece["createdBy"] = PFUser.currentUser()
        piece.save()
    }
    
    class func getLastTenPieces() {
        var query = PFQuery(className: parseClassName)
        query.limit = 10
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects as? [StoryPiece] {
                    for object in objects {

                    }
                }
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
    }
}

