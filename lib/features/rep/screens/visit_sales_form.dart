import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme.dart';
import '../../../core/models/product_model.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/utils/image_url_helper.dart';
import '../../../core/widgets/glass_card.dart';

class VisitSalesForm extends ConsumerStatefulWidget {
  final List<Map<String, dynamic>> initialItems;
  final ValueChanged<List<Map<String, dynamic>>> onChanged;
  const VisitSalesForm({
    super.key,
    required this.initialItems,
    required this.onChanged,
  });

  @override
  ConsumerState<VisitSalesForm> createState() => _VisitSalesFormState();
}

class _VisitSalesFormState extends ConsumerState<VisitSalesForm> {
  String _searchQuery = '';
  late List<Map<String, dynamic>> _cartItems;

  @override
  void initState() {
    super.initState();
    _cartItems = List.from(widget.initialItems);
  }

  void _notifyParent() {
    widget.onChanged(List.from(_cartItems));
  }

  void _showAddToCartDialog(ProductModel product) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final qtySoldCtrl = TextEditingController(text: AppStrings.lbl_0_46);
    final qtyFreeCtrl = TextEditingController(text: AppStrings.lbl_0_46);

    final existingIndex = _cartItems.indexWhere(
      (i) => i['productId'] == product.id,
    );
    if (existingIndex != -1) {
      qtySoldCtrl.text = _cartItems[existingIndex]['qtySold'].toString();
      qtyFreeCtrl.text = _cartItems[existingIndex]['qtyFree'].toString();
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.scaffoldBg(isDark),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          product.name,
          style: AppTextStyles.headlineSm.copyWith(color: AppColors.onSurface),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: qtySoldCtrl,
              keyboardType: TextInputType.number,
              style: AppTextStyles.bodyMd,
              decoration: InputDecoration(
                labelText: AppStrings.quantitySold,
                filled: true,
                fillColor: AppColors.inputFill(isDark),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: qtyFreeCtrl,
              keyboardType: TextInputType.number,
              style: AppTextStyles.bodyMd,
              decoration: InputDecoration(
                labelText: AppStrings.freeSamples,
                filled: true,
                fillColor: AppColors.inputFill(isDark),
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
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onPressed: () {
              final sold = int.tryParse(qtySoldCtrl.text) ?? 0;
              final free = int.tryParse(qtyFreeCtrl.text) ?? 0;
              if (sold < 0 || free < 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(AppStrings.quantitiesCannotBeNegative),
                  ),
                );
                return;
              }
              if (sold == 0 && free == 0) {
                if (existingIndex != -1) {
                  setState(() {
                    _cartItems.removeAt(existingIndex);
                    _notifyParent();
                  });
                }
                Navigator.pop(ctx);
                return;
              }
              final item = {
                'productId': product.id,
                'productName': product.name,
                'qtySold': sold,
                'qtyFree': free,
                'priceAtSale': product.unitPrice ?? 0.0,
              };
              setState(() {
                if (existingIndex != -1) {
                  _cartItems[existingIndex] = item;
                } else {
                  _cartItems.add(item);
                }
                _notifyParent();
              });
              Navigator.pop(ctx);
            },
            child: Text(AppStrings.saveToCart),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
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
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              title: Text(AppStrings.addSalesSamples),
            ),
            if (_cartItems.isNotEmpty)
              GlassCard(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cart (${_cartItems.length} items)',
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
                        itemCount: _cartItems.length,
                        itemBuilder: (ctx, idx) {
                          final item = _cartItems[idx];
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
                                  'Sold: ${item['qtySold']} | Free: ${item['qtyFree']}',
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
                  fillColor: AppColors.inputFill(isDark),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: productsAsync.when(
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
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final product = filtered[index];
                      final inCart = _cartItems.any(
                        (i) => i['productId'] == product.id,
                      );

                      return GlassCard(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        child: InkWell(
                          onTap: () => _showAddToCartDialog(product),
                          borderRadius: BorderRadius.circular(20),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
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
                                          Icons.medication_rounded,
                                          color: AppColors.primary,
                                        ),
                                      )
                                    : Icon(
                                        Icons.medication_rounded,
                                        color: AppColors.primary,
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
                                      'Price: \$${product.unitPrice?.toStringAsFixed(2) ?? "0.00"} | Stock: ${product.stockQty}',
                                      style: AppTextStyles.labelSm.copyWith(
                                        color: AppColors.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                inCart
                                    ? Icons.check_circle_rounded
                                    : Icons.add_circle_outline_rounded,
                                color: inCart
                                    ? AppColors.success
                                    : AppColors.primary,
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
            ),
          ],
        ),
      ),
    );
  }
}
