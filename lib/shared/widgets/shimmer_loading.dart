import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import 'package:pdos_app/core/theme/app_colors.dart';

class ShimmerLoading extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerLoading({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius = 12,
    this.baseColor,
    this.highlightColor,
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value + 1, 0),
              colors: [
                widget.baseColor ?? (isDark ? Color(0xFF1E2030) : AppColors.surfaceContainerHigh),
                widget.highlightColor ?? (isDark ? Color(0xFF2A2D40) : AppColors.surfaceContainer),
                widget.baseColor ?? (isDark ? Color(0xFF1E2030) : AppColors.surfaceContainerHigh),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.15)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerLoading(width: 140, height: 14),
          SizedBox(height: 14),
          ShimmerLoading(width: 100, height: 32),
          SizedBox(height: 10),
          ShimmerLoading(width: 80, height: 14),
        ],
      ),
    );
  }
}

class ShimmerDashboard extends StatelessWidget {
  const ShimmerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(20),
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        ShimmerLoading(width: 220, height: 18),
        SizedBox(height: 28),
        ShimmerLoading(height: 100),
        SizedBox(height: 16),
        ShimmerLoading(height: 100),
        SizedBox(height: 16),
        ShimmerLoading(height: 220),
        SizedBox(height: 16),
        ShimmerLoading(height: 140),
      ],
    );
  }
}
