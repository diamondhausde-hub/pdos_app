import 'package:pdos_app/core/localization/app_strings.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/glass_card.dart';

class VisitWizardReview extends StatelessWidget {
  final Map<String, dynamic> data;

  const VisitWizardReview({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final isRetroactive = data['isRetroactive'] == true;
    final salesCount = (data['salesItems'] as List?)?.length ?? 0;
    final stockCount = (data['stockChecks'] as List?)?.length ?? 0;
    final photosCount = (data['photos'] as List?)?.length ?? 0;
    final expensesCount = (data['expenses'] as List?)?.length ?? 0;
    final specialReqCount = (data['specialRequests'] as List?)?.length ?? 0;
    final signaturePath = data['signaturePath'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(AppStrings.invoiceSummary, style: AppTextStyles.headlineSm, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryRow(Icons.history, 'Entry Type', isRetroactive ? 'Retroactive' : 'Live Check-in'),
                const Divider(height: 16),
                
                Text(AppStrings.salesOrder, style: AppTextStyles.headlineSm),
                const SizedBox(height: 8),
                if (salesCount == 0)
                  Text(AppStrings.noItemsOrdered, style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant))
                else
                  ...((data['salesItems'] as List).map((item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${item['productName'] ?? 'Product'}', style: AppTextStyles.bodyMd),
                            Text('${item['qtySold']} Sold / ${item['qtyFree']} Free', style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ))),
                
                const Divider(height: 24),
                _buildSummaryRow(Icons.inventory_2_rounded, 'Stock Checks', '$stockCount items checked'),
                
                if (photosCount > 0) ...[
                  const Divider(height: 24),
                  _buildSummaryRow(Icons.camera_alt_rounded, 'Shelf Photos', '$photosCount photo${photosCount == 1 ? '' : 's'} taken'),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: photosCount,
                      itemBuilder: (ctx, idx) {
                        final path = (data['photos'] as List)[idx] as String;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(File(path), width: 80, fit: BoxFit.cover),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                
                const Divider(height: 24),
                Text(AppStrings.expensesExtras, style: AppTextStyles.headlineSm),
                const SizedBox(height: 8),
                Text('$expensesCount expenses logged', style: AppTextStyles.bodyMd),
                Text('$specialReqCount special requests', style: AppTextStyles.bodyMd),
                
                const Divider(height: 24),
                _buildSummaryRow(
                  signaturePath != null ? Icons.draw_rounded : Icons.edit_off_rounded,
                  'Signature',
                  signaturePath != null ? 'Signed' : 'Missing Signature',
                  valueColor: signaturePath != null ? AppColors.success : AppColors.error,
                ),
                
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String label, String value, {Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.labelMd.copyWith(color: AppColors.onSurfaceVariant)),
              const SizedBox(height: 4),
              Text(value, style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w500, color: valueColor)),
            ],
          ),
        ),
      ],
    );
  }
}
