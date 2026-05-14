import 'package:android_intent_plus/android_intent.dart';

class AccessibilityService {

  static Future<void> openAccessibilitySettings() async {

    const intent = AndroidIntent(
      action: 'android.settings.ACCESSIBILITY_SETTINGS',
    );

    await intent.launch();
  }
}