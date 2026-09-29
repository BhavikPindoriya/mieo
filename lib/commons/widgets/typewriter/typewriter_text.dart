import 'package:flutter/material.dart';

import '../highlighted_text.dart';
import 'typewriter_schedule.dart';

// ─────────────────────────────────────────────────────────────────────────────
// TYPEWRITER TEXT
//
// A text that types itself out (HighlightedText markers work as usual): after
// [TypewriterText.delay], its characters appear one by one on a
// TypewriterSchedule, a beat each and a longer one after a phrase.
//
// The whole text is laid out from the start (the untyped rest transparent),
// so the widget never changes size or reflows, and a screen reader reads the
// whole text at once. With animations turned off (MediaQuery
// .disableAnimationsOf), the text shows straight away.
//
// State: one AnimationController that runs once through the delay and the
// typing time, the schedule, and how many characters show, a ValueNotifier
// the controller updates on every frame but that only notifies (and rebuilds
// the paragraph) when a character appears. A new text or delay while typing
// shows the text in full.
// ─────────────────────────────────────────────────────────────────────────────
class TypewriterText extends StatefulWidget {
  const TypewriterText(this.text, {super.key, this.style, this.textAlign, this.delay = Duration.zero});

  /// The text, with any accent words between HighlightedText markers.
  final String text;

  final TextStyle? style;

  final TextAlign? textAlign;

  /// How long the text stays blank before the first character appears.
  final Duration delay;

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> with SingleTickerProviderStateMixin {
  late TypewriterSchedule _schedule;
  late final AnimationController _controller;

  /// UTF-16 code units of the plain text shown so far.
  final ValueNotifier<int> _visible = ValueNotifier(0);

  String get _plainText => HighlightedText(widget.text).plainText;

  Duration get _duration => widget.delay + _schedule.duration;

  @override
  void initState() {
    super.initState();
    _schedule = TypewriterSchedule(_plainText);
    _controller = AnimationController(vsync: this, duration: _duration)
      ..addListener(_reveal)
      ..forward();
    _reveal();
  }

  /// Shows the characters due at the controller's point in the delay and
  /// typing time.
  void _reveal() => _visible.value = _schedule.visibleLength(_duration * _controller.value - widget.delay);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) _controller.value = 1;
  }

  @override
  void didUpdateWidget(TypewriterText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text == widget.text && oldWidget.delay == widget.delay) return;
    _schedule = TypewriterSchedule(_plainText);
    _controller
      ..duration = _duration
      ..value = 1;
  }

  @override
  void dispose() {
    _controller.dispose();
    _visible.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _visible,
      builder: (context, visible, _) =>
          HighlightedText(widget.text, style: widget.style, textAlign: widget.textAlign, visibleLength: visible),
    );
  }
}
