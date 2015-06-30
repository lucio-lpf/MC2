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
    
    override func viewDidLoad() {
        
        //ADICIONADNO O REFRESH
        refreshControl.addTarget(self, action: Selector("updatePosts"), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl)
        
        //ADICIONANDO AS CELLS COSTUMIZADAS
        var nib = UINib(nibName: "StoryCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: StoryCell.indentifier.Story)
        
        
        //ADICIONANDO AO MAIN ARRAY OS 10 POSTS
        Story.loadfirststories({ (arraydeposts) -> Void in
            self.postsarray = arraydeposts
            self.tableView.reloadData()
        })
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
    
    func createNewStory(title: String, firstPiece: String) {
//        print("StoryTitle: \(title)  -  StoryPiece: \(firstPiece) \n")
        
        StoryPiece.createStoryPiece(firstPiece) {
            (piece,success, error) in
            if (success) {
                
            } else {
                print(error)
            }
        }
        
        Story.createStory(title){
            (story,success, error) in
            if (success) {
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
