//
//  StoryPieceViewController.swift
//  Our Story
//
//  Created by Wagner Santos on 6/24/15.
//  Copyright (c) 2015 mc2. All rights reserved.
//

import UIKit
import Parse

class StoryPieceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate {
 
    @IBOutlet var tableView: UITableView!
    var newStoryPieceView: UIView!
    
    var pieces:[StoryPiece]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "StoryPieceCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: StoryCell.indentifier.StoryPiece)
        
        testePieces()
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
        self.view.addSubview(blurView)
        
        newStoryPieceView = AddNewStoryPieceView.instanceFromNib()
        newStoryPieceView.frame = CGRectMake(0, 0, self.view.frame.size.width - 20, 250)
        newStoryPieceView.center = self.view.center
        
        self.view.addSubview(newStoryPieceView)
        
    }
    
    func testePieces(){
        
        var teste1 = StoryPiece()
        teste1.text? = "Era uma vez João e Maria indo para a floresta escura"
        teste1.createdBy? = PFUser.currentUser()!
        
        var teste2 = StoryPiece()
        teste2.text? = "Era uma vez João e Maria indo para a floresta escura"
        teste2.createdBy? = PFUser.currentUser()!
        
        var teste3 = StoryPiece()
        teste3.text? = "Era uma vez João e Maria indo para a floresta escura"
        teste3.createdBy? = PFUser.currentUser()!
        
//        pieces.append(teste1)
//        pieces.append(teste2)
//        pieces.append(teste3)
    }
    
}