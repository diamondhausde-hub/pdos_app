import 'package:flutter/material.dart';
import '../theme/theme.dart';
import 'package:pdos_app/core/theme/app_colors.dart';

class NavBarItemData {
  final IconData icon;
  final int badgeCount;
  final String? label;
  const NavBarItemData({required this.icon, this.badgeCount = 0, this.label});
}

class AnimatedNavBar extends StatelessWidget {
  final int currentIndex;
  final List<NavBarItemData> items;
  final ValueChanged<int> onItemSelected;
  final Widget? centerItem;

  const AnimatedNavBar({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onItemSelected,
    this.centerItem,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withValues(alpha: 0.08),
            blurRadius: 40,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final actualWidth = constraints.maxWidth;
              
              int totalSlots = items.length;
              if (centerItem != null) {
                totalSlots++;
              }
              
              final slotWidth = actualWidth / totalSlots;
              
              // Calculate target slot index
              int activeSlot = currentIndex;
              if (centerItem != null && currentIndex >= (items.length ~/ 2)) {
                activeSlot = currentIndex + 1;
              }
              
              final pillCenter = (activeSlot * slotWidth) + (slotWidth / 2);
              final pillLeft = pillCenter - 28; // 28 is half of the pill width (56/2)

              return SizedBox(
                height: 56,
                child: Stack(
                  children: [
                    // Animated Pill
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutBack,
                      left: pillLeft,
                      top: 0,
                      width: 56,
                      height: 56,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    
                    // Row of items
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: _buildRow(context),
                    ),
                  ],
                ),
              );
            }
          ),
        ),
      ),
    );
  }

  List<Widget> _buildRow(BuildContext context) {
    final children = <Widget>[];
    final half = items.length ~/ 2;

    if (centerItem != null) {
      for (int i = 0; i < half; i++) {
        children.add(Expanded(child: _navItem(context, i)));
      }
      
      // The center + button
      children.add(
        Expanded(
          child: Transform.translate(
            offset: const Offset(0, -8),
            child: SizedBox(
              width: 52,
              height: 52,
              child: centerItem,
            ),
          ),
        ),
      );

      for (int i = half; i < items.length; i++) {
        children.add(Expanded(child: _navItem(context, i)));
      }
    } else {
      for (int i = 0; i < items.length; i++) {
        children.add(Expanded(child: _navItem(context, i)));
      }
    }

    return children;
  }

  Widget _navItem(BuildContext context, int index) {
    final isActive = currentIndex == index;
    final item = items[index];

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onItemSelected(index),
      child: Container(
        height: 56,
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Icon
            AnimatedScale(
              scale: isActive ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                item.icon,
                size: 24,
                color: isActive
                    ? AppColors.primary
                    : AppColors.onSurfaceVariant,
              ),
            ),
            
            if (item.badgeCount > 0)
              Positioned(
                right: -8,
                top: -8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    item.badgeCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
