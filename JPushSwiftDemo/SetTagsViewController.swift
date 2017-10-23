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
  let callBackSEL = Selector("tagsAliasCallBack:tags:alias:") //
  
  @IBAction func textFieldDidEndOnExit(_ sender: AnyObject) {
    sender.resignFirstResponder()
  }
  
  @IBAction func resetTags(_ sender: AnyObject) {
    JPUSHService.setTags(NSSet() as Set<NSObject>, callbackSelector: callBackSEL, object: self)
    let alert = UIAlertView(title: "设置", message: "已发送重置tags请求", delegate: self, cancelButtonTitle: "确定")
    alert.show()
  }

  @IBAction func resetAlias(_ sender: AnyObject) {
    JPUSHService.setAlias("", callbackSelector: callBackSEL, object: self)
    let alert = UIAlertView(title: "设置", message: "已发送重置 Alias 请求", delegate: self, cancelButtonTitle: "确定")
    alert.show()
  }
  
  @IBAction func setTagsAlias(_ sender: AnyObject) {

    let tags = NSMutableSet()
    
    if tags1TextField.text != "" {
      tags.add(tags1TextField.text!)
    }
    
    if tags2TextField.text != "" {
      tags.add(tags2TextField.text!)
    }

    let alias = aliasTextField.text
    
    var outAlias:NSString?
    var outTags:NSSet?
    (outAlias, outTags) = self.analyseInput(alias as NSString!, tags: tags)
    
    JPUSHService.setTags(outTags as? Set<NSObject>, alias: outAlias as? String, callbackSelector: callBackSEL, target: self)
    
    let alert = UIAlertView(title: "设置", message: "已发送设置", delegate: self, cancelButtonTitle: "确定")
    alert.show()
  }
  
  func analyseInput(_ alias:NSString!, tags:NSSet!)->(NSString?,NSSet?) {
    var outAlias:NSString?
    var outTags:NSSet?

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
          tags.enumerateObjects({ (tag:Any, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
            if (tag as AnyObject).isEqual(to: "") {
              emptyStringCount += 1
            } else {
              emptyStringCount = 0
              stop.pointee = true
            }
          } as! (Any, UnsafeMutablePointer<ObjCBool>) -> Void)
          if emptyStringCount == tags.count {
            outAlias = nil
          }
        }
    return (outAlias,outTags)
  }
  
  @objc func tagsAliasCallBack(_ resCode:CInt, tags:NSSet, alias:NSString) {
    let callbackString = "\(resCode),  tags: \(self.logSet(tags))"
    if callBackTextView.text == "服务器返回结果" {
      callBackTextView.text = callbackString
    } else {
      callBackTextView.text = "\(callbackString)    \(callBackTextView.text)"
    }
    print("TagsAlias回调: \(callbackString)")
  }
  

  func logSet(_ dic:NSSet)->String? {
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
  
  @IBAction func clear(_ sender: AnyObject) {
    tags1TextField.text = ""
    tags2TextField.text = ""
    aliasTextField.text = ""
  }
  
  @IBAction func clearResult(_ sender: AnyObject) {
    callBackTextView.text = ""
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let gesture = UITapGestureRecognizer(target: self, action:#selector(SetTagsViewController.handleTap(_:)))
    gesture.delegate = self
    self.view.addGestureRecognizer(gesture)
  }
  
  @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()

  }


}

