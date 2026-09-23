import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme.dart';
import '../../../core/models/product_model.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/utils/image_url_helper.dart';
import '../../../core/widgets/glass_card.dart';

class VisitStockForm extends ConsumerStatefulWidget {
  final List<Map<String, dynamic>> initialChecks;
  final ValueChanged<List<Map<String, dynamic>>> onChanged;
  const VisitStockForm({
    super.key,
    required this.initialChecks,
    required this.onChanged,
  });

  @override
  ConsumerState<VisitStockForm> createState() => _VisitStockFormState();
}

class _VisitStockFormState extends ConsumerState<VisitStockForm> {
  String _searchQuery = '';
  late List<Map<String, dynamic>> _checks;

  @override
  void initState() {
    super.initState();
    _checks = List.from(widget.initialChecks);
  }

  void _notifyParent() {
    widget.onChanged(List.from(_checks));
  }

  void _showAddCheckDialog(ProductModel product) {
    final qtyCtrl = TextEditingController(text: AppStrings.lbl_0_46);
    final existingIndex = _checks.indexWhere(
      (i) => i['productId'] == product.id,
    );
    if (existingIndex != -1) {
      qtyCtrl.text = _checks[existingIndex]['observedQty'].toString();
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          product.name,
          style: AppTextStyles.headlineSm.copyWith(color: AppColors.onSurface),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: qtyCtrl,
              keyboardType: TextInputType.number,
              style: AppTextStyles.bodyMd,
              decoration: InputDecoration(
                labelText: AppStrings.observedQuantityOnShelf,
                filled: true,
                fillColor: AppColors.surfaceContainer,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: AppTextStyles.bodyMd.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onPressed: () {
              final qty = int.tryParse(qtyCtrl.text) ?? 0;
              if (qty < 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text(AppStrings.quantityCannotBeNegative)),
                );
                return;
              }
              final item = {
                'productId': product.id,
                'productName': product.name,
                'observedQty': qty,
              };
              setState(() {
                if (existingIndex != -1) {
                  _checks[existingIndex] = item;
                } else {
                  _checks.add(item);
                }
                _notifyParent();
              });
              Navigator.pop(ctx);
            },
            child: Text(AppStrings.saveCheck),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withValues(alpha: 0.08),
              AppColors.secondary.withValues(alpha: 0.05),
              AppColors.surface.withValues(alpha: 0.02),
            ],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              title: Text(AppStrings.stockCheck),
            ),
            if (_checks.isNotEmpty)
              GlassCard(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Checked (${_checks.length} items)',
                      style: AppTextStyles.bodyLg.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 90,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _checks.length,
                        itemBuilder: (ctx, idx) {
                          final item = _checks[idx];
                          return GlassCard(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['productName'],
                                  style: AppTextStyles.labelLg.copyWith(
                                    color: AppColors.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Observed: ${item['observedQty']}',
                                  style: AppTextStyles.labelSm.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                onChanged: (val) =>
                    setState(() => _searchQuery = val.toLowerCase()),
                style: AppTextStyles.bodyMd,
                decoration: InputDecoration(
                  hintText: AppStrings.searchProducts,
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: AppColors.onSurfaceVariant,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 0,
                  ),
                  filled: true,
                  fillColor: AppColors.surfaceContainerLow,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            productsAsync.when(
                loading: () => Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
                data: (products) {
                  final filtered = products
                      .where((p) => p.name.toLowerCase().contains(_searchQuery))
                      .toList();
                  if (filtered.isEmpty) {
                    return const Center(child: Text(AppStrings.noProductsFound));
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final product = filtered[index];
                      final checked = _checks.any(
                        (i) => i['productId'] == product.id,
                      );

                      return GlassCard(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        child: InkWell(
                          onTap: () => _showAddCheckDialog(product),
                          borderRadius: BorderRadius.circular(20),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: AppColors.secondary.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: product.imageUrl != null
                                    ? Image.network(
                                        fullImageUrl(product.imageUrl),
                                        fit: BoxFit.cover,
                                        errorBuilder: (c, e, s) => const Icon(
                                          Icons.inventory_2_rounded,
                                          color: AppColors.secondary,
                                        ),
                                      )
                                    : Icon(
                                        Icons.inventory_2_rounded,
                                        color: AppColors.secondary,
                                      ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: AppTextStyles.bodyMd.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Category: ${product.category ?? "None"}',
                                      style: AppTextStyles.labelSm.copyWith(
                                        color: AppColors.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                checked
                                    ? Icons.check_circle_rounded
                                    : Icons.radio_button_unchecked_rounded,
                                color: checked
                                    ? AppColors.success
                                    : AppColors.onSurfaceVariant,
                                size: 28,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
