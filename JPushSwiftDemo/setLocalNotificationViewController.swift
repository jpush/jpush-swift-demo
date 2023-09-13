//
//  setLocalNotificationViewController.swift
//  jpush-swift-demo
//
//  Created by oshumini on 16/1/21.
//  Copyright © 2016年 HuminiOS. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

class setLocalNotificationViewController: UIViewController,UITextFieldDelegate,UIGestureRecognizerDelegate {
    
    @IBOutlet var backgroundView: UIView!
    
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var subtitleTF: UITextField!
    @IBOutlet weak var bodyTF: UITextField!
    @IBOutlet weak var badgeTF: UITextField!
    @IBOutlet weak var actionTF: UITextField!
    @IBOutlet weak var soundTF: UITextField!
    @IBOutlet weak var cateforyIdentifierTF: UITextField!
    @IBOutlet weak var threadIDTF: UITextField!
    @IBOutlet weak var summaryArgumentTF: UITextField!
    @IBOutlet weak var summaryArgCountTF: UITextField!
    @IBOutlet weak var requestIdentifierTF: UITextField!
    
    @IBOutlet weak var repeatSW: UISwitch!
    
    @IBOutlet weak var deliveredSW: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        JPUSHService.pageEnter(to: NSStringFromClass(type(of: self)))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        JPUSHService.pageEnter(to: NSStringFromClass(type(of: self)))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func addNotificationWithDateTrigger(_ sender: Any) {
        
        let trigger = JPushNotificationTrigger()
        if #available(iOS 10, *){
            // 周二早上8点
            var components = DateComponents()
            components.weekday = 2
            components.hour = 8
            trigger.dateComponents = components
        } else {
            // date
            let fireDate = Date(timeIntervalSinceNow: 20)
            trigger.fireDate = fireDate
        }
        trigger.repeat = repeatSW.isOn
        let request = JPushNotificationRequest()
        request.content = generateNotificationContent()
        request.trigger = trigger
        request.completionHandler = { result in
            if ((result as AnyObject).isKind(of: UNNotificationRequest.self)) {
                JPushUtils.showAlertController(withTitle: "添加 date 通知失败", message: "")
                return
            }
            print("添加日期通知成功 --- \(result)")
            var message = ""
            if #available(iOS 10, *) {
                message = "iOS10以上，\(trigger.dateComponents)触发"
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let dateStr = dateFormatter.string(from: trigger.fireDate )
                message = "iOS10以下，\(dateStr)触发"
            }
            JPushUtils.showAlertController(withTitle: "添加 date 通知成功", message: message)
            
        }
        request.requestIdentifier = requestIdentifierTF.text ?? ""
        JPUSHService.addNotification(request)
    }
    
    
    @IBAction func addNotificationWithRegionTrigger(_ sender: Any) {
        
        let trigger = JPushNotificationTrigger()
        if #available(iOS 10, *) {
            let cen = CLLocationCoordinate2D(latitude: 22.5531706, longitude: 113.9025006)
            let region = CLCircularRegion(center: cen, radius: 2000.0, identifier: "JIGUANG")
            trigger.region = region
            trigger.repeat = repeatSW.isOn
        } else {
            print("region 触发通知只在 iOS8 以上有效哦……")
            JPushUtils.showAlertController(withTitle: "", message: "region 触发通知只在 iOS8 以上有效")
            return
        }
        let request = JPushNotificationRequest()
        request.content = generateNotificationContent()
        request.trigger = trigger
        request.completionHandler = { result in
            if (result as AnyObject).isKind(of: UNNotificationRequest.self) {
                print("添加地理位置通知成功 --- \(result)")
                let message = "\(trigger.region)"
                JPushUtils.showAlertController(withTitle: "添加 region 通知成功", message: message)
            } else {
                JPushUtils.showAlertController(withTitle: "添加 region 通知失败", message: "")
            }
        }
        request.requestIdentifier = requestIdentifierTF.text ?? ""
        JPUSHService.addNotification(request)
        
    }
    
    @IBAction func addNotificationWithTimeintervalTrigger(_ sender: Any) {
        let trigger = JPushNotificationTrigger()
        if #available(iOS 10, *) {
            // 20秒后触发
            trigger.timeInterval = 20
            if trigger.timeInterval < 60 {
                // 由于系统限制，重复触发时间必须大于等于60秒，否则会崩溃
                trigger.repeat = false
            } else {
                trigger.repeat = repeatSW.isOn
            }
        } else {
            print("timeInterval 触发通知只在 iOS10 以上有效哦……")
            JPushUtils.showAlertController(withTitle: "", message: "timeInterval 触发通知只在 iOS10 以上有效")
            return
        }
        let request = JPushNotificationRequest()
        request.content = generateNotificationContent()
        request.trigger = trigger
        request.completionHandler = { result in
            if ((result as AnyObject).isKind(of: UNNotificationRequest.self)) {
                print("添加 timeInterval 通知成功 --- \(result)")
                let message = "iOS10以上，\(Int(trigger.timeInterval))秒后触发"
                JPushUtils.showAlertController(withTitle: "添加 timeInterval 通知成功", message: message)
            } else {
                JPushUtils.showAlertController(withTitle: "添加 timeInterval 通知失败", message: "")
            }
        }
        request.requestIdentifier = requestIdentifierTF.text ?? ""
        JPUSHService.addNotification(request)
    }
    
    
    @IBAction func findNotifationWithIdentifier(_ sender: Any) {
        let identifier = JPushNotificationIdentifier()
        // 注意：identifiers 这里可以设置多个 identifier 来查找多个指定推送。
        identifier.identifiers = [requestIdentifierTF.text ?? ""]
        // delivered iOS10以上有效，YES 表示在通知中心显示的里面查找，NO 则是在待推送的里面查找；iOS10以下无效
        identifier.delivered = deliveredSW.isOn
        identifier.findCompletionHandler = { results in
            // results iOS10以下返回UILocalNotification对象数组
            // iOS10以上 根据delivered传入值返回UNNotification或UNNotificationRequest对象数组
            print("查找指定通知 - 返回结果为：\(String(describing: results))")
            let title = "查找指定通知 \(String(describing: results?.count)) 条"
            let message = "\(String(describing: results))"
            JPushUtils.showAlertController(withTitle: title, message: message)
        }
        JPUSHService.findNotification(identifier)
        
    }
    
    @IBAction func findAllNotification(_ sender: Any) {
        let identifier = JPushNotificationIdentifier()
        //iOS10以上 identifiers 为nil或者空数组，会根据delivered值查找对应推送。delivered为 YES 表示查找通知中心显示的所有通知，NO则是查找所有待推送通知
        //iOS10以下 identifiers 为nil或者空数组，会找到所有未被触发的通知。
        identifier.identifiers = nil
        identifier.delivered = self.deliveredSW.isOn
        identifier.findCompletionHandler = {results in
            print("查找指定通知 - 返回结果为：\(String(describing: results))")
            let title = "查找指定通知 \(String(describing: results?.count)) 条"
            let message = "\(String(describing: results))"
            JPushUtils.showAlertController(withTitle: title, message: message)
        }
        JPUSHService.findNotification(identifier)
    }
    
    @IBAction func removeNotificationWithIdentifier(_ sender: Any) {
        let identifier = JPushNotificationIdentifier()
        if self.requestIdentifierTF.text?.count ?? 0 > 0 {
            //note:identifiers这里可以设置多个identifier来删除多个指定推送。
            identifier.identifiers = [self.requestIdentifierTF.text!]
            //在iOS10以下，可以通过通知对象来删除具体的某一个通知
            identifier.delivered = self.deliveredSW.isOn
            JPUSHService.removeNotification(identifier)
            print("删除指定通知")
            JPushUtils.showAlertController(withTitle: "", message: "删除指定通知")
        }
    }
    
    @IBAction func removeAllNotification(_ sender: Any) {
        //iOS10以下 移除所有推送；
        //iOS10以上 移除所有在通知中心显示推送和待推送请求, 当然也可以通过 delivered 属性来选择移除所有通知中心的通知，或者是未触发的所有通知
        JPUSHService.removeNotification(nil)
        print("删除所有通知")
        JPushUtils.showAlertController(withTitle: "", message: "删除所有通知")
    }
    
    func generateNotificationContent() -> JPushNotificationContent {
        let content = JPushNotificationContent()
        content.title = titleTF.text ?? ""
        content.subtitle = subtitleTF.text ?? ""
        content.body = bodyTF.text ?? ""
        content.badge = NSNumber(value: Int(badgeTF.text ?? "") ?? 0)
        if #available(iOS 10, *) {
        }else {
            content.action = actionTF.text ?? ""
        }
        content.categoryIdentifier = cateforyIdentifierTF.text ?? ""
        content.threadIdentifier = threadIDTF.text ?? ""
        
        if #available(iOS 10.0, *) {
            let soundSetting = JPushNotificationSound()
            soundSetting.soundName = soundTF.text
            if #available(iOS 12.0, *) {
                soundSetting.criticalSoundName = "sound.caf"
                soundSetting.criticalSoundVolume = 0.9
            }
            content.soundSetting = soundSetting
        } else {
            content.sound = soundTF.text
        }
        
        if #available(iOS 12.0, *) {
            content.summaryArgument = summaryArgumentTF.text ?? ""
            content.summaryArgumentCount = UInt(Int(summaryArgCountTF.text ?? "") ?? 0)
        }
        
        if #available(iOS 16.0, *) {
            content.filterCriteria = "fromwork"
        }
        
        if #available(iOS 10.0, *) {
            if requestIdentifierTF.text?.count ?? 0 <= 0 {
                JPushUtils.showAlertController(withTitle: "", message: "通知identifier不能为空")
            }
        }
        
        return content
    }
    
}
