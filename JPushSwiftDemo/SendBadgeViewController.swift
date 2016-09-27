//
//  SendBadgeViewController.swift
//  jpush-swift-demo
//
//  Created by oshumini on 16/1/21.
//  Copyright © 2016年 HuminiOS. All rights reserved.
//

import UIKit

class SendBadgeViewController: UIViewController,UIGestureRecognizerDelegate {
  @IBOutlet weak var sendBadgeText: UITextField!
  @IBOutlet weak var sendBadgeButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    let gesture = UITapGestureRecognizer(target: self, action:#selector(SendBadgeViewController.handleTap(_:)))
    gesture.delegate = self
    self.view.addGestureRecognizer(gesture)
  }
  
  func handleTap(_ recognizer: UITapGestureRecognizer) {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  @IBAction func onClickToSend(_ sender: AnyObject) {

    let badgeText:NSString? = sendBadgeText.text as NSString?
    let value:Int = Int(badgeText!.intValue)
    JPUSHService.setBadge(value)
    print("send badge:%d to jpush server",value)
  }
}

