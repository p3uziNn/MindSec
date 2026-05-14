package com.example.testapp.accessibility

import android.accessibilityservice.AccessibilityService
import android.content.Intent
import android.view.accessibility.AccessibilityEvent
import com.example.testapp.MainActivity

class MyAccessibilityService : AccessibilityService() {

    private val blockedApps = listOf(
        "com.instagram.android",
        "com.zhiliaoapp.musically",
        "com.twitter.android",
        "com.google.android.youtube"
    )

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {

        if (event == null) return

        if (event.eventType ==
            AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) {

            val packageName =
                event.packageName?.toString() ?: return

            if (blockedApps.contains(packageName)) {

                val intent =
                    Intent(this, MainActivity::class.java)

                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)

                intent.putExtra("blocked_app", packageName)

                startActivity(intent)
            }
        }
    }

    override fun onInterrupt() {}
}