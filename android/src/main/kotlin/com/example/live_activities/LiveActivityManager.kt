package com.example.live_activities

import android.util.Log
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import androidx.core.app.NotificationManagerCompat
import java.math.BigInteger
import java.security.MessageDigest

open class LiveActivityManager(private val context: Context) {
    private val liveActivitiesMap = mutableMapOf<Int, Long>()
    private lateinit var channelName: String

    open suspend fun buildNotification(
        notification: Notification.Builder,
        event: String,
        data: Map<String, Any>
    ): Notification {
        throw NotImplementedError("You must implement buildNotification in your subclass")
    }

    private fun createNotificationChannel(
        channelName: String,
        channelDescription: String,
        channelImportance: Int = NotificationManager.IMPORTANCE_LOW,
    ) {
        this.channelName = channelName
        val existingChannel =
            (context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager).getNotificationChannel(
                channelName
            )
        if (existingChannel == null) {
            val channel = NotificationChannel(
                channelName, channelDescription, channelImportance
            ).apply {
                setSound(null, null)
                enableVibration(false)
                setShowBadge(false)
                lockscreenVisibility = Notification.VISIBILITY_PUBLIC
            }

            val notificationManager =
                context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

    // Converts a string to an int to use it as notification ID
    private fun getNotificationIdFromString(input: String): Int {
        val digest =
            MessageDigest.getInstance("SHA-256").digest(input.toByteArray())
        return BigInteger(digest).abs().toInt()  // Get positive Int
    }

    fun initialize(data: Map<String, Any>) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return

        val liveActivityChannelName =
            data["liveActivityChannelName"] as? String ?: "Live Activities"
        val liveActivityChannelDescription =
            data["liveActivityChannelDescription"] as? String
                ?: "Live Activities Notifications"


        createNotificationChannel(
            liveActivityChannelName, liveActivityChannelDescription
        )
    }

    suspend fun createActivity(
        id: String,
        timestamp: Long, data: Map<String, Any>
    ): String? {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return null;

        val activityId = getNotificationIdFromString(id)

        val notificationManager =
            context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        val areNotificationsEnabled =
            NotificationManagerCompat.from(context).areNotificationsEnabled()

        if (areNotificationsEnabled) {
            notificationManager.notify(
                activityId, buildNotification(
                    Notification.Builder(context, channelName),
                    "create",
                    data,
                )
            )
        } else {
            Log.w(
                "LiveActivityManager",
                "Notification permission denied. Unable to show notification."
            )
            return null
        }

        liveActivitiesMap[activityId] = timestamp
        return id
    }

    suspend fun updateActivity(
        id: String,
        timestamp: Long,
        data: Map<String, Any>
    ) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return

        val activityId = getNotificationIdFromString(id)

        if (liveActivitiesMap.containsKey(activityId) && liveActivitiesMap[activityId] ?: 0L >= timestamp) {
            Log.w(
                "LiveActivityManager",
                "Attempted to update activity with ID $id but the timestamp is not newer than the existing one."
            )
            return
        }

        val notificationManager =
            context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        val areNotificationsEnabled =
            NotificationManagerCompat.from(context).areNotificationsEnabled()

        if (areNotificationsEnabled) {
            notificationManager.notify(
                activityId, buildNotification(
                    Notification.Builder(context, channelName),
                    "update",
                    data
                )
            )
        } else {
            Log.w(
                "LiveActivityManager",
                "Notification permission denied. Unable to show notification."
            )
            return
        }

        liveActivitiesMap[activityId] = timestamp
    }

    fun endActivity(
        id: String,
        data: Map<String, Any>
    ) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return

        val activityId = getNotificationIdFromString(id)

        val notificationManager =
            context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        notificationManager.cancel(activityId)
        liveActivitiesMap.remove(activityId)
    }

    fun endAllActivities(data: Map<String, Any>) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return

        val notificationManager =
            context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        for (activityId in liveActivitiesMap.keys.toList()) {
            notificationManager.cancel(activityId)
            liveActivitiesMap.remove(activityId)
        }
    }

    fun getAllActivitiesIds(data: Map<String, Any>): List<Int> {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return emptyList()

        return liveActivitiesMap.keys.toList()
    }

    fun areActivitiesEnabled(data: Map<String, Any>): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return false;

        return true
    }
}
