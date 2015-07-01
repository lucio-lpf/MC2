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
    var pieces = []
    var refreshControl = UIRefreshControl()
    let tapGesture = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //ADICIONADNO O REFRESH
        refreshControl.addTarget(self, action: Selector("updatePieces"), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl)
        
       // ADICIONANDO AO MAIN ARRAY OS 10 POSTS
        
       //INICIAR AS PIECES
        updatePieces()
        tapGesture.addTarget(self, action: "cancelCreateStory")
        
        let nib = UINib(nibName: "StoryPieceCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: StoryCell.indentifier.StoryPiece)
        
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
        return pieces.count 
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCellWithIdentifier(StoryCell.indentifier.StoryPiece) as! StoryCell
       // var storyPiece = pieces[indexPath.row] as! NSObject
        
        //cell.loadItem(storyPiece.text! ,image:"teste1")
        cell.storyPieceMessage.text = self.pieces[indexPath.row].valueForKey("text") as? String
        var style = PFUser.currentUser()?.valueForKey("storyStyle") as? String
        cell.storyPieceBkgImage.image = UIImage(named: style)
        
        return cell
    }
    
    
    
    @IBAction func addNewStoryPiece(sender: AnyObject) {
        //Create the visual effect
        let blurEffect: UIBlurEffect = UIBlurEffect(style: .Light)
        let blurView: UIVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        blurView.tag = 10
        blurView.userInteractionEnabled = true
        blurView.addGestureRecognizer(tapGesture)

        
        newStoryPieceView = AddNewStoryPieceView.instanceFromNib()
        newStoryPieceView.frame = CGRectMake(0, 0, self.view.frame.size.width - 20, 250)
        newStoryPieceView.center = self.view.center
        newStoryPieceView.tag = 11
        newStoryPieceView.delegate = self
//        newStoryPieceView.backgroundColor = UIColor(red: 255, green: 238, blue: 129, alpha: 1)
        
        if (self.view.viewWithTag(10) == nil) {
            self.view.addSubview(blurView)
        }
        
        if (self.view.viewWithTag(11) == nil) {
            self.view.addSubview(newStoryPieceView)
        }
    }
    
    
    func cancelCreateStory() {
        removeSubViews()
    }
    
    func createNewStoryPiece(message: String) {
        StoryPiece.createStoryPiece(message, parent: parentStory as! PFObject) {
            (piece, success, error) -> () in
            print(piece)
            self.updatePieces()
        }
    }
    
    func removeSubViews() {
        if let view = self.view.viewWithTag(11){
            if let subview = self.view.viewWithTag(10) {
                subview.removeFromSuperview()
                view.removeFromSuperview()
            }
        }
        updatePieces()
    }
    
    
    func updatePieces(){
        //ATUALIZANDO OS 10 PRIMEIROS POSTS (USA O REFRESH)
        StoryPiece.loadfirstpieces(self.parentStory, completion: { (arraydepieces) -> Void in
            self.pieces = arraydepieces
            self.tableView.reloadData()
        })
        self.refreshControl.endRefreshing()
    }
    
}