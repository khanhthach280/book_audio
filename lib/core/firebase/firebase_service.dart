import 'package:book_audio/core/firebase/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

/// Firebase service for initializing Firebase
class FirebaseService {
  static bool _initialized = false;
  
  /// Initialize Firebase
  static Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _initialized = true;
    } catch (e) {
      throw Exception('Failed to initialize Firebase: $e');
    }
  }
  
  /// Check if Firebase is initialized
  static bool get isInitialized => _initialized;
}
