import Flutter
import UIKit
import OSAMCommon

public class SwiftCommonModuleFlutterPlugin: NSObject, FlutterPlugin {

    private var osamCommons: OSAMCommons? = nil
    let analyticsBridge: AnalyticsBridge
    let crashlyticsBridge: CrashlyticsBridge
    let platformUtilBridge: PlatformUtilBridge

    init(analyticsStreamHandler: AnalyticsBridge, crashlyticsStreamHandler: CrashlyticsBridge, platformUtilStreamHandler: PlatformUtilBridge) {
        self.analyticsBridge   = analyticsStreamHandler
        self.crashlyticsBridge = crashlyticsStreamHandler
        self.platformUtilBridge = platformUtilStreamHandler
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(name: "common_module_flutter_method_channel", binaryMessenger: registrar.messenger())
        let instance = SwiftCommonModuleFlutterPlugin(analyticsStreamHandler: AnalyticsBridge(), crashlyticsStreamHandler: CrashlyticsBridge(), platformUtilStreamHandler: PlatformUtilBridge())
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
        let analyticsEventChannel = FlutterEventChannel(name: "common_module_flutter_analytics_event_channel", binaryMessenger: registrar.messenger())
        analyticsEventChannel.setStreamHandler(instance.analyticsBridge)
        let crashlyticsEventChannel = FlutterEventChannel(name: "common_module_flutter_crashlytics_event_channel", binaryMessenger: registrar.messenger())
        crashlyticsEventChannel.setStreamHandler(instance.crashlyticsBridge)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "init" {
            let backendEndpoint = ((call.arguments as? Dictionary<String, Any>)?["backendEndpoint"] as? String) ?? ""
            createOSAMCommons(backendEndpoint: backendEndpoint)
            result(nil)
        }
        if call.method == "versionControl" {
            if let osamCommons = self.osamCommons {
                let language : String = ((call.arguments as? Dictionary<String, Any>)?["language"] as? String) ?? ""
                osamCommons.versionControl(
                    language: getLanguageFromString(langugageCode: language),
                    f: { versionControlResponse in
                        result(versionControlResponse.toStringResponse())
                    }
                )
            } else {
                result(FlutterError(code: "NO_VIEW", message: "No ViewController Available", details: nil))
            }
        } else if call.method == "rating" {
            if let osamCommons = self.osamCommons {
                let language : String = ((call.arguments as? Dictionary<String, Any>)?["language"] as? String) ?? ""
                osamCommons.rating(
                    language: getLanguageFromString(langugageCode: language),
                    f: { versionControlResponse in
                        result(versionControlResponse.toStringResponse())
                    }
                )
            } else {
                result(FlutterError(code: "NO_VIEW", message: "No ViewController Available", details: nil))
            }
        } else if call.method == "deviceInformation" {
           if let osamCommons = self.osamCommons {
               osamCommons.deviceInformation(
                   f: { deviceInformationResponse, deviceInformation in
                       if let model = deviceInformation {
                           let json = "{\"platformName\":\"\(model.platformName)\",\"platformVersion\":\"\(model.platformVersion)\",\"platformModel\":\"\(model.platformModel)\"}"
                           result(json)
                       } else {
                           let json = "{\"platformName\":\"\",\"platformVersion\":\"\",\"platformModel\":\"\"}"
                           result(json)
                       }
                   }
               )
           } else {
               result(FlutterError(code: "NO_VIEW", message: "No ViewController Available", details: nil))
           }
        } else if call.method == "appInformation" {
           if let osamCommons = self.osamCommons {
               osamCommons.appInformation(
                   f: { appInformationResponse, appInformation in
                       if let model = appInformation {
                           let json = "{\"appName\":\"\(model.appName)\",\"appVersionName\":\"\(model.appVersionName)\",\"appVersionCode\":\"\(model.appVersionCode)\"}"
                           result(json)
                       } else {
                           let json = "{\"appName\":\"\",\"appVersionName\":\"\",\"appVersionCode\":\"\"}"
                           result(json)
                       }
                   }
               )
           } else {
               result(FlutterError(code: "NO_VIEW", message: "No ViewController Available", details: nil))
           }
        } else {
           result(FlutterMethodNotImplemented)
        }
    }

    private func createOSAMCommons(backendEndpoint: String) {
        if let viewController = UIApplication.shared.delegate?.window??.rootViewController {
            osamCommons = OSAMCommons(vc: viewController, backendEndpoint: backendEndpoint,
            crashlyticsWrapper: crashlyticsBridge, analyticsWrapper: analyticsBridge, platformUtil: platformUtilBridge);
        }
    }
}
