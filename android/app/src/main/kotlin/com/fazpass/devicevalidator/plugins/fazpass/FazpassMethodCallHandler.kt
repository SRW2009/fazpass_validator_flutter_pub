package com.fazpass.devicevalidator.plugins.fazpass

import androidx.fragment.app.FragmentActivity
import com.keypaz.android_trusted_device_v2.Fazpass
import com.keypaz.android_trusted_device_v2.FazpassSettings
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class FazpassMethodCallHandler(
    private val activity: FragmentActivity,
    private val fazpass: Fazpass
): MethodChannel.MethodCallHandler {

    init {
        fazpass.init(activity, "device-validator-key.pub")
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "generateMeta" -> {
                val accountIndex = call.arguments as Int
                fazpass.generateMeta(activity, accountIndex, false) { meta, error ->
                    if (error == null) {
                        result.success(meta)
                        return@generateMeta
                    }
                    result.error(
                        "fazpass-${error.name}",
                        "error.exception.message",
                        null
                    )
                }
            }
            "generateNewSecretKey" -> {
                try {
                    fazpass.generateNewSecretKey(activity)
                    result.success(null)
                } catch (e: Exception) {
                    result.error("fazpass-Error", e.message, null)
                }
            }
            "getSettings" -> {
                val accountIndex = call.arguments as Int
                val settings = fazpass.getSettings(accountIndex)
                result.success(settings?.toString())
            }
            "setSettings" -> {
                val args = call.arguments as Map<*, *>
                val accountIndex = args["accountIndex"] as Int
                val settingsString = args["settings"] as String?
                val settings = if (settingsString != null) FazpassSettings.fromString(settingsString) else null
                fazpass.setSettings(activity, accountIndex, settings)
                result.success(null)
            }
            "getCrossDeviceDataFromNotification" -> {
                val request = fazpass.getCrossDeviceDataFromNotification(activity.intent)
                result.success(request?.toMap())
            }
            "getAppSignatures" -> {
                val appSignatures = fazpass.getAppSignatures(activity)
                result.success(appSignatures)
            }
            else -> result.notImplemented()
        }
    }
}