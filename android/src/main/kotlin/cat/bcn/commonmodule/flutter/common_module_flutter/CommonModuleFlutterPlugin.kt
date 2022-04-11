package cat.bcn.commonmodule.flutter.common_module_flutter

import android.app.Activity
import androidx.annotation.NonNull
import cat.bcn.commonmodule.flutter.common_module_flutter.analytics.AnalyticsBridge
import cat.bcn.commonmodule.flutter.common_module_flutter.crashlytics.CrashlyticsBridge
import cat.bcn.commonmodule.flutter.common_module_flutter.extension.getLanguageFromString
import cat.bcn.commonmodule.flutter.common_module_flutter.extension.toStringResponse
import cat.bcn.commonmodule.ui.versioncontrol.OSAMCommons
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** CommonModuleFlutterPlugin */
class CommonModuleFlutterPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var methodChannel: MethodChannel

    private var activity: Activity? = null
    private var osamCommons: OSAMCommons? = null
    private val analyticsBridge = AnalyticsBridge()
    private val crashlyticsBridge = CrashlyticsBridge()

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel = MethodChannel(
            flutterPluginBinding.binaryMessenger,
            "common_module_flutter_method_channel"
        )
        methodChannel.setMethodCallHandler(this)
        val analyticsEventChannel = EventChannel(
            flutterPluginBinding.binaryMessenger,
            "common_module_flutter_analytics_event_channel"
        )
        analyticsEventChannel.setStreamHandler(analyticsBridge)
        val crashlyticsEventChannel = EventChannel(
            flutterPluginBinding.binaryMessenger,
            "common_module_flutter_crashlytics_event_channel"
        )
        crashlyticsEventChannel.setStreamHandler(crashlyticsBridge)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "init" -> {
                createOSAMCommons(call.argument("backendEndpoint") ?: "")
                result.success(null)
            }
            "versionControl" -> {
                val osamCommons = this.osamCommons
                if (osamCommons != null) {
                    val language = getLanguageFromString(call.argument("language") ?: "")
                    osamCommons.versionControl(language) {
                        result.success(it.toStringResponse())
                    }
                } else {
                    result.error("NO_VIEW", "No Activity Available", null)
                }
            }
            "rating" -> {
                val osamCommons = this.osamCommons
                if (osamCommons != null) {
                    val language = getLanguageFromString(call.argument("language") ?: "")
                    osamCommons.rating(language) {
                        result.success(it.toStringResponse())
                    }
                } else {
                    result.error("NO_VIEW", "No Activity Available", null)
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        clearReferences()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        clearReferences()
    }

    private fun createOSAMCommons(backendEndpoint: String) {
        activity?.let {
            osamCommons = OSAMCommons(
                activity = it,
                context = it,
                backendEndpoint,
                crashlyticsBridge,
                analyticsBridge
            )
        }
    }

    private fun clearReferences() {
        activity = null
        osamCommons = null
    }
}
