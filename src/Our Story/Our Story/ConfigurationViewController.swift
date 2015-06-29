//
//  ConfigurationViewController.swift
//  Our Story
//
//  Created by Christian S. on 29/06/15.
//  Copyright (c) 2015 mc2. All rights reserved.
//

import Foundation
import UIKit
import Parse

class ConfigurationViewController: UIViewController {
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var storyStyleButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var styles = ["cor1","cor2"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.alpha = 0

        var user = PFUser.currentUser()
        userNameLabel.text = user?.objectForKey("name") as? String
        
        storyStyleButton.layer.cornerRadius = 10;
        storyStyleButton.layer.borderColor = UIColor.whiteColor().CGColor
        storyStyleButton.layer.borderWidth = 2.0
        //        avatarImage.layer.shadowColor = UIColor.grayColor().CGColor;
        //        avatarImage.layer.shadowOffset=CGSizeMake(2, 2);
        //        avatarImage.layer.shadowOpacity=1.0;
        //        avatarImage.layer.shadowRadius=1.0;
        storyStyleButton.clipsToBounds = true
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func changeStyleButtonAction(sender: AnyObject) {
        
        collectionView.hidden = false
        animateCollectionViewAlphaFadeIn()
    }
    
    func animateCollectionViewAlphaFadeIn(){
        UIView.animateWithDuration(1, animations: {
            self.collectionView.alpha = 1
        })
    }
    
    func animateCollectionViewAlphaFadeOut(){
        UIView.animateWithDuration(1, animations: {
            self.collectionView.alpha = 0
        })
    }
    
}
