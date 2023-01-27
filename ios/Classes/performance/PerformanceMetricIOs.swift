import Foundation
import OSAMCommon

class PerformanceMetricIOs: PerformanceMetric {

    let url: String
    let httpMethod: String
    let getEventSink: () -> FlutterEventSink?
    var uniqueId: String = ""

    init(url: String, httpMethod: String, getEventSink: @escaping () -> FlutterEventSink?) {
        self.url = url
        self.httpMethod = httpMethod
        self.getEventSink = getEventSink
        self.uniqueId = String(currentTimeInMilliSeconds())
    }

    func start() {
        print("PerformanceMetricIOS start")
        getEventSink()?(["uniqueId": uniqueId, "event": "start", "url": url, "httpMethod": httpMethod])
    }
    func setRequestPayloadSize(bytes: Int64) {
        print("PerformanceMetricIOS setRequestPayloadSize")
        getEventSink()?(["uniqueId": uniqueId, "event": "setRequestPayloadSize", "bytes": String(bytes)])
    }
    func markRequestComplete() {
        print("PerformanceMetricIOS markRequestComplete")
        getEventSink()?(["uniqueId": uniqueId, "event": "markRequestComplete"])
    }
    func markResponseStart() {
        print("PerformanceMetricIOS markResponseStart")
        getEventSink()?(["uniqueId": uniqueId, "event": "markResponseStart"])
    }
    func setResponseContentType(contentType: String) {
        print("PerformanceMetricIOS setResponseContentType")
        getEventSink()?(["uniqueId": uniqueId, "event": "setResponseContentType", "contentType": contentType])
    }
    func setHttpResponseCode(responseCode: Int32) {
        print("PerformanceMetricIOS setHttpResponseCode")
        getEventSink()?(["uniqueId": uniqueId, "event": "setHttpResponseCode", "responseCode": String(responseCode)])
    }
    func setResponsePayloadSize(bytes: Int64) {
        print("PerformanceMetricIOS setResponsePayloadSize")
        getEventSink()?(["uniqueId": uniqueId, "event": "setResponsePayloadSize", "bytes": String(bytes)])
    }
    func putAttribute(attribute: String, value: String) {
        print("PerformanceMetricIOS putAttribute")
        getEventSink()?(["uniqueId": uniqueId, "event": "putAttribute", "attribute": attribute, "value": value])
    }
    func stop() {
        print("PerformanceMetricIOS stop")
        getEventSink()?(["uniqueId": uniqueId, "event": "stop"])
    }

    private func currentTimeInMilliSeconds() -> Int {
        let currentDate = Date()
        let since1970 = currentDate.timeIntervalSince1970
        return Int(since1970 * 1000)
    }
}