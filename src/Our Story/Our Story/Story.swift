//
//  Story.swift
//  Our Story
//
//  Created by Wagner Santos on 6/24/15.
//  Copyright (c) 2015 mc2. All rights reserved.
//

import Parse

enum piecesCount: Int {
    case short = 50
    case medium = 150
    case long = 300
}

class Story: NSObject {
    
    var storyName: String!
    var storyPieces: [StoryPiece]?
    var storySize: piecesCount?
    var createdBy: PFUser?
    var language: NSString!
    var editing: Bool?
    
    
    func savestory(story: NSObject) -> (){
        var newobject = PFObject(className: "Story")
        newobject = story as! PFObject
        newobject.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("Deu certo o salve :)")
            } else {
                print("Deu errado o salve : /(error)")
            }
        }
    }
    
    
//    class func footerisabletoexist(tamanho:Int,completion: (Bool) -> Void){
//        var queryposts = PFQuery(className: "Story")
//        var verificador : Bool
//        verificador = true
//        queryposts.countObjectsInBackgroundWithBlock { (inteiro, erro) -> Void in
//            if inteiro > Int32(tamanho){
//                verificador = true
//            }
//            else{
//                verificador = false
//            }
//            completion(verificador)
//        }
//    }
    
    
    class func createStory(titulo: String, header:String, callback:(PFObject?,Bool,NSError?)->()) {
        var newStory = PFObject(className: "Story")
        newStory.setValue(titulo, forKey: "storyName")
        newStory.setValue(header, forKey: "header")
        newStory.setValue(false, forKey: "editing")
        newStory.setValue(PFUser.currentUser()?.valueForKey("storyStyle"), forKey: "postStyle")
        newStory.setValue(PFUser.currentUser(), forKey: "createdBy")
        newStory.saveInBackgroundWithBlock {
            (bool, error) in
            if error == nil{
                StoryPiece.createStoryPiece(header, parent: newStory, callback: { (pieces, bulian, error) -> () in
                    if error != nil{
                        print(error)
                    }
                })
            }
            callback(newStory,bool,error)
        }
    }
    
    //PARA USAR A FUNÇÃO storyQuery LEMBRE:
    //1) key: (NSString) REFERENTE AO METODO WHEREKEY, CASO NÃO QUEIRA UTILIZAR ESSE METODO, SET ELA PARA nil
    //2) compare: (AnyObject) REFERENTE AO OBJETO QUE O WHERE KEY SERÁ COMPARADO, CASO NAO HAJA WHEREKEY, COLOQUE nil
    //3) limite: (Int) DEFINE O LIMITE DA QUERY. CASO NAO QUEIRA UM LIMITE, SET ELE PARA nil
    //4) order: (Int) DEFINE A ORDEM DA QUERY DE ACORDO COM A DATA DE CRIAÇÃO  -> 0 PARA MAIS NOVAS ATE MAIS VELHOS, 1 PARA MAIS VELHAS ATÉ MAIS NOVAS. QUALQUER OUTRO VALOR FARÁ COM QUE NAO HAJA UMA ORDEM DE DATA.
    //5) callback (NSMutableArray) ARRAY RETORNADO PELO METODO COM OS POSTS.
    //EXEMPLO NO FINAL DO ARQUIVO : ProfileViewController.swift
    
    class func storyQuery(key:NSString?,compare:AnyObject?,limite:Int?,order:Int, callback:(NSMutableArray) -> Void){
        var storyQuery = PFQuery(className: "Story")
        var postsarray:NSMutableArray = []
        if limite != nil {
            storyQuery.limit = limite!
        }
        if key != nil {
            storyQuery.whereKey(key as! String, equalTo: compare!)
        }
        if order == 0{
            storyQuery.orderByDescending("createdAt")
        }
        else if order == 1{
            storyQuery.orderByAscending("createdAt")
        }
        storyQuery.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                for var index = 0; index != results!.count; ++index{
                    postsarray.addObject(results![index])
                }
                callback(postsarray)
            })
        })
    }
}







