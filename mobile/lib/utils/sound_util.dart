import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Sound utility for playing celebratory sounds, correct/wrong feedback, and streak sounds.
/// Uses local asset files bundled with the app for reliable offline playback.
class SoundUtil {
  static final AudioPlayer _player = AudioPlayer();
  static bool _enabled = true;
  static bool _initialized = false;

  static void setEnabled(bool enabled) {
    _enabled = enabled;
  }

  static bool get isEnabled => _enabled;

  /// Initialize the audio player with proper settings
  static Future<void> _ensureInitialized() async {
    if (_initialized) return;
    try {
      await _player.setPlayerMode(PlayerMode.lowLatency);
      await _player.setReleaseMode(ReleaseMode.release);
      await _player.setVolume(1.0);
      _initialized = true;
    } catch (e) {
      debugPrint('SoundUtil: Init error: $e');
    }
  }

  /// Play a correct answer chime — ascending C-E-G
  static Future<void> playCorrect() async {
    if (!_enabled) return;
    try {
      await _ensureInitialized();
      await _player.stop();
      await _player.play(AssetSource('sounds/correct.wav'));
    } catch (e) {
      debugPrint('SoundUtil: Could not play correct sound: $e');
    }
  }

  /// Play a wrong answer gentle sound (not a buzzer)
  static Future<void> playWrong() async {
    if (!_enabled) return;
    try {
      await _ensureInitialized();
      await _player.stop();
      await _player.play(AssetSource('sounds/wrong.wav'));
    } catch (e) {
      debugPrint('SoundUtil: Could not play wrong sound: $e');
    }
  }

  /// Play a celebratory streak sound (fanfare)
  static Future<void> playStreakCelebration() async {
    if (!_enabled) return;
    try {
      await _ensureInitialized();
      await _player.stop();
      await _player.play(AssetSource('sounds/streak_celebration.wav'));
    } catch (e) {
      debugPrint('SoundUtil: Could not play streak celebration: $e');
    }
  }

  /// Play a lesson complete celebration
  static Future<void> playLessonComplete() async {
    if (!_enabled) return;
    try {
      await _ensureInitialized();
      await _player.stop();
      await _player.play(AssetSource('sounds/lesson_complete.wav'));
    } catch (e) {
      debugPrint('SoundUtil: Could not play lesson complete: $e');
    }
  }

  /// Play a coin collect sound
  static Future<void> playCoin() async {
    if (!_enabled) return;
    try {
      await _ensureInitialized();
      await _player.stop();
      await _player.play(AssetSource('sounds/coin.wav'));
    } catch (e) {
      debugPrint('SoundUtil: Could not play coin sound: $e');
    }
  }

  /// Play streak milestone sound (3, 7, 14, 30 day streaks)
  static Future<void> playStreakMilestone(int streakDays) async {
    if (!_enabled) return;
    try {
      await _ensureInitialized();
      await _player.stop();
      if (streakDays >= 30) {
        // Epic celebration for 30+ day streaks
        await _player.play(AssetSource('sounds/streak_milestone.wav'));
      } else if (streakDays >= 14) {
        // Big celebration for 14+ day streaks
        await _player.play(AssetSource('sounds/streak_milestone.wav'));
      } else {
        // Standard celebration for 3+ day streaks
        await _player.play(AssetSource('sounds/streak_celebration.wav'));
      }
    } catch (e) {
      debugPrint('SoundUtil: Could not play streak milestone: $e');
    }
  }

  static void dispose() {
    _player.dispose();
  }
}
