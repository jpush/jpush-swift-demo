//
//  SecondViewController.swift
//  jpush-swift-demo
//
//  Created by oshumini on 16/1/21.
//  Copyright © 2016年 HuminiOS. All rights reserved.
//

import UIKit

class SetTagsViewController: UIViewController,UIGestureRecognizerDelegate {
  @IBOutlet weak var tags1TextField: UITextField!
  @IBOutlet weak var tags2TextField: UITextField!
  @IBOutlet weak var aliasTextField: UITextField!

  @IBOutlet weak var callBackTextView: UITextView!

  @IBAction func textFieldDidEndOnExit(sender: AnyObject) {
    sender.resignFirstResponder()
  }
  
  @IBAction func resetTags(sender: AnyObject) {
    JPUSHService.setTags(NSSet() as Set<NSObject>, callbackSelector: Selector("tagsAliasCallback:tags:alias:"), object: self)
    let alert = UIAlertView(title: "设置", message: "已发送重置tags请求", delegate: self, cancelButtonTitle: "确定")
    alert.show()
  }

  @IBAction func resetAlias(sender: AnyObject) {
    JPUSHService.setAlias("", callbackSelector: Selector("tagsAliasCallback:tags:alias:"), object: self)
    let alert = UIAlertView(title: "设置", message: "已发送重置 Alias 请求", delegate: self, cancelButtonTitle: "确定")
    alert.show()
  }
  
  @IBAction func setTagsAlias(sender: AnyObject) {

    var tags = NSMutableSet()
    
    if tags1TextField.text != "" {
      tags.addObject(tags1TextField.text!)
    }
    
    if tags2TextField.text != "" {
      tags.addObject(tags2TextField.text!)
    }
    
    var alias:String = aliasTextField.text!
    var outAlias:NSString!
    var outTags:NSSet!
    (outAlias, outTags) = self.analyseInput(alias, tags: tags)
    
    JPUSHService.setTags(outTags as Set<NSObject>, alias: outAlias as String, callbackSelector: Selector("tagsAliasCallback:tags:alias:"), target: self)
    
    let alert = UIAlertView(title: "设置", message: "已发送设置", delegate: self, cancelButtonTitle: "确定")
    alert.show()
  }
  
  func analyseInput(alias:NSString!, tags:NSSet!)->(NSString!,NSSet!) {
    var outAlias:NSString!
    var outTags:NSSet!

        if alias.length == 0 {
          outAlias = nil
        } else {
          outAlias = alias
        }
    
        if tags.count == 0 {
          outTags = nil
        } else {
          outTags = tags
          var emptyStringCount = 0
          tags.enumerateObjectsUsingBlock({ (tag:AnyObject, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
            if tag.isEqualToString("") {
              emptyStringCount++
            } else {
              emptyStringCount = 0
              stop.memory = true
            }
          })
          if emptyStringCount == tags.count {
            outAlias = nil
          }
        }
    return (outAlias,outTags)
  }
  
  func tagsAliasCallBack(resCode:Int, tags:NSSet, alias:NSString) {
    var callbackString = "\(resCode),  tags: \(self.loadView())"
    if callBackTextView.text == "服务器返回结果" {
      callBackTextView.text = callbackString
    } else {
      callBackTextView.text = "\(callbackString)\n\(callBackTextView.text)"
    }
    print("TagsAlias回调: \(callbackString)")
  }
  

  func logSet(dic:NSSet)->String? {
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
  
  @IBAction func clear(sender: AnyObject) {
    tags1TextField.text = ""
    tags2TextField.text = ""
    aliasTextField.text = ""
  }
  
  @IBAction func clearResult(sender: AnyObject) {
    callBackTextView.text = ""
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let gesture = UITapGestureRecognizer(target: self, action:Selector("handleTap:"))
    gesture.delegate = self
    self.view.addGestureRecognizer(gesture)
  }
  
  func handleTap(recognizer: UITapGestureRecognizer) {
    UIApplication.sharedApplication().sendAction(Selector("resignFirstResponder"), to: nil, from: nil, forEvent: nil)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()

  }


}

