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
  }

  void _initSentenceBuilder() {
    if (_currentItem.exerciseType == ExerciseType.build_sentence) {
      _arrangedWords = [];
      _availableWords = [..._currentItem.answer, ..._currentItem.distractors]
        ..shuffle(Random(_seedRandom(_currentItem.id + _currentIndex.toString())));
    }
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

  void _selectAnswer(String answer) {
    if (_answered) return;
    setState(() {
      _selectedAnswer = answer;
      _attempts++;
    });
  }

  void _checkAnswer() {
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
    });
    _updateProgress();
    _initSentenceBuilder();
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
                child: isSentenceBuilder
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
    final options = [..._currentItem.answer, ..._currentItem.distractors]
      ..shuffle(Random(_seedRandom(_currentItem.id + _currentIndex.toString())));

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
    final canCheck = isSentenceBuilder
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
