//
//  setLocalNotificationViewController.swift
//  jpush-swift-demo
//
//  Created by oshumini on 16/1/21.
//  Copyright © 2016年 HuminiOS. All rights reserved.
//

import UIKit

class setLocalNotificationViewController: UIViewController,UITextFieldDelegate,UIGestureRecognizerDelegate {
  @IBOutlet weak var notificationDatePicker: UIDatePicker!
  @IBOutlet weak var notificationBodyTextField: UITextField!
  @IBOutlet weak var notificationButtonTextField: UITextField!
  @IBOutlet weak var notificationIdentifierTextField: UITextField!
  @IBOutlet weak var notificationBadgeTextField: UITextField!
  
  var localnotif:UILocalNotification?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    let gesture = UITapGestureRecognizer(target: self, action:#selector(setLocalNotificationViewController.handleTap(_:)))
    gesture.delegate = self
    self.view.addGestureRecognizer(gesture)
  }
  
  func handleTap(_ recognizer: UITapGestureRecognizer) {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()

  }
  
  @IBAction func setNotification(_ sender: AnyObject) {
    localnotif = JPUSHService.setLocalNotification(notificationDatePicker.date, alertBody: notificationBodyTextField.text, badge: Int32(notificationBadgeTextField.text!)!, alertAction: notificationButtonTextField.text, identifierKey: notificationIdentifierTextField.text, userInfo: nil, soundName: nil)
    var result:String?
    if localnotif != nil {
      result = "设置本地通知成功"
    } else {
      result = "设置本地通知失败"
    }
    let alert = UIAlertView(title: "设置", message: result, delegate: self, cancelButtonTitle: "确定")
    alert.show()
  }
  
  func clearAllInput() {
    notificationBadgeTextField.text = ""
    notificationBodyTextField.text = ""
    notificationButtonTextField.text = ""
    notificationIdentifierTextField.text = ""
    notificationDatePicker.date = Date().addingTimeInterval(0)
  
  }
  @IBAction func clearAllNotification(_ sender: AnyObject) {
    JPUSHService.clearAllLocalNotifications()
    let alert = UIAlertView(title: "设置", message: "取消所有本地通知成功", delegate: self, cancelButtonTitle: "确定")
    alert.show()
  }

  @IBAction func clearLastNotification(_ sender: AnyObject) {
    var alertMessage:String?
    if localnotif != nil {
      JPUSHService.delete(localnotif)
      localnotif = nil
      alertMessage = "取消上一个通知成功"
    } else {
      alertMessage = "不存在上一个设置通知"
    }
    
    let alert = UIAlertView(title: "设置", message: alertMessage, delegate: self, cancelButtonTitle: "确定")
    alert.show()
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if textField.tag != 10 {
      return true
    }
    return true
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
}
