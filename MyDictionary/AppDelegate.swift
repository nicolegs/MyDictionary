//
//  AppDelegate.swift
//  MyDictionary
//
//  Created by Nicolegs on 11/5/15.
//  Copyright © 2016 nicolegs. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        
        
        
// Allen-CODE--------------------------------------------------------------
//        let srcURL = NSBundle.mainBundle().URLForResource("CarPartBig1", withExtension: "csv")!
//        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
//        var toURL = NSURL(string: "file://\(documentsPath)")!
//        toURL = toURL.URLByAppendingPathComponent(srcURL.lastPathComponent!)
//        do {
//            try NSFileManager().copyItemAtURL(srcURL, toURL: toURL)
//        } catch let error as NSError {
//            print(error.localizedDescription)
//        }
// Allen-CODE--------------------------------------------------------------
        
        
        
        
        
        //tentativa de não carregar o file se já tiver no iphone. START
        let fetchRequest: NSFetchRequest = NSFetchRequest(entityName: "DictionaryEntity")
        fetchRequest.fetchLimit = 1
        do {
            let result = try managedObjectContext.executeFetchRequest(fetchRequest)
            // I assume this code only gets executed if there is no error
            if result.count == 0 {
                preloadData()
                // You know you do not have any items, so download
            }
        } catch let error as NSError {
            print("Error: \(error.domain)")
            // Handle error
        }
      
        UINavigationBar.appearance().barTintColor = UIColor(red: 210.0/255.0, green:
            178.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()

        
        //cor, tamanho e letra que vai na Navigation bar
        if let barFont = UIFont(name: "Avenir-Light", size: 24.0) {
            UINavigationBar.appearance().titleTextAttributes =
                [NSForegroundColorAttributeName:UIColor.blackColor(),
                    NSFontAttributeName:barFont]
        }
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
 
        return true
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
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.mgdn.inc.CockpitDictionary" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("CockpitDictionary", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("CockpitDictionary.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    // MARK: - CSV Parser Methods
    
    func parseCSV (contentsOfURL: NSURL, encoding: NSStringEncoding) -> [(word:String, definition:String)]? {
        
        // Load the CSV file and parse it
        let delimiter = ","
        var items:[(word:String, definition:String)]?
        
        do {
            let content = try String(contentsOfURL: contentsOfURL, encoding: encoding)
            print(content)
            items = []
            let lines:[String] = content.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()) as [String]
            
            for line in lines {
                var values:[String] = []
                if line != "" {
                    // For a line with double quotes
                    // we use NSScanner to perform the parsing
                    if line.rangeOfString("\"") != nil {
                        var textToScan:String = line
                        var value:NSString?
                        var textScanner:NSScanner = NSScanner(string: textToScan)
                        while textScanner.string != "" {
                            
                            if (textScanner.string as NSString).substringToIndex(1) == "\"" {
                                textScanner.scanLocation += 1
                                textScanner.scanUpToString("\"", intoString: &value)
                                textScanner.scanLocation += 1
                            } else {
                                textScanner.scanUpToString(delimiter, intoString: &value)
                            }
                            
                            // Store the value into the values array
                            values.append(value as! String)
                            
                            // Retrieve the unscanned remainder of the string
                            if textScanner.scanLocation < textScanner.string.characters.count {
                                textToScan = (textScanner.string as NSString).substringFromIndex(textScanner.scanLocation + 1)
                            } else {
                                textToScan = ""
                            }
                            textScanner = NSScanner(string: textToScan)
                        }
                        
                        // For a line without double quotes, we can simply separate the string
                        // by using the delimiter (e.g. comma)
                    } else  {
                        values = line.componentsSeparatedByString(delimiter)
                    }
                    
                    // Put the values into the tuple and add it to the items array
                    let item = (word: values[0], definition: values[1])
                    items?.append(item)
                }
            }
            
        } catch {
            print(error)
        }
        
        return items
    }
    
    func preloadData () {
 
        
        
        
        
        
        
// Allen--------------Remove this-------------------------------------------------
                guard let remoteURL = NSURL(string: "https://googledrive.com/host/0B4xB0m95siM2c042MWJfY0o5LTg/CarPartBig1.csv") else {
                    return}
// Allen--------------Until here-------------------------------------------------
        
       
        
        
        
// Allen-CODE--------------------------------------------------------------
//        func preloadData(toURL: NSURL) {
//            let remoteURL = toURL
// Allen-CODE--------------------------------------------------------------

        
        
        
        
        
        
            let fetchRequest: NSFetchRequest = NSFetchRequest(entityName: "DictionaryEntity")
            fetchRequest.fetchLimit = 1
            do {
                let result = try managedObjectContext.executeFetchRequest(fetchRequest)
                
                // I assume this code only gets executed if there is no error
                if result.count == 0 {
                    
                    removeData()
                    
                    // You know you do not have any items, so download
                }
            } catch let error as NSError {
                print("Error: \(error.domain)")
                // Handle error
            }
            //tentativa de não remover o file se já tiver no iphone. END
            // Remove all the menu items before preloading
        
            removeData()
            
            if let items = parseCSV( remoteURL, encoding: NSUTF8StringEncoding) {
                // Preload the menu items
                for item in items {
                    let dictionaryItem = NSEntityDescription.insertNewObjectForEntityForName("DictionaryEntity", inManagedObjectContext: managedObjectContext) as! Dictionary
                    dictionaryItem.word = item.word
                    dictionaryItem.definition = item.definition
                    
                    do {
                        try managedObjectContext.save()
                    } catch {
                        print(error)
                    }
                }
                
            }
        }
        
        func removeData () {
            // Remove the existing items
            let fetchRequest = NSFetchRequest(entityName: "DictionaryEntity")
            
            do {
                let dictionaryItems = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Dictionary]
                for dictionaryItem in dictionaryItems {
                    managedObjectContext.deleteObject(dictionaryItem)
                }
            } catch {
                print(error)
            }
            
        }
        
    }

// Allen-CODE--------------------------------------------------------------
// }
// Allen-CODE--------------------------------------------------------------