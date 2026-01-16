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
    private var channelName: String = "Live Activities"

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
        activityTag: String,
        timestamp: Long,
        data: Map<String, Any>
    ): String? {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return null;

        val notificationId = getNotificationIdFromString(activityTag)

        val notificationManager =
            context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        val areNotificationsEnabled =
            NotificationManagerCompat.from(context).areNotificationsEnabled()

        if (areNotificationsEnabled) {
            val builder = Notification.Builder(context, channelName)
            builder.extras.putLong("activity_timestamp", timestamp)

            notificationManager.notify(
                activityTag,
                notificationId,
                buildNotification(builder, "create", data)
            )
        } else {
            Log.w(
                "LiveActivityManager",
                "Notification permission denied. Unable to show notification."
            )
            return null
        }

        return activityTag
    }

    suspend fun createOrUpdateActivity(
        activityTag: String,
        timestamp: Long,
        data: Map<String, Any>
    ): String? {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return null

        val notificationId = getNotificationIdFromString(activityTag)

        val notificationManager =
            context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        val existingNotification = notificationManager.getActiveNotifications()
            .firstOrNull {
                it.tag == activityTag &&
                it.notification.channelId == channelName
            }

        if (existingNotification != null) {
            updateActivity(activityTag, timestamp, data)
            return activityTag
        } else {
            return createActivity(activityTag, timestamp, data)
        }
    }

    suspend fun updateActivity(
        activityTag: String,
        timestamp: Long,
        data: Map<String, Any>
    ) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return

        val notificationId = getNotificationIdFromString(activityTag)

        val notificationManager =
            context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        // Check if existing notification has a newer or equal timestamp
        val existingNotification = notificationManager.getActiveNotifications()
            .firstOrNull {
                it.tag == activityTag &&
                it.notification.channelId == channelName
            }

        val existingTimestamp = existingNotification?.notification?.extras?.getLong("activity_timestamp") ?: 0L
        if (existingTimestamp >= timestamp) {
            Log.w(
                "LiveActivityManager",
                "Attempted to update activity with ID $activityTag but the timestamp is not newer than the existing one."
            )
            return
        }

        val areNotificationsEnabled =
            NotificationManagerCompat.from(context).areNotificationsEnabled()

        if (areNotificationsEnabled) {
            val builder = Notification.Builder(context, channelName)
            builder.extras.putLong("activity_timestamp", timestamp)

            notificationManager.notify(
                activityTag,
                notificationId,
                buildNotification(builder, "update", data)
            )
        } else {
            Log.w(
                "LiveActivityManager",
                "Notification permission denied. Unable to show notification."
            )
            return
        }
    }

    fun endActivity(
        activityTag: String,
        data: Map<String, Any>
    ) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return

        val notificationId = getNotificationIdFromString(activityTag)

        val notificationManager =
            context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        notificationManager.cancel(activityTag, notificationId)
    }

    fun endAllActivities(data: Map<String, Any>) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return

        val notificationManager =
            context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        notificationManager.getActiveNotifications()
            .filter { statusBarNotification ->
                statusBarNotification.notification.channelId == channelName
            }
            .forEach { statusBarNotification ->
                notificationManager.cancel(statusBarNotification.tag, statusBarNotification.id)
            }
    }

    fun getAllActivitiesIds(data: Map<String, Any>): List<String> {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return emptyList()

        val notificationManager =
            context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        return notificationManager.getActiveNotifications()
            .filter { statusBarNotification ->
                statusBarNotification.notification.channelId == channelName
            }
            .mapNotNull { statusBarNotification ->
                statusBarNotification.tag
            }
    }

    fun areActivitiesSupported(data: Map<String, Any>): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return false;
        return true
    }

    fun areActivitiesEnabled(data: Map<String, Any>): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return false;
        return NotificationManagerCompat.from(context).areNotificationsEnabled()
    }
}