import Flutter
import UIKit
import OSAMCommon

public class SwiftCommonModuleFlutterPlugin: NSObject, FlutterPlugin {

    private var osamCommons: OSAMCommons? = nil
    private var backendEndpoint: String? = nil
    private var lastViewController: UIViewController? = nil
    
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
        let instance = SwiftCommonModuleFlutterPlugin(
            analyticsStreamHandler: AnalyticsBridge(),
            crashlyticsStreamHandler: CrashlyticsBridge(),
            platformUtilStreamHandler: PlatformUtilBridge(),
            performanceStreamHandler: PerformanceBridge(),
            messagingStreamHandler: MessagingBridge()
        )
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
        DispatchQueue.main.async {
            self.handleOnMainThread(call, result: result)
        }
    }

    private func handleOnMainThread(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? [String: Any]
        
        if call.method == "init" {
            if let endpoint = args?["backendEndpoint"] as? String {
                self.backendEndpoint = endpoint
                createOSAMCommons(backendEndpoint: endpoint)
            }
            result(nil)
            return
        }
        
        if let endpoint = self.backendEndpoint, osamCommons == nil {
            createOSAMCommons(backendEndpoint: endpoint)
        }
        
        if call.method == "versionControl" {
            if let osamCommons = self.osamCommons {
                let language : String = (args?["language"] as? String) ?? ""
                let isDarkMode : Bool = (args?["isDarkMode"] as? Bool) ?? false
                let applyComModStyles : Bool = (args?["applyComModStyles"] as? Bool) ?? false
                
                self.lockBackgroundUI(true)
                
                osamCommons.versionControl(
                    language: getLanguageFromString(langugageCode: language),
                    isDarkMode: isDarkMode,
                    applyComModStyles: applyComModStyles,
                    f: { versionControlResponse in
                        self.lockBackgroundUI(false)
                        result(versionControlResponse.toStringResponse())
                    }
                )
            } else {
                result(FlutterError(code: "NO_VIEW", message: "OSAMCommons not initialized", details: nil))
            }
        } else if call.method == "rating" {
            if let osamCommons = self.osamCommons {
                let language : String = (args?["language"] as? String) ?? ""
                let isDarkMode : Bool = (args?["isDarkMode"] as? Bool) ?? false
                
                self.lockBackgroundUI(true)
                
                osamCommons.rating(
                    language: getLanguageFromString(langugageCode: language),
                    isDarkMode: isDarkMode,
                    f: { versionControlResponse in
                        self.lockBackgroundUI(false)
                        result(versionControlResponse.toStringResponse())
                    }
                )
            } else {
                result(FlutterError(code: "NO_VIEW", message: "OSAMCommons not initialized", details: nil))
            }
        } else {
           self.handleOtherMethods(call, args: args, result: result)
        }
    }
    
    private func handleOtherMethods(_ call: FlutterMethodCall, args: [String: Any]?, result: @escaping FlutterResult) {
        if call.method == "deviceInformation" {
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
               result(FlutterError(code: "NO_VIEW", message: "OSAMCommons not initialized", details: nil))
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
               result(FlutterError(code: "NO_VIEW", message: "OSAMCommons not initialized", details: nil))
           }
        } else if call.method == "changeLanguageEvent" {
            if let osamCommons = self.osamCommons {
                let language : String = (args?["language"] as? String) ?? ""
                osamCommons.changeLanguageEvent(
                    language: getLanguageFromString(langugageCode: language),
                    f: { languageInformationResponse in
                        result(languageInformationResponse.toStringResponse())
                    }
                )
            } else {
                result(FlutterError(code: "NO_VIEW", message: "OSAMCommons not initialized", details: nil))
            }
        } else if call.method == "firstTimeOrUpdateAppEvent" {
            if let osamCommons = self.osamCommons {
                let language : String = (args?["language"] as? String) ?? ""
                osamCommons.firstTimeOrUpdateEvent(
                    language: getLanguageFromString(langugageCode: language),
                    f: { languageInformationResponse in
                        result(languageInformationResponse.toStringResponse())
                    }
                )
            } else {
                result(FlutterError(code: "NO_VIEW", message: "OSAMCommons not initialized", details: nil))
            }
        } else if call.method == "subscribeToCustomTopic" {
            if let osamCommons = self.osamCommons {
                let topic: String = (args?["topic"] as? String) ?? ""
                osamCommons.subscribeToCustomTopic(
                    topic: topic,
                    f: { subscriptionResponse in
                        result(subscriptionResponse.toStringResponse())
                    }
                )
            } else {
                result(FlutterError(code: "NO_VIEW", message: "OSAMCommons not initialized", details: nil))
            }
        } else if call.method == "unsubscribeToCustomTopic" {
            if let osamCommons = self.osamCommons {
                let topic: String = (args?["topic"] as? String) ?? ""
                osamCommons.unsubscribeToCustomTopic(
                    topic: topic,
                    f: { subscriptionResponse in
                        result(subscriptionResponse.toStringResponse())
                    }
                )
            } else {
                result(FlutterError(code: "NO_VIEW", message: "OSAMCommons not initialized", details: nil))
            }
        } else if call.method == "getFCMToken" {
            if let osamCommons = self.osamCommons {
                osamCommons.getFCMToken { tokenResponse in
                    switch tokenResponse {
                    case let success as TokenResponse.Success:
                        result(success.token)
                    case let error as TokenResponse.Error:
                        let errorMessage = error.error.message ?? "Failed to retrieve FCM token."
                        result(FlutterError(code: "GET_TOKEN_ERROR", message: errorMessage, details: nil))
                    default:
                        result(FlutterError(code: "UNKNOWN_ERROR", message: "An unknown error occurred.", details: nil))
                    }
                }
            } else {
                result(FlutterError(code: "NO_VIEW", message: "OSAMCommons not initialized", details: nil))
            }
        } else {
           result(FlutterMethodNotImplemented)
        }
    }

    private var lockViewController: UIViewController? = nil

    private func lockBackgroundUI(_ lock: Bool) {
        DispatchQueue.main.async {
            let window: UIWindow?
            if #available(iOS 13.0, *) {
                window = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }
            } else {
                window = UIApplication.shared.keyWindow
            }

            guard let activeWindow = window,
                  let rootVC = activeWindow.rootViewController else { return }

            if lock {
                guard self.lockViewController == nil else { return }
                
                activeWindow.endEditing(true)
                
                let lockVC = UIViewController()
                lockVC.view.backgroundColor = .clear
                lockVC.view.isUserInteractionEnabled = true
                lockVC.modalPresentationStyle = .overFullScreen
                
                rootVC.present(lockVC, animated: false, completion: nil)
                self.lockViewController = lockVC
            } else {
                self.lockViewController?.dismiss(animated: false, completion: nil)
                self.lockViewController = nil
            }

            UIAccessibility.post(notification: lock ? .screenChanged : .layoutChanged, argument: nil)
        }
    }

    private func createOSAMCommons(backendEndpoint: String) {
        guard !backendEndpoint.isEmpty else { return }
        
        var viewController: UIViewController? = nil
        if #available(iOS 13.0, *) {
            viewController = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }?.rootViewController
        }
        
        if viewController == nil {
            viewController = UIApplication.shared.keyWindow?.rootViewController
        }
        
        guard let vc = viewController else { return }
        
        if osamCommons == nil || backendEndpoint != self.backendEndpoint {
            self.backendEndpoint = backendEndpoint
            self.lastViewController = vc
            osamCommons = OSAMCommons(vc: vc,
                                      backendEndpoint: backendEndpoint,
                                      crashlyticsWrapper: crashlyticsBridge,
                                      performanceWrapper: performanceBridge,
                                      analyticsWrapper: analyticsBridge,
                                      platformUtil: platformUtilBridge,
                                      messagingWrapper: messagingBridge);
        }
    }
}
