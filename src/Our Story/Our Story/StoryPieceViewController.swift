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
    var parentStory:PFObject!
    var parentStoryObjectId: String = "ok"
    var piecesArray = []
    var refreshControl = UIRefreshControl()
    let tapGesture = UITapGestureRecognizer()
    var timer: NSTimer?
    var initialPosition:CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        
        //ADICIONADNO O REFRESH
        refreshControl.addTarget(self, action: Selector("updatePieces"), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl)
        
       // ADICIONANDO AO MAIN ARRAY OS 10 POSTS
        if self.parentStoryObjectId != "ok"{
            StoryPiece.piecesQuery("objectId", compare: self.parentStoryObjectId, limite: nil, order: 1, callback: { (arrayDePieces) -> Void in
                self.piecesArray = arrayDePieces
                self.tableView.reloadData()
            })
        }else{
                            //INICIAR AS PIECES
        updatePieces()
        }
        tapGesture.addTarget(self, action: "dismissKeyboard")
        
        let nib = UINib(nibName: "StoryPieceCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: StoryCell.indentifier.StoryPiece)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name:UIKeyboardWillHideNotification, object: nil);
        initialPosition = self.view.center.y
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func viewDidAppear(animated: Bool) {
//         var nav = self.navigationController?.navigationBar
//    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return pieces.count
        return piecesArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = self.tableView.dequeueReusableCellWithIdentifier(StoryCell.indentifier.StoryPiece) as! StoryCell
       // var storyPiece = pieces[indexPath.row] as! NSObject
        
        
        var piece = piecesArray.objectAtIndex(indexPath.row) as? NSObject
        
        if indexPath.row == 0 {
            cell.loadStoryPieceStart(piece!)
        } else if indexPath.row == piecesArray.count - 1 {
            cell.loadStoryPieceEnd(piece!)
        } else {
            cell.loadStoryPieceMiddle(piece!)
        }
        
        
        cell.storyPieceBkgImage.layer.cornerRadius = 10;
        cell.storyPieceBkgImage.layer.borderColor = UIColor.whiteColor().CGColor
        cell.storyPieceBkgImage.layer.borderWidth = 0.3
        cell.storyPieceBkgImage.clipsToBounds = true
        
        var view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        cell.selectedBackgroundView = view
        
        return cell
    }
    
    
    
    @IBAction func addNewStoryPiece(sender: AnyObject) {
        //Create the visual effect
        self.parentStory.fetchInBackgroundWithBlock { (newobject, error) -> Void in
            self.parentStory = newobject
            var editing = self.parentStory.valueForKey("editing") as! Bool
            if !editing{
                
                self.parentStory.setValue(true, forKey: "editing")
                self.parentStory.saveInBackgroundWithBlock { (bool, error) -> Void in
                    if (error == nil){
                        self.timer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(120), target: self, selector: Selector("removeSubViews"), userInfo: nil, repeats: false)
                        
                        
                        self.view.addSubview(self.addBlurView())
                        self.view.addSubview(self.addStoryPieceView())
                        
                    }
                }
            }
                
            else{
                var alert = UIAlertController(title: "Desculpe ", message: "Você não pode editar no momento, tente mais tarde", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }

        }
        
            }
    
    func addStoryPieceView() -> AddNewStoryPieceView {
        newStoryPieceView = AddNewStoryPieceView.instanceFromNib()
        newStoryPieceView.frame = CGRectMake(0, 0, self.view.frame.size.width - 20, 250)
        newStoryPieceView.center = self.view.center
        newStoryPieceView.tag = 11
        newStoryPieceView.delegate = self
//        newStoryPieceView.backgroundColor = UIColor(red: 255, green: 238, blue: 129, alpha: 1)
        newStoryPieceView.backgroundColor = UIColor.clearColor()
        
        return newStoryPieceView
    }
    
    
    func addBlurView() -> UIVisualEffectView {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let blurEffect: UIBlurEffect = UIBlurEffect(style: .Light)
        let blurView: UIVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        blurView.tag = 10
        blurView.userInteractionEnabled = true
        blurView.addGestureRecognizer(tapGesture)
        
        return blurView
    }
    
    func dismissKeyboard() {
        if let subview = self.view.viewWithTag(11) {
            subview.endEditing(true)
        }
    }
    
    func createNewStoryPiece(message: String) {
        if !message.isEmpty {
            StoryPiece.createStoryPiece(message, parent: parentStory as PFObject) {
                (piece, success, error) -> () in
                self.updatePieces()
            }
        } else {
            showAlert("Sem dados", msg: "Preencha os campos da história", action: "Ok")
        }
    }
    
    
    func showAlert(title:String, msg:String, action:String){
        var alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: action, style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func removeSubViews() {
        if let view = self.view.viewWithTag(11){
            if let subview = self.view.viewWithTag(10) {
                UIView.animateWithDuration(0.4, animations: {
                    subview.alpha = 0.0
                })
                subview.removeFromSuperview()
                view.removeFromSuperview()
            }
        }
        
        self.timer?.invalidate()
        self.parentStory.setValue(false, forKey: "editing")
        self.parentStory.saveInBackgroundWithBlock { (bool, error) -> Void in
            if (error != nil){
                print (error)
            }
        }
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        updatePieces()
    }
    
    
    func updatePieces(){
        //ATUALIZANDO OS 10 PRIMEIROS POSTS (USA O REFRESH)
//        StoryPiece.loadfirstpieces(self.parentStory, completion: { (arraydepieces) -> Void in
//            self.piecesArray = arraydepieces
//            self.tableView.reloadData()
//        })
        StoryPiece.piecesQuery("parentStory", compare: self.parentStory, limite: 300, order: 1, callback:{ (arrayDePieces) -> Void in
            self.piecesArray = arrayDePieces
            self.tableView.reloadData()
        })
        
        self.refreshControl.endRefreshing()
    }
    
    
    
    
    func keyboardWillShow(sender: NSNotification) {
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if let subview = self.view.viewWithTag(11) {
                subview.center.y -= keyboardSize.height/4
            }
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if let subview = self.view.viewWithTag(11) {
                subview.center.y = initialPosition
            }
        }
    }
    
    override func restoreUserActivityState(activity: NSUserActivity) {

        if let userInfo = activity.userInfo{
            self.parentStoryObjectId = userInfo["objectId"] as! String
        }
        

        
        super.restoreUserActivityState(activity)
    }
    
}