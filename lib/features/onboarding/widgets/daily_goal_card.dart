import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../commons/widgets/app_tooltip_bubble.dart';
import '../../../core/constants/animation_constants.dart';
import '../../../core/constants/theme_constants.dart';
import '../../../core/localization/lang_keys.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/theme/colors.dart';
import '../../../utils/extensions/context_extensions.dart';
import '../models/models.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DAILY GOAL CARD
//
// Figma "Goal Setting" (62:9618) on the daily goal question: a card
// (Surface/Background Nuturel, radius 24, a Stroke/Dim/primary outline and a
// hard shadow 4 in Shadow/Primary/Lighter) with, 16 apart between 12 top and
// bottom and 16 side paddings:
//
//   1. Minute picker — a 58-high strip (Surface/Extra Dim/Primary, radius 12)
//      of goals, each its number in title/large over "Min" in label/medium,
//      65 apart. The strip scrolls sideways and always settles with one goal
//      in its middle, under a fixed 58 × 58 frame (Icons/primary, 1 wide with
//      a 6-deep bottom, like a key): that goal is picked, and its "Min" turns
//      Texts/primary (the others are Shades/neutral/400 in both themes). A
//      "Nice 👍" tooltip (AppTooltipBubble) points down at the frame from above
//      the card; it ducks away while the strip moves and pops back when it
//      settles. Tapping a goal scrolls it into the frame.
//   2. Time tabs — three equal tabs (label/large); the picked one sits on a
//      Surface/Primary pill (radius 8) that slides between them, its label in
//      Texts/On Surface/primary, the others in Texts/Heading. Each tab takes
//      taps 48 high although its pill is 34: the extra reaches into the space
//      around the tabs, which is taken out of the card's gap and padding.
//
// The strip's goals keep their order in RTL (the list starts at the right).
// Local state: the strip's scroll controller, the goal in the frame and
// whether the strip is moving.
// ─────────────────────────────────────────────────────────────────────────────
class DailyGoalCard extends StatelessWidget {
  const DailyGoalCard({
    super.key,
    required this.minutes,
    required this.initialMinutes,
    required this.onMinutesChanged,
    required this.times,
    required this.selectedTime,
    required this.onTimeChanged,
  });

  /// The goals the picker offers, in minutes.
  final List<int> minutes;

  /// The goal in the frame when the card first shows; one of [minutes].
  final int initialMinutes;

  /// Called with each goal that lands in the frame.
  final ValueChanged<int> onMinutesChanged;

  final List<PracticeTime> times;
  final PracticeTime selectedTime;
  final ValueChanged<PracticeTime> onTimeChanged;

  static const BorderRadius _radius = BorderRadius.all(Radius.circular(ThemeConstants.radius24));

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface.backgroundNeutral,
        borderRadius: _radius,
        border: AppBorders.outline(colors.stroke.dimPrimary),
        boxShadow: AppShadows.hard(colors.shadow.primaryLighter),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(
          ThemeConstants.spacing16,
          ThemeConstants.spacing12,
          ThemeConstants.spacing16,
          ThemeConstants.spacing12 - _tabTouchOverhang,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: ThemeConstants.spacing16 - _tabTouchOverhang,
          children: [
            // ── Minute picker ──
            _MinutePicker(minutes: minutes, initialMinutes: initialMinutes, onChanged: onMinutesChanged),

            // ── Time tabs ──
            _TimeTabs(times: times, selected: selectedTime, onSelected: onTimeChanged),
          ],
        ),
      ),
    );
  }
}

// ── Figma geometry ──
/// Height of the minute strip, and side of the frame over it.
const double _stripHeight = 58;

/// Distance between two goals' centres: a 29-wide goal and the 36 gap.
const double _goalExtent = 65;

/// The frame's outline: 1 wide on the top and sides, 6 on the bottom, drawn
/// outside its 58 × 58 box.
const double _frameSide = 1;
const double _frameBottom = 6;

/// The goals are two-digit numbers ("05").
const int _goalDigits = 2;

/// Height of the tabs' pill.
const double _tabHeight = 34;

/// How far a tab's 48-high tap area reaches above and below its pill.
const double _tabTouchOverhang = (ThemeConstants.minTapTarget - _tabHeight) / 2;

/// The strip of goals, the frame over its middle and the tooltip above.
class _MinutePicker extends StatefulWidget {
  const _MinutePicker({required this.minutes, required this.initialMinutes, required this.onChanged});

  final List<int> minutes;
  final int initialMinutes;
  final ValueChanged<int> onChanged;

  @override
  State<_MinutePicker> createState() => _MinutePickerState();
}

class _MinutePickerState extends State<_MinutePicker> {
  late int _index = widget.minutes.indexOf(widget.initialMinutes).clamp(0, widget.minutes.length - 1);
  late final ScrollController _controller = ScrollController(initialScrollOffset: _index * _goalExtent)
    ..addListener(_onScroll);

  /// Whether the strip is moving (dragged, flung or scrolled to a goal).
  bool _moving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Picks the goal nearest the frame as the strip moves, with a tick.
  void _onScroll() {
    final index = (_controller.offset / _goalExtent).round().clamp(0, widget.minutes.length - 1);
    if (index == _index) return;
    setState(() => _index = index);
    unawaited(HapticFeedback.selectionClick());
    widget.onChanged(widget.minutes[index]);
  }

  void _scrollTo(int index) => unawaited(
    _controller.animateTo(
      index * _goalExtent,
      duration: AnimationConstants.durationMedium,
      curve: AnimationConstants.curveStandard,
    ),
  );

  /// Tracks whether the strip is moving, to hide the tooltip meanwhile.
  bool _onScrollNotification(ScrollNotification notification) {
    final moving = switch (notification) {
      ScrollStartNotification() => true,
      ScrollEndNotification() => false,
      _ => _moving,
    };
    if (moving != _moving) setState(() => _moving = moving);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // ── Strip ──
        NotificationListener<ScrollNotification>(
          onNotification: _onScrollNotification,
          child: _GoalStrip(controller: _controller, minutes: widget.minutes, picked: _index, onTap: _scrollTo),
        ),

        // ── Frame ──
        const Positioned.fill(
          child: IgnorePointer(child: Center(child: _Frame())),
        ),

        // ── Tooltip ──
        // Its pill sits on the strip's top edge, the tail pointing down at the
        // frame.
        PositionedDirectional(
          top: 0,
          start: 0,
          end: 0,
          child: IgnorePointer(
            child: Center(
              child: FractionalTranslation(
                translation: const Offset(0, _raiseByOwnHeight),
                child: AnimatedScale(
                  scale: _moving ? _tooltipHidden : _tooltipShown,
                  alignment: Alignment.bottomCenter,
                  duration: AnimationConstants.bubblePop,
                  curve: _moving ? AnimationConstants.curveStandard : AnimationConstants.curvePop,
                  child: AppTooltipBubble(LangKeys.dailyGoalCheer.tr),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Moves the tooltip up by its own height.
const double _raiseByOwnHeight = -1;

const double _tooltipHidden = 0;
const double _tooltipShown = 1;

/// The rounded strip with the goals scrolling in it. Padded by half its width
/// less half a goal on each side, so every goal (the first and last too) can
/// stop in the middle; offset `i × 65` puts goal `i` there.
class _GoalStrip extends StatelessWidget {
  const _GoalStrip({required this.controller, required this.minutes, required this.picked, required this.onTap});

  final ScrollController controller;
  final List<int> minutes;
  final int picked;
  final ValueChanged<int> onTap;

  static const BorderRadius _radius = BorderRadius.all(Radius.circular(ThemeConstants.radius12));

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: context.colors.surface.extraDimPrimary, borderRadius: _radius),
      child: ClipRRect(
        borderRadius: _radius,
        child: SizedBox(
          height: _stripHeight,
          child: LayoutBuilder(
            builder: (context, constraints) => ListView.builder(
              controller: controller,
              scrollDirection: Axis.horizontal,
              physics: const _SnapToGoalPhysics(),
              padding: EdgeInsetsDirectional.symmetric(horizontal: (constraints.maxWidth - _goalExtent) / 2),
              itemExtent: _goalExtent,
              itemCount: minutes.length,
              itemBuilder: (context, index) =>
                  _Goal(minutes: minutes[index], picked: index == picked, onTap: () => onTap(index)),
            ),
          ),
        ),
      ),
    );
  }
}

/// One goal: its number over "Min", scaled down to fit the strip at large
/// text sizes.
class _Goal extends StatelessWidget {
  const _Goal({required this.minutes, required this.picked, required this.onTap});

  final int minutes;
  final bool picked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Semantics(
      button: true,
      selected: picked,
      inMutuallyExclusiveGroup: true,
      label: LangKeys.dailyGoalMinutes.trParams({'count': '$minutes'}),
      onTap: onTap,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(minutes.toString().padLeft(_goalDigits, '0'), maxLines: 1, style: textTheme.titleLarge),
                Text(
                  LangKeys.dailyGoalMinutesUnit.tr,
                  maxLines: 1,
                  style: textTheme.labelMedium?.copyWith(
                    color: picked ? context.colors.text.primary : AppColors.neutral400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Settles a fling or drag with a goal in the middle: where the strip would
/// come to rest, rounded to the nearest goal.
class _SnapToGoalPhysics extends ScrollPhysics {
  const _SnapToGoalPhysics({super.parent});

  @override
  _SnapToGoalPhysics applyTo(ScrollPhysics? ancestor) => _SnapToGoalPhysics(parent: buildParent(ancestor));

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    // Past either end the parent physics brings the strip back first.
    if ((velocity <= 0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }
    final tolerance = toleranceFor(position);
    final resting = super.createBallisticSimulation(position, velocity)?.x(double.infinity) ?? position.pixels;
    final target = ((resting / _goalExtent).round() * _goalExtent).clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );
    if ((target - position.pixels).abs() < tolerance.distance && velocity.abs() < tolerance.velocity) return null;
    return ScrollSpringSimulation(spring, position.pixels, target, velocity, tolerance: tolerance);
  }
}

/// The fixed frame over the strip's middle.
class _Frame extends StatelessWidget {
  const _Frame();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size.square(_stripHeight),
      painter: _FramePainter(color: context.colors.icon.primary),
    );
  }
}

/// Paints the frame's outline outside its box: the ring between the box
/// (radius 12) and the box grown by the outline widths, whose corners grow
/// with them (13 at the top, 13 × 18 at the bottom), as Figma draws an
/// outside stroke of mixed widths.
class _FramePainter extends CustomPainter {
  const _FramePainter({required this.color});

  final Color color;

  static const Radius _inner = Radius.circular(ThemeConstants.radius12);
  static const Radius _outerTop = Radius.circular(ThemeConstants.radius12 + _frameSide);
  static const Radius _outerBottom = Radius.elliptical(
    ThemeConstants.radius12 + _frameSide,
    ThemeConstants.radius12 + _frameBottom,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final inner = RRect.fromRectAndRadius(Offset.zero & size, _inner);
    final outer = RRect.fromLTRBAndCorners(
      -_frameSide,
      -_frameSide,
      size.width + _frameSide,
      size.height + _frameBottom,
      topLeft: _outerTop,
      topRight: _outerTop,
      bottomLeft: _outerBottom,
      bottomRight: _outerBottom,
    );
    canvas.drawDRRect(outer, inner, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_FramePainter oldDelegate) => oldDelegate.color != color;
}

/// The three time tabs with the pill sliding under the picked one.
class _TimeTabs extends StatelessWidget {
  const _TimeTabs({required this.times, required this.selected, required this.onSelected});

  final List<PracticeTime> times;
  final PracticeTime selected;
  final ValueChanged<PracticeTime> onSelected;

  static const BorderRadius _pillRadius = BorderRadius.all(Radius.circular(ThemeConstants.radius8));

  /// The pill's alignment for the picked tab: -1 at the start, 1 at the end.
  double get _pillX => times.length < 2 ? 0 : times.indexOf(selected) / (times.length - 1) * 2 - 1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ThemeConstants.minTapTarget,
      child: Stack(
        children: [
          // ── Pill ──
          Positioned.fill(
            top: _tabTouchOverhang,
            bottom: _tabTouchOverhang,
            child: AnimatedAlign(
              alignment: AlignmentDirectional(_pillX, 0),
              duration: AnimationConstants.durationMedium,
              curve: AnimationConstants.curveStandard,
              child: FractionallySizedBox(
                widthFactor: 1 / times.length,
                heightFactor: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: context.colors.surface.primary, borderRadius: _pillRadius),
                ),
              ),
            ),
          ),

          // ── Tabs ──
          Row(
            children: [
              for (final time in times)
                Expanded(
                  child: _TimeTab(label: time.labelKey.tr, selected: time == selected, onTap: () => onSelected(time)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// One tab's label and tap area, the label scaled down to fit its third of
/// the row at large text sizes.
class _TimeTab extends StatelessWidget {
  const _TimeTab({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  static const EdgeInsetsDirectional _padding = EdgeInsetsDirectional.symmetric(horizontal: ThemeConstants.spacing16);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      selected: selected,
      inMutuallyExclusiveGroup: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: _padding,
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: AnimatedDefaultTextStyle(
                style: Theme.of(context).textTheme.labelLarge!
                    .copyWith(color: selected ? colors.text.onPrimary : colors.text.heading),
                duration: AnimationConstants.durationMedium,
                curve: AnimationConstants.curveStandard,
                child: Text(label, maxLines: 1),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
