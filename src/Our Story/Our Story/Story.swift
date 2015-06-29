//
//  Story.swift
//  Our Story
//
//  Created by Wagner Santos on 6/24/15.
//  Copyright (c) 2015 mc2. All rights reserved.
//

import Parse

enum piecesCount: Int {
    case short = 50
    case medium = 150
    case long = 300
}

class Story: NSObject {
    
    var storyName: String!
    var storyPieces: [StoryPiece]?
    var storySize: piecesCount?
    var createdBy: PFUser?
    var language: NSString!
    var editing: Bool?
    
    
    func savestory(story: NSObject) -> (){
        var newobject = PFObject(className: "Story")
        newobject = story as! PFObject
        newobject.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("Deu certo o salve :)")
            } else {
                print("Deu errado o salve : /(error)")
            }
        }
    }
    
    class func loadfirststories(completion: (NSMutableArray) -> Void ) {
        var postsarray:NSMutableArray = []
        var postquery = PFQuery(className: "Story")
        postquery.orderByDescending("createdAt")
        postquery.limit = 10 //PEGANDO OS 10 PRIMEIROS POSTS
        //ADICIONANDO AO MAIN ARRAY OS 10 POSTS
        postquery.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                for var index = 0; index != results!.count; ++index{
                    postsarray.addObject(results![index])
                
                }
                completion(postsarray)
            })
        })
    }
}
