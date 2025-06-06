package com.example.live_activities_example

import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.FlutterEngine

import com.example.live_activities.LiveActivityManagerHolder

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        LiveActivityManagerHolder.instance = CustomLiveActivityManager(this)
    }
}
