import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Text-to-speech utility for pronouncing words during spelling exercises.
/// Uses flutter_tts which leverages iOS native AVFoundation.
class TtsUtil {
  static final FlutterTts _tts = FlutterTts();
  static bool _initialized = false;
  static bool _isInitializing = false;

  /// Initialize TTS with proper iOS audio session configuration
  static Future<void> _ensureInitialized() async {
    if (_initialized) return;
    if (_isInitializing) return;
    _isInitializing = true;
    try {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(0.4); // Slow for kids
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.1); // Slightly higher pitch, kid-friendly
      // Configure iOS audio session for playback (mix with others for sound effects)
      await _tts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.playback,
        [IosTextToSpeechAudioCategoryOptions.mixWithOthers],
      );
      _initialized = true;
    } catch (e) {
      debugPrint('TtsUtil: Init error: $e');
    } finally {
      _isInitializing = false;
    }
  }

  /// Speak a word clearly for the spelling exercise
  static Future<void> speakWord(String word) async {
    try {
      await _ensureInitialized();
      await _tts.stop();
      await _tts.speak(word);
    } catch (e) {
      debugPrint('TtsUtil: Could not speak word "$word": $e');
    }
  }

  /// Speak a word slowly (for replay / hint)
  static Future<void> speakWordSlow(String word) async {
    try {
      await _ensureInitialized();
      await _tts.stop();
      await _tts.setSpeechRate(0.25);
      await _tts.speak(word);
      // Reset to normal rate after speaking
      await Future.delayed(const Duration(seconds: 2));
      await _tts.setSpeechRate(0.4);
    } catch (e) {
      debugPrint('TtsUtil: Could not speak word "$word": $e');
    }
  }

  static void dispose() {
    _tts.stop();
  }
}
