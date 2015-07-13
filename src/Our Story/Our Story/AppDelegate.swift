//
//  AppDelegate.swift
//  Our Story
//
//  Created by Wagner Santos on 6/22/15.
//  Copyright (c) 2015 mc2. All rights reserved.
//

import UIKit
import Parse


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
//        UINavigationBar.appearance().barTintColor = UIColor(red: 77/255, green: 160/255, blue: 121/255, alpha: 1.0)

//PARSE CONFIGURATION
        Parse.setApplicationId("SpzinDa5nEonzM13nr1DdqEt0Mq2xOCAkZLVItsP",
            clientKey: "8k8VpjFRa6rtj4ssj1kDAJuje1Axia5ANir11buL")

//PARSE + FACEBOOK CONFIG
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)

//PUSH NOTIFICATION
        let userNotificationTypes = (UIUserNotificationType.Alert |  UIUserNotificationType.Badge |  UIUserNotificationType.Sound);
        
        let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
//LOGIN FACEBOOK
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        // Store the deviceToken in the current Installation and save it to Parse
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
    }
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    
    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
        
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    
    
    func application(application: UIApplication, handleWatchKitExtensionRequest userInfo: [NSObject : AnyObject]?, reply: (([NSObject : AnyObject]!) -> Void)!) {
        
        if let info = userInfo?["request"] as? String {
            
            if info == "Stories" {
                
                var dict: NSDictionary = NSDictionary()
                
                if PFUser.currentUser() != nil {
                    //Fazendo query pra pegar a última história
                    var postquery = PFQuery(className: "Story")
                    postquery.orderByDescending("createdAt")
                    postquery.whereKey("createdBy", equalTo: PFUser.currentUser()!)
//                    postquery.whereKey("createdBy", equalTo: "bla")
                    
                    postquery.limit = 1
                    
                    postquery.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
                        
                        //cria um dict e se ele tiver uma última história, devolve o título dela
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            if !(error != nil) {
                                if results != nil { //possui história
                                    
                                    //                                dict = ["name": results![0].objectForKey("storyName") as! String]
                                    //                                  dict.setValue(results![0].objectId as String?!, forKey: "objectId")
                                    var nome = results![0].objectForKey("storyName") as! String
                                    var objectId = results![0].objectId as String!
                                    dict = ["name": nome, "objectId":objectId]
                                    reply(dict as [NSObject : AnyObject])
                                    
                                    
                                } else { //senão, devolve um string vazio, que vai ser tratado baseado no erro que for enviado junto
                                    dict = ["name": "", "erro":"Usuário não possui histórias criadas."]//esse else não necessariamente corresponde a esse erro - verificar depois
                                    reply(dict as [NSObject : AnyObject])
                                }
                            } else{
                                dict = ["name": "", "erro": "Conexão não estabelecida."]//esse else não necessariamente corresponde a esse erro - verificar depois
                                reply(dict as [NSObject : AnyObject])
                            }
                            
                        })
                        
                    })

                } else{
                    dict = ["name": "", "erro": "Você não está logado. Faça o login e tente novamente."]
                    reply(dict as [NSObject : AnyObject])
                }
                
            }
//problema aqui encima. Dificuldade para diferenciar quando o parse devolve nil (user não possui história criada) de quando dá erro de conexão. VER PELO TIPO DO ERRO QUE O PARSE DEVOLVE.
            
        } else{
            println("fail")
            reply(["fail":"fail"])
        }
        

        
        
        //        var bogusWorkaroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier()
//        
//        bogusWorkaroundTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({ () -> Void in
//            UIApplication.sharedApplication().endBackgroundTask(bogusWorkaroundTask)
//        })
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(2 * NSEC_PER_MSEC)), dispatch_get_main_queue()) { () -> Void in
//            UIApplication.sharedApplication().endBackgroundTask(bogusWorkaroundTask)
//        }
//        
//        
//        
//        var realBackgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier()
//        realBackgroundTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({ () -> Void in
//            reply(nil)
//            UIApplication.sharedApplication().endBackgroundTask(realBackgroundTask)
//        })

        
        
    }
    
    
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]!) -> Void) -> Bool {
        
        if userActivity.activityType == "com.mc2.Our-Story.WatchHandoff" {
            if let win = window {
                var viewController = win.rootViewController as! StoryPieceViewController
                viewController.restoreUserActivityState(userActivity)
            }
        }
        return true
    }

}