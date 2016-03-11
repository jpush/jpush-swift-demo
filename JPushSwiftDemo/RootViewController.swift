//
//  FirstViewController.swift
//  jpush-swift-demo
//
//  Created by oshumini on 16/1/21.
//  Copyright © 2016年 HuminiOS. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
  @IBOutlet weak var netWorkStateLabel: UILabel!
  @IBOutlet weak var deviceTokenValue: UILabel!
  @IBOutlet weak var registrationValueLabel: UILabel!
  @IBOutlet weak var appKeyLabel: UILabel!

  @IBOutlet weak var messageCountLabel: UILabel!
  @IBOutlet weak var notificationCountLabel: UILabel!
  @IBOutlet weak var messageContentView: UILabel!
  @IBOutlet weak var cleanMessageButton: UIButton!
  
  var messageContents:NSMutableArray!
  var messageCount = 0
  var notificationCount = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()

    messageContents = NSMutableArray()
    let defaultCenter:NSNotificationCenter = NSNotificationCenter.defaultCenter()
    defaultCenter.addObserver(self, selector: "networkDidSetup:", name:kJPFNetworkDidSetupNotification, object: nil)
    defaultCenter.addObserver(self, selector: "networkDidClose:", name:kJPFNetworkDidCloseNotification, object: nil)
    defaultCenter.addObserver(self, selector: "networkDidRegister:", name:kJPFNetworkDidRegisterNotification, object: nil)
    defaultCenter.addObserver(self, selector: "networkDidLogin:", name:kJPFNetworkDidLoginNotification, object: nil)
    defaultCenter.addObserver(self, selector: "networkDidReceiveMessage:", name:kJPFNetworkDidReceiveMessageNotification, object: nil)
    defaultCenter.addObserver(self, selector: "serviceError:", name:kJPFServiceErrorNotification, object: nil)
    registrationValueLabel.text = JPUSHService.registrationID()
    appKeyLabel.text = appKey
    
    defaultCenter.addObserver(self, selector: "didRegisterRemoteNotification:", name:"DidRegisterRemoteNotification", object: nil)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func cleanMessage(sender: AnyObject) {
    messageCount = 0
    notificationCount = 0
    self.reloadMessageCountLabel()
    messageContents.removeAllObjects()
    self.notificationCountLabel.text = "0"
  }
  
  func unObserveAllNotifications() {
    let defaultCenter = NSNotificationCenter.defaultCenter()
    defaultCenter.removeObserver(self)
  }

  func networkDidSetup(notification:NSNotification) {
    netWorkStateLabel.text = "已连接"
    print("已连接")
  }
  
  func networkDidClose(notification:NSNotification) {
    netWorkStateLabel.text = "未连接"
    print("连接已断开")
  }
  func networkDidRegister(notification:NSNotification) {
    netWorkStateLabel.text = "已注册"
    if let info = notification.userInfo as? Dictionary<String,String> {
      // Check if value present before using it
      if let s = info["RegistrationID"] {
        registrationValueLabel.text = s
      } else {
        print("no value for key\n")
      }
    } else {
      print("wrong userInfo type")
    }
    print("已注册")
  }
  
  func networkDidLogin(notification:NSNotification) {
    netWorkStateLabel.text = "已登录"
    print("已登录")
    if JPUSHService.registrationID() != nil {
      registrationValueLabel.text = JPUSHService.registrationID()
      print("get RegistrationID")
    }
  }
  
  func logDic(dic:NSDictionary)->String? {
    if dic.count == 0 {
      return nil
    }
    
    let tempStr1 = dic.description.stringByReplacingOccurrencesOfString("\\u", withString: "\\U")
    let tempStr2 = dic.description.stringByReplacingOccurrencesOfString("\"", withString: "\\\"")
    let tempStr3 = "\"" + tempStr2 + "\""
    var tempData:NSData = (tempStr3 as NSString).dataUsingEncoding(NSUTF8StringEncoding)!
    let str = (String)(NSPropertyListSerialization.propertyListFromData(tempData, mutabilityOption:NSPropertyListMutabilityOptions.Immutable, format:nil, errorDescription: nil))
    return str
    
  }
  
  func networkDidReceiveMessage(notification:NSNotification) {
    var userInfo = notification.userInfo as? Dictionary<String,String>
    let title = userInfo!["title"]
    let content = userInfo!["content"]
    let extra = userInfo?["ID"] as? NSDictionary
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"

    let currentContent = "收到自定义消息: \(NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: NSDateFormatterStyle.NoStyle, timeStyle: NSDateFormatterStyle.MediumStyle)) tittle: \(title) content: \(content) extra: \(self.logDic(extra!))"
    messageContents.insertObject(currentContent, atIndex: 0)
    
    let allContent = "收到消息: \(NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: NSDateFormatterStyle.NoStyle, timeStyle: NSDateFormatterStyle.MediumStyle)) extra \(self.logDic(extra!))"
    messageContentView.text = allContent
    messageCount++
    self.reloadMessageCountLabel()
  }
  
  func serviceError(notification:NSNotification) {
    let userInfo = notification.userInfo as? Dictionary<String,String>
    let error = userInfo!["error"]
    print(error)
  }

  func didRegisterRemoteNotification(notification:NSNotification) {
    var deviceTokenStr = notification.object
    deviceTokenValue.text = "\(deviceTokenStr)"
  }
  
  func reloadMessageCountLabel() {
    messageCountLabel.text = "\(messageCount)"
  }
  
  func reloadNotificationCountLabel() {
    notificationCountLabel.text = "\(notificationCount)"
  }
  
  func addNotificationCount() {
    notificationCount++
    self.reloadNotificationCountLabel()
  }
  
  func addMessageCount() {
    messageCount++
    self.reloadMessageCountLabel()
  }
  func reloadMessageContentView() {
    messageContentView.text = ""
  }
}

