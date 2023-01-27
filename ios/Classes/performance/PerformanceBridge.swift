import OSAMCommon

class PerformanceBridge: NSObject, FlutterStreamHandler, PerformanceWrapper {
    private var eventSink: FlutterEventSink?
    
    func createMetric(url: String, httpMethod: String) -> PerformanceMetric {
        return PerformanceMetricIOs(url: url, httpMethod: httpMethod, getEventSink: { self.eventSink })
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
