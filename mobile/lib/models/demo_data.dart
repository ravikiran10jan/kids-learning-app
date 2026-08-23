import '../models/subject.dart';
import '../models/exercise_type.dart';
import '../models/unit.dart';
import '../models/skill.dart';
import '../models/item.dart';
import 'math_content.dart';
import 'english_content.dart';

// ─── ENGLISH UNITS ───
final demoEnglishUnits = [
  Unit(id: 'eu1', subject: Subject.ENGLISH, code: 'ENG-U1', title: 'Alphabet & Phonics',
      skillIds: ['es1', 'es2', 'es3']),
  Unit(id: 'eu2', subject: Subject.ENGLISH, code: 'ENG-U2', title: 'Sight Words',
      skillIds: ['es4', 'es5']),
  Unit(id: 'eu3', subject: Subject.ENGLISH, code: 'ENG-U3', title: 'Simple Sentences',
      skillIds: ['es6', 'es7']),
];

// ─── MATH UNITS ───
final demoMathUnits = [
  Unit(id: 'mu1', subject: Subject.MATH, code: 'MATH-U1', title: 'Counting & Numbers',
      skillIds: ['ms1', 'ms2', 'ms3']),
  Unit(id: 'mu2', subject: Subject.MATH, code: 'MATH-U2', title: 'Addition',
      skillIds: ['ms4', 'ms5']),
  Unit(id: 'mu3', subject: Subject.MATH, code: 'MATH-U3', title: 'Subtraction',
      skillIds: ['ms6', 'ms7']),
];

// ─── ENGLISH SKILLS ───
final demoEnglishSkills = [
  Skill(id: 'es1', subject: Subject.ENGLISH, unitCode: 'ENG-U1', title: 'Uppercase Letters', icon: '🔤',
      prerequisites: [], itemIds: ['ei1','ei2','ei3','ei4','ei5','ei6']),
  Skill(id: 'es2', subject: Subject.ENGLISH, unitCode: 'ENG-U1', title: 'Lowercase Letters', icon: '🔡',
      prerequisites: ['es1'], itemIds: ['ei7','ei8','ei9','ei10','ei11']),
  Skill(id: 'es3', subject: Subject.ENGLISH, unitCode: 'ENG-U1', title: 'Letter Sounds', icon: '🔊',
      prerequisites: ['es1','es2'], itemIds: ['ei12','ei13','ei14','ei15','ei16']),
  Skill(id: 'es4', subject: Subject.ENGLISH, unitCode: 'ENG-U2', title: 'Common Words', icon: '📖',
      prerequisites: ['es3'], itemIds: ['ei17','ei18','ei19','ei20','ei21']),
  Skill(id: 'es5', subject: Subject.ENGLISH, unitCode: 'ENG-U2', title: 'Rhyming Words', icon: '🎵',
      prerequisites: ['es4'], itemIds: ['ei22','ei23','ei24','ei25','ei26']),
  Skill(id: 'es6', subject: Subject.ENGLISH, unitCode: 'ENG-U3', title: 'Build a Sentence', icon: '✏️',
      prerequisites: ['es5'], itemIds: ['ei27','ei28','ei29','ei30']),
  Skill(id: 'es7', subject: Subject.ENGLISH, unitCode: 'ENG-U3', title: 'Reading Comprehension', icon: '📚',
      prerequisites: ['es6'], itemIds: ['ei31','ei32','ei33','ei34']),
];

// ─── MATH SKILLS ───
final demoMathSkills = [
  Skill(id: 'ms1', subject: Subject.MATH, unitCode: 'MATH-U1', title: 'Count to 10', icon: '🔢',
      prerequisites: [], itemIds: ['mi1','mi2','mi3','mi4','mi5','mi6']),
  Skill(id: 'ms2', subject: Subject.MATH, unitCode: 'MATH-U1', title: 'Count to 20', icon: '🔢',
      prerequisites: ['ms1'], itemIds: ['mi7','mi8','mi9','mi10','mi11']),
  Skill(id: 'ms3', subject: Subject.MATH, unitCode: 'MATH-U1', title: 'Number Recognition', icon: '👀',
      prerequisites: ['ms1'], itemIds: ['mi12','mi13','mi14','mi15','mi16']),
  Skill(id: 'ms4', subject: Subject.MATH, unitCode: 'MATH-U2', title: 'Add within 10', icon: '➕',
      prerequisites: ['ms2'], itemIds: ['mi17','mi18','mi19','mi20','mi21']),
  Skill(id: 'ms5', subject: Subject.MATH, unitCode: 'MATH-U2', title: 'Add within 20', icon: '➕',
      prerequisites: ['ms4'], itemIds: ['mi22','mi23','mi24','mi25','mi26']),
  Skill(id: 'ms6', subject: Subject.MATH, unitCode: 'MATH-U3', title: 'Subtract within 10', icon: '➖',
      prerequisites: ['ms4'], itemIds: ['mi27','mi28','mi29','mi30','mi31']),
  Skill(id: 'ms7', subject: Subject.MATH, unitCode: 'MATH-U3', title: 'Subtract within 20', icon: '➖',
      prerequisites: ['ms6'], itemIds: ['mi32','mi33','mi34','mi35','mi36']),
];

// ─── ENGLISH ITEMS ───
final demoEnglishItems = [
  // es1 – Uppercase Letters (pick_text)
  Item(id:'ei1',skillId:'es1',exerciseType:ExerciseType.pick_text,
      prompt:ItemPrompt(text:'Which letter is "A"?'),answer:['A'],distractors:['B','C','D']),
  Item(id:'ei2',skillId:'es1',exerciseType:ExerciseType.pick_text,
      prompt:ItemPrompt(text:'Which letter is "M"?'),answer:['M'],distractors:['N','W','V']),
  Item(id:'ei3',skillId:'es1',exerciseType:ExerciseType.pick_text,
      prompt:ItemPrompt(text:'Which letter is "S"?'),answer:['S'],distractors:['Z','5','X']),
  Item(id:'ei4',skillId:'es1',exerciseType:ExerciseType.pick_text,
      prompt:ItemPrompt(text:'Which letter is "G"?'),answer:['G'],distractors:['J','Q','P']),
  Item(id:'ei5',skillId:'es1',exerciseType:ExerciseType.pick_text,
      prompt:ItemPrompt(text:'Which letter is "R"?'),answer:['R'],distractors:['P','B','K']),
  Item(id:'ei6',skillId:'es1',exerciseType:ExerciseType.pick_text,
      prompt:ItemPrompt(text:'Which letter is "T"?'),answer:['T'],distractors:['F','I','L']),

  // es2 – Lowercase Letters
  Item(id:'ei7',skillId:'es2',exerciseType:ExerciseType.pick_text,
      prompt:ItemPrompt(text:'Which letter is "a"?'),answer:['a'],distractors:['e','o','u']),
  Item(id:'ei8',skillId:'es2',exerciseType:ExerciseType.pick_text,
      prompt:ItemPrompt(text:'Which letter is "b"?'),answer:['b'],distractors:['d','p','q']),
  Item(id:'ei9',skillId:'es2',exerciseType:ExerciseType.pick_text,
      prompt:ItemPrompt(text:'Which letter is "g"?'),answer:['g'],distractors:['j','q','y']),
  Item(id:'ei10',skillId:'es2',exerciseType:ExerciseType.pick_text,
      prompt:ItemPrompt(text:'Which letter is "m"?'),answer:['m'],distractors:['n','w','v']),
  Item(id:'ei11',skillId:'es2',exerciseType:ExerciseType.pick_text,
      prompt:ItemPrompt(text:'Which letter is "t"?'),answer:['t'],distractors:['f','i','l']),

  // es3 – Letter Sounds
  Item(id:'ei12',skillId:'es3',exerciseType:ExerciseType.pick_text,
      prompt:ItemPrompt(text:'What sound does "B" make?'),answer:['buh'],distractors:['sss','mmm','tuh']),
  Item(id:'ei13',skillId:'es3',exerciseType:ExerciseType.pick_text,
      prompt:ItemPrompt(text:'What sound does "S" make?'),answer:['sss'],distractors:['buh','rrr','zzz']),
  Item(id:'ei14',skillId:'es3',exerciseType:ExerciseType.pick_text,
      prompt:ItemPrompt(text:'What sound does "M" make?'),answer:['mmm'],distractors:['nnn','lll','buh']),
  Item(id:'ei15',skillId:'es3',exerciseType:ExerciseType.pick_text,
      prompt:ItemPrompt(text:'What sound does "T" make?'),answer:['tuh'],distractors:['duh','puh','kuh']),
  Item(id:'ei16',skillId:'es3',exerciseType:ExerciseType.pick_text,
      prompt:ItemPrompt(text:'What sound does "R" make?'),answer:['rrr'],distractors:['lll','www','buh']),

  // es4 – Common Words (sight words)
  Item(id:'ei17',skillId:'es4',exerciseType:ExerciseType.pick_text,
      prompt:ItemPrompt(text:'Which word means "not far"?'),answer:['near'],distractors:['far','tall','big']),
  Item(id:'ei18',skillId:'es4',exerciseType:ExerciseType.pick_text,
      prompt:ItemPrompt(text:'Which word is a color?'),answer:['red'],distractors:['run','sit','two']),
  Item(id:'ei19',skillId:'es4',exerciseType:ExerciseType.pick_text,
      prompt:ItemPrompt(text:'Which word means "a lot"?'),answer:['many'],distractors:['one','the','is']),
  Item(id:'ei20',skillId:'es4',exerciseType:ExerciseType.pick_text,
      prompt:ItemPrompt(text:'Which word is an animal?'),answer:['cat'],distractors:['the','and','was']),
  Item(id:'ei21',skillId:'es4',exerciseType:ExerciseType.pick_text,
      prompt:ItemPrompt(text:'Which word means "to go fast"?'),answer:['run'],distractors:['sit','big','red']),

  // es5 – Rhyming Words
  Item(id:'ei22',skillId:'es5',exerciseType:ExerciseType.pick_text,
      prompt:ItemPrompt(text:'What rhymes with "cat"?'),answer:['hat'],distractors:['dog','cup','pen']),
  Item(id:'ei23',skillId:'es5',exerciseType:ExerciseType.pick_text,
      prompt:ItemPrompt(text:'What rhymes with "sun"?'),answer:['fun'],distractors:['moon','tree','red']),
  Item(id:'ei24',skillId:'es5',exerciseType:ExerciseType.pick_text,
      prompt:ItemPrompt(text:'What rhymes with "big"?'),answer:['pig'],distractors:['cow','ant','red']),
  Item(id:'ei25',skillId:'es5',exerciseType:ExerciseType.pick_text,
      prompt:ItemPrompt(text:'What rhymes with "log"?'),answer:['dog'],distractors:['cat','bat','pen']),
  Item(id:'ei26',skillId:'es5',exerciseType:ExerciseType.pick_text,
      prompt:ItemPrompt(text:'What rhymes with "bee"?'),answer:['tree'],distractors:['sky','rock','fish']),

  // es6 – Build a Sentence
  Item(id:'ei27',skillId:'es6',exerciseType:ExerciseType.build_sentence,
      prompt:ItemPrompt(text:'Arrange: "The cat is big"'),answer:['The','cat','is','big'],distractors:['A','small','was']),
  Item(id:'ei28',skillId:'es6',exerciseType:ExerciseType.build_sentence,
      prompt:ItemPrompt(text:'Arrange: "I like to read"'),answer:['I','like','to','read'],distractors:['We','run','play']),
  Item(id:'ei29',skillId:'es6',exerciseType:ExerciseType.build_sentence,
      prompt:ItemPrompt(text:'Arrange: "She has a red ball"'),answer:['She','has','a','red','ball'],distractors:['He','blue']),
  Item(id:'ei30',skillId:'es6',exerciseType:ExerciseType.build_sentence,
      prompt:ItemPrompt(text:'Arrange: "Dogs can run fast"'),answer:['Dogs','can','run','fast'],distractors:['Cats','swim','slow']),

  // es7 – Reading Comprehension
  Item(id:'ei31',skillId:'es7',exerciseType:ExerciseType.pick_text,
      prompt:ItemPrompt(text:'"The dog ran." Who ran?'),answer:['The dog'],distractors:['The cat','A bird','No one']),
  Item(id:'ei32',skillId:'es7',exerciseType:ExerciseType.pick_text,
      prompt:ItemPrompt(text:'"Sam has a red hat." What color is the hat?'),answer:['red'],distractors:['blue','green','yellow']),
  Item(id:'ei33',skillId:'es7',exerciseType:ExerciseType.pick_text,
      prompt:ItemPrompt(text:'"I see a big tree." What is big?'),answer:['tree'],distractors:['dog','house','car']),
  Item(id:'ei34',skillId:'es7',exerciseType:ExerciseType.pick_text,
      prompt:ItemPrompt(text:'"Mom can sing well." Who can sing?'),answer:['Mom'],distractors:['Dad','Sister','Teacher']),
];

// ─── MATH ITEMS ───
final demoMathItems = [
  // ms1 – Count to 10
  Item(id:'mi1',skillId:'ms1',exerciseType:ExerciseType.pick_number,
      prompt:ItemPrompt(text:'How many apples? 🍎🍎🍎'),answer:['3'],distractors:['2','4','5']),
  Item(id:'mi2',skillId:'ms1',exerciseType:ExerciseType.pick_number,
      prompt:ItemPrompt(text:'How many stars? ⭐⭐⭐⭐⭐'),answer:['5'],distractors:['3','4','6']),
  Item(id:'mi3',skillId:'ms1',exerciseType:ExerciseType.pick_number,
      prompt:ItemPrompt(text:'How many hearts? ❤️❤️'),answer:['2'],distractors:['1','3','4']),
  Item(id:'mi4',skillId:'ms1',exerciseType:ExerciseType.pick_number,
      prompt:ItemPrompt(text:'How many balls? ⚽⚽⚽⚽⚽⚽⚽'),answer:['7'],distractors:['5','6','8']),
  Item(id:'mi5',skillId:'ms1',exerciseType:ExerciseType.pick_number,
      prompt:ItemPrompt(text:'Count: 🐱🐱🐱🐱'),answer:['4'],distractors:['3','5','6']),
  Item(id:'mi6',skillId:'ms1',exerciseType:ExerciseType.pick_number,
      prompt:ItemPrompt(text:'Count the dots: ●●●●●●●●●●'),answer:['10'],distractors:['8','9','7']),

  // ms2 – Count to 20
  Item(id:'mi7',skillId:'ms2',exerciseType:ExerciseType.pick_number,
      prompt:ItemPrompt(text:'What comes after 14?'),answer:['15'],distractors:['13','16','12']),
  Item(id:'mi8',skillId:'ms2',exerciseType:ExerciseType.pick_number,
      prompt:ItemPrompt(text:'What comes after 19?'),answer:['20'],distractors:['18','21','17']),
  Item(id:'mi9',skillId:'ms2',exerciseType:ExerciseType.pick_number,
      prompt:ItemPrompt(text:'What number is 12 + 1?'),answer:['13'],distractors:['11','14','10']),
  Item(id:'mi10',skillId:'ms2',exerciseType:ExerciseType.pick_number,
      prompt:ItemPrompt(text:'Count: 🌟 (16 stars) 🌟'),answer:['16'],distractors:['15','17','14']),
  Item(id:'mi11',skillId:'ms2',exerciseType:ExerciseType.pick_number,
      prompt:ItemPrompt(text:'What comes before 18?'),answer:['17'],distractors:['19','16','20']),

  // ms3 – Number Recognition
  Item(id:'mi12',skillId:'ms3',exerciseType:ExerciseType.pick_text,
      prompt:ItemPrompt(text:'Which shows "five"?'),answer:['5'],distractors:['3','7','9']),
  Item(id:'mi13',skillId:'ms3',exerciseType:ExerciseType.pick_text,
      prompt:ItemPrompt(text:'Which shows "eight"?'),answer:['8'],distractors:['6','3','10']),
  Item(id:'mi14',skillId:'ms3',exerciseType:ExerciseType.pick_text,
      prompt:ItemPrompt(text:'Which shows "two"?'),answer:['2'],distractors:['4','7','1']),
  Item(id:'mi15',skillId:'ms3',exerciseType:ExerciseType.pick_text,
      prompt:ItemPrompt(text:'Which shows "ten"?'),answer:['10'],distractors:['8','12','7']),
  Item(id:'mi16',skillId:'ms3',exerciseType:ExerciseType.pick_text,
      prompt:ItemPrompt(text:'Which shows "six"?'),answer:['6'],distractors:['9','3','8']),

  // ms4 – Add within 10
  Item(id:'mi17',skillId:'ms4',exerciseType:ExerciseType.pick_number,
      prompt:ItemPrompt(text:'2 + 3 = ?'),answer:['5'],distractors:['4','6','7']),
  Item(id:'mi18',skillId:'ms4',exerciseType:ExerciseType.pick_number,
      prompt:ItemPrompt(text:'4 + 1 = ?'),answer:['5'],distractors:['3','6','4']),
  Item(id:'mi19',skillId:'ms4',exerciseType:ExerciseType.pick_number,
      prompt:ItemPrompt(text:'3 + 3 = ?'),answer:['6'],distractors:['5','7','8']),
  Item(id:'mi20',skillId:'ms4',exerciseType:ExerciseType.pick_number,
      prompt:ItemPrompt(text:'5 + 2 = ?'),answer:['7'],distractors:['6','8','9']),
  Item(id:'mi21',skillId:'ms4',exerciseType:ExerciseType.pick_number,
      prompt:ItemPrompt(text:'6 + 4 = ?'),answer:['10'],distractors:['8','9','11']),

  // ms5 – Add within 20
  Item(id:'mi22',skillId:'ms5',exerciseType:ExerciseType.pick_number,
      prompt:ItemPrompt(text:'8 + 5 = ?'),answer:['13'],distractors:['12','14','11']),
  Item(id:'mi23',skillId:'ms5',exerciseType:ExerciseType.pick_number,
      prompt:ItemPrompt(text:'9 + 7 = ?'),answer:['16'],distractors:['15','17','14']),
  Item(id:'mi24',skillId:'ms5',exerciseType:ExerciseType.pick_number,
      prompt:ItemPrompt(text:'7 + 6 = ?'),answer:['13'],distractors:['12','14','15']),
  Item(id:'mi25',skillId:'ms5',exerciseType:ExerciseType.pick_number,
      prompt:ItemPrompt(text:'8 + 8 = ?'),answer:['16'],distractors:['14','15','18']),
  Item(id:'mi26',skillId:'ms5',exerciseType:ExerciseType.pick_number,
      prompt:ItemPrompt(text:'9 + 9 = ?'),answer:['18'],distractors:['16','17','19']),

  // ms6 – Subtract within 10
  Item(id:'mi27',skillId:'ms6',exerciseType:ExerciseType.pick_number,
      prompt:ItemPrompt(text:'5 - 2 = ?'),answer:['3'],distractors:['2','4','7']),
  Item(id:'mi28',skillId:'ms6',exerciseType:ExerciseType.pick_number,
      prompt:ItemPrompt(text:'8 - 3 = ?'),answer:['5'],distractors:['4','6','11']),
  Item(id:'mi29',skillId:'ms6',exerciseType:ExerciseType.pick_number,
      prompt:ItemPrompt(text:'10 - 4 = ?'),answer:['6'],distractors:['5','7','14']),
  Item(id:'mi30',skillId:'ms6',exerciseType:ExerciseType.pick_number,
      prompt:ItemPrompt(text:'7 - 5 = ?'),answer:['2'],distractors:['3','12','1']),
  Item(id:'mi31',skillId:'ms6',exerciseType:ExerciseType.pick_number,
      prompt:ItemPrompt(text:'9 - 6 = ?'),answer:['3'],distractors:['4','2','15']),

  // ms7 – Subtract within 20
  Item(id:'mi32',skillId:'ms7',exerciseType:ExerciseType.pick_number,
      prompt:ItemPrompt(text:'15 - 7 = ?'),answer:['8'],distractors:['7','9','6']),
  Item(id:'mi33',skillId:'ms7',exerciseType:ExerciseType.pick_number,
      prompt:ItemPrompt(text:'18 - 9 = ?'),answer:['9'],distractors:['8','7','11']),
  Item(id:'mi34',skillId:'ms7',exerciseType:ExerciseType.pick_number,
      prompt:ItemPrompt(text:'14 - 6 = ?'),answer:['8'],distractors:['7','9','10']),
  Item(id:'mi35',skillId:'ms7',exerciseType:ExerciseType.pick_number,
      prompt:ItemPrompt(text:'20 - 8 = ?'),answer:['12'],distractors:['11','13','10']),
  Item(id:'mi36',skillId:'ms7',exerciseType:ExerciseType.pick_number,
      prompt:ItemPrompt(text:'16 - 9 = ?'),answer:['7'],distractors:['6','8','9']),
];

// ─── HELPERS ───
final allDemoUnits = [...demoEnglishUnits, ...demoMathUnits, ...mathCambridgeUnits, ...englishCambridgeUnits];
final allDemoSkills = [...demoEnglishSkills, ...demoMathSkills, ...mathCambridgeSkills, ...englishCambridgeSkills];
final allDemoItems = [...demoEnglishItems, ...demoMathItems, ...mathCambridgeItems, ...englishCambridgeItems];

List<Item> itemsForSkill(String skillId) {
  return allDemoItems.where((i) => i.skillId == skillId).toList();
}

Skill? findSkill(String skillId) {
  try {
    return allDemoSkills.firstWhere((s) => s.id == skillId);
  } catch (_) {
    return null;
  }
}

Unit? findUnit(String unitId) {
  try {
    return allDemoUnits.firstWhere((u) => u.id == unitId);
  } catch (_) {
    return null;
  }
}
