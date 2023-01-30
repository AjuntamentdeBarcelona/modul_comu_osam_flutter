package cat.bcn.commonmodule.flutter.common_module_flutter.performance

import android.content.Context
import cat.bcn.commonmodule.performance.PerformanceMetric
import cat.bcn.commonmodule.performance.PerformanceWrapper
import io.flutter.plugin.common.EventChannel
import android.util.Log

class PerformanceBridge(val context: () -> Context?) : EventChannel.StreamHandler, PerformanceWrapper {

    private var eventSink: EventChannel.EventSink? = null

    override fun createMetric(url: String, httpMethod: String): PerformanceMetric {
        val funName = object {}.javaClass.enclosingMethod?.name
        Log.d("PerformanceMetric", "${funName} url: $url, httpMethod: $httpMethod")
        return PerformanceMetricAndroid(context, url, httpMethod) { eventSink }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }
}