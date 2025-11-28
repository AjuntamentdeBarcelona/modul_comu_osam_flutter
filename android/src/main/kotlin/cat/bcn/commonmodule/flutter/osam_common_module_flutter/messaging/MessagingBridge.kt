package cat.bcn.commonmodule.flutter.osam_common_module_flutter.messaging

import android.content.Context
import cat.bcn.commonmodule.messaging.MessagingWrapper
import io.flutter.plugin.common.EventChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

class MessagingBridge(val context: () -> Context?) : EventChannel.StreamHandler, MessagingWrapper {

    companion object {
        private const val TOPIC = "topic"
        private const val ACTION = "action"
        private const val SUBSCRIBE = "subscribe"
        private const val UNSUBSCRIBE = "unsubscribe"
        private const val GET_TOKEN = "getToken"
    }

    private var eventSink: EventChannel.EventSink? = null

    override suspend fun subscribeToTopic(topic: String) {
        // We must switch to the Main Thread to communicate with Flutter
        withContext(Dispatchers.Main) {
            eventSink?.success(
                mapOf(
                    TOPIC to topic,
                    ACTION to SUBSCRIBE
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
                    TOPIC to topic,
                    ACTION to UNSUBSCRIBE
                )
            )
            Unit
        }
    }

    override suspend fun getToken(): String {
        val prefs = context()?.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        withContext(Dispatchers.Main) {
            eventSink?.success(
                mapOf(
                    TOPIC to "",
                    ACTION to GET_TOKEN
                )
            )
            Unit
        }
        return prefs?.getString("flutter.fcm_token", "") ?: ""
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }
}