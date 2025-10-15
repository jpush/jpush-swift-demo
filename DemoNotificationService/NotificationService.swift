//
//  NotificationService.swift
//  DemoNotificationService
//
//  Created by Shuni Huang on 2025/10/13.
//  Copyright © 2025 HXHG. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
            
//            contentHandler(bestAttemptContent)
            
            apnsDeliverWith(request: request)
        }
    }
    
    private func apnsDeliverWith(request: UNNotificationRequest) {
           // Please invoke this func on release version
           // JPushNotificationExtensionService.setLogOff()
           
           // Service extension SDK
           // Upload to calculate delivery rate
           JPushNotificationExtensionService.jpushSetAppkey("4fcc3e237eec4c4fb804ad49")
           JPushNotificationExtensionService.jpushReceive(request) { [weak self] in
               print("apns upload success")
               if let bestAttemptContent = self?.bestAttemptContent {
                   self?.contentHandler?(bestAttemptContent)
               }
           }
       }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
