import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?rootViewController as! FlutterViewController
    let flutterChannel = FlutterMethodChannel(name: "com.belajarubic.methodchannel", binaryMessenger: controller.binaryMessenger)

    flutterChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in

      if(call.method == "getDirectMessage"){
        result ("Received callback from iOS")
        
      } else if (call.method == "getErrorMessage"){
        result(FlutterError(code: "-1", message: "Something went wrong", details: "something went wrong"))
      
      } else if (call.method == "getMessageFromParam"){
        guard let args = call.arguments as? [String:Any] else {return}
        let param1 =  args["param1"] as! String
        result ("Received param from iOS : \(param1)")
      
      } else if (call.method == "getMessageFromNative"){
        result ("Wait 3 second and see the result")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
          flutterChannel.invokeMethod("fromNative", arguments: "{\"message\":\"hello from native iOS\"}")
        }
      
      }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
