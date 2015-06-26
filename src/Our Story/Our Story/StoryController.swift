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
        tableView.registerNib(nib, forCellReuseIdentifier: "customCell")
        
        var postquery = PFQuery(className: "story")
        postquery.limit = 10 //PEGANDO OS 10 PRIMEIROS POSTS
        var results = postquery.findObjects() as? [PFObject]
        //ADICIONANDO AO MAIN ARRAY OS 10 POSTS
        for var index = 0; index != results!.count; ++index{
            postsarray.addObject(results![index])
            
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var celula: UITableViewCell
            var cell:StoryCell = self.tableView.dequeueReusableCellWithIdentifier("customCell") as! StoryCell
            var story = postsarray.objectAtIndex(indexPath.row) as? NSObject
            cell.loadItens(story!)
            return cell
}
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return postsarray.count
    }
    
}