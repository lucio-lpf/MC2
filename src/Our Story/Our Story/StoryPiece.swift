//
//  StoryPiece.swift
//  Our Story
//
//  Created by Wagner Santos on 6/24/15.
//  Copyright (c) 2015 mc2. All rights reserved.
//

import Parse

class StoryPiece: NSObject {
    
    var text: String?
    var createdBy: PFUser?
    var createdAt: NSDate?

    
    
    class func loadfirstpieces(object:NSObject,completion: (NSMutableArray) -> Void ) {
        var piecessarray:NSMutableArray = []
        var piecesquery = PFQuery(className: "StoryPieces")
        piecesquery.whereKey("parentStory", equalTo: object)
        piecesquery.orderByDescending("createdAt")
        //ADICIONANDO AO MAIN ARRAY OS 10 POSTS
        piecesquery.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                print(error)
                
                for var index = 0; index != results!.count; ++index{
                    piecessarray.addObject(results![index])
                }
                completion(piecessarray)
            })
        })
    }
    
    func savestorypiece(storypiece: NSObject) -> (){
        var newobject = PFObject(className: "StoryPieces")
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
    
    class func createStoryPiece(message:String, callback:(PFObject,Bool,NSError?)->()) {
        
        var piece = PFObject(className: "StoryPieces")
        piece.setValue(message, forKey: "text")
//        piece.setValue(PFUser.currentUser(), forKey: "createdBy")
        piece.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) in
                callback(piece,success,error)
        }
    }
}

