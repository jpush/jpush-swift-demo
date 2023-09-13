//
//  JPushUtils.swift
//  JPushSwiftDemo
//
//  Created by Shuni Huang on 2023/9/12.
//  Copyright © 2023 HXHG. All rights reserved.
//

import UIKit

class JPushUtils: NSObject {

    class func showAlertController(withTitle title: String, message: String) {
        DispatchQueue.main.async {
            if  #available(iOS 8, *) {
                
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let closeAction = UIAlertAction(title: "好的", style: .default) { _ in
                        // Handler for close action
                    }
                alertController.addAction(closeAction)
                let vc = UIApplication.shared.keyWindow?.rootViewController
                vc?.present(alertController, animated: true, completion: nil)
               
            } else {
                let alertView = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: "确定")
                alertView.show()
            }
        }
    }
    
}
