# jpush-swift-demo
Offically supported Swift Demo for JPush iOS SDK. 

## jpush sdk swift 集成步骤
### 1. 添加工程文件到
![image](https://github.com/jpush/jpush-swift-demo/blob/master/ReadMeRecource/添加jpushSDK到工程中%20.gif)

### 2. 在工程中新建一个 Objective-C Bridging Header 文件
![image](https://github.com/jpush/jpush-swift-demo/blob/master/ReadMeRecource/生成ObjCBridge文件.gif)

### 3. 在刚生成的Objective-C Bridging Header文件中导入 jpush 头文件
![image](https://github.com/jpush/jpush-swift-demo/blob/master/ReadMeRecource/在ObjctBridgingHeader添加sdk头文件.gif)

### 4. 在Link Binary with Libraries 添加下图的依赖库
![image](https://github.com/jpush/jpush-swift-demo/blob/master/ReadMeRecource/添加依赖库文件.png)

### 5. 在Appdelegate.swift 文件的 didFinishLaunching 方法中添加如下代码
```
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    if((UIDevice.currentDevice().systemVersion as NSString).floatValue >= 8.0) {
      // 可以自定义 categories
      JPUSHService.registerForRemoteNotificationTypes(UIUserNotificationType.Badge.rawValue | UIUserNotificationType.Badge.rawValue | UIUserNotificationType.Alert.rawValue , categories: nil)
    } else {
      JPUSHService.registerForRemoteNotificationTypes(UIUserNotificationType.Badge.rawValue | UIUserNotificationType.Badge.rawValue | UIUserNotificationType.Alert.rawValue , categories: nil)
    }
    JPUSHService.setupWithOption(launchOptions, appKey: appKey, channel: channel, apsForProduction: isProduction)
    
    return true
  }
```

### 6. 在Appdelegate.swift 文件的 didRegisterForRemoteNotificationsWithDeviceToken 方法中添加如下代码
```
  func application(application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
      print("get the deviceToken  \(deviceToken)")
      NSNotificationCenter.defaultCenter().postNotificationName("DidRegisterRemoteNotification", object: deviceToken)
      JPUSHService.registerDeviceToken(deviceToken)
      
  }
```

到此 已经完成集成 JPush sdk 的基本功能，如需要更多功能请打开Demo工程了解详情
