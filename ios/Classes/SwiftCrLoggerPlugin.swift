import Flutter
import UIKit

public class SwiftCrLoggerPlugin: NSObject, FlutterPlugin {
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "cr_logger", binaryMessenger: registrar.messenger())
    let instance = SwiftCrLoggerPlugin()
    FlutterEventChannel(name: "com.cleveroad.cr_logger/logger", binaryMessenger: registrar.messenger())
                  .setStreamHandler(CrLogger())
      

    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
