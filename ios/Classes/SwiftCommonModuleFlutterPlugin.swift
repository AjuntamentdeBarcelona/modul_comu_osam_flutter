import Flutter
import UIKit
import OSAMCommon

public class SwiftCommonModuleFlutterPlugin: NSObject, FlutterPlugin {

    private var osamCommons: OSAMCommons? = nil
    let analyticsBridge: AnalyticsBridge
    let crashlyticsBridge: CrashlyticsBridge
    let platformUtilBridge: PlatformUtilBridge
    let performanceBridge: PerformanceBridge
    let messagingBridge: MessagingBridge

    init(analyticsStreamHandler: AnalyticsBridge,
         crashlyticsStreamHandler: CrashlyticsBridge,
         platformUtilStreamHandler: PlatformUtilBridge,
         performanceStreamHandler: PerformanceBridge,
         messagingStreamHandler: MessagingBridge) {
        self.analyticsBridge   = analyticsStreamHandler
        self.crashlyticsBridge = crashlyticsStreamHandler
        self.platformUtilBridge = platformUtilStreamHandler
        self.performanceBridge = performanceStreamHandler
        self.messagingBridge = messagingStreamHandler
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(name: "common_module_flutter_method_channel", binaryMessenger: registrar.messenger())
        let instance = SwiftCommonModuleFlutterPlugin(analyticsStreamHandler: AnalyticsBridge(), crashlyticsStreamHandler: CrashlyticsBridge(), platformUtilStreamHandler: PlatformUtilBridge(), performanceStreamHandler: PerformanceBridge(), messagingStreamHandler: MessagingBridge())
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
        let analyticsEventChannel = FlutterEventChannel(name: "common_module_flutter_analytics_event_channel", binaryMessenger: registrar.messenger())
        analyticsEventChannel.setStreamHandler(instance.analyticsBridge)
        let crashlyticsEventChannel = FlutterEventChannel(name: "common_module_flutter_crashlytics_event_channel", binaryMessenger: registrar.messenger())
        crashlyticsEventChannel.setStreamHandler(instance.crashlyticsBridge)
        let performanceEventChannel = FlutterEventChannel(name: "common_module_flutter_performance_event_channel", binaryMessenger: registrar.messenger())
        performanceEventChannel.setStreamHandler(instance.performanceBridge)
        let messagingEventChannel = FlutterEventChannel(name: "common_module_flutter_messaging_event_channel", binaryMessenger: registrar.messenger())
        messagingEventChannel.setStreamHandler(instance.messagingBridge)
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
        } else if call.method == "changeLanguageEvent" {
            if let osamCommons = self.osamCommons {
                let language : String = ((call.arguments as? Dictionary<String, Any>)?["language"] as? String) ?? ""
                osamCommons.changeLanguageEvent(
                    language: getLanguageFromString(langugageCode: language),
                    f: { languageInformationResponse in
                        result(languageInformationResponse.toStringResponse())
                    }
                )
            } else {
                result(FlutterError(code: "NO_VIEW", message: "No ViewController Available", details: nil))
            }
        } else if call.method == "firstTimeOrUpdateAppEvent" {
            if let osamCommons = self.osamCommons {
                let language : String = ((call.arguments as? Dictionary<String, Any>)?["language"] as? String) ?? ""
                osamCommons.firstTimeOrUpdateEvent(
                    language: getLanguageFromString(langugageCode: language),
                    f: { languageInformationResponse in
                        result(languageInformationResponse.toStringResponse())
                    }
                )
            } else {
                result(FlutterError(code: "NO_VIEW", message: "No ViewController Available", details: nil))
            }
        } else if call.method == "subscribeToCustomTopic" {
            if let osamCommons = self.osamCommons {
                let topic: String = ((call.arguments as? Dictionary<String, Any>)?["topic"] as? String) ?? ""
                osamCommons.subscribeToCustomTopic(
                    topic: topic,
                    f: { subscriptionResponse in
                        result(subscriptionResponse.toStringResponse())
                    }
                )
            } else {
                result(FlutterError(code: "NO_VIEW", message: "No ViewController Available", details: nil))
            }
        } else if call.method == "unsubscribeToCustomTopic" {
            if let osamCommons = self.osamCommons {
                let topic: String = ((call.arguments as? Dictionary<String, Any>)?["topic"] as? String) ?? ""
                osamCommons.unsubscribeToCustomTopic(
                    topic: topic,
                    f: { subscriptionResponse in
                        result(subscriptionResponse.toStringResponse())
                    }
                )
            } else {
                result(FlutterError(code: "NO_VIEW", message: "No ViewController Available", details: nil))
            }
        }else if call.method == "getFCMToken" {
            if let osamCommons = self.osamCommons {
                // Call the getFCMToken method which provides the result in a callback.
                osamCommons.getFCMToken { tokenResponse in
                    // Handle the response inside the callback.
                    switch tokenResponse {
                    case let success as TokenResponse.Success:
                        // On success, send the token back to Flutter.
                        result(success.token)
                    case let error as TokenResponse.Error:
                        // On error, send an error code and the message from the response.
                        let errorMessage = error.error.message ?? "Failed to retrieve FCM token."
                        result(FlutterError(code: "GET_TOKEN_ERROR", message: errorMessage, details: nil))
                    default:
                        // Handle any other unexpected response types.
                        result(FlutterError(code: "UNKNOWN_ERROR", message: "An unknown error occurred.", details: nil))
                    }
                }
            }
        }
        else {
           result(FlutterMethodNotImplemented)
        }
    }

    private func createOSAMCommons(backendEndpoint: String) {
        if let viewController = UIApplication.shared.delegate?.window??.rootViewController {
            osamCommons = OSAMCommons(vc: viewController,
                                      backendEndpoint: backendEndpoint,
                                      crashlyticsWrapper: crashlyticsBridge,
                                      performanceWrapper: performanceBridge,
                                      analyticsWrapper: analyticsBridge,
                                      platformUtil: platformUtilBridge,
                                      messagingWrapper: messagingBridge);
        }
    }
}
