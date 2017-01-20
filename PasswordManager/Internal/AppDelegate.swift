//
//  AppDelegate.swift
//  Task_6
//
//  Created by Kirill Asyamolov on 18/11/16.
//  Copyright © 2016 Kirill Asyamolov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow.init(frame: UIScreen.main.bounds)

        let navigationController = UINavigationController(rootViewController: RecordsViewController())
        navigationController.navigationBar.isTranslucent = false

        window!.rootViewController = navigationController
        
        window!.backgroundColor = UIColor.white
        window!.makeKeyAndVisible()
        
        return true
    }

}

