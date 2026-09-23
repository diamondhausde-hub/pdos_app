import 'package:flutter/material.dart';

class SlideTransitionRoute extends PageRouteBuilder {
  final Widget page;
  final AxisDirection direction;

  SlideTransitionRoute({required this.page, this.direction = AxisDirection.up})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset.zero;
            switch (direction) {
              case AxisDirection.up:
                begin = const Offset(0, 0.08);
                break;
              case AxisDirection.down:
                begin = const Offset(0, -0.08);
                break;
              case AxisDirection.left:
                begin = const Offset(0.08, 0);
                break;
              case AxisDirection.right:
                begin = const Offset(-0.08, 0);
                break;
            }
            return SlideTransition(
              position: Tween<Offset>(
                begin: begin,
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
                reverseCurve: Curves.easeInCubic,
              )),
              child: FadeTransition(
                opacity: Tween<double>(begin: 0, end: 1).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOut,
                  ),
                ),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 300),
        );
}
