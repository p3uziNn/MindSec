package com.example.testapp.accessibility

import android.accessibilityservice.AccessibilityService
import android.content.Intent
import android.view.accessibility.AccessibilityEvent
import com.example.testapp.MainActivity

class MyAccessibilityService : AccessibilityService() {

    private fun getSelectedApps(): Set<String> {
        val prefs = getSharedPreferences("FlutterSharedPreferences", MODE_PRIVATE)
        val jsonString = prefs.getString("flutter.selected_monitored_apps", "") ?: ""

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

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event == null || event.eventType != AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) return

        val packageName = event.packageName?.toString() ?: return
        val currentTime = System.currentTimeMillis()

        // 1. Ignora o próprio aplicativo MindPause
        if (packageName == "com.example.testapp") return

        // 2. CHECAGEM DA TRAVA: Se o app foi liberado recentemente pelo botão continuar, ignora o bloqueio
        if (packageName == lastOpenedPackage && currentTime - lastInterventionTime < TO_MS) {
            return
        }

        // 3. Se estiver na lista de bloqueados, executa a intervenção
        if (getSelectedApps().contains(packageName)) {
            lastOpenedPackage = packageName
            lastInterventionTime = currentTime

            val intent = Intent(this, MainActivity::class.java).apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK)
                putExtra("blocked_app", packageName)
            }
            startActivity(intent)
        }
    }

    override fun onInterrupt() {}

    // Companion Object permite que a MainActivity atualize o estado de liberação do app
    companion object {
        private var lastOpenedPackage = ""
        private var lastInterventionTime = 0L
        private const val TO_MS = 20000L // 20 segundos de tolerância após clicar em continuar

        fun bypassApp(packageName: String) {
            lastOpenedPackage = packageName
            lastInterventionTime = System.currentTimeMillis()
        }
    }
}