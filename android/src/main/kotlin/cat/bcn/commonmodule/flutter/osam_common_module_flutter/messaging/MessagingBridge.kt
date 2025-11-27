package cat.bcn.commonmodule.flutter.osam_common_module_flutter.messaging

import cat.bcn.commonmodule.messaging.MessagingWrapper
import io.flutter.plugin.common.EventChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

class MessagingBridge : EventChannel.StreamHandler, MessagingWrapper {

    private var eventSink: EventChannel.EventSink? = null

    override suspend fun subscribeToTopic(topic: String) {
        // We must switch to the Main Thread to communicate with Flutter
        withContext(Dispatchers.Main) {
            eventSink?.success(
                mapOf(
                    "topic" to topic
                )
            )
            Unit
        }
    }

    override suspend fun unsubscribeFromTopic(topic: String) {
        // We must switch to the Main Thread to communicate with Flutter
        withContext(Dispatchers.Main) {
            eventSink?.success(
                mapOf(
                    "topic" to topic
                )
            )
            Unit
        }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }
}