import 'subject.dart';
import 'exercise_type.dart';
import 'unit.dart';
import 'skill.dart';
import 'item.dart';

// ─── Homework Units ───────────────────────────────────────────────────────────
// Homework is a separate section from the regular curriculum path.
// Homework skills have no prerequisites and are always unlocked.
final List<Unit> homeworkUnits = [
  Unit(id: 'eng-hw', subject: Subject.ENGLISH, code: 'ENG-HW', title: 'Homework', skillIds: ['hw1', 'hw2']),
];

// ─── Homework Skills ──────────────────────────────────────────────────────────
final List<Skill> homeworkSkills = [
  Skill(id: 'hw1', subject: Subject.ENGLISH, unitCode: 'ENG-HW',
      title: 'Spelling Practice', icon: '📝', prerequisites: [],
      itemIds: ['ei462','ei463','ei464','ei465','ei466','ei467','ei468','ei469','ei470','ei471']),
  Skill(id: 'hw2', subject: Subject.ENGLISH, unitCode: 'ENG-HW',
      title: 'Spelling Practice 2', icon: '✏️', prerequisites: [],
      itemIds: ['ei472','ei473','ei474','ei475','ei476','ei477','ei478','ei479','ei480','ei481']),
];

// ─── Homework Items ───────────────────────────────────────────────────────────
final List<Item> homeworkItems = [
  Item(id: 'ei462', skillId: 'hw1', exerciseType: ExerciseType.spell_tiles,
      prompt: ItemPrompt(text: 'Spell this: 🏢 (up to date, not old-fashioned)'),
      answer: ['m', 'o', 'd', 'e', 'r', 'n'], distractors: ['a', 'p', 's']),
  Item(id: 'ei463', skillId: 'hw1', exerciseType: ExerciseType.spell_tiles,
      prompt: ItemPrompt(text: 'Spell this: 🎨 (a plan or drawing for something)'),
      answer: ['d', 'e', 's', 'i', 'g', 'n'], distractors: ['a', 'o', 'r']),
  Item(id: 'ei464', skillId: 'hw1', exerciseType: ExerciseType.spell_tiles,
      prompt: ItemPrompt(text: 'Spell this: ⭕ (a round shape with no corners)'),
      answer: ['c', 'i', 'r', 'c', 'l', 'e'], distractors: ['a', 'o', 's']),
  Item(id: 'ei465', skillId: 'hw1', exerciseType: ExerciseType.spell_tiles,
      prompt: ItemPrompt(text: 'Spell this: 📐 (the edges where sides of something meet)'),
      answer: ['c', 'o', 'r', 'n', 'e', 'r', 's'], distractors: ['a', 'd', 't']),
  Item(id: 'ei466', skillId: 'hw1', exerciseType: ExerciseType.spell_tiles,
      prompt: ItemPrompt(text: 'Spell this: 🛠️ (to make or produce something)'),
      answer: ['c', 'r', 'e', 'a', 't', 'e'], distractors: ['o', 's', 'i']),
  Item(id: 'ei467', skillId: 'hw1', exerciseType: ExerciseType.spell_tiles,
      prompt: ItemPrompt(text: 'Spell this: 🔄 (to make something different)'),
      answer: ['c', 'h', 'a', 'n', 'g', 'e'], distractors: ['o', 'r', 's']),
  Item(id: 'ei468', skillId: 'hw1', exerciseType: ExerciseType.spell_tiles,
      prompt: ItemPrompt(text: 'Spell this: 🎁 (to give or show something)'),
      answer: ['p', 'r', 'e', 's', 'e', 'n', 't'], distractors: ['a', 'd', 'o']),
  Item(id: 'ei469', skillId: 'hw1', exerciseType: ExerciseType.spell_tiles,
      prompt: ItemPrompt(text: 'Spell this: 🟦 (a shape with 4 equal sides)'),
      answer: ['s', 'q', 'u', 'a', 'r', 'e'], distractors: ['c', 'o', 'e']),
  Item(id: 'ei470', skillId: 'hw1', exerciseType: ExerciseType.spell_tiles,
      prompt: ItemPrompt(text: 'Spell this: 🧈 (having an even surface, not rough)'),
      answer: ['s', 'm', 'o', 'o', 't', 'h'], distractors: ['a', 'e', 'n']),
  Item(id: 'ei471', skillId: 'hw1', exerciseType: ExerciseType.spell_tiles,
      prompt: ItemPrompt(text: 'Spell this: 🏗️ (to construct something)'),
      answer: ['b', 'u', 'i', 'l', 'd'], distractors: ['a', 'e', 'o']),
  Item(id: 'ei472', skillId: 'hw2', exerciseType: ExerciseType.spell_tiles,
      prompt: ItemPrompt(text: 'Spell this: 🦎 (to change so you fit a new place or situation)'),
      answer: ['a', 'd', 'a', 'p', 't'], distractors: ['e', 'o', 'b']),
  Item(id: 'ei473', skillId: 'hw2', exerciseType: ExerciseType.spell_tiles,
      prompt: ItemPrompt(text: 'Spell this: 🎨 (a plan or drawing for something)'),
      answer: ['d', 'e', 's', 'i', 'g', 'n'], distractors: ['a', 'y', 'r']),
  Item(id: 'ei474', skillId: 'hw2', exerciseType: ExerciseType.spell_tiles,
      prompt: ItemPrompt(text: 'Spell this: ⛅ (sun, rain or wind — what the sky is doing today)'),
      answer: ['w', 'e', 'a', 't', 'h', 'e', 'r'], distractors: ['i', 'o', 'n']),
  Item(id: 'ei475', skillId: 'hw2', exerciseType: ExerciseType.spell_tiles,
      prompt: ItemPrompt(text: 'Spell this: 🌍 (the usual weather of a place over many years)'),
      answer: ['c', 'l', 'i', 'm', 'a', 't', 'e'], distractors: ['o', 'y', 'n']),
  Item(id: 'ei476', skillId: 'hw2', exerciseType: ExerciseType.spell_tiles,
      prompt: ItemPrompt(text: 'Spell this: 🛡️ (to keep something safe from harm)'),
      answer: ['p', 'r', 'o', 't', 'e', 'c', 't'], distractors: ['a', 'i', 'k']),
  Item(id: 'ei477', skillId: 'hw2', exerciseType: ExerciseType.spell_tiles,
      prompt: ItemPrompt(text: 'Spell this: 👥 (more than one person)'),
      answer: ['p', 'e', 'o', 'p', 'l', 'e'], distractors: ['a', 'i', 'u']),
  Item(id: 'ei478', skillId: 'hw2', exerciseType: ExerciseType.spell_tiles,
      prompt: ItemPrompt(text: 'Spell this: 🔄 (to make something different)'),
      answer: ['c', 'h', 'a', 'n', 'g', 'e'], distractors: ['o', 'r', 's']),
  Item(id: 'ei479', skillId: 'hw2', exerciseType: ExerciseType.spell_tiles,
      prompt: ItemPrompt(text: 'Spell this: ❓ (for the reason that)'),
      answer: ['b', 'e', 'c', 'a', 'u', 's', 'e'], distractors: ['o', 'i', 'z']),
  Item(id: 'ei480', skillId: 'hw2', exerciseType: ExerciseType.spell_tiles,
      prompt: ItemPrompt(text: 'Spell this: 🗣️ (to say what something is like)'),
      answer: ['d', 'e', 's', 'c', 'r', 'i', 'b', 'e'], distractors: ['a', 'o', 't']),
  Item(id: 'ei481', skillId: 'hw2', exerciseType: ExerciseType.spell_tiles,
      prompt: ItemPrompt(text: 'Spell this: ⭐ (the one you like best of all)'),
      answer: ['f', 'a', 'v', 'o', 'u', 'r', 'i', 't', 'e'], distractors: ['y', 's', 'l']),
];
