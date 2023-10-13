package com.example.hello_flutter_method_channel

import android.media.RingtoneManager
import io.flutter.embedding.android.FlutterActivity

import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodCall

class MainActivity: FlutterActivity() {

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "method/ping")
        channel.setMethodCallHandler { methodCall: MethodCall, result: MethodChannel.Result ->

            if (methodCall.method == "ping") {
                val context = applicationContext
                val notification = RingtoneManager.getActualDefaultRingtoneUri(context, RingtoneManager.TYPE_NOTIFICATION);
                val r = RingtoneManager.getRingtone(context, notification);
                r.play();
                val res =  mapOf(
                    "device" to "Android",
                    "message" to "ok",
                )
                result.success(res)
            }
            else {
                result.notImplemented()
            }
        }
    }

}
