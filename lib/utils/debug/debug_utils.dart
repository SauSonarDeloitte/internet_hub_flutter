import 'package:flutter/foundation.dart';

/// Utility class for debug mode checks
class DebugUtils {
  /// Returns true if the app is running in debug mode
  static bool get isDebugMode => kDebugMode;
  
  /// Returns true if the app is running in release mode
  static bool get isReleaseMode => kReleaseMode;
  
  /// Returns true if the app is running in profile mode
  static bool get isProfileMode => kProfileMode;
}
