package com.fazpass.devicevalidator.plugins.fazpass

import androidx.fragment.app.FragmentActivity
import com.keypaz.android_trusted_device_v2.FazpassFactory
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class FazpassPlugin(
    activity: FragmentActivity
): FlutterPlugin {

    private val fazpass = FazpassFactory.getInstance()
    private val callHandler = FazpassMethodCallHandler(activity, fazpass)
    private val cdStreamHandler = FazpassCDStreamHandler(activity, fazpass)
    private lateinit var channel: MethodChannel
    private lateinit var cdChannel: EventChannel

    companion object {
        private const val CHANNEL = "com.fazpass.trusted-device"
        private const val CD_CHANNEL = "com.fazpass.trusted-device-cd"
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler(callHandler)
        cdChannel = EventChannel(binding.binaryMessenger, CD_CHANNEL)
        cdChannel.setStreamHandler(cdStreamHandler)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        cdStreamHandler.onCancel(null)
        cdChannel.setStreamHandler(null)
    }
}