import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../core/theme/theme.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/utils/image_url_helper.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/models/product_model.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final ProductModel product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  final _noteController = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final p = widget.product;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(isDark),
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg(isDark),
        surfaceTintColor: Colors.transparent,
        foregroundColor: AppColors.onSurface,
        title: Text(p.name, style: AppTextStyles.headlineSm),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero image section
            Container(
              height: 280,
              width: double.infinity,
              color: AppColors.surfaceContainerLow,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  p.imageUrl != null
                      ? ClipRRect(
                          child: Image.network(
                            fullImageUrl(p.imageUrl),
                            fit: BoxFit.contain,
                            errorBuilder: (c, e, s) => _placeholder(),
                          ),
                        )
                      : _placeholder(),
                  Positioned(
                    top: 16, right: 16,
                    child: _buildBadge(p),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow('Category', p.category ?? 'General'),
                  const SizedBox(height: 12),
                  _infoRow('Stock', '${p.stockQty} units'),
                  const SizedBox(height: 12),
                  _infoRow('Min Threshold', '${p.minThreshold}'),
                  if (p.unitPrice != null) ...[
                    const SizedBox(height: 12),
                    _infoRow('Price', '${p.unitPrice} IQD'),
                  ],
                  if (p.barcode != null && p.barcode!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _infoRow('Barcode', p.barcode!),
                  ],
                  if (p.expiryDate != null) ...[
                    const SizedBox(height: 12),
                    _infoRow('Expiry', '${p.expiryDate!.toLocal()}'.split(' ')[0]),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Note to supervisor
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppStrings.noteToSupervisor,
                        style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600, color: AppColors.onSurface)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _noteController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: AppStrings.writeANoteAbout,
                        hintStyle: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: AppColors.inputFill(isDark),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                      style: AppTextStyles.bodyMd,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _sending ? null : _sendReport,
                        icon: _sending
                            ? SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onPrimary))
                            : Icon(Icons.send_rounded, size: 18),
                        label: Text(_sending ? 'Sending...' : 'Send to Supervisor'),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: AppColors.surfaceContainerLow,
      child: Center(
        child: Icon(Icons.medication_rounded, size: 80, color: AppColors.primary),
      ),
    );
  }

  Widget _buildBadge(ProductModel p) {
    if (p.isExpired) {
      return _badgeChip('Expired', AppColors.error);
    }
    if (p.isExpiringSoon) {
      return _badgeChip('Expiring Soon', AppColors.warning);
    }
    if (p.isLowStock) {
      return _badgeChip('Low Stock', AppColors.warning);
    }
    return const SizedBox.shrink();
  }

  Widget _badgeChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(label,
          style: AppTextStyles.labelSm.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          )),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
        Text(value, style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600, color: AppColors.onSurface)),
      ],
    );
  }

  Future<void> _sendReport() async {
    final note = _noteController.text.trim();
    if (note.isEmpty) return;

    setState(() => _sending = true);
    try {
      final api = ref.read(apiServiceProvider);
      await api.dio.post('/products/${widget.product.id}/report', data: {'content': note});
      _noteController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.reportSentToSupervisor)),
        );
      }
    } on DioException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.response?.data['detail']?.toString() ?? 'Failed to send report')),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }
}
