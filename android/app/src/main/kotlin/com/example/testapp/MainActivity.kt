package com.example.testapp

import android.content.Intent
import android.net.Uri
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL =
        "mindpause/intervention"

    override fun configureFlutterEngine(
        flutterEngine: FlutterEngine
    ) {

        super.configureFlutterEngine(
            flutterEngine
        )

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler {

            call,
            result ->

            when (call.method) {

                "getBlockedApp" -> {

                    val blockedApp =
                        intent.getStringExtra(
                            "blocked_app"
                        )

                    result.success(
                        blockedApp
                    )
                }

                "openBlockedApp" -> {

                    val packageName =
                        call.argument<String>(
                            "packageName"
                        )

                    if (packageName != null) {

                        val launchIntent =
                            packageManager
                                .getLaunchIntentForPackage(
                                    packageName
                                )

                        if (launchIntent != null) {

                            launchIntent.addFlags(
                                Intent.FLAG_ACTIVITY_NEW_TASK
                            )

                            startActivity(
                                launchIntent
                            )

                            result.success(true)

                        } else {

                            result.success(false)
                        }

                    } else {

                        result.success(false)
                    }
                }

                "goHome" -> {

                    val homeIntent = Intent(
                        Intent.ACTION_MAIN
                    )

                    homeIntent.addCategory(
                        Intent.CATEGORY_HOME
                    )

                    homeIntent.flags =
                        Intent.FLAG_ACTIVITY_NEW_TASK

                    startActivity(homeIntent)

                    result.success(true)
                }

                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}