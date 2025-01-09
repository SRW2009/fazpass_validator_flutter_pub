import Flutter
import ios_trusted_device_v2
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    
    static private let CHANNEL = "com.fazpass.trusted-device"
    
    private let fazpass = Fazpass.shared
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller = window?.rootViewController as! FlutterViewController
        
        let channel = FlutterMethodChannel(name: AppDelegate.CHANNEL, binaryMessenger: controller.binaryMessenger)
        let callHandler = FazpassMethodCallHandler(fazpass: fazpass)
        channel.setMethodCallHandler(callHandler.handle)
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
