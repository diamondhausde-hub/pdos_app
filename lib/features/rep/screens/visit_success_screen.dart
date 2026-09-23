import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme.dart';
import '../services/visit_pdf_service.dart';
import '../../shared/widgets/schedule_appointment_sheet.dart';

class VisitSuccessScreen extends ConsumerStatefulWidget {
  final String repName;
  final String targetName;
  final String? clientId;
  final DateTime visitDate;
  final List<Map<String, dynamic>> salesItems;
  final List<Map<String, dynamic>> stockChecks;
  final List<String> photos;
  final List<dynamic> expenses;
  final List<dynamic> specialRequests;
  final String? notes;
  final String? signaturePath;

  const VisitSuccessScreen({
    super.key,
    required this.repName,
    required this.targetName,
    this.clientId,
    required this.visitDate,
    required this.salesItems,
    required this.stockChecks,
    this.photos = const [],
    required this.expenses,
    required this.specialRequests,
    this.notes,
    this.signaturePath,
  });

  @override
  ConsumerState<VisitSuccessScreen> createState() => _VisitSuccessScreenState();
}

class _VisitSuccessScreenState extends ConsumerState<VisitSuccessScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _pdfSlideAnimation;
  late Animation<Offset> _scheduleSlideAnimation;
  late Animation<double> _pdfFadeAnimation;
  late Animation<double> _scheduleFadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000), // Extended for sequence
    );

    // Checkmark pop
    _scaleAnimation = CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.3, curve: Curves.elasticOut));
    
    // Text fade in
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: const Interval(0.3, 0.5, curve: Curves.easeIn));
    
    // PDF Button slides and fades in first
    _pdfSlideAnimation = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.5, 0.7, curve: Curves.easeOutCubic)),
    );
    _pdfFadeAnimation = CurvedAnimation(parent: _controller, curve: const Interval(0.5, 0.7, curve: Curves.easeIn));

    // Schedule Button slides and fades in after PDF
    _scheduleSlideAnimation = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.7, 0.9, curve: Curves.easeOutCubic)),
    );
    _scheduleFadeAnimation = CurvedAnimation(parent: _controller, curve: const Interval(0.7, 0.9, curve: Curves.easeIn));
    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check_circle_rounded, size: 80, color: AppColors.success),
                  ),
                ),
                const SizedBox(height: 32),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Text(
                        'Visit Completed!',
                        style: AppTextStyles.headlineLg.copyWith(color: AppColors.success, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your visit report has been saved and synced.',
                        style: AppTextStyles.bodyLg.copyWith(color: AppColors.onSurfaceVariant),
                        textAlign: TextAlign.center,
                      ),
                      if (widget.photos.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text('${widget.photos.length} photo${widget.photos.length == 1 ? '' : 's'} taken', style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
                      ],
                      const SizedBox(height: 48),
                      // Actions
                      SlideTransition(
                        position: _pdfSlideAnimation,
                        child: FadeTransition(
                          opacity: _pdfFadeAnimation,
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.picture_as_pdf_rounded),
                            label: Text(AppStrings.downloadSharePdf),
                            onPressed: () async {
                              try {
                                final path = await VisitPdfService.generateAndShareVisitPdf(
                                  repName: widget.repName,
                                  targetName: widget.targetName,
                                  visitDate: widget.visitDate,
                                  salesItems: widget.salesItems,
                                  stockChecks: widget.stockChecks,
                                  expenses: widget.expenses,
                                  specialRequests: widget.specialRequests,
                                  photos: widget.photos,
                                  notes: widget.notes,
                                  signaturePath: widget.signaturePath,
                                );
                                if (context.mounted && path != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('PDF saved: $path'), backgroundColor: AppColors.success),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('PDF Error: $e'), backgroundColor: Colors.red),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 56),
                              backgroundColor: AppColors.primary,
                              elevation: 4,
                              shadowColor: AppColors.primary.withValues(alpha: 0.4),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SlideTransition(
                        position: _scheduleSlideAnimation,
                        child: FadeTransition(
                          opacity: _scheduleFadeAnimation,
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.calendar_month_rounded),
                            label: Text(AppStrings.scheduleFollowUp),
                            onPressed: () {
                              showScheduleAppointmentSheet(
                                context,
                                ref,
                                initialClientId: widget.clientId,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 56),
                              backgroundColor: AppColors.secondary,
                              elevation: 4,
                              shadowColor: AppColors.secondary.withValues(alpha: 0.4),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      FadeTransition(
                        opacity: _scheduleFadeAnimation, // Fade with the last button
                        child: TextButton(
                          onPressed: () => context.go('/rep/my-day'),
                          style: TextButton.styleFrom(
                            minimumSize: const Size(double.infinity, 56),
                          ),
                          child: Text(AppStrings.done, style: AppTextStyles.labelLg.copyWith(color: AppColors.onSurfaceVariant)),
                        ),
                      ),
                    ],
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
