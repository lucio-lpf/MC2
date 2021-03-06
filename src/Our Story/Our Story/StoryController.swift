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
    var createdStoryId:String!
    var celltouched: PFObject!
    let tapGesture = UITapGestureRecognizer()
    var initialPosition:CGFloat!
    
    override func viewDidLoad() {
//        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
//        self.navigationController?.navigationBar.barTintColor = UIColor(red:212/255 , green: 214/255, blue: 218/255, alpha: 1.00)

        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        
        self.tabBarController?.tabBar.tintColor = UIColor(red:63/255 , green: 63/255, blue: 63/255, alpha: 1.00)
        
        var title:UILabel = UILabel()
        
        title.textColor = UIColor(red:212/255 , green: 214/255, blue: 218/255, alpha: 1.00)
        
        
        self.navigationItem.titleView?.tintColor = UIColor(red:124/255 , green: 197/255, blue: 135/255, alpha: 1.00)

        
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
        
            cell.loadStoryStart(story!)

            var view = UIView()
            view.backgroundColor = UIColor.whiteColor()
            cell.selectedBackgroundView = view
        
            return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return postsarray.count
    }
    
    @IBAction func createNewStory(sender: AnyObject) {
        //CRIANDO NOVA HISTORIA (POPUP DO BLUR E DA SUBVIEW)
        //Create the visual effect
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.view.addSubview(addBlurView())
        self.view.addSubview(addStoryView())
        
    }
    
    
    @IBAction func logOutButtonAction(sender: AnyObject) {
        PFUser.logOutInBackgroundWithBlock { (err) -> Void in
            if !(err != nil) {
                self.navigationController?.setNavigationBarHidden(true, animated: false)
                self.tabBarController?.tabBar.hidden = true
                
                var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                var vc = storyboard.instantiateViewControllerWithIdentifier("LoginStoryboard") as! LogInViewController
                self.showViewController(vc, sender: self)
            }
        }
        
        
    }
    
    
    func addStoryView() -> AddNewStoryView {
        newStoryView = AddNewStoryView.instanceFromNib()
        newStoryView.frame  = CGRectMake(0, 0, self.view.frame.size.width - 20, 300)
        newStoryView.center = self.view.center
        newStoryView.tag = 11
        newStoryView.delegate = self
        return newStoryView
    }
    
    
    func addBlurView() -> UIVisualEffectView {
        let blurEffect: UIBlurEffect = UIBlurEffect(style: .Light)
        let blurView: UIVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        blurView.tag = 10
        blurView.userInteractionEnabled = true
        blurView.addGestureRecognizer(tapGesture)
        return blurView
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //TAMANHO DA CELL TEM QUE SER O TAMANHO DA CELL CUSTOMIZADA
        return 180
    }
    
    func updatePosts() {
        
        //ATUALIZANDO OS 10 PRIMEIROS POSTS (USA O REFRESH)
        Story.storyQuery(nil, compare: nil, limite: 100, order: 0, callback: {
            (arrayDePosts) in
            self.postsarray = arrayDePosts
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
        
        if !title.isEmpty && !firstPiece.isEmpty {
            Story.createStory(title, header:firstPiece) {
                (story,success, error) in
                if (success) {
                    self.updatePosts()
                } else {
                    print(error)
                }
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
        //REMOVE O POPUP
        if let view = self.view.viewWithTag(11){
            if let subview = self.view.viewWithTag(10) {
                UIView.animateWithDuration(0.4, animations: {
                    subview.alpha = 0.0
                })
                
                subview.removeFromSuperview()
                view.removeFromSuperview()
            }
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
