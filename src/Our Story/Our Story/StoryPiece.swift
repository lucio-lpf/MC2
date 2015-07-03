//
//  StoryPiece.swift
//  Our Story
//
//  Created by Wagner Santos on 6/24/15.
//  Copyright (c) 2015 mc2. All rights reserved.
//

import Parse

class StoryPiece: NSObject {
    
    var text: String?
    var createdBy: PFUser?
    var createdAt: NSDate?

    
    
    class func loadfirstpieces(object:PFObject,completion: (NSMutableArray) -> Void ) {
        var piecessarray:NSMutableArray = []
        var piecesquery = PFQuery(className: "StoryPieces")
        piecesquery.whereKey("parentStory", equalTo: object)
        piecesquery.orderByAscending("createdAt")
        //ADICIONANDO AO MAIN ARRAY OS 10 POSTS
        piecesquery.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                print("ERRO  \(error)")
                
                for var index = 0; index != results!.count; ++index{
                    piecessarray.addObject(results![index])
                }
                completion(piecessarray)
            })
        })
    }
    
    func savestorypiece(storypiece: NSObject) -> (){
        var newobject = PFObject(className: "StoryPieces")
        newobject = storypiece as! PFObject
        newobject.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("Deu certo o salve :)")
            } else {
               print("Deu errado o salve : /(error)")
            }
        }
    }
    
    class func createStoryPiece(message:String, parent:PFObject, callback:(PFObject,Bool,NSError?)->()) {
        
        var piece = PFObject(className: "StoryPieces")
        piece.setValue(message, forKey: "text")
        piece.setValue(parent, forKey: "parentStory")
        piece.setValue(PFUser.currentUser()?.valueForKey("storyStyle"), forKey: "postStyle")
        piece.setValue(PFUser.currentUser(), forKey: "createdBy")
        piece.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) in
                callback(piece,success,error)
        }
    }
    
    //PARA USAR A FUNÇÃO pieceQuery LEMBRE:
    //1) key: (NSString) REFERENTE AO METODO WHEREKEY, CASO NÃO QUEIRA UTILIZAR ESSE METODO, SET ELA PARA nil
    //2) compare: (AnyObject) REFERENTE AO OBJETO QUE O WHERE KEY SERÁ COMPARADO, CASO NAO HAJA WHEREKEY, COLOQUE nil
    //3) limite: (Int) DEFINE O LIMITE DA QUERY. CASO NAO QUEIRA UM LIMITE, SET ELE PARA nil
    //4) order: (Int) DEFINE A ORDEM DA QUERY DE ACORDO COM A DATA DE CRIAÇÃO  -> 0 PARA MAIS NOVAS ATE MAIS VELHOS, 1 PARA MAIS VELHAS ATÉ MAIS NOVAS. QUALQUER OUTRO VALOR FARÁ COM QUE NAO HAJA UMA ORDEM DE DATA.
    //5) callback (NSMutableArray) ARRAY RETORNADO PELO METODO COM OS PIECES.
    //EXEMPLO NO FINAL DO ARQUIVO : ProfileViewController.swift
    
    class func piecesQuery(key:NSString?,compare:AnyObject?,limite:Int?,order:Int, callback:(NSMutableArray) -> Void){
        var piecesQuery = PFQuery(className: "StoryPieces")
        var piecesarray:NSMutableArray = []
        if limite != nil {
            piecesQuery.limit = limite!
        }
        if key != nil {
            piecesQuery.whereKey(key as! String, equalTo: compare!)
        }
        if order == 0{
            piecesQuery.orderByDescending("createdAt")
        }
        else if order == 1{
            piecesQuery.orderByAscending("createdAt")
        }
        piecesQuery.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                for var index = 0; index != results!.count; ++index{
                    piecesarray.addObject(results![index])
                }
                callback(piecesarray)
            })
        })
    }
}

