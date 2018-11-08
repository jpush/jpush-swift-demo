//
//  AppDelegate.swift
//  JPushSwiftDemo
//
//  Created by oshumini on 16/3/11.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit
import UserNotifications

let appKey = "a1703c14b186a68a66ef86c1"
let channel = "Publish channel"
let isProduction = false

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, JPUSHRegisterDelegate {

  var window: UIWindow?
  
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//    let entity = JPUSHRegisterEntity()
    
    if #available(iOS 10, *) {
      let entity = JPUSHRegisterEntity()
      entity.types = NSInteger(UNAuthorizationOptions.alert.rawValue) |
        NSInteger(UNAuthorizationOptions.sound.rawValue) |
        NSInteger(UNAuthorizationOptions.badge.rawValue)
      JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
      
    } else if #available(iOS 8, *) {
      // 可以自定义 categories
      JPUSHService.register(
        forRemoteNotificationTypes: UIUserNotificationType.badge.rawValue |
          UIUserNotificationType.sound.rawValue |
          UIUserNotificationType.alert.rawValue,
        categories: nil)
    } else {
      // ios 8 以前 categories 必须为nil
      JPUSHService.register(
        forRemoteNotificationTypes: UIRemoteNotificationType.badge.rawValue |
          UIRemoteNotificationType.sound.rawValue |
          UIRemoteNotificationType.alert.rawValue,
        categories: nil)
    }
    
    JPUSHService.setup(withOption: launchOptions, appKey: appKey, channel: channel, apsForProduction: isProduction)
    
    _ = NotificationCenter.default
    return true
  }
    
  @available(iOS 10.0, *)
  func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {

//    let userInfo = response.notification.request.content.userInfo
//    let request = response.notification.request // 收到推送的请求
//    let content = request.content // 收到推送的消息内容
//    
//    let badge = content.badge // 推送消息的角标
//    let body = content.body   // 推送消息体
//    let sound = content.sound // 推送消息的声音
//    let subtitle = content.subtitle // 推送消息的副标题
//    let title = content.title // 推送消息的标题

  }
  
  @available(iOS 10.0, *)
  func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!,
                               withCompletionHandler completionHandler: ((Int) -> Void)!) {
//    let userInfo = notification.request.content.userInfo
//    
//    let request = notification.request // 收到推送的请求
//    let content = request.content // 收到推送的消息内容
//    
//    let badge = content.badge // 推送消息的角标
//    let body = content.body   // 推送消息体
//    let sound = content.sound // 推送消息的声音
//    let subtitle = content.subtitle // 推送消息的副标题
//    let title = content.title // 推送消息的标题
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    application.applicationIconBadgeNumber = 0
    application.cancelAllLocalNotifications()
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    
  }
  
  func application(_ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      print("get the deviceToken  \(deviceToken)")
      NotificationCenter.default.post(name: Notification.Name(rawValue: "DidRegisterRemoteNotification"), object: deviceToken)
    JPUSHService.registerDeviceToken(deviceToken)
  }
  
  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("did fail to register for remote notification with error ", error)
    
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
    JPUSHService.handleRemoteNotification(userInfo)
    print("受到通知", userInfo)
    NotificationCenter.default.post(name: Notification.Name(rawValue: "AddNotificationCount"), object: nil)  //把  要addnotificationcount
  }
  
  func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
    JPUSHService.showLocalNotification(atFront: notification, identifierKey: nil)
  }
  
  @available(iOS 7, *)
  func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
    
  }
  
  @available(iOS 7, *)
  func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
    
  }
  
  @available(iOS 7, *)
  func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable: Any], withResponseInfo responseInfo: [AnyHashable: Any], completionHandler: @escaping () -> Void) {
    
  }
  

  
}

