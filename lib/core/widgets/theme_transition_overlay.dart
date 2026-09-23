import 'package:flutter/material.dart';

/// Global singleton access — screens call this directly without needing
/// a context ancestor lookup across MaterialApp boundaries.
class ThemeTransitionController {
  static ThemeTransitionOverlayState? _state;
  static void _register(ThemeTransitionOverlayState s) => _state = s;
  static void _unregister(ThemeTransitionOverlayState s) {
    if (_state == s) _state = null;
  }

  /// Call from anywhere to trigger the circular reveal animation.
  static Future<void> animate({
    required Offset globalOrigin,
    required bool toDark,
    required VoidCallback onSwitch,
  }) async {
    final s = _state;
    if (s == null || !s.mounted) {
      onSwitch(); // fallback — just switch with no animation
      return;
    }
    await s.animateThemeChange(
      globalOrigin: globalOrigin,
      toDark: toDark,
      onSwitch: onSwitch,
    );
  }
}

// ---------------------------------------------------------------------------

/// Place this once inside MaterialApp.builder, wrapping the child.
/// It registers itself globally so any screen can trigger the animation.
class ThemeTransitionOverlay extends StatefulWidget {
  final Widget child;
  const ThemeTransitionOverlay({super.key, required this.child});

  @override
  State<ThemeTransitionOverlay> createState() => ThemeTransitionOverlayState();
}

class ThemeTransitionOverlayState extends State<ThemeTransitionOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  bool _animating = false;
  Offset _localOrigin = Offset.zero;
  Color _circleColor = Colors.black;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this);
    ThemeTransitionController._register(this);
  }

  @override
  void dispose() {
    ThemeTransitionController._unregister(this);
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> animateThemeChange({
    required Offset globalOrigin,
    required bool toDark,
    required VoidCallback onSwitch,
  }) async {
    if (_animating) {
      onSwitch();
      return;
    }

    // Use global coordinates directly — overlay covers the full screen
    setState(() {
      _localOrigin = globalOrigin;
      _circleColor =
          toDark ? const Color(0xFF080C14) : const Color(0xFFF2F4FA);
      _animating = true;
    });

    _ctrl.value = 0.0;

    // Phase 1: expand circle to cover screen
    await _ctrl.animateTo(
      0.5,
      duration: const Duration(milliseconds: 270),
      curve: Curves.easeIn,
    );

    // Theme switches here — hidden under the fully-expanded circle
    onSwitch();
    await Future.delayed(const Duration(milliseconds: 30));

    // Phase 2: shrink circle to reveal new theme
    await _ctrl.animateTo(
      1.0,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOut,
    );

    if (mounted) {
      setState(() => _animating = false);
      _ctrl.value = 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        if (_animating)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _ctrl,
                builder: (ctx, _) => CustomPaint(
                  painter: _CirclePainter(
                    origin: _localOrigin,
                    progress: _ctrl.value,
                    color: _circleColor,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------

class _CirclePainter extends CustomPainter {
  final Offset origin;
  final double progress; // 0→0.5 expand, 0.5→1.0 shrink
  final Color color;

  const _CirclePainter({
    required this.origin,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final maxR = _maxRadius(size, origin);
    final double radius;
    if (progress <= 0.5) {
      radius = maxR * (progress / 0.5);
    } else {
      radius = maxR * (1.0 - (progress - 0.5) / 0.5);
    }
    if (radius <= 0) return;
    canvas.drawCircle(origin, radius, Paint()..color = color);
  }

  double _maxRadius(Size size, Offset o) {
    final corners = [
      Offset.zero,
      Offset(size.width, 0),
      Offset(0, size.height),
      Offset(size.width, size.height),
    ];
    return corners.map((c) => (c - o).distance).reduce((a, b) => a > b ? a : b);
  }

  @override
  bool shouldRepaint(_CirclePainter old) =>
      old.progress != progress || old.origin != origin || old.color != color;
}
