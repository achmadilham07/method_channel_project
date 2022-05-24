package com.belajarubic.method_channel_project

import android.os.Handler
import android.os.Looper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.belajarubic.methodchannel"
    private lateinit var flutterChannel: MethodChannel
    private lateinit var handler: Handler

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        handler = Handler(Looper.getMainLooper())
        val messenger: BinaryMessenger = flutterEngine.dartExecutor.binaryMessenger
        flutterChannel = MethodChannel(messenger, CHANNEL)

        flutterChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "getDirectMessage" -> {
                    result.success("Received callback from android")
                }
                "getErrorMessage" -> {
                    result.error(
                        "-1",
                        "This message is Something went wrong",
                        "This detail is Something went wrong"
                    )
                }
                "getMessageFromParam" -> {
                    val argument: Int? = call.argument<Int>("param1")
                    result.success("Received param from Android : $argument")
                }
                "getMessageFromNative" -> {
                    result.success ("Wait 3 second and see the result")
                    handler.postDelayed({
                        flutterChannel.invokeMethod(
                            "fromNative",
                            "{\"message\":\"hello from native Android\"}"
                        )
                    }, 3000)
                }
            }
        }
    }
}
