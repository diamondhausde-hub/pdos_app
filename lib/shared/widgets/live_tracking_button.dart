import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../core/theme/theme.dart';

class LiveTrackingButton extends StatefulWidget {
  final bool isTracking;
  final Future<void> Function(bool) onToggle;

  const LiveTrackingButton({
    super.key,
    required this.isTracking,
    required this.onToggle,
  });

  @override
  State<LiveTrackingButton> createState() => _LiveTrackingButtonState();
}

class _LiveTrackingButtonState extends State<LiveTrackingButton>
    with TickerProviderStateMixin {
  late AnimationController _animController;
  bool _isLoading = false;

  late Animation<double> _widthAnim;
  late Animation<double> _circleRotate;
  late Animation<double> _circleScale;
  late Animation<double> _fillHeight;
  late Animation<double> _dotRotation;
  late Animation<double> _circleOpacity;
  late Animation<double> _startTextOpacity;
  late Animation<double> _liveTextOpacity;
  late Animation<Color?> _borderColor;

  @override
  void initState() {
    super.initState();
    // Fixed duration for perfect consistency (2000ms = 2 seconds)
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // 0.0 to 0.15 -> Shrink to 34
    // 0.85 to 1.0 -> Expand to 90
    _widthAnim = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 96.0, end: 34.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 15.0,
      ),
      TweenSequenceItem(tween: ConstantTween(34.0), weight: 70.0),
      TweenSequenceItem(
        tween: Tween(begin: 34.0, end: 104.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 15.0,
      ),
    ]).animate(_animController);

    // Rotate circle 180deg (pi) in first 15%
    _circleRotate = Tween<double>(begin: 0, end: math.pi).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.15, curve: Curves.easeOut),
      ),
    );

    // Pulse circle in first 30%
    _circleScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.95), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 0.95, end: 1.05), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0), weight: 30),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 700),
    ]).animate(CurvedAnimation(
        parent: _animController, curve: const Interval(0.0, 0.3)));

    // Fill height (15% to 85%)
    _fillHeight = Tween<double>(begin: 0, end: 27).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.15, 0.85, curve: Curves.easeInOut),
      ),
    );

    // Dot rotation (15% to 85%)
    _dotRotation = Tween<double>(begin: -math.pi / 2, end: 1.5 * math.pi).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.15, 0.85, curve: Curves.easeInOut),
      ),
    );

    // Circle disappears at end (85% to 95%)
    _circleOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.85, 0.95, curve: Curves.easeOut),
      ),
    );

    // Start text fades out in first 15%
    _startTextOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.15, curve: Curves.easeOut),
      ),
    );

    // Live text fades in at end (85% to 100%)
    _liveTextOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.85, 1.0, curve: Curves.easeOut),
      ),
    );

    // Border turns green at end
    _borderColor = ColorTween(
      begin: AppColors.error,
      end: AppColors.success,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.85, 1.0, curve: Curves.easeOut),
      ),
    );

    if (widget.isTracking) {
      _animController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant LiveTrackingButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isTracking != oldWidget.isTracking) {
      if (widget.isTracking) {
        _animController.forward();
      } else {
        _animController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (_animController.isAnimating || _isLoading) return;

    // Prevent double taps while network request is pending
    setState(() => _isLoading = true);
    widget.onToggle(!widget.isTracking).whenComplete(() {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _animController,
        builder: (context, child) {
          final double currentWidth = _widthAnim.value;
          final bool showDot = _animController.value >= 0.15 &&
              _animController.value <= 0.85;
          return SizedBox(
            width: currentWidth,
            height: 34,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Main Button Outline
                Container(
                  width: currentWidth,
                  height: 34,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17),
                    border: Border.all(
                      color: _borderColor.value ?? AppColors.error,
                      width: 2,
                    ),
                    color: Colors.transparent,
                  ),
                ),
                // "Live" text (Start)
                if (_startTextOpacity.value > 0)
                  Positioned(
                    right: 12,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Opacity(
                        opacity: _startTextOpacity.value,
                        child: Text(
                          'Live',
                          style: AppTextStyles.labelSm.copyWith(
                            color: AppColors.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                // "Live ON" text (End)
                if (_liveTextOpacity.value > 0)
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Opacity(
                        opacity: _liveTextOpacity.value,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.success,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Live ON',
                                style: AppTextStyles.labelSm.copyWith(
                                  color: AppColors.success,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                // Inner Circle
                if (_circleOpacity.value > 0)
                  Positioned(
                    left: 4,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Opacity(
                        opacity: _circleOpacity.value,
                        child: Transform.scale(
                          scale: _circleScale.value,
                          child: Transform.rotate(
                            angle: _circleRotate.value,
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: const BoxDecoration(
                                color: AppColors.error,
                                shape: BoxShape.circle,
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Fill animation from bottom
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    height: _fillHeight.value,
                                    child: Container(
                                      color: const Color(0xFF8B2828),
                                    ),
                                  ),
                                  // Icons
                                  Opacity(
                                    opacity: (1.0 - _circleRotate.value / math.pi)
                                        .clamp(0.0, 1.0),
                                    child: Icon(
                                      Icons.play_arrow_rounded,
                                      color: AppColors.onPrimary,
                                      size: 16,
                                    ),
                                  ),
                                  Opacity(
                                    opacity: (_circleRotate.value / math.pi)
                                        .clamp(0.0, 1.0),
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: AppColors.onPrimary,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                // Spinning Dot
                if (showDot)
                  Align(
                    alignment: Alignment.center,
                    child: Transform.rotate(
                      angle: _dotRotation.value,
                      child: Transform.translate(
                        offset: const Offset(15, 0),
                        child: Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
