package com.example.live_activities

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch

class LiveActivitiesPlugin : FlutterPlugin, MethodCallHandler {

    private lateinit var channel: MethodChannel

    private val pluginScope = CoroutineScope(SupervisorJob() + Dispatchers.Main)

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(
            flutterPluginBinding.binaryMessenger, "live_activities"
        )
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        try {
            val args = call.arguments as? Map<String, Any> ?: emptyMap()
            val data = args["data"] as? Map<String, Any> ?: emptyMap()
            val liveActivityManager = LiveActivityManagerHolder.instance!!

            when (call.method) {
                "init" -> {
                    liveActivityManager.initialize(data)
                    result.success("initialized")
                }

                "createActivity" -> {
                    val timestamp = System.currentTimeMillis()
                    val id = args["activityId"] as String

                    pluginScope.launch {
                        val notificationId = liveActivityManager.createActivity(
                            id,
                            timestamp,
                            data
                        )
                        result.success(notificationId)
                    }
                }

                "updateActivity" -> {
                    val timestamp = System.currentTimeMillis()
                    val id = args["activityId"] as String

                    pluginScope.launch {
                        liveActivityManager.updateActivity(id, timestamp, data)
                        result.success("activity/updated")
                    }
                }

                "endActivity" -> {
                    val id = args["activityId"] as String

                    liveActivityManager.endActivity(id, data)
                    result.success("activity/ended")
                }

                "endAllActivities" -> {
                    liveActivityManager.endAllActivities(data)
                    result.success("activities/ended")
                }

                "getAllActivitiesIds" -> {
                    val ids = liveActivityManager.getAllActivitiesIds(data)
                    result.success(ids)
                }

                "areActivitiesSupported" -> {
                    val supported = liveActivityManager.areActivitiesSupported(data)
                    result.success(supported)
                }

                "areActivitiesEnabled" -> {
                    val enabled = liveActivityManager.areActivitiesEnabled(data)
                    result.success(enabled)
                }

                else -> {
                    result.notImplemented()
                }
            }
        } catch (e: Exception) {
            result.error("ERROR", e.message ?: "Unknown error", null)
        }
    }


    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
