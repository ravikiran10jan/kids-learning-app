import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/lesson.dart';
import '../models/item.dart';
import '../models/exercise_type.dart';
import '../models/lesson_result.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/sound_util.dart';
import 'result_screen.dart';
import '../utils/tts_util.dart';

class LessonScreen extends StatefulWidget {
  final Lesson lesson;
  final String skillTitle;

  const LessonScreen({
    super.key,
    required this.lesson,
    required this.skillTitle,
  });

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  String? _selectedAnswer;
  bool _answered = false;
  bool _correct = false;
  int _attempts = 0;
  bool _firstTry = true;
  final List<ExerciseResult> _results = [];

  // Sentence builder state
  List<String> _arrangedWords = [];
  List<String> _availableWords = [];

  // Build-the-word state (spelling exercise)
  // Letter bank = answer letters + distractors, shuffled. Tapping the correct
  // next letter pops it and moves it into the next slot; a wrong letter shakes.
  List<String> _bankLetters = [];
  List<bool> _bankUsed = [];
  List<String> _placedLetters = [];
  int? _poppingBankIndex;
  int? _shakingBankIndex;
  int _shakeTick = 0; // bumps so a repeated wrong tap replays the shake
  String _spellWord = '';

  // Cached shuffled options (prevents re-shuffle on rebuild)
  List<String> _cachedOptions = [];
  String _cachedOptionKey = '';

  late AnimationController _animController;
  late Animation<double> _progressAnim;

  Item get _currentItem => widget.lesson.exercises[_currentIndex];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _progressAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
    _updateProgress();
    _initSentenceBuilder();
    _initSpellTiles();
  }

  void _initSentenceBuilder() {
    if (_currentItem.exerciseType == ExerciseType.build_sentence) {
      _arrangedWords = [];
      _availableWords = [..._currentItem.answer, ..._currentItem.distractors]
        ..shuffle(Random(_seedRandom(_currentItem.id + _currentIndex.toString())));
    }
  }

  void _initSpellTiles() {
    if (_currentItem.exerciseType == ExerciseType.spell_tiles) {
      final answer = List<String>.from(_currentItem.answer);
      _spellWord = answer.join('');
      _bankLetters = [...answer, ..._currentItem.distractors]
        ..shuffle(Random(_seedRandom(_currentItem.id + _currentIndex.toString())));
      _bankUsed = List<bool>.filled(_bankLetters.length, false);
      _placedLetters = [];
      _poppingBankIndex = null;
      _shakingBankIndex = null;
      // Auto-play word via TTS
      WidgetsBinding.instance.addPostFrameCallback((_) {
        TtsUtil.speakWord(_spellWord);
      });
    }
  }

  bool get _spellComplete =>
      _placedLetters.length == _currentItem.answer.length;

  void _spellTap(int index) {
    if (_answered || _bankUsed[index] || _poppingBankIndex != null) return;
    final expected = _currentItem.answer[_placedLetters.length];
    final letter = _bankLetters[index];
    _attempts++;

    if (letter != expected) {
      // Wrong letter: gentle sound, shake, and it stays in the bank
      SoundUtil.playWrong();
      setState(() {
        _firstTry = false;
        _shakingBankIndex = index;
        _shakeTick++;
      });
      return;
    }

    // Correct letter: pop the tile, then move it into the next slot
    setState(() {
      _shakingBankIndex = null;
      _poppingBankIndex = index;
    });
    Future.delayed(const Duration(milliseconds: 180), () {
      if (!mounted) return;
      setState(() {
        _poppingBankIndex = null;
        _bankUsed[index] = true;
        _placedLetters.add(letter);
        if (_spellComplete) {
          SoundUtil.playCorrect();
          _answered = true;
          _correct = true;
        }
      });
    });
  }

  void _addWord(String word) {
    if (_answered) return;
    setState(() {
      _availableWords.remove(word);
      _arrangedWords.add(word);
      _attempts++;
    });
  }

  void _removeWord(int index) {
    if (_answered) return;
    setState(() {
      final word = _arrangedWords.removeAt(index);
      _availableWords.add(word);
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _updateProgress() {
    _animController.animateTo(
      (_currentIndex) / widget.lesson.exercises.length,
    );
  }

  List<String> _getShuffledOptions() {
    final key = _currentItem.id + _currentIndex.toString();
    if (key != _cachedOptionKey) {
      _cachedOptionKey = key;
      _cachedOptions = [..._currentItem.answer, ..._currentItem.distractors]
        ..shuffle(Random(_seedRandom(key)));
    }
    return _cachedOptions;
  }

  void _selectAnswer(String answer) {
    if (_answered) return;
    setState(() {
      _selectedAnswer = answer;
      _attempts++;
    });
  }

  void _checkAnswer() {
    // Spell tiles auto-check once the last slot is filled
    if (_currentItem.exerciseType == ExerciseType.spell_tiles) return;
    bool isCorrect;
    if (_currentItem.exerciseType == ExerciseType.build_sentence) {
      if (_arrangedWords.length != _currentItem.answer.length) return;
      isCorrect = true;
      for (int i = 0; i < _currentItem.answer.length; i++) {
        if (_arrangedWords[i] != _currentItem.answer[i]) {
          isCorrect = false;
          break;
        }
      }
    } else {
      if (_selectedAnswer == null) return;
      isCorrect = _currentItem.answer.contains(_selectedAnswer);
    }

    // Play sound
    if (isCorrect) {
      SoundUtil.playCorrect();
    } else {
      SoundUtil.playWrong();
    }

    setState(() {
      _answered = true;
      _correct = isCorrect;
      if (!isCorrect) _firstTry = false;
    });
  }

  void _next() {
    // Record result
    _results.add(ExerciseResult(
      itemId: _currentItem.id,
      correct: _correct,
      firstTry: _firstTry,
      attempts: _attempts,
    ));

    if (_currentIndex >= widget.lesson.exercises.length - 1) {
      _finishLesson();
      return;
    }

    setState(() {
      _currentIndex++;
      _selectedAnswer = null;
      _answered = false;
      _correct = false;
      _attempts = 0;
      _firstTry = true;
      _arrangedWords = [];
      _availableWords = [];
      _bankLetters = [];
      _bankUsed = [];
      _placedLetters = [];
      _poppingBankIndex = null;
      _shakingBankIndex = null;
      _spellWord = '';
      _cachedOptions = [];
      _cachedOptionKey = '';
    });
    _updateProgress();
    _initSentenceBuilder();
    _initSpellTiles();
  }

  void _finishLesson() {
    final firstTryCorrect = _results.where((r) => r.firstTry).length;
    final coinsEarned = firstTryCorrect * 10;
    final result = LessonResult(
      lessonId: widget.lesson.id,
      skillId: widget.lesson.skillId,
      profileId: context.read<AppState>().profile.id,
      totalExercises: _results.length,
      firstTryCorrectCount: firstTryCorrect,
      coinsEarned: coinsEarned,
      exerciseResults: _results,
    );

    context.read<AppState>().completeLesson(result);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(result: result),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSentenceBuilder =
        _currentItem.exerciseType == ExerciseType.build_sentence;
    final isSpellTiles =
        _currentItem.exerciseType == ExerciseType.spell_tiles;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            _buildTopBar(),
            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: AnimatedBuilder(
                animation: _progressAnim,
                builder: (_, __) => ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: _progressAnim.value,
                    backgroundColor: Colors.grey.shade200,
                    valueColor:
                        const AlwaysStoppedAnimation(AppColors.primary),
                    minHeight: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Question + answer area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: isSpellTiles
                    ? _buildSpellTiles(context)
                    : isSentenceBuilder
                        ? _buildSentenceBuilder(context)
                        : _buildStandardOptions(context),
              ),
            ),
            // Bottom feedback + button
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildStandardOptions(BuildContext context) {
    final options = _getShuffledOptions();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _currentItem.prompt.text,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 32),
          ...options.map((opt) => _buildOption(opt)),
        ],
      ),
    );
  }

  // ─── Sentence Builder UI ───
  Widget _buildSentenceBuilder(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _currentItem.prompt.text,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 24),
        // Sentence area — arranged words
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 100),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F7FF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _answered
              ? (_correct ? AppColors.correct : AppColors.error)
              : AppColors.secondary.withOpacity(0.5),
              width: 2,
            ),
          ),
          child: _arrangedWords.isEmpty
              ? Center(
                  child: Text(
                    'Tap words below to build your sentence',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                )
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: List.generate(_arrangedWords.length, (i) {
                    final word = _arrangedWords[i];
                    final isCorrectWord =
                        i < _currentItem.answer.length &&
                        word == _currentItem.answer[i];
                    Color tileColor = const Color(0xFFDDF4FF);
                    Color borderColor = AppColors.secondary;
                    Color textColor = AppColors.secondary;
                    if (_answered) {
                      if (isCorrectWord) {
                        tileColor = const Color(0xFFD7FFB8);
                        borderColor = AppColors.correct;
                        textColor = AppColors.correct;
                      } else {
                        tileColor = const Color(0xFFFFDFE0);
                        borderColor = AppColors.error;
                        textColor = AppColors.error;
                      }
                    }
                    return GestureDetector(
                      onTap: _answered ? null : () => _removeWord(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: tileColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          word,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
        ),
        const SizedBox(height: 32),
        // Word bank — available words
        const Text(
          'Word Bank',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300, width: 1.5),
            ),
            child: _availableWords.isEmpty
                ? Center(
                    child: Text(
                      _answered ? '' : 'All words placed!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  )
                : Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: _availableWords.map((word) {
                      return GestureDetector(
                        onTap: _answered ? null : () => _addWord(word),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: AppColors.primary, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            word,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ),
      ],
    );
  }


  // ─── Build-the-Word (Spelling) UI ───
  Widget _buildSpellTiles(BuildContext context) {
    final answer = _currentItem.answer;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Prompt text
          Text(
            _currentItem.prompt.text,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Listen again button
          OutlinedButton.icon(
            onPressed: () => TtsUtil.speakWord(_spellWord),
            icon: const Icon(Icons.volume_up, size: 22),
            label: const Text('Listen again'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.secondary,
              side: const BorderSide(color: AppColors.secondary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
          ),
          const SizedBox(height: 32),
          // Word slots — fill up left to right as letters are chosen
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: List.generate(answer.length, (i) {
              final filled = i < _placedLetters.length;
              return _buildSlot(
                letter: filled ? _placedLetters[i] : null,
                isNext: !filled && i == _placedLetters.length && !_answered,
                complete: _answered && _correct,
              );
            }),
          ),
          const SizedBox(height: 36),
          // Letter bank
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: List.generate(_bankLetters.length, (i) {
              return _buildBankTile(
                index: i,
                letter: _bankLetters[i],
                used: _bankUsed[i],
                popping: _poppingBankIndex == i,
                shaking: _shakingBankIndex == i,
              );
            }),
          ),
          const SizedBox(height: 24),
          // Instruction text
          if (!_answered)
            Text(
              _placedLetters.isEmpty
                  ? 'Tap the letters in order to spell the word'
                  : 'Keep going! ${answer.length - _placedLetters.length} to go',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSlot({
    required String? letter,
    required bool isNext,
    required bool complete,
  }) {
    final filled = letter != null;
    final Color bgColor;
    final Color borderColor;
    final Color textColor;
    if (complete) {
      bgColor = const Color(0xFFD7FFB8);
      borderColor = AppColors.correct;
      textColor = AppColors.correct;
    } else if (filled) {
      bgColor = const Color(0xFFDDF4FF);
      borderColor = AppColors.secondary;
      textColor = AppColors.secondary;
    } else {
      bgColor = Colors.grey.shade50;
      borderColor = isNext ? AppColors.secondary : Colors.grey.shade300;
      textColor = AppColors.textPrimary;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: 48,
      height: 58,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: isNext ? 3 : 2),
        boxShadow: complete
            ? [
                BoxShadow(
                  color: AppColors.correct.withOpacity(0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: Center(
        child: filled
            // Pop-in as the letter lands in its slot
            ? TweenAnimationBuilder<double>(
                key: ValueKey('slot-$letter-${_placedLetters.length}'),
                tween: Tween(begin: 0.4, end: 1.0),
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutBack,
                builder: (_, scale, child) =>
                    Transform.scale(scale: scale, child: child),
                child: Text(
                  letter.toUpperCase(),
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                  ),
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildBankTile({
    required int index,
    required String letter,
    required bool used,
    required bool popping,
    required bool shaking,
  }) {
    final Color borderColor = shaking
        ? AppColors.error
        : popping
            ? AppColors.correct
            : Colors.grey.shade400;
    final Color bgColor = shaking
        ? const Color(0xFFFFDFE0)
        : popping
            ? const Color(0xFFD7FFB8)
            : Colors.white;

    Widget tile = AnimatedScale(
      scale: popping ? 1.3 : 1.0,
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOutBack,
      child: AnimatedOpacity(
        opacity: used ? 0.25 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 56,
          height: 64,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: 2),
            boxShadow: used
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Center(
            child: Text(
              letter.toUpperCase(),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );

    if (shaking) {
      // Side-to-side wobble for a wrong letter; keyed on _shakeTick so a
      // second wrong tap on the same tile replays it.
      tile = TweenAnimationBuilder<double>(
        key: ValueKey('shake-$index-$_shakeTick'),
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 350),
        onEnd: () {
          if (mounted && _shakingBankIndex == index) {
            setState(() => _shakingBankIndex = null);
          }
        },
        builder: (_, t, child) => Transform.translate(
          offset: Offset(sin(t * pi * 4) * 6 * (1 - t), 0),
          child: child,
        ),
        child: tile,
      );
    }

    return GestureDetector(
      onTap: (used || _answered) ? null : () => _spellTap(index),
      child: tile,
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => _showExitDialog(),
            icon: const Icon(Icons.close, size: 28),
          ),
          const Spacer(),
          Text(
            '${_currentIndex + 1} / ${widget.lesson.exercises.length}',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildOption(String option) {
    final isSelected = _selectedAnswer == option;
    final isCorrectOption = _currentItem.answer.contains(option);
    final showCorrect = _answered && isCorrectOption;
    final showWrong = _answered && isSelected && !_correct;

    Color bgColor;
    Color borderColor;
    Color textColor = AppColors.textPrimary;

    if (showCorrect) {
      bgColor = const Color(0xFFD7FFB8);
      borderColor = AppColors.correct;
      textColor = AppColors.correct;
    } else if (showWrong) {
      bgColor = const Color(0xFFFFDFE0);
      borderColor = AppColors.error;
      textColor = AppColors.error;
    } else if (isSelected) {
      bgColor = const Color(0xFFDDF4FF);
      borderColor = AppColors.secondary;
      textColor = AppColors.secondary;
    } else {
      bgColor = Colors.white;
      borderColor = Colors.grey.shade300;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: _answered ? null : () => _selectAnswer(option),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 2),
          ),
          child: Text(
            option,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    final isSentenceBuilder =
        _currentItem.exerciseType == ExerciseType.build_sentence;
    final canCheck = _currentItem.exerciseType == ExerciseType.spell_tiles
        ? _answered  // Spell tiles auto-check once the word is complete
        : isSentenceBuilder
            ? _arrangedWords.length == _currentItem.answer.length
            : _selectedAnswer != null;

    if (!_answered && canCheck) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: ElevatedButton(
          onPressed: _checkAnswer,
          child: const Text('CHECK'),
        ),
      );
    }

    if (_answered) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _correct
              ? const Color(0xFFD7FFB8)
              : const Color(0xFFFFDFE0),
        ),
        child: Row(
          children: [
            Icon(
              _correct ? Icons.check_circle : Icons.cancel,
              color: _correct ? AppColors.correct : AppColors.error,
              size: 32,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _correct ? 'Great job!' : 'Not quite!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color:
                          _correct ? AppColors.correct : AppColors.error,
                    ),
                  ),
                  if (!_correct)
                    Text(
                      'Answer: ${_currentItem.answer.join(" ")}',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.error.withOpacity(0.8),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: _next,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _correct ? AppColors.correct : AppColors.error,
                minimumSize: const Size(100, 48),
              ),
              child: Text(
                _currentIndex >= widget.lesson.exercises.length - 1
                    ? 'FINISH'
                    : 'NEXT',
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox(height: 80);
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Leave lesson?'),
        content: const Text('Your progress will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Stay'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Leave',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  // Simple deterministic shuffle seed
  int _seedRandom(String s) {
    int hash = 0;
    for (int i = 0; i < s.length; i++) {
      hash = ((hash << 5) - hash) + s.codeUnitAt(i);
      hash |= 0;
    }
    return hash;
  }
}
