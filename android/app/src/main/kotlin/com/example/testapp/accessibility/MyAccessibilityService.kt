package com.example.testapp.accessibility

import android.accessibilityservice.AccessibilityService
import android.content.Intent
import android.view.accessibility.AccessibilityEvent
import com.example.testapp.MainActivity

class MyAccessibilityService : AccessibilityService() {

    private fun getSelectedApps(): Set<String> {

        val prefs = getSharedPreferences(
            "FlutterSharedPreferences",
            MODE_PRIVATE
        )

        val jsonString = prefs.getString(
            "flutter.selected_monitored_apps",
            ""
        ) ?: ""

        val cleaned = jsonString
        .replace("\"", "")
        .removePrefix("[")
        .removeSuffix("]")

        return cleaned
            .split(",")
            .map { it.trim() }
            .filter { it.isNotEmpty() }
            .toSet()
    }

    override fun onAccessibilityEvent(
        event: AccessibilityEvent?
    ) {

        if (event == null) return

        if (
            event.eventType ==
            AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED
        ) {

            val packageName =
                event.packageName?.toString()
                    ?: return

            if (
                getSelectedApps()
                    .contains(packageName)
            ) {

                val intent = Intent(
                    this,
                    MainActivity::class.java
                )

                intent.addFlags(
                    Intent.FLAG_ACTIVITY_NEW_TASK
                )

                intent.putExtra(
                    "blocked_app",
                    packageName
                )

                startActivity(intent)
            }
        }
    }

    override fun onInterrupt() {}
}