import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/theme.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/local_db/app_database.dart';

class QuickScanScreen extends ConsumerStatefulWidget {
  const QuickScanScreen({super.key});

  @override
  ConsumerState<QuickScanScreen> createState() => _QuickScanScreenState();
}

class _QuickScanScreenState extends ConsumerState<QuickScanScreen> {
  final MobileScannerController _controller = MobileScannerController();
  bool _isShowingSheet = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) async {
    if (_isShowingSheet) return;
    
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? code = barcodes.first.rawValue;
    if (code == null) return;

    setState(() => _isShowingSheet = true);
    
    // Pause scanner while showing sheet
    _controller.pause();

    // Look up the product in local DB
    final db = ref.read(appDatabaseProvider);
    final LocalProduct? product = await (db.select(db.localProducts)
          ..where((t) => t.barcode.equals(code)))
        .getSingleOrNull();

    if (!mounted) return;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return _ProductDetailsSheet(
          barcode: code,
          product: product,
        );
      },
    );

    if (mounted) {
      setState(() => _isShowingSheet = false);
      _controller.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onSurface,
      appBar: AppBar(
        title: Text(AppStrings.quickProductScan, style: TextStyle(color: AppColors.onPrimary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.onPrimary),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        alignment: Alignment.center,
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),
          
          // Scanner overlay frame
          Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary, width: 3),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          Positioned(
            bottom: 60,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.onSurfaceVariant,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Align barcode within the frame',
                style: TextStyle(color: AppColors.onPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductDetailsSheet extends StatelessWidget {
  final String barcode;
  final LocalProduct? product;

  const _ProductDetailsSheet({
    required this.barcode,
    this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (product == null) ...[
            Center(
              child: Icon(Icons.error_outline_rounded, size: 64, color: AppColors.error),
            ),
            const SizedBox(height: 16),
            Text(
              'Product Not Found',
              style: AppTextStyles.headlineMd.copyWith(color: AppColors.error),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'The barcode $barcode is not in the local product catalog. Please ensure the admin has linked this barcode to a product.',
              style: AppTextStyles.bodyMd,
              textAlign: TextAlign.center,
            ),
          ] else ...[
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: product!.imageUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(product!.imageUrl!, fit: BoxFit.cover),
                        )
                      : Icon(Icons.inventory_2_rounded, size: 40, color: AppColors.primary),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product!.name, style: AppTextStyles.headlineSm),
                      const SizedBox(height: 4),
                      Text(
                        product!.category ?? 'Uncategorized',
                        style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'SAR ${product!.unitPrice?.toStringAsFixed(2) ?? 'N/A'}',
                        style: AppTextStyles.headlineLg.copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: AppStrings.stockQuantity,
                    value: product!.stockQty.toString(),
                    icon: Icons.inventory_rounded,
                    color: product!.isLowStock ? AppColors.warning : AppColors.success,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    title: AppStrings.status,
                    value: product!.isActive ? 'Active' : 'Inactive',
                    icon: Icons.check_circle_rounded,
                    color: product!.isActive ? AppColors.success : AppColors.error,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close sheet
                context.pop(); // Close scanner screen
              },
              child: Text(AppStrings.close),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 8),
              Text(title, style: AppTextStyles.labelSm.copyWith(color: color)),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: AppTextStyles.headlineLg.copyWith(color: color)),
        ],
      ),
    );
  }
}
