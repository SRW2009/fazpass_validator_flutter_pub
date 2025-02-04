package com.fazpass.devicevalidator.plugins.fazpass

import androidx.fragment.app.FragmentActivity
import com.keypaz.android_trusted_device_v2.Fazpass
import io.flutter.plugin.common.EventChannel

class FazpassCDStreamHandler(
    activity: FragmentActivity,
    fazpass: Fazpass
): EventChannel.StreamHandler {

    private val stream = fazpass.getCrossDeviceDataStreamInstance(activity)

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        stream.listen {
            events?.success(it.toMap())
        }
    }

    override fun onCancel(arguments: Any?) {
        stream.close()
    }
}