package xyz.libreunitn.libreunitrentoapp

import android.os.Bundle
import android.content.Intent

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.EventChannel


class MainActivity: FlutterActivity() {
	private var lastIntentUri: String? = null
	private lateinit var eventChannel: EventChannel
	private var eventSink: EventChannel.EventSink? = null

	protected override fun onCreate(savedInstanceState: Bundle?) {
		super.onCreate(savedInstanceState)
		val intent = this.getIntent()
		if(this.isValidIntent(intent)){
			this.lastIntentUri = intent.getDataString()
		}
	}

	override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)
		this.eventChannel = EventChannel(
			flutterEngine.getDartExecutor().getBinaryMessenger(),
			"xyz.libreunitn.invocationUri"
		)
		this.eventChannel.setStreamHandler(
			object: EventChannel.StreamHandler {
				override fun onListen(arguments: Any?, eventSink: EventChannel.EventSink){
					eventSink.success(lastIntentUri)
					this@MainActivity.eventSink = eventSink
				}

				override fun onCancel(arguments: Any?){
					this@MainActivity.eventSink = null
				}
			}
		)
	}

	override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
		this.eventSink?.endOfStream()
		super.cleanUpFlutterEngine(flutterEngine)
	}

	protected override fun onNewIntent(intent: Intent){
		super.onNewIntent(intent)
		if(isValidIntent(intent)){
			lastIntentUri = intent.getDataString()
			eventSink?.success(lastIntentUri)
		}
	}

	private fun isValidIntent(intent: Intent): Boolean = Intent.ACTION_VIEW.equals(intent.getAction()) && intent.getDataString() != null
}

/*
══╡ EXCEPTION CAUGHT BY SERVICES LIBRARY ╞══════════════════════════════════════════════════════════
The following PlatformException was thrown while activating platform stream on channel
xyz.libreunitn.invocationUri:
PlatformException(error, Parameter specified as non-null is null: method
kotlin.jvm.internal.Intrinsics.checkParameterIsNotNull, parameter arguments, null, null)

When the exception was thrown, this was the stack:
#0      StandardMethodCodec.decodeEnvelope (package:flutter/src/services/message_codecs.dart:607:7)
#1      MethodChannel._invokeMethod (package:flutter/src/services/platform_channel.dart:156:18)
<asynchronous suspension>
#2      EventChannel.receiveBroadcastStream.<anonymous closure> (package:flutter/src/services/platform_channel.dart:486:9)
<asynchronous suspension>
════════════════════════════════════════════════════════════════════════════════════════════════════
*/
