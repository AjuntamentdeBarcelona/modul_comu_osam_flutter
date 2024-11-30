import Foundation
import OSAMCommon
import UIKit

class PlatformUtilBridge: NSObject, FlutterStreamHandler, PlatformUtil {
    private var eventSink: FlutterEventSink?

    func encodeUrl(url: String) -> String? {
        let urlString: String? = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        return urlString
    }
    
    func openUrl(url: String) -> Bool {
        if let urlObj = URL(string: url) {
            UIApplication.shared.open(urlObj)
            return true
        } else {
            return false
        }
    }
    
    func getDeviceModelIdentifier() -> String {
        var modelName: String {
            var systemInfo = utsname()
            uname(&systemInfo)
            let machineMirror = Mirror(reflecting: systemInfo.machine)
            let identifier = machineMirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8, value != 0 else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }
            
            switch identifier {
            /*case "iPhone11,6": return "iPhone XR"
            case "iPhone11,4", "iPhone11,2": return "iPhone XS Max"
            case "iPhone11,8": return "iPhone XS"
            case "iPhone12,1": return "iPhone 11"
            case "iPhone12,3": return "iPhone 11 Pro"
            case "iPhone12,5": return "iPhone 11 Pro Max"*/
            //Add more cases for other devices as needed
            default: return identifier
            }
        }
        return modelName
    }

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
}
