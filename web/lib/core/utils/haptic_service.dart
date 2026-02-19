import 'package:flutter/services.dart';

class HapticService {
  static Future<void> lightImpact() async {
    await HapticFeedback.lightImpact();
  }

  static Future<void> mediumImpact() async {
    await HapticFeedback.mediumImpact();
  }
  
  static Future<void> heavyImpact() async {
     await HapticFeedback.heavyImpact();
  }
}
