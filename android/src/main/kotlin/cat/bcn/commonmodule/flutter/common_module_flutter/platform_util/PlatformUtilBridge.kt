package cat.bcn.commonmodule.flutter.common_module_flutter.platform_util

import cat.bcn.commonmodule.platform.PlatformUtil
import io.flutter.plugin.common.EventChannel
import android.content.Context
import android.content.Intent
import android.net.Uri
import androidx.core.content.ContextCompat

class PlatformUtilBridge(val context: () -> Context?) : EventChannel.StreamHandler, PlatformUtil {

    private var eventSink: EventChannel.EventSink? = null

    override fun encodeUrl(url: String): String? {
        return url
    }

    override fun openUrl(url: String): Boolean {
        val ctx = context()
        if (ctx != null) {
            val intent = Intent(Intent.ACTION_VIEW)
            intent.data = Uri.parse(url)
            ContextCompat.startActivity(ctx, intent, null)
            return true
        }
        return false
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }
}