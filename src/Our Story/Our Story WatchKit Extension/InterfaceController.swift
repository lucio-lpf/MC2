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
    
    
    @IBOutlet weak var lblText: WKInterfaceLabel!
    
    @IBOutlet weak var loadButton: WKInterfaceButton!
    

    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        WKInterfaceController.openParentApplication(["request": "Stories"], reply:{(replyFromParent, error) -> Void in
            
            if !(error != nil){
                
                println(" testando esse bagulho: \(replyFromParent)")
                
                if replyFromParent != nil{
                    var dict = replyFromParent as NSDictionary
                    self.lblText.setText(dict["name"] as? String)
               
                } else {
                    self.loadButton.setTitle("Toque para tentar novamente 😉")
                    self.lblText.setText("Não conseguimos carregar sua última história.")
                    
                }
                
                
                
            } else {
                println(error.description)
                self.loadButton.setTitle("Toque para tentar novamente 😉")
                self.lblText.setText("Não conseguimos carregar sua última história.")
            }
        })
        
//        loadTableData()
        
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
  
    
    @IBAction func loadButtonAction() {
        
        self.lblText.setText("Carregando última história...")
        
        WKInterfaceController.openParentApplication(["request": "Stories"], reply:{(replyFromParent, error) -> Void in
            
            if !(error != nil){
                
                println(" testando esse bagulho no reload: \(replyFromParent)")
                
                if replyFromParent != nil{
                    var dict = replyFromParent as NSDictionary
                    self.lblText.setText(dict["name"] as? String)
                    self.loadButton.setTitle("Recarregar")
                    
                } else {
                    self.loadButton.setTitle("Toque para tentar novamente 😉")
                    self.lblText.setText("Não conseguimos carregar sua última história.")
                    
                }
            } else {
                println(error.description)
                self.loadButton.setTitle("Toque para tentar novamente 😉")
                self.lblText.setText("Não conseguimos carregar sua última história.")
            }
        })

    }
    
    
    
//    func loadTableData(){
//        tableView.setNumberOfRows(items.count, withRowType: "TableRow")
//        
//        var i = 0
//        for item in items {
//            let row = tableView.rowControllerAtIndex(i) as! TableRowObject
//            row.titleLabel.setText(item)
//            i++
//        }
//    }

}
