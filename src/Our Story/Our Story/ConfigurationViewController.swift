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
    
    let styles: [String] = ["pink", "blue", "green", "yellow", "purple"]
    
    var identifier = StyleSample.identifier 
    
    var showCollectionView = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var postquery = PFQuery(className: "Story")
        var postsarray: NSMutableArray = []
        postquery.orderByDescending("createdAt")
                postquery.whereKey("createdBy", equalTo: "bla")
        postquery.limit = 1
        
        postquery.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in

                var dict: NSDictionary = NSDictionary()
                if results != nil {
                    for var index = 0; index != results!.count; ++index{
                        
                        dict = ["name": results![0].objectForKey("storyName") as! String]
                        //                                  dict.setValue(results![0].objectId as String?!, forKey: "objectId")
                        println(dict)
                        
                        
                        
                    }
                } else {
                    dict = ["name": ""]
                        println(dict)
                }
            })

                

            })
    
        
        showCollectionView = true
        
        self.collectionView.alpha = 0

        var user = PFUser.currentUser()
        userNameLabel.text = user?.objectForKey("name") as? String
        
        storyStyleButton.setBackgroundImage(UIImage(named: user!.objectForKey("storyStyle") as! String), forState: UIControlState())
        
        storyStyleButton.layer.cornerRadius = 10;
        storyStyleButton.layer.borderColor = UIColor.blackColor().CGColor
        storyStyleButton.layer.borderWidth = 1.0
        storyStyleButton.clipsToBounds = true
        
        
        let nibStyle = UINib(nibName: "StyleSample", bundle: nil)
        self.collectionView.registerNib(nibStyle, forCellWithReuseIdentifier: identifier)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func changeStyleButtonAction(sender: AnyObject) {
        if showCollectionView {
            animateCollectionViewAlphaFadeIn()
            showCollectionView = false
        } else {
            animateCollectionViewAlphaFadeOut()
            showCollectionView = true
        }
    
    }
    
    func animateCollectionViewAlphaFadeIn(){
        UIView.animateWithDuration(1, animations: {
            self.collectionView.hidden = false
            self.collectionView.alpha = 1
        })
    }
    
    func animateCollectionViewAlphaFadeOut(){
        UIView.animateWithDuration(0.7, animations: {
            
            self.collectionView.alpha = 0
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.7 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
                    self.collectionView.hidden = true
            }

        })
        
       
    }
    
    
    @IBAction func backButtonAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
        cell.imageView.layer.cornerRadius = 6;
        cell.imageView.layer.borderColor = UIColor.blackColor().CGColor
        cell.imageView.layer.borderWidth = 1.5
        cell.imageView.clipsToBounds = true
        
        cell.frame.size.width = 60
        cell.frame.size.height = 60
        
        // Configure the cell
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
        return CGSizeMake(60, 60)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        
        var userConfig = UserConfiguration()
        
        userConfig.changeStoryStyle(styles[indexPath.row] as String, completion: { (success) -> Void in
            
            if success {
                self.storyStyleButton.setBackgroundImage(UIImage(named: self.styles[indexPath.row] as String), forState: UIControlState())
                self.animateCollectionViewAlphaFadeOut()
                self.showCollectionView = true
            } else {
                println("não salvou o style no parse")
                var alert = UIAlertController(title: "Sem conexão com a internet", message: "Não conseguimos salvar a alteração, tente novamente mais tarde.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
           
        })

        
        
    }
}
