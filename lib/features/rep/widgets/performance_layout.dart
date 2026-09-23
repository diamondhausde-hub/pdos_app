import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PerformanceLayout extends StatelessWidget {
  final int currentIndex;
  final Widget child;
  final String title;

  const PerformanceLayout({
    super.key,
    required this.currentIndex,
    required this.child,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/rep/my-day');
            }
          },
        ),
      ),
      body: child,
    );
  }
}
