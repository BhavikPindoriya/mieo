import 'package:flutter/widgets.dart';

import '../../../core/constants/animation_constants.dart';

// ─────────────────────────────────────────────────────────────────────────────
// TYPEWRITER SCHEDULE
//
// When each character of a text appears as it types itself out. Time runs in
// steps of AnimationConstants.typewriterCharacter: a character takes one step,
// and a punctuation mark that ends a phrase (followed by a space: "Yey..! I",
// "Questions. Please") holds the next character back for [pauseSteps], so the
// line reads like speech.
//
// A character is a grapheme cluster (a letter with its combining marks, an
// emoji), never half of one, so Urdu and emoji type cleanly. Offsets are
// UTF-16 code units, the unit TextSpan and TextPainter count in.
// ─────────────────────────────────────────────────────────────────────────────
@immutable
class TypewriterSchedule {
  /// Schedules [text] as it reads on screen (HighlightedText.plainText).
  factory TypewriterSchedule(String text) {
    final characters = text.characters.toList();
    final ends = <int>[];
    final appearSteps = <int>[];
    var end = 0;
    var step = 0;
    for (final (index, character) in characters.indexed) {
      appearSteps.add(step);
      end += character.length;
      ends.add(end);
      final endsPhrase =
          _phraseEnds.contains(character) && index + 1 < characters.length && characters[index + 1].trim().isEmpty;
      step += endsPhrase ? pauseSteps : 1;
    }
    return TypewriterSchedule._(ends, appearSteps);
  }

  const TypewriterSchedule._(this._ends, this._appearSteps);

  /// Steps the character after a phrase-ending punctuation mark waits.
  static const int pauseSteps = 4;

  /// Punctuation that ends a phrase: Latin, and the Urdu full stop, question
  /// mark and comma.
  static const Set<String> _phraseEnds = {'.', '!', '?', '…', ',', '۔', '؟', '،'};

  /// UTF-16 end offset of each character.
  final List<int> _ends;

  /// The step at which each character appears.
  final List<int> _appearSteps;

  /// From the first character appearing to one step after the last.
  Duration get duration =>
      _appearSteps.isEmpty ? Duration.zero : AnimationConstants.typewriterCharacter * (_appearSteps.last + 1);

  /// How many UTF-16 code units show [elapsed] after typing starts: the whole
  /// characters whose step has come (the first shows at once).
  int visibleLength(Duration elapsed) {
    if (elapsed.isNegative) return 0;
    final step = elapsed.inMicroseconds ~/ AnimationConstants.typewriterCharacter.inMicroseconds;
    // The appear steps rise, so the characters shown are those up to the
    // last one whose step is at most [step].
    var low = 0;
    var high = _appearSteps.length;
    while (low < high) {
      final middle = (low + high) ~/ 2;
      if (_appearSteps[middle] <= step) {
        low = middle + 1;
      } else {
        high = middle;
      }
    }
    return low == 0 ? 0 : _ends[low - 1];
  }
}
