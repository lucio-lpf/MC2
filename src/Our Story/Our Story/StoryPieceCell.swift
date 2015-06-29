//
//  StoryPieceCell.swift
//  Our Story
//
//  Created by Wagner Santos on 6/24/15.
//  Copyright (c) 2015 mc2. All rights reserved.
//

import UIKit


class StoryPieceCell: UITableViewCell {
    
    @IBOutlet var bkgStyle: UIImageView!
    @IBOutlet var storyPiece: UILabel!
    static let indentifier = "storyPiece"
    
    func loadItem(message: String, image:String) {
        storyPiece.text = message
        bkgStyle.image = UIImage(named: image)
    }
}