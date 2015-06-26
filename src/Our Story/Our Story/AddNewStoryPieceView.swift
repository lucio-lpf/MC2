//
//  AddNewStoryPieceView.swift
//  Our Story
//
//  Created by Wagner Santos on 6/26/15.
//  Copyright (c) 2015 mc2. All rights reserved.
//


class AddNewStoryPieceView: UIView, UITextViewDelegate {
    

    class func instanceFromNib() -> UIView {
        return UINib(nibName: "AddNewStoryPieceView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
    }
}
