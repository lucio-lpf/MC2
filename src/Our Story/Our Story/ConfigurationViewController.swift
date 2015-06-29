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

class ConfigurationViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var storyStyleButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let styles: [String] = ["padrao_papel"]
    
    var identifier = StyleSample.identifier //trocar pra StoryCell
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storyStyleButton.imageView?.image = UIImage(named: "padrao_papel")
        
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
        
        
        let nibStyle = UINib(nibName: "StyleSample", bundle: nil)
        self.collectionView.registerNib(nibStyle, forCellWithReuseIdentifier: identifier)
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
    
    
    
    //COLLECTIONVIEW DELEGATE
    //2
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return styles.count
    }
    
    //3
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.identifier , forIndexPath: indexPath) as! StyleSample
        cell.imageView.image = UIImage(named: self.styles[indexPath.row])
        // Configure the cell
        return cell
    }
}
