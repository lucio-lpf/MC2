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

    
    func loadItens(story:Story){
        titleLabel.text = story.storyName
        storylabel.text = story.header
        informationLabel.text = story.createdBy!.valueForKey("name") as? String
        
    }

}