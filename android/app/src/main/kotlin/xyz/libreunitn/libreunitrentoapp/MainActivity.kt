package xyz.libreunitn.libreunitrentoapp

import android.os.Bundle
import android.content.Intent

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
	private var invocationUri: String? = null

	protected override fun onCreate(savedInstanceState: Bundle?) {
		super.onCreate(savedInstanceState)
		val intent = this.getIntent()
		val uri = intent.getDataString()
		if(Intent.ACTION_VIEW.equals(intent.getAction()) && uri != null){
			this.invocationUri = uri
		}
	}

	public override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)
		MethodChannel(
			flutterEngine.getDartExecutor().getBinaryMessenger(),
			"xyz.libreunitn.invocationUri"
		).setMethodCallHandler({
			call, result -> if(call.method.equals("getInvocationUriString")){
				result.success(this.invocationUri)
			}
		})
	}
}
