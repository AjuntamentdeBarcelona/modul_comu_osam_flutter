import OSAMCommon

class CrashlyticsBridge: NSObject, FlutterStreamHandler, CrashlyticsWrapper {
    private var eventSink: FlutterEventSink?
    
    func recordException(className: String, stackTrace: String) {
        eventSink?(["className": className, "stackTrace": stackTrace])
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
