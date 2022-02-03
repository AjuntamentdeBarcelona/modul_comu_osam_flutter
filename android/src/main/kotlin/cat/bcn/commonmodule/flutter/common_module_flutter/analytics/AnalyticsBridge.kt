package cat.bcn.commonmodule.flutter.common_module_flutter.analytics

import cat.bcn.commonmodule.analytics.AnalyticsWrapper
import io.flutter.plugin.common.EventChannel

class AnalyticsBridge : EventChannel.StreamHandler, AnalyticsWrapper {

    private var eventSink: EventChannel.EventSink? = null

    override fun logEvent(name: String, parameters: Map<String, String>) {
        eventSink?.success(mapOf("name" to name, "parameters" to parameters))
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }
}