//
//  AppDelegate.swift
//  JPushSwiftDemo
//
//  Created by oshumini on 16/3/11.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit
let appKey = "4f7aef34fb361292c566a1cd"
let channel = "Publish channel"
let isProduction = false

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    if((UIDevice.currentDevice().systemVersion as NSString).floatValue >= 8.0) {
      // 可以自定义 categories
      JPUSHService.registerForRemoteNotificationTypes(UIUserNotificationType.Badge.rawValue | UIUserNotificationType.Badge.rawValue | UIUserNotificationType.Alert.rawValue , categories: nil)
    } else {
      JPUSHService.registerForRemoteNotificationTypes(UIUserNotificationType.Badge.rawValue | UIUserNotificationType.Badge.rawValue | UIUserNotificationType.Alert.rawValue , categories: nil)
    }
    JPUSHService.setupWithOption(launchOptions, appKey: appKey, channel: channel, apsForProduction: isProduction)
    
    return true
  }
  
  func applicationWillResignActive(application: UIApplication) {
    
  }
  
  func applicationDidEnterBackground(application: UIApplication) {
    
  }
  
  func applicationWillEnterForeground(application: UIApplication) {
    application.applicationIconBadgeNumber = 0
    application.cancelAllLocalNotifications()
  }
  
  func applicationDidBecomeActive(application: UIApplication) {
    
  }
  
  func applicationWillTerminate(application: UIApplication) {
    
  }
  
  func application(application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
      print("get the deviceToken  \(deviceToken)")
      NSNotificationCenter.defaultCenter().postNotificationName("DidRegisterRemoteNotification", object: deviceToken)
      JPUSHService.registerDeviceToken(deviceToken)
      
  }
  
  func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
    print("did fail to register for remote notification with error ", error)
    
  }
  
  func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
    JPUSHService.handleRemoteNotification(userInfo)
    print("受到通知", userInfo)
    NSNotificationCenter.defaultCenter().postNotificationName("AddNotificationCount", object: nil)  //把  要addnotificationcount
  }
  
  func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
    JPUSHService.showLocalNotificationAtFront(notification, identifierKey: nil)
  }
  
  @available(iOS 7, *)
  func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
    
  }
  
  @available(iOS 7, *)
  func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
    
  }
  
  @available(iOS 7, *)
  func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], withResponseInfo responseInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
    
  }

}

