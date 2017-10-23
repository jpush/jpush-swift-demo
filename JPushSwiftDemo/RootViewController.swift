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
    let defaultCenter:NotificationCenter = NotificationCenter.default
    defaultCenter.addObserver(self, selector: #selector(RootViewController.networkDidSetup(_:)), name:NSNotification.Name.jpfNetworkDidSetup, object: nil)
    defaultCenter.addObserver(self, selector: #selector(RootViewController.networkDidClose(_:)), name:NSNotification.Name.jpfNetworkDidClose, object: nil)
    defaultCenter.addObserver(self, selector: #selector(RootViewController.networkDidRegister(_:)), name:NSNotification.Name.jpfNetworkDidRegister, object: nil)
    defaultCenter.addObserver(self, selector: #selector(RootViewController.networkDidLogin(_:)), name:NSNotification.Name.jpfNetworkDidLogin, object: nil)
    defaultCenter.addObserver(self, selector: #selector(RootViewController.networkDidReceiveMessage(_:)), name:NSNotification.Name.jpfNetworkDidReceiveMessage, object: nil)
    defaultCenter.addObserver(self, selector: #selector(RootViewController.serviceError(_:)), name:NSNotification.Name.jpfServiceError, object: nil)
    registrationValueLabel.text = JPUSHService.registrationID()
    appKeyLabel.text = appKey
    
    defaultCenter.addObserver(self, selector: #selector(RootViewController.didRegisterRemoteNotification(_:)), name:NSNotification.Name(rawValue: "DidRegisterRemoteNotification"), object: nil)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func cleanMessage(_ sender: AnyObject) {
    messageCount = 0
    notificationCount = 0
    self.reloadMessageCountLabel()
    messageContents.removeAllObjects()
    self.notificationCountLabel.text = "0"
  }
  
  func unObserveAllNotifications() {
    let defaultCenter = NotificationCenter.default
    defaultCenter.removeObserver(self)
  }

  @objc func networkDidSetup(_ notification:Notification) {
    netWorkStateLabel.text = "已连接"
    print("已连接")
  }
  
  @objc func networkDidClose(_ notification:Notification) {
    netWorkStateLabel.text = "未连接"
    print("连接已断开")
  }
  @objc func networkDidRegister(_ notification:Notification) {
    netWorkStateLabel.text = "已注册"
    if let info = (notification as NSNotification).userInfo as? Dictionary<String,String> {
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
  
  @objc func networkDidLogin(_ notification:Notification) {
    netWorkStateLabel.text = "已登录"
    print("已登录")
    if JPUSHService.registrationID() != nil {
      registrationValueLabel.text = JPUSHService.registrationID()
      print("get RegistrationID")
    }
  }
  
  func logDic(_ dic:NSDictionary)->String? {
    if dic.count == 0 {
      return nil
    }
    
    let tempStr1 = dic.description.replacingOccurrences(of: "\\u", with: "\\U")
    let tempStr2 = dic.description.replacingOccurrences(of: "\"", with: "\\\"")
    let tempStr3 = "\"" + tempStr2 + "\""
    let tempData:Data = (tempStr3 as NSString).data(using: String.Encoding.utf8.rawValue)!
    let str = (String)(describing: PropertyListSerialization.propertyListFromData(tempData, mutabilityOption:PropertyListSerialization.MutabilityOptions(), format:nil, errorDescription: nil))
    return str
    
  }
  
  @objc func networkDidReceiveMessage(_ notification:Notification) {
    var userInfo = (notification as NSNotification).userInfo as? Dictionary<String,String>
    let title = userInfo!["title"]
    let content = userInfo!["content"]
    let extra = userInfo?["ID"] as? NSDictionary
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"

    let currentContent = "收到自定义消息: \(DateFormatter.localizedString(from: Date(), dateStyle: DateFormatter.Style.none, timeStyle: DateFormatter.Style.medium)) tittle: \(title) content: \(content) extra: \(self.logDic(extra!))"
    messageContents.insert(currentContent, at: 0)
    
    let allContent = "收到消息: \(DateFormatter.localizedString(from: Date(), dateStyle: DateFormatter.Style.none, timeStyle: DateFormatter.Style.medium)) extra \(self.logDic(extra!))"
    messageContentView.text = allContent
    messageCount += 1
    self.reloadMessageCountLabel()
  }
  
  @objc func serviceError(_ notification:Notification) {
    let userInfo = (notification as NSNotification).userInfo as? Dictionary<String,String>
    let error = userInfo!["error"]
    print(error)
  }

  @objc func didRegisterRemoteNotification(_ notification:Notification) {
    let deviceTokenStr = notification.object
    deviceTokenValue.text = "\(deviceTokenStr)"
  }
  
  func reloadMessageCountLabel() {
    messageCountLabel.text = "\(messageCount)"
  }
  
  func reloadNotificationCountLabel() {
    notificationCountLabel.text = "\(notificationCount)"
  }
  
  func addNotificationCount() {
    notificationCount += 1
    self.reloadNotificationCountLabel()
  }
  
  func addMessageCount() {
    messageCount += 1
    self.reloadMessageCountLabel()
  }
  func reloadMessageContentView() {
    messageContentView.text = ""
  }
}

