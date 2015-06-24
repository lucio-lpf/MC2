//
//  Story.swift
//  Our Story
//
//  Created by Wagner Santos on 6/24/15.
//  Copyright (c) 2015 mc2. All rights reserved.
//

import Parse

enum StoryType: Int {
    case short = 50
    case medium = 150
    case long = 300
}

class Story: NSObject {
    
    var storyName: String?
    var storyPieces: [StoryPiece]?
    var storyType: StoryType?
    var createdBy: User?
    var createdAt: NSDate?
    var editing: Bool?
}
