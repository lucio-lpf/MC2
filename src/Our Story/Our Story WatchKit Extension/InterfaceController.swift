//
//  InterfaceController.swift
//  Our Story WatchKit Extension
//
//  Created by Christian S. on 30/06/15.
//  Copyright (c) 2015 mc2. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet weak var tableView: WKInterfaceTable!
    
    var items = ["um app daora muito louco mano", "dois", "tres", "quatro", "cinco"]
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        loadTableData()
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func loadTableData(){
        tableView.setNumberOfRows(items.count, withRowType: "TableRow")
        
        var i = 0
        for item in items {
            let row = tableView.rowControllerAtIndex(i) as! TableRowObject
            row.titleLabel.setText(item)
            i++
        }
    }

}
