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

class StoryController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var postsarray : NSMutableArray = [] // ARRAY PRA ARMAZENAR OS POSTS E EXIBI-LOS NA TABLEVIEW
    @IBOutlet weak var tableView: UITableView!
    var refreshControl = UIRefreshControl()
    
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
        //VENDO SE PRECISA DE FOOTER PRA LOAD MAIS POSTS
        
        
        
        
        
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var celula: UITableViewCell
            var cell:StoryCell = self.tableView.dequeueReusableCellWithIdentifier(StoryCell.indentifier.Story) as! StoryCell
            var story = postsarray.objectAtIndex(indexPath.row) as? NSObject
            cell.loadItens(story!)
            return cell
}
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return postsarray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 320
    }
    func updatePosts(){
        //ATUALIZANDO OS 10 PRIMEIROS POSTS (USA O REFRESH)
        Story.loadfirststories({ (arraydeposts) -> Void in
            self.postsarray = arraydeposts
            self.tableView.reloadData()
        })
        self.refreshControl.endRefreshing()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
}