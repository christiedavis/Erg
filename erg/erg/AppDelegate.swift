//
//  AppDelegate.swift
//  erg
//
//  Created by Christie on 13/05/17.
//  Copyright © 2017 star. All rights reserved.
//

import UIKit
import CoreData

import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let coordinator: AppCoordinatorDelegate = AppCoordinator()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        self.setupTabBar()
        
        self.coordinator.enterNextFlow(currentCoordinator: nil, sender: nil)

        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "erg")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension AppDelegate {
    func setupTabBar() {
        // Appearance options
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().barTintColor = UIColor.white
//        UITabBar.appearance().tintColor = UIColor.burntYellow
//        UITabBar.appearance().unselectedItemTintColor = UIColor.steelDrive
        UITabBar.appearance().clipsToBounds = false
        
//        UITabBar.appearance().backgroundImage = UIImage.colorForNavBar(color: UIColor.white)
//        UITabBar.appearance().shadowImage = UIImage(named: Constants.Image.rectangle)
        
//        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.steelDrive, NSAttributedString.Key.font: UIFont.fineprint2Font()], for: UIControl.State.normal)
//        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.fineprint1Font()], for: UIControl.State.selected)
    }
}
