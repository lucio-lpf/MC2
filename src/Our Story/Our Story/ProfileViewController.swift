//
//  ProfileViewController.swift
//  Our Story
//
//  Created by Christian S. on 25/06/15.
//  Copyright (c) 2015 mc2. All rights reserved.
//

import Foundation
import UIKit


let offset_HeaderStop:CGFloat = 40.0 // At this offset the Header stops its transformations
let offset_B_LabelHeader:CGFloat = 62.0 // At this offset the Black label reaches the Header
let distance_W_LabelHeader:CGFloat = 35.0 // The distance between the bottom of the Header and the top of the White Label

class ProfileViewController : UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var userNameScrollView: UILabel!
    @IBOutlet weak var createdStoriesScrollView: UILabel!
    @IBOutlet weak var takePartStoriesScrollView: UILabel!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    var headerImageView: UIImageView!
    var headerBlurImageView: UIImageView!

    var blurredHeaderImageView:UIImageView?
    
    var identifierStoryPiece = StoryPieceCell.indentifier
    
    var identifierStory = StoryPieceCell.indentifier //trocar pra StoryCell
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        scrollView.contentSize.width = 0
        scrollView.contentSize.height = screenSize.height + 200
        
        avatarImage.layer.cornerRadius = 40;
        avatarImage.layer.borderColor = UIColor.whiteColor().CGColor
        avatarImage.layer.borderWidth = 2.0
//        avatarImage.layer.shadowColor = UIColor.grayColor().CGColor;
//        avatarImage.layer.shadowOffset=CGSizeMake(2, 2);
//        avatarImage.layer.shadowOpacity=1.0;
//        avatarImage.layer.shadowRadius=1.0;
        avatarImage.clipsToBounds = true

        
        //preenchendo os campos de informacão do user
        var facebookLogin = FacebookLogin()
        facebookLogin.login { (user, error) -> Void in
            facebookLogin.returnUserDataWithImage { (fetchedName, fetchedEmail, fetchedImage, error) -> Void in
            self.avatarImage.image = fetchedImage
            self.userNameScrollView.text = fetchedName as? String
            self.headerLabel.text = fetchedName as? String
            }
        }
        
        
        
        let nibStoryPiece = UINib(nibName: "StoryPieceCell", bundle: nil)
        self.tableView.registerNib(nibStoryPiece, forCellReuseIdentifier: identifierStoryPiece)
        
        var nibStory = UINib(nibName: "StoryPieceCell", bundle: nil) //Trocar para StoryCell
        tableView.registerNib(nibStory, forCellReuseIdentifier: identifierStory)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        // Header - Image
        
        headerImageView = UIImageView(frame: header.bounds)
        headerImageView?.image = UIImage(named: "header_bg")
        headerImageView?.contentMode = UIViewContentMode.ScaleAspectFill
        header.insertSubview(headerImageView, belowSubview: headerLabel)

        
        // Header - Blurred Image
        
        headerBlurImageView = UIImageView(frame: header.bounds)
        headerBlurImageView?.image = UIImage(named: "header_bg")?.blurredImageWithRadius(10, iterations: 20, tintColor: UIColor.clearColor())
        headerBlurImageView?.contentMode = UIViewContentMode.ScaleAspectFill
        headerBlurImageView?.alpha = 0.0
        header.insertSubview(headerBlurImageView, belowSubview: headerLabel)
        
        header.clipsToBounds = true
        
    }
    
    
    //UITableViewDelegate
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell = UITableViewCell()
        
        if(segmentedControl.isEnabledForSegmentAtIndex(0))
        {
            var vcell = self.tableView.dequeueReusableCellWithIdentifier(identifierStoryPiece) as! StoryPieceCell
            vcell.loadItem("", image: "teste1")
            return vcell
        }
        else if(segmentedControl.isEnabledForSegmentAtIndex(1))
        {
            var vcell = self.tableView.dequeueReusableCellWithIdentifier(identifierStoryPiece) as! StoryPieceCell
            return vcell
        }
       

        
        return cell
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 100
    }
    
    
    @IBAction func segmentedControlAction(sender: AnyObject) {
        
        if(segmentedControl.selectedSegmentIndex == 0)
        {
            println("First Segment Selected")
        }
        else if(segmentedControl.selectedSegmentIndex == 1)
        {
            println("Second Segment Selected")
        }
        tableView.reloadData()
        
    }
    
    
    
    
    //UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if !scrollView.isKindOfClass(UITableView) {
            var offset = scrollView.contentOffset.y
            var avatarTransform = CATransform3DIdentity
            var headerTransform = CATransform3DIdentity
            
            
            // PULL DOWN -----------------
            
            if offset < 0 {
                
                let headerScaleFactor:CGFloat = -(offset) / header.bounds.height
                let headerSizevariation = ((header.bounds.height * (1.0 + headerScaleFactor)) - header.bounds.height)/2.0
                headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
                headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
                
                header.layer.transform = headerTransform
            }
            
            // SCROLL UP/DOWN ------------
                
            else {
                
                // Header -----------
                
                headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offset_HeaderStop, -offset), 0)
                
                //  ------------ Label
                
                let labelTransform = CATransform3DMakeTranslation(0, max(-distance_W_LabelHeader, offset_B_LabelHeader - offset), 0)
                headerLabel.layer.transform = labelTransform
                
                //  ------------ Blur
                
                headerBlurImageView?.alpha = min (1.0, (offset - offset_B_LabelHeader)/distance_W_LabelHeader)
                
                // Avatar -----------
                
                let avatarScaleFactor = (min(offset_HeaderStop, offset)) / avatarImage.bounds.height / 1.4 // Slow down the animation
                let avatarSizeVariation = ((avatarImage.bounds.height * (1.0 + avatarScaleFactor)) - avatarImage.bounds.height) / 2.0
                avatarTransform = CATransform3DTranslate(avatarTransform, 0, avatarSizeVariation, 0)
                avatarTransform = CATransform3DScale(avatarTransform, 1.0 - avatarScaleFactor, 1.0 - avatarScaleFactor, 0)
                
                if offset <= offset_HeaderStop {
                    
                    if avatarImage.layer.zPosition < header.layer.zPosition{
                        header.layer.zPosition = 0
                    }
                    
                }else {
                    if avatarImage.layer.zPosition >= header.layer.zPosition{
                        header.layer.zPosition = 2
                    }
                }
            }
            
            // Apply Transformations
            
            header.layer.transform = headerTransform
            avatarImage.layer.transform = avatarTransform 
        }
        

        
        

    }
    
}