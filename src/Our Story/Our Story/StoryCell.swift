//
//  StoryCustomCell.swift
//  Our Story
//
//  Created by Lúcio Pereira Franco on 25/06/15.
//  Copyright (c) 2015 mc2. All rights reserved.
//

import Foundation
import UIKit

class StoryCell: UITableViewCell {
    
    static let indentifier = (StoryPiece:"storyPieceCell", Story:"storyCell")
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet var storylabel: UILabel!
    
    @IBOutlet var informationLabel: UILabel!
    
    @IBOutlet var storyPieceMessage: UILabel!
    @IBOutlet var storyPieceBkgImage: UIImageView!
    
    func loadItens(story: NSObject){
//        backgroundImage.image = UIImage(named: "yellow")
        self.backgroundImage.layer.cornerRadius = 10;
        self.backgroundImage.layer.borderColor = UIColor.whiteColor().CGColor
        self.backgroundImage.layer.borderWidth = 0.3
        self.backgroundImage.clipsToBounds = true
   
//        if let user: AnyObject = story.valueForKey("createdBy") {
//            backgroundImage.image = UIImage(named: (story.valueForKey("createdBy")!.valueForKey("storyStyle") as? String)!)
            backgroundImage.image = UIImage(named: "blue")
            titleLabel.text = story.valueForKey("storyName") as? String
            storylabel.text = story.valueForKey("header") as? String
//            informationLabel.text = story.valueForKey("createdBy")!.valueForKey("name") as? String
//        }
    }
    
    class func instanceFromNib() -> AddNewStoryPieceView {
        var instance = UINib(nibName: "AddNewStoryPieceView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! AddNewStoryPieceView
        
        instance.backgroundColor = UIColor(red: 255, green: 238, blue: 129, alpha: 1)
        
        var txt = instance.viewWithTag(1) as! UITextView
        txt.delegate = instance as UITextViewDelegate
        txt.layer.cornerRadius = 5
        txt.layer.borderWidth = 0.3
        txt.layer.borderColor = UIColor.blackColor().CGColor
        
        
        return instance
    }

}