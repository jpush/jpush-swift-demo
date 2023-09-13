//
//  AppDelegate.swift
//  JPushSwiftDemo
//
//  Created by oshumini on 16/3/11.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation

let appKey = "4fcc3e237eec4c4fb804ad49"
let channel = "Publish channel"
let isProduction = false

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var locationManager: CLLocationManager?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        getLocationAuthority()
        
        let entity = JPUSHRegisterEntity()
        if #available(iOS 12, *) {
            entity.types = NSInteger(UNAuthorizationOptions.alert.rawValue) |
            NSInteger(UNAuthorizationOptions.sound.rawValue) |
            NSInteger(UNAuthorizationOptions.badge.rawValue) |
            NSInteger(UNAuthorizationOptions.provisional.rawValue)
        } else {
            entity.types = NSInteger(UNAuthorizationOptions.alert.rawValue) |
            NSInteger(UNAuthorizationOptions.sound.rawValue) |
            NSInteger(UNAuthorizationOptions.badge.rawValue)
        }
        
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        //如果使用地理围栏功能，需要注册地理围栏代理
        JPUSHService.registerLbsGeofenceDelegate(self, withLaunchOptions: launchOptions)
        //如果使用应用内消息功能，需要配置pageEnterTo:和pageLeave:接口，且可以通过设置该代理获取应用内消息的展示和点击事件
        JPUSHService.setInAppMessageDelegate(self)
        //如不需要使用IDFA，advertisingIdentifier 可为nil
        JPUSHService.setup(withOption: launchOptions, appKey: appKey, channel: channel, apsForProduction: isProduction, advertisingIdentifier: nil)
        
        //2.1.9版本新增获取registration id block接口。
        JPUSHService .registrationIDCompletionHandler { resCode, registrationID in
            if resCode == 0 {
                print("registrationID获取成功：\(String(describing: registrationID))")
            } else {
                print("registrationID获取失败，code：\(String(describing: registrationID))")
            }
        }
        
        return true
    }
  
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("get the deviceToken  \(deviceToken)")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "DidRegisterRemoteNotification"), object: deviceToken)
        // 注册devicetoken
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("did fail to register for remote notification with error ", error)
        
    }
    
    // iOS10以上静默推送会走该回调
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // 注意调用
        JPUSHService.handleRemoteNotification(userInfo)
        print("iOS7及以上系统，收到通知:\(userInfo)");
    }
    
}

extension AppDelegate:JPUSHRegisterDelegate, JPUSHGeofenceDelegate, JPUSHInAppMessageDelegate {
    
    //MARK - JPUSHRegisterDelegate
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: (() -> Void)) {
        
        let userInfo = response.notification.request.content.userInfo
        let request = response.notification.request // 收到推送的请求
//        let content = request.content // 收到推送的消息内容
        
//        let badge = content.badge // 推送消息的角标
//        let body = content.body   // 推送消息体
//        let sound = content.sound // 推送消息的声音
//        let subtitle = content.subtitle // 推送消息的副标题
//        let title = content.title // 推送消息的标题
        
        if (response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self) == true) {
            // 注意调用
            JPUSHService.handleRemoteNotification(userInfo)
            print("iOS10 收到远程通知:\(userInfo)")
            
        } else {
            print("iOS10 收到本地通知:\(userInfo)")
        }
        
        completionHandler()
        
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification,
                                 withCompletionHandler completionHandler: ((Int) -> Void)) {
        let userInfo = notification.request.content.userInfo
        let request = notification.request // 收到推送的请求
//        let content = request.content // 收到推送的消息内容
        
//        let badge = content.badge // 推送消息的角标
//        let body = content.body   // 推送消息体
//        let sound = content.sound // 推送消息的声音
//        let subtitle = content.subtitle // 推送消息的副标题
//        let title = content.title // 推送消息的标题
        
        if (notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self) == true) {
            // 注意调用
            JPUSHService.handleRemoteNotification(userInfo)
            print("iOS10 收到远程通知:\(userInfo)")
            addNotificationCount()
        } else {
            print("iOS10 收到本地通知:\(userInfo)")
        }
        
        completionHandler(Int(UNNotificationPresentationOptions.badge.rawValue | UNNotificationPresentationOptions.sound.rawValue | UNNotificationPresentationOptions.alert.rawValue))
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification) {
        
    }
    
    func jpushNotificationAuthorization(_ status: JPAuthorizationStatus, withInfo info: [AnyHashable : Any]?) {
        print("receive notification authorization status:\(status), info:\(String(describing: info))")
    }
    
    //MARK - JPUSHGeofenceDelegate
    func jpushGeofenceRegion(_ geofence: [AnyHashable : Any]?, error: Error?) {
        print("geofence: \(String(describing: geofence)), error: \(String(describing: error))")
    }
    
    func jpushCallbackGeofenceReceived(_ geofenceList: [[AnyHashable : Any]]?) {
        print("geofenceList: \(String(describing: geofenceList))")
    }
    
    //进入地理围栏区域
    func jpushGeofenceIdentifer(_ geofenceId: String, didEnterRegion userInfo: [AnyHashable : Any]?, error: Error?) {
        print("didEnterRegion")
    }
    
    //离开地理围栏区域
    func jpushGeofenceIdentifer(_ geofenceId: String, didExitRegion userInfo: [AnyHashable : Any]?, error: Error?) {
        print("didExitRegion")
    }
    
    //MARK - JPushInAppMessageDelegate
    func jPush(inAppMessageDidShow inAppMessage: JPushInAppMessage) {
        let messageId = inAppMessage.mesageId;
        let title = inAppMessage.title;
        let content = inAppMessage.content;
        // ... 更多参数获取请查看JPushInAppMessage
       print("jPushInAppMessageDidShow - messageId:\(messageId), title:\(title), content:\(content)")
    }
    
    func jPush(inAppMessageDidClick inAppMessage: JPushInAppMessage) {
        let messageId = inAppMessage.mesageId;
        let title = inAppMessage.title;
        let content = inAppMessage.content;
        // ... 更多参数获取请查看JPushInAppMessage
       print("jPushInAppMessageDidClick - messageId:\(messageId), title:\(title), content:\(content)")
    }
}


extension AppDelegate: CLLocationManagerDelegate {
    // MARK - location
    func getLocationAuthority() {
        locationManager = CLLocationManager()
        if #available(iOS 8.0, *) {
            locationManager?.requestAlwaysAuthorization()
        } else {
            if CLLocationManager.authorizationStatus() == .notDetermined {
                print("kCLAuthorizationStatusNotDetermined")
            }
        }
        locationManager?.delegate = self
    }
    
    // MARK - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .notDetermined {
            print("获取地理位置权限成功")
        }
    }
}

extension AppDelegate {
    // MARK - other
    func addNotificationCount() {
        let tabbarVC = UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
        let rootViewVC = tabbarVC.viewControllers!.first as! RootViewController
        rootViewVC.addNotificationCount()
    }
}

