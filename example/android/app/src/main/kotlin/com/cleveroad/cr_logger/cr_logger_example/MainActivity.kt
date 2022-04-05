package com.cleveroad.cr_logger.cr_logger_example

import androidx.annotation.NonNull
import com.cleveroad.cr_logger.cr_logger.CrLogger
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.cleveroad.cr_logger_example/logs"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "debug" -> {
                    CrLogger.d("Debug logs from native android")
                    result.success(true)
                }
                "info" -> {
                    CrLogger.i("Info logs from native android")
                    result.success(true)
                }
                "error" -> {
                    CrLogger.e("Error logs from native android")
                    result.success(true)
                }
                "logJson" -> {
                    val map = getOrderedMap()
                    CrLogger.d(map)
                    CrLogger.i(map)
                    CrLogger.e(map)
                    result.success(true)
                }
            }
        }
    }

    private fun getOrderedMap(): Map<String, Any> {
        val sessionMap = mapOf(
            "accessToken" to "gnrjknsmdkom232",
            "refreshToken" to "sdapasldofkds123",
            "tokenLifetime" to 123456789,
        )
        val avatarMap = mapOf(
            "avatarUrl" to "https://image.example/userId/avatar.jpg",
            "smallAvatarUrl" to "https://image.example/userId/small_avatar.jpg",
        )

        return mapOf(
            "id" to "mnjtnnjw542",
            "firstName" to "Steave",
            "lastName" to "Jobs",
            "session" to sessionMap,
            "avatar" to avatarMap,
        )
    }
}


