//
//  FazpassMethodCallHandler.swift
//  Runner
//
//  Created by Andri nova riswanto on 09/10/24.
//

import Foundation
import ios_trusted_device_v2

@objc class FazpassMethodCallHandler: NSObject {
    
    let fazpass: Fazpass
    
    init(fazpass: Fazpass) {
        self.fazpass = fazpass
        fazpass.`init`(publicAssetName: "PubKey", application: UIApplication.shared, fcmAppId: "1:762638394860:ios:d7c38a63b5d43616c90cc9")
        let settings = FazpassSettings.Builder()
            .enableSelectedSensitiveData(sensitiveData: SensitiveData.location, SensitiveData.vpn)
            .build()
        fazpass.setSettings(accountIndex: -1, settings: settings)
    }
    
    func handle(call: FlutterMethodCall, result: @escaping FlutterResult) -> Void {
        switch call.method {
        case "generateMeta":
            let accountIndex = call.arguments as! Int
            fazpass.generateMeta(accountIndex: accountIndex) { meta, fazpassError in
                guard fazpassError != nil else {
                    result(meta)
                    return
                }
                result(
                    FlutterError(
                        code: "fazpass-\(String(describing: fazpassError))",
                        message: fazpassError?.localizedDescription,
                        details: nil
                    )
                )
            }
        case "generateNewSecretKey":
            do {
                try fazpass.generateNewSecretKey()
                result(nil)
            } catch {
                result(FlutterError(code: "fazpass-Error", message: error.localizedDescription, details: nil))
            }
        case "getSettings":
            let accountIndex = call.arguments as! Int
            let settings = fazpass.getSettings(accountIndex: accountIndex)
            result(settings?.toString())
        case "setSettings":
            let args = call.arguments as! Dictionary<String, Any>
            var settings: FazpassSettings?
            if (args["settings"] is String) {
                settings = FazpassSettings.fromString(args["settings"] as! String)
            }
            fazpass.setSettings(accountIndex: args["accountIndex"] as! Int, settings: settings)
            result(nil)
        case "getCrossDeviceDataFromNotification":
            let request = fazpass.getCrossDeviceDataFromNotification(userInfo: nil)
            result(request?.toDict())
        default:
          result(FlutterMethodNotImplemented)
        }
    }
}
