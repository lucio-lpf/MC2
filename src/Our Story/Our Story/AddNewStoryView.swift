//
//  AddNewStoryView.swift
//  Our Story
//
//  Created by Wagner Santos on 6/29/15.
//  Copyright (c) 2015 mc2. All rights reserved.
//

protocol StoryViewDelegate:NSObjectProtocol{
    func createNewStory(title:String,firstPiece:String)
    func removeSubViews()
}

class AddNewStoryView: UIView, UITextViewDelegate {
    
    @IBOutlet var storyTitle: UITextField!
    @IBOutlet var firstStoryPiece: UITextView!
    
     var delegate:StoryViewDelegate?
    
    
    @IBOutlet var contChar: UILabel!
    class func instanceFromNib() -> AddNewStoryView {
        var instance = UINib(nibName: "AddNewStoryView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! AddNewStoryView
        
        
        
        var title = instance.viewWithTag(1) as! UITextField
        title.layer.cornerRadius = 5
        title.layer.borderWidth = 0.3
        title.layer.borderColor = UIColor.blackColor().CGColor
        
        var txt = instance.viewWithTag(2) as! UITextView
        txt.delegate = instance as UITextViewDelegate
        txt.layer.cornerRadius = 5
        txt.layer.borderWidth = 0.3
        txt.layer.borderColor = UIColor.blackColor().CGColor
        
        
        return instance
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        let newLength = count(textView.text.utf16) + count(text.utf16) - range.length
        
        contChar.text =  String(newLength)
        
        if(newLength < 140){
            contChar.text = "\(140 - newLength)"
            return true
        }else{
            contChar.text = "0"
            return false
        }
    }
    @IBAction func createNewStory(sender: AnyObject) {
        print("createNewStory")
        self.delegate?.createNewStory(storyTitle.text, firstPiece: firstStoryPiece.text)
        self.delegate?.removeSubViews()
    }
    
    @IBAction func closeView(sender: AnyObject) {
        print("closeView")
        self.delegate?.removeSubViews()
    }
}