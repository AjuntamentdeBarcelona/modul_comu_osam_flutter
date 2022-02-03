import OSAMCommon

class AnalyticsBridge: NSObject, FlutterStreamHandler, AnalyticsWrapper {
    private var eventSink: FlutterEventSink?
    
    func logEvent(name: String, parameters: [String : String]) {
        eventSink?(["name": name, "parameters": parameters])
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
