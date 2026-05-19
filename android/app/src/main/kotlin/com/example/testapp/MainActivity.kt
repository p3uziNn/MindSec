package com.example.testapp

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "mindpause/intervention"
    private var latestBlockedApp: String? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getBlockedApp" -> {
                    result.success(latestBlockedApp)
                    latestBlockedApp = null
                }

                "openBlockedApp" -> {
                    val packageName = call.argument<String>("packageName")
                    if (packageName != null) {
                        val launchIntent = packageManager.getLaunchIntentForPackage(packageName)
                        if (launchIntent != null) {
                            latestBlockedApp = null
                            
                            // Limpa extras antigos para evitar recarregamento fantasma
                            intent.removeExtra("blocked_app") 

                            // CORREÇÃO: Avisa o serviço de acessibilidade para liberar este pacote ANTES de abrir o app
                            com.example.testapp.accessibility.MyAccessibilityService.bypassApp(packageName)

                            launchIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
                            startActivity(launchIntent)
                            
                            // Minimiza o MindPause após abrir o app de destino
                            moveTaskToBack(true) 
                            
                            result.success(true)
                        } else {
                            result.success(false)
                        }
                    } else {
                        result.success(false)
                    }
                }

                "goHome" -> {
                    val homeIntent = Intent(Intent.ACTION_MAIN).apply {
                        addCategory(Intent.CATEGORY_HOME)
                        flags = Intent.FLAG_ACTIVITY_NEW_TASK
                    }
                    startActivity(homeIntent)
                    result.success(true)
                }

                else -> {
                    result.notImplemented()
                }
            }
        }

        latestBlockedApp = intent.getStringExtra("blocked_app")
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)

        val app = intent.getStringExtra("blocked_app")
        latestBlockedApp = app

        // ESSENCIAL: Notifica o Flutter instantaneamente se o app já estiver aberto em segundo plano
        flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
            MethodChannel(messenger, CHANNEL).invokeMethod("newBlockedApp", app)
        }
    }
}