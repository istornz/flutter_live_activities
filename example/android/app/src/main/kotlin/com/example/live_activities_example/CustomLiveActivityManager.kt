package com.example.live_activities_example


import android.app.Notification
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.widget.RemoteViews
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import java.net.HttpURLConnection
import java.net.URL
import com.example.live_activities.LiveActivityManager

class CustomLiveActivityManager(context: Context) :
    LiveActivityManager(context) {
    private val context: Context = context.applicationContext
    private val pendingIntent = PendingIntent.getActivity(
        context, 200, Intent(context, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_REORDER_TO_FRONT
        }, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
    )

    private val remoteViews = RemoteViews(
        context.packageName, R.layout.live_activity
    )

    suspend fun loadImageBitmap(imageUrl: String?): Bitmap? {
        val dp = context.resources.displayMetrics.density.toInt()
        return withContext(Dispatchers.IO) {
            if (imageUrl.isNullOrEmpty()) return@withContext null
            try {
                val url = URL(imageUrl)
                val connection = url.openConnection() as HttpURLConnection
                connection.doInput = true
                connection.connectTimeout = 3000
                connection.readTimeout = 3000
                connection.connect()
                connection.inputStream.use { inputStream ->
                    val originalBitmap = BitmapFactory.decodeStream(inputStream)
                    originalBitmap?.let {
                        val targetSize = 64 * dp
                        val aspectRatio =
                            it.width.toFloat() / it.height.toFloat()
                        val (targetWidth, targetHeight) = if (aspectRatio > 1) {
                            targetSize to (targetSize / aspectRatio).toInt()
                        } else {
                            (targetSize * aspectRatio).toInt() to targetSize
                        }
                        Bitmap.createScaledBitmap(
                            it,
                            targetWidth,
                            targetHeight,
                            true
                        )
                    }
                }
            } catch (e: Exception) {
                e.printStackTrace()
                null
            }
        }
    }

    private suspend fun updateRemoteViews(
        team1Name: String,
        team1Score: Int,
        team2Name: String,
        team2Score: Int,
        timestamp: Long,
        team1ImageUrl: String?,
        team2ImageUrl: String?,
    ) {
        remoteViews.setTextViewText(R.id.team1_name, team1Name)
        remoteViews.setTextViewText(R.id.team2_name, team2Name)
        remoteViews.setTextViewText(R.id.score, "$team1Score : $team2Score")

        val elapsedRealtime = android.os.SystemClock.elapsedRealtime()
        val currentTimeMillis = System.currentTimeMillis()
        val base = elapsedRealtime - (currentTimeMillis - timestamp)

        remoteViews.setChronometer(R.id.match_time, base, null, true)

        val team1Image =
            if (!team1ImageUrl.isNullOrEmpty()) loadImageBitmap(
                team1ImageUrl
            ) else null
        val team2Image =
            if (!team2ImageUrl.isNullOrEmpty()) loadImageBitmap(
                team2ImageUrl
            ) else null

        team1Image?.let { image ->
            remoteViews.setImageViewBitmap(
                R.id.team1_image_placeholder,
                image,
            )
        }

        team2Image?.let { image ->
            remoteViews.setImageViewBitmap(
                R.id.team2_image_placeholder,
                image,
            )
        }
    }


    override suspend fun buildNotification(
        notification: Notification.Builder,
        event: String,
        data: Map<String, Any>
    ): Notification {
        val matchName = data["matchName"] as String
        val timestamp = data["matchStartDate"] as Long
        val team1Name = data["teamAName"] as String
        val team1Score = data["teamAScore"] as Int
        val team2Name = data["teamBName"] as String
        val team2Score = data["teamBScore"] as Int

        /// If the event is "update", skip images as previous notification already downloaded them
        val team1ImageUrl =
            if (event == "update") null else data["teamAImageUrl"] as String?
        val team2ImageUrl =
            if (event == "update") null else data["teamBImageUrl"] as String?

        updateRemoteViews(
            team1Name,
            team1Score,
            team2Name,
            team2Score,
            timestamp,
            team1ImageUrl,
            team2ImageUrl,
        )

        return notification
            .setSmallIcon(R.drawable.ic_notification)
            .setOngoing(true).setContentTitle("$team1Name vs $team2Name")
            .setContentIntent(pendingIntent)
            .setContentText("$team1Score : $team2Score")
            .setStyle(Notification.BigTextStyle())
            .setCustomContentView(remoteViews)
            .setCustomBigContentView(remoteViews)
            .setPriority(Notification.PRIORITY_LOW)
            .setCategory(Notification.CATEGORY_EVENT)
            .setVisibility(Notification.VISIBILITY_PUBLIC)
            .build()
    }
}
