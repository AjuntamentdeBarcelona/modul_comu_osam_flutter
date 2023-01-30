package cat.bcn.commonmodule.flutter.common_module_flutter.performance

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import cat.bcn.commonmodule.performance.PerformanceMetric
import io.flutter.plugin.common.EventChannel

class PerformanceMetricAndroid(val context: () -> Context?, val url: String, val httpMethod: String, var getEventSink: () -> EventChannel.EventSink?) :
    PerformanceMetric {

    val uniqueId = "${System.currentTimeMillis()}${System.nanoTime()}"
    private val uiThreadHandler: Handler = Handler(Looper.getMainLooper());

    override fun start() {
        val funName = object {}.javaClass.enclosingMethod?.name
        uiThreadHandler.post {
            Log.d("PerformanceMetric", "${funName} url: $url, httpMethod: $httpMethod")
            getEventSink()?.success(mapOf("uniqueId" to uniqueId, "event" to "start", "url" to url, "httpMethod" to httpMethod))
        }
    }

    override fun setRequestPayloadSize(bytes: Long) {
        val funName = object {}.javaClass.enclosingMethod?.name
        uiThreadHandler.post {
            Log.d("PerformanceMetric", "${funName} bytes: $bytes")
            getEventSink()?.success(mapOf("uniqueId" to uniqueId, "event" to "setRequestPayloadSize", "bytes" to "$bytes"))
        }
    }

    override fun markRequestComplete() {
        val funName = object {}.javaClass.enclosingMethod?.name
        uiThreadHandler.post {
            Log.d("PerformanceMetric", "${funName}")
            getEventSink()?.success(mapOf("uniqueId" to uniqueId, "event" to "markRequestComplete"))
        }
    }

    override fun markResponseStart() {
        val funName = object {}.javaClass.enclosingMethod?.name
        uiThreadHandler.post {
            Log.d("PerformanceMetric", "${funName}")
            getEventSink()?.success(mapOf("uniqueId" to uniqueId, "event" to "markResponseStart"))
        }
    }

    override fun setResponseContentType(contentType: String) {
        val funName = object {}.javaClass.enclosingMethod?.name
        uiThreadHandler.post {
            Log.d("PerformanceMetric", "${funName} contentType: $contentType")
            getEventSink()?.success(mapOf("uniqueId" to uniqueId, "event" to "setResponseContentType", "contentType" to contentType))
        }
    }

    override fun setHttpResponseCode(responseCode: Int) {
        val funName = object {}.javaClass.enclosingMethod?.name
        uiThreadHandler.post {
            Log.d("PerformanceMetric", "${funName} responseCode: $responseCode")
            getEventSink()?.success(mapOf("uniqueId" to uniqueId, "event" to "setHttpResponseCode", "responseCode" to "$responseCode"))
        }
    }

    override fun setResponsePayloadSize(bytes: Long) {
        val funName = object {}.javaClass.enclosingMethod?.name
        uiThreadHandler.post {
            Log.d("PerformanceMetric", "${funName} bytes: $bytes")
            getEventSink()?.success(mapOf("uniqueId" to uniqueId, "event" to "setResponsePayloadSize", "bytes" to "$bytes"))
        }
    }

    override fun putAttribute(attribute: String, value: String) {
        val funName = object {}.javaClass.enclosingMethod?.name
        uiThreadHandler.post {
            Log.d("PerformanceMetric", "${funName} attribute: $attribute, value: $value")
            getEventSink()?.success(mapOf("uniqueId" to uniqueId, "event" to "putAttribute", "attribute" to attribute, "value" to value))
        }
    }

    override fun stop() {
        val funName = object {}.javaClass.enclosingMethod?.name
        uiThreadHandler.post {
            Log.d("PerformanceMetric", "${funName}")
            getEventSink()?.success(mapOf("uniqueId" to uniqueId, "event" to "stop"))
        }
    }
}