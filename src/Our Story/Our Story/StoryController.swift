//
//  StoryController.swift
//  Our Story
//
//  Created by Lúcio Pereira Franco on 24/06/15.
//  Copyright (c) 2015 mc2. All rights reserved.
//

import Foundation
import Parse
import UIKit

class StoryController: UIViewController, UITableViewDataSource, UITableViewDelegate, StoryViewDelegate {
    
    var postsarray : NSMutableArray = [] // ARRAY PRA ARMAZENAR OS POSTS E EXIBI-LOS NA TABLEVIEW
    @IBOutlet weak var tableView: UITableView!
    var newStoryView: AddNewStoryView!
    var refreshControl = UIRefreshControl()
    var currentStory:NSObject!
    
    override func viewDidLoad() {
        refreshControl.addTarget(self, action: Selector("updatePosts"), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl)
        var nib = UINib(nibName: "StoryCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: StoryCell.indentifier.Story)
        
    Story.loadfirststories({ (arraydeposts) -> Void in
        self.postsarray = arraydeposts
        self.tableView.reloadData()
       })
        //ADICIONANDO AO MAIN ARRAY OS 10 POSTS        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
            var cell:StoryCell = self.tableView.dequeueReusableCellWithIdentifier(StoryCell.indentifier.Story) as! StoryCell
            var story = postsarray.objectAtIndex(indexPath.row) as? NSObject

            self.currentStory = story
        
            cell.loadItens(story!)
            return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return postsarray.count
    }
    
    @IBAction func createNewStory(sender: AnyObject) {
        
        //Create the visual effect
        let blurEffect: UIBlurEffect = UIBlurEffect(style: .Light)
        let blurView: UIVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        blurView.tag = 10
        self.view.addSubview(blurView)
        
        newStoryView = AddNewStoryView.instanceFromNib()
        newStoryView.frame  = CGRectMake(0, 0, self.view.frame.size.width - 20, 300)
        newStoryView.center = self.view.center
        newStoryView.tag = 11
        
        newStoryView.delegate = self
        
        self.view.addSubview(newStoryView)
        
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 320
    }
    
    func updatePosts(){
        
        Story.loadfirststories({ (arraydeposts) -> Void in
            self.postsarray = arraydeposts
            self.tableView.reloadData()
        })
        self.refreshControl.endRefreshing()
    }
    
    func createNewStory(title: String, firstPiece: String) {
//        print("StoryTitle: \(title)  -  StoryPiece: \(firstPiece)")
        
//        Story.create(title,firstPiece)
    }
    
    func removeSubViews() {
        if let view = self.view.viewWithTag(11){
            if let subview = self.view.viewWithTag(10) {
                subview.removeFromSuperview()
                view.removeFromSuperview()
            }
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToStoryPieces" {
            
            if let viewController: StoryPieceViewController = segue.destinationViewController as? StoryPieceViewController {
                if let s = currentStory {
                    viewController.parentStory = s
                }
            }
        }
    }
}











