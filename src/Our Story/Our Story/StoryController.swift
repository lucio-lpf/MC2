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
    var createdStoryId:String!
    var celltouched: PFObject!
    let tapGesture = UITapGestureRecognizer()
    var initialPosition:CGFloat!
    
    @IBOutlet weak var okokok: UIBarButtonItem!
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.barTintColor = UIColor.grayColor()
        
        //ADICIONADNO O REFRESH
        refreshControl.addTarget(self, action: Selector("updatePosts"), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl)
        
        //ADICIONANDO AS CELLS COSTUMIZADAS
        var nib = UINib(nibName: "StoryCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: StoryCell.indentifier.Story)
        
        
        updatePosts()
        tapGesture.addTarget(self, action: "dismissKeyboard")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name:UIKeyboardWillHideNotification, object: nil);
        initialPosition = self.view.center.y
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        //COLOCANDO AS CELLS CUSTOMIZADAS
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
        //CRIANDO NOVA HISTORIA (POPUP DO BLUR E DA SUBVIEW)
        //Create the visual effect
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let blurEffect: UIBlurEffect = UIBlurEffect(style: .Light)
        let blurView: UIVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        blurView.tag = 10
        blurView.userInteractionEnabled = true
        blurView.addGestureRecognizer(tapGesture)

        
        newStoryView = AddNewStoryView.instanceFromNib()
        newStoryView.frame  = CGRectMake(0, 0, self.view.frame.size.width - 20, 300)
        newStoryView.center = self.view.center
        newStoryView.tag = 11
        
        newStoryView.delegate = self
        
            self.view.addSubview(blurView)
            self.view.addSubview(newStoryView)
        
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //TAMANHO DA CELL TEM QUE SER O TAMANHO DA CELL CUSTOMIZADA
        return 180
    }
    
    func updatePosts(){
        //ATUALIZANDO OS 10 PRIMEIROS POSTS (USA O REFRESH)
        Story.loadfirststories({ (arraydeposts) -> Void in
            self.postsarray = arraydeposts
            self.tableView.reloadData()
        })
        self.refreshControl.endRefreshing()
    }
    
    
    func dismissKeyboard() {
        if let subview = self.view.viewWithTag(11) {
            subview.endEditing(true)
        }
    }
    
    func createNewStory(title: String, firstPiece: String) {
//        print("StoryTitle: \(title)  -  StoryPiece: \(firstPiece) \n")
        
        Story.createStory(title, header:firstPiece) {
            (story,success, error) in
            if (success) {
                self.updatePosts()
            } else {
                print(error)
            }
        }
    }
    
    func removeSubViews() {
        //REMOVE O POPUP
        if let view = self.view.viewWithTag(11){
            if let subview = self.view.viewWithTag(10) {
                subview.removeFromSuperview()
                view.removeFromSuperview()
            }
        }
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        updatePosts()
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //SABENDO A CELL SELECIONADA, EU SEI A POSIÇAO NO VETOR
        self.celltouched = postsarray.objectAtIndex(indexPath.row) as! PFObject
        self.performSegueWithIdentifier("goToStoryPieces", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "goToStoryPieces") {
            
            if let newStoryPiece = segue.destinationViewController as? StoryPieceViewController {
                newStoryPiece.parentStory = self.celltouched
            }
        }
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
    
    
   
//
//    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        //VENDO SE PRECISA DE FOOTER PRA LOAD MAIS POSTS 
//        var tamanho = postsarray.count
//        Story.footerisabletoexist(tamanho) { (Bool) -> Void in
//            //SE SIM, BOTA UMA SUBVIEW COM BUTTON PRA LOAD MORE
//            if Bool == true{
//                
//                
//            }
//            //SE NAO, SO DEIXA NIL
//            else{
//            }
//        }
//        return nil
//    }
}
