//
//  AddNewStoryPieceView.swift
//  Our Story
//
//  Created by Wagner Santos on 6/26/15.
//  Copyright (c) 2015 mc2. All rights reserved.
//

protocol StoryPieceViewDelegate:NSObjectProtocol {
    func createNewStoryPiece(message:String)
    func removeSubViews()
}

class AddNewStoryPieceView: UIView, UITextViewDelegate {
    
    
    
    @IBOutlet var message: UITextView!
    @IBOutlet var contChar: UILabel!
    
    var delegate:StoryPieceViewDelegate?
    

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
    
    @IBAction func addContribution(sender: AnyObject) {
        self.delegate?.createNewStoryPiece(message.text)
        self.delegate?.removeSubViews()
    }
    @IBAction func closeView(sender: AnyObject) {
        self.delegate?.removeSubViews()
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
    
    
}
