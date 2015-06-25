//
//  Login.swift
//  Our Story
//
//  Created by Christian S. on 23/06/15.
//  Copyright (c) 2015 mc2. All rights reserved.
//

import Foundation
import Parse

class FacebookLogin {
        
    init() {
    
    }
    
    func login(completionClosure: (user: PFUser, error: NSError?) -> Void){
        
        let permissions = ["public_profile", "email", "user_friends"]
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) {
            (user: PFUser?, error: NSError?) -> Void in
            completionClosure(user: user!, error: error)
        }
    }
    
    
    func returnUserData(completionClosure: (name: NSString?, email: NSString?, error: NSError?) -> Void) {
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                println("Error: \(error)")
            }
            else
            {
                println("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                println("User fetched Name is: \(userName)")
                let userEmail : NSString = result.valueForKey("email") as! NSString
                println("User fetched Email is: \(userEmail)")
                completionClosure(name: result.valueForKey("name") as? NSString, email: result.valueForKey("email") as? NSString, error: error )
            }
        })
    }
    
    
    func returnUserDataWithImage(completionClosure: (fetchedName: NSString?, fetchedEmail: NSString?, fetchedImage: UIImage?, error: NSError?) -> Void) {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                println("Error: \(error)")
            }
            else
            {
                println("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                println("User fetched Name is: \(userName)")
                let userEmail : NSString = result.valueForKey("email") as! NSString
                println("User fetched Email is: \(userEmail)")
                
                var facebookAccountId = result.valueForKey("id") as! NSString
                var urlFacebookProfile = "http://graph.facebook.com/\(facebookAccountId)/picture?type=large"
                
                if let checkedUrl = NSURL(string: urlFacebookProfile) {
                    self.downloadImage(checkedUrl, completion: { (image) -> Void in
                        completionClosure(fetchedName: result.valueForKey("name") as? NSString, fetchedEmail: result.valueForKey("email") as? NSString, fetchedImage: image, error: error )
                    })
                }

                
                
               
            }
        })
    }

    
    
    func downloadImage(url:NSURL, completion: (UIImage) -> Void){
        println("Started downloading profile image \"\(url.lastPathComponent!.stringByDeletingPathExtension)\".")
        getDataFromUrl(url) { data in
            dispatch_async(dispatch_get_main_queue()) {
                println("Finished downloading \"\(url.lastPathComponent!.stringByDeletingPathExtension)\".")
                
                completion(UIImage(data: data!)!)
                
                //não esquecer:
                //                self.ProfilePhoto.contentMode = UIViewContentMode.ScaleAspectFit
                
                
            }
            
        }
    }
    
    func getDataFromUrl(urL:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: NSData(data: data))
            }.resume()
    }

}