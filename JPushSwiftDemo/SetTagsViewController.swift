//
//  SecondViewController.swift
//  jpush-swift-demo
//
//  Created by oshumini on 16/1/21.
//  Copyright © 2016年 HuminiOS. All rights reserved.
//

import UIKit

class SetTagsViewController: UIViewController,UIGestureRecognizerDelegate {
    @IBOutlet weak var tagsTextField: UITextField!
    @IBOutlet weak var aliasTextField: UITextField!
    @IBOutlet weak var holderTextView: UITextView!
    
    var seq = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        holderTextView.layer.borderColor = UIColor.lightGray.cgColor
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
        tagsTextField.resignFirstResponder()
        aliasTextField.resignFirstResponder()
    }
    
    
    @IBAction func addTags(_ sender: Any) {
        JPUSHService.addTags(self.getTags(), completion: { iResCode, iTags, seq in
            let tagsArray = Array(iTags ?? [])
            let tagsString = "\(tagsArray)"
            self.inputResponseCode(iResCode, content: tagsString, andSeq: seq)
        }, seq: self.getSeq())
    }
    
    @IBAction func setTags(_ sender: Any) {
        JPUSHService.setTags(self.getTags(), completion: { iResCode, iTags, seq in
            let tagsArray = Array(iTags ?? [])
            let tagsString = "\(tagsArray)"
            self.inputResponseCode(iResCode, content: tagsString, andSeq: seq)
        }, seq: self.getSeq())
    }
    
    
    @IBAction func getAllTags(_ sender: Any) {
        JPUSHService.getAllTags({ iResCode, iTags, seq in
            let tagsArray = Array(iTags ?? [])
            let tagsString = "\(tagsArray)"
            self.inputResponseCode(iResCode, content: tagsString, andSeq: seq)
        }, seq: self.getSeq())
    }
    
    @IBAction func deleteTags(_ sender: Any) {
        JPUSHService.deleteTags(self.getTags(), completion: { iResCode, iTags, seq in
            let tagsArray = Array(iTags ?? [])
            let tagsString = "\(tagsArray)"
            self.inputResponseCode(iResCode, content: tagsString, andSeq: seq)
        }, seq: self.getSeq())
    }
    
    
    @IBAction func cleanTags(_ sender: Any) {
        JPUSHService.cleanTags({ iResCode, iTags, seq in
            let tagsArray = Array(iTags ?? [])
            let tagsString = "\(tagsArray)"
            self.inputResponseCode(iResCode, content: tagsString, andSeq: seq)
        }, seq: self.getSeq())
    }
    
    @IBAction func vaildTag(_ sender: Any) {
        if self.getTags().count == 0 {
            return
        }
        JPUSHService.validTag(self.getTags().first!, completion: { iResCode, iTags, seq, isBind in
            let tagsArray = Array(iTags ?? [])
            let tagsString = "\(tagsArray)"
            let content = "\(tagsString) isBind:\(isBind)"
            self.inputResponseCode(iResCode, content: content, andSeq: seq)
        }, seq: self.getSeq())
    }
    
    @IBAction func setAlias(_ sender: Any) {
        if self.getAlias()?.count ?? 0 <= 0 {
            return
        }
        JPUSHService.setAlias(self.getAlias()!, completion: { iResCode, iAlias, seq in
            self.inputResponseCode(iResCode, content: iAlias ?? "", andSeq: seq)
        }, seq: self.getSeq())
        
    }
    
    
    @IBAction func deleteAlias(_ sender: Any) {
        JPUSHService.deleteAlias({ iResCode, iAlias, seq in
            self.inputResponseCode(iResCode, content: iAlias ?? "", andSeq: seq)
        }, seq: self.getSeq())
    }
    
    
    @IBAction func getAlias(_ sender: Any) {
        JPUSHService.getAlias({ iResCode, iAlias, seq in
            self.inputResponseCode(iResCode, content: iAlias ?? "", andSeq: seq)
        }, seq: self.getSeq())
    }
    
    
    @IBAction func resetTextField(_ sender: Any) {
        tagsTextField.text = nil
        aliasTextField.text = nil
    }
    
    @IBAction func resetTextView(_ sender: Any) {
        holderTextView.text = nil
    }
    
    
    func getTags() -> Set<String> {
        let tagsList = self.tagsTextField.text?.components(separatedBy: ",") ?? []
        
        if self.tagsTextField.text?.count ?? 0 > 0 && tagsList.isEmpty {
            JPushUtils.showAlertController(withTitle: "提示", message: "没有输入tags,请使用逗号作为tags分隔符")
        }
        
        var tags = Set<String>()
        tags.formUnion(tagsList)
        
        // 过滤掉无效的tag
        let newTags = JPUSHService.filterValidTags(tags)
        return newTags as! Set<String>
    }
    
    func getAlias() -> String? {
        return self.aliasTextField.text
    }
    
    func inputResponseCode(_ code: Int, content: String, andSeq seq: Int) {
        self.holderTextView.text.append("\n\n code:\(code) content:\(content) seq:\(seq)")
    }
    
    func getSeq() -> Int {
        seq += 1
        return seq
    }
    
}

