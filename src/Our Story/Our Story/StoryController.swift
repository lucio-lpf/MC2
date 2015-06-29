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
    
    override func viewDidLoad() {
        var nib = UINib(nibName: "StoryCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: StoryCell.indentifier.Story)
        
    Story.loadfirststories({ (arraydeposts) -> Void in
        self.postsarray = arraydeposts
        self.tableView.reloadData()
       })
        //ADICIONANDO AO MAIN ARRAY OS 10 POSTS
       
        
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
    
}