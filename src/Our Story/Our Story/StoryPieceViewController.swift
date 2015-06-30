//
//  StoryPieceViewController.swift
//  Our Story
//
//  Created by Wagner Santos on 6/24/15.
//  Copyright (c) 2015 mc2. All rights reserved.
//

import UIKit
import Parse

class StoryPieceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, StoryPieceViewDelegate {
 
    @IBOutlet var tableView: UITableView!
    var newStoryPieceView: AddNewStoryPieceView!
    var parentStory:NSObject!
    var pieces:[StoryPiece]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "StoryPieceCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: StoryCell.indentifier.StoryPiece)
        
        var parent = parentStory as? Story
        print(parent?.storyName)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
         var nav = self.navigationController?.navigationBar
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return pieces.count
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCellWithIdentifier(StoryCell.indentifier.StoryPiece) as! StoryCell
//        var storyPiece = pieces[indexPath.row]
        
//        cell.loadItem(storyPiece.text! ,image:"teste1")
        cell.storyPieceMessage.text = "Tudo começou assim..."
        cell.storyPieceBkgImage.image = UIImage(named: "teste1")
        
        return cell
    }
    
    
    
    @IBAction func addNewStoryPiece(sender: AnyObject) {
        
        //Create the visual effect
        let blurEffect: UIBlurEffect = UIBlurEffect(style: .Light)
        let blurView: UIVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        blurView.tag = 10
        self.view.addSubview(blurView)
        
        newStoryPieceView = AddNewStoryPieceView.instanceFromNib()
        newStoryPieceView.frame = CGRectMake(0, 0, self.view.frame.size.width - 20, 250)
        newStoryPieceView.center = self.view.center
        newStoryPieceView.tag = 11
        newStoryPieceView.delegate = self
        
        self.view.addSubview(newStoryPieceView)
        
    }
    
    func createNewStoryPiece(message: String) {
        
    }
    
    func removeSubViews() {
        if let view = self.view.viewWithTag(11){
            if let subview = self.view.viewWithTag(10) {
                subview.removeFromSuperview()
                view.removeFromSuperview()
            }
        }
    }
    
}