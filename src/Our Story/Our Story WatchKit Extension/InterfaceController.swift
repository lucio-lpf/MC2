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
        
        let request = ["request":"Stories"]
        
        WKInterfaceController.openParentApplication(request, reply:{(replyFromParent, error) -> Void in
            
            if !(error != nil){
                
                println(" testando esse bagulho: \(replyFromParent)")
                
                if replyFromParent["name"] as! String != "" {
                    var dict = replyFromParent as NSDictionary
                    self.lblText.setText(dict["name"] as? String)
                    
                    self.updateUserActivity("com.mc2.Our-Story.WatchHandoff", userInfo: ["objectId": dict["objectId"] as! String], webpageURL: nil)

               
                } else {
                    if replyFromParent["erro"] as! String == "Usuário não possui histórias criadas." {
//                        self.loadButton.setTitle("Recarregar")
                        self.loadButton.setTitle("Tap to try again 😉")
//                        self.lblText.setText("Você não possui nenhuma história.")
                        self.lblText.setText("An error occured while trying to reach your last story.")

                    } else
                        if replyFromParent["erro"] as! String == "Conexão não estabelecida."{
                            self.loadButton.setTitle("Tap to try again 😉")
//                            self.lblText.setText("Não conseguimos carregar sua última história. Confira sua conexão e tente novamente.")
                            self.lblText.setText("An error occured while trying to reach your last story.")
                            
                        }else {
                            self.loadButton.setTitle("Reload")
                            self.lblText.setText("You're not logged in. Log in and tap to reload.")

                        }
                }
                
                
                
            } else {
                println(error.description)
                self.loadButton.setTitle("Tap to try again 😉")
//                self.lblText.setText("Não conseguimos carregar sua última história.")
                self.lblText.setText("An error occured while trying to reach your last story.")
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
        
        self.lblText.setText("Loading last story...")
        
//        WKInterfaceController.openParentApplication(["request": "Stories"], reply:{(replyFromParent, error) -> Void in
//            
//            if !(error != nil){
//                
//                println(" testando esse bagulho: \(replyFromParent)")
//                
//                if replyFromParent["name"] as! String != "" {
//                    var dict = replyFromParent as NSDictionary
//                    self.lblText.setText(dict["name"] as? String)
//                    self.loadButton.setTitle("Recarregar")
//                    
//                } else {
//                    self.loadButton.setTitle("Recarregar")
//                    self.lblText.setText("Você não possui nenhuma história.")
//                    
//                }
//                
//            } else {
//                println(error.description)
//                self.loadButton.setTitle("Toque para tentar novamente 😉")
//                self.lblText.setText("Não conseguimos carregar sua última história.")
//            }
//        })
        
        let request = ["request":"Stories"]
        
        WKInterfaceController.openParentApplication(request, reply:{(replyFromParent, error) -> Void in
            
            if !(error != nil){
                
                println(" testando esse bagulho: \(replyFromParent)")
                
                if replyFromParent["name"] as! String != "" {
                    
                    var dict = replyFromParent as NSDictionary
                    
                    self.loadButton.setTitle("Reload")
                    self.lblText.setText(dict["name"] as? String)
                    
                    self.updateUserActivity("com.mc2.Our-Story.WatchHandoff", userInfo: ["objectId": dict["objectId"] as! String], webpageURL: nil)
                    
                    
                } else {
                    if replyFromParent["erro"] as! String == "Usuário não possui histórias criadas." {
//                        self.loadButton.setTitle("Recarregar")
                        self.loadButton.setTitle("Tap to try again 😉")
//                        self.lblText.setText("Você não possui nenhuma história.")
                        self.lblText.setText("An error occured while trying to reach your last story.")
                        
                    } else
                        if replyFromParent["erro"] as! String == "Conexão não estabelecida."{
                            self.loadButton.setTitle("Tap to try again 😉")
//                            self.lblText.setText("Não conseguimos carregar sua última história. Confira sua conexão e tente novamente.")
                            self.lblText.setText("An error occured while trying to reach your last story.")
                            
                        }else {
                            self.loadButton.setTitle("Reload")
                            self.lblText.setText("You're not logged in. Log in and tap to reload.")
                            
                    }
                }
                
                
                
            } else {
                println(error.description)
                self.loadButton.setTitle("Tap to try again 😉")
//                self.lblText.setText("Não conseguimos carregar sua última história.")
                self.lblText.setText("An error occured while trying to reach your last story.")
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
