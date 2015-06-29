//
//  StoryCustomCell.swift
//  Our Story
//
//  Created by Lúcio Pereira Franco on 25/06/15.
//  Copyright (c) 2015 mc2. All rights reserved.
//

import Foundation
import UIKit

class StoryCell: UITableViewCell{
    
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet var storylabel: UILabel!
    
    @IBOutlet var informationLabel: UILabel!
    
    func loadItens(story: NSObject)->(){
        
     titleLabel.text = story.valueForKey("storyName") as? String
        var pieces = story.valueForKey("storyPieces") as! NSArray
        storylabel.text = pieces[0] as? String
       informationLabel.text = story.valueForKey("createdBy")?.valueForKey("objectId") as? String
        
        
        
        
    }
}