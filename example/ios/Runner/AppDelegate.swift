import UIKit
import Flutter
import cr_logger

let CHANNEL = "com.cleveroad.cr_logger_example/logs"

@main
@objc class AppDelegate: FlutterAppDelegate {
    
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let loggerChannel = FlutterMethodChannel(name: CHANNEL, binaryMessenger: controller.binaryMessenger)
        
        loggerChannel.setMethodCallHandler {(call: FlutterMethodCall, result: FlutterResult) -> Void in
            switch call.method {
            case "debug":
                CrLogger.d(message: "Debug logs from native iOS")
            case "info":
                CrLogger.i(message: "Info logs from native iOS")
                break
            case "error":
                CrLogger.e(message: "Error logs from native iOS")
                break
            case "logJson":
                let keyValuePairsData = self.getOrderedMap()
                CrLogger.d(message: keyValuePairsData)
                CrLogger.i(message: keyValuePairsData)
                CrLogger.e(message: keyValuePairsData)
                
            default:
                result(FlutterMethodNotImplemented)
            }
            result(true)
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    
    private func getOrderedMap() -> KeyValuePairs<String, Any> {
        let keyValueSession: KeyValuePairs<String, Any> = [
            "accessToken": "gnrjknsmdkom232",
            "refreshToken": "sdapasldofkds123",
            "tokenLifetime": 123456789
        ]
        
        let keyValueAvatar : KeyValuePairs<String, Any> = [
            "avatarUrl": "https://image.example/userId/avatar.jpg",
            "smallAvatarUrl":"https://image.example/userId/small_avatar.jpg"
        ]
        
        let keyValueUser : KeyValuePairs<String, Any> = [
            "id" : "mnjtnnjw542",
            "firstName": "Steave",
            "lastName": "Jobs",
            "session": keyValueSession,
            "avatar": keyValueAvatar,
        ]
        
        
        return keyValueUser
    }
}

