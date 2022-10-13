import OSAMCommon

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
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
}
