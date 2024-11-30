package cat.bcn.commonmodule.flutter.osam_common_module_flutter.crashlytics

import cat.bcn.commonmodule.crashlytics.CrashlyticsWrapper
import io.flutter.plugin.common.EventChannel

class CrashlyticsBridge : EventChannel.StreamHandler, CrashlyticsWrapper {

    private var eventSink: EventChannel.EventSink? = null

    override fun recordException(exception: Exception) {
        eventSink?.success(
            mapOf(
                "className" to exception::class.qualifiedName,
                "stackTrace" to exception.stackTraceToString()
            )
        )
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }
}