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
    
    func loadStory(story: NSObject) {
        
        backgroundImage.layer.cornerRadius = 10;
        backgroundImage.layer.borderColor = UIColor.whiteColor().CGColor
        backgroundImage.layer.borderWidth = 0.3
        backgroundImage.clipsToBounds = true
        backgroundImage.image = UIImage(named: story.valueForKey("postStyle") as! String)
        titleLabel.text = story.valueForKey("storyName") as? String
        storylabel.text = story.valueForKey("header") as? String
        //informationLabel.text = story.valueForKey("createdBy")!.valueForKey("name") as? String
    }
    
    func loadStoryPiece(piece: NSObject) {
        storyPieceBkgImage.image = UIImage(named: piece.valueForKey("postStyle") as! String)
        storyPieceMessage.text = piece.valueForKey("text") as? String
    }
    
    
    
    class func instanceFromNib() -> AddNewStoryPieceView {
        var instance = UINib(nibName: "AddNewStoryPieceView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! AddNewStoryPieceView
        
        var txt = instance.viewWithTag(1) as! UITextView
        txt.delegate = instance as UITextViewDelegate
        txt.layer.cornerRadius = 5
        txt.layer.borderWidth = 0.3
        txt.layer.borderColor = UIColor.blackColor().CGColor
        
        return instance
    }

}