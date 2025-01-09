package com.fazpass.devicevalidator

import io.flutter.embedding.android.FlutterFragmentActivity
import com.fazpass.devicevalidator.plugins.fazpass.FazpassPlugin
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterFragmentActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine.plugins.apply {
            add(FazpassPlugin(this@MainActivity))
        }
    }
}
