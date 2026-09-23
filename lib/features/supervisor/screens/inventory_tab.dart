import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme.dart';
import '../../../core/models/product_model.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/utils/image_url_helper.dart';
import 'product_form_screen.dart';

class InventoryTab extends ConsumerStatefulWidget {
  const InventoryTab({super.key});

  @override
  ConsumerState<InventoryTab> createState() => _InventoryTabState();
}

class _InventoryTabState extends ConsumerState<InventoryTab> {
  String _selectedFilter = 'All';
  String _searchQuery = '';
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<ProductModel> _getFilteredProducts(List<ProductModel> products) {
    var result = products;
    if (_searchQuery.isNotEmpty) {
      result = result.where((p) =>
        p.name.toLowerCase().contains(_searchQuery) ||
        (p.category ?? '').toLowerCase().contains(_searchQuery)
      ).toList();
    }
    switch (_selectedFilter) {
      case 'Low Stock':
        return result.where((p) => p.isLowStock).toList();
      case 'Expiring':
        return result.where((p) => p.isExpiringSoon || p.isExpired).toList();
      default:
        return result;
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      body: productsAsync.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err', style: TextStyle(color: Colors.red))),
        data: (allProducts) {
          final lowStockCount = allProducts.where((p) => p.isLowStock).length;
          final expiringCount = allProducts.where((p) => p.isExpiringSoon || p.isExpired).length;
          final filteredProducts = _getFilteredProducts(allProducts);

          return Column(
            children: [
              // Alert Summary Cards
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: _AlertCard(
                        icon: Icons.warning_amber_rounded,
                        label: AppStrings.low,
                        count: lowStockCount,
                        color: AppColors.warning,
                        isSelected: _selectedFilter == 'Low Stock',
                        onTap: () => setState(() => _selectedFilter = _selectedFilter == 'Low Stock' ? 'All' : 'Low Stock'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _AlertCard(
                        icon: Icons.schedule,
                        label: AppStrings.expiring,
                        count: expiringCount,
                        color: AppColors.error,
                        isSelected: _selectedFilter == 'Expiring',
                        onTap: () => setState(() => _selectedFilter = _selectedFilter == 'Expiring' ? 'All' : 'Expiring'),
                      ),
                    ),
                  ],
                ),
              ),

              // Search
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _searchCtrl,
                  decoration: InputDecoration(
                    hintText: AppStrings.searchForAProduct,
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(icon: Icon(Icons.clear), onPressed: () { _searchCtrl.clear(); setState(() => _searchQuery = ''); })
                        : null,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: AppColors.surfaceContainerLow,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onChanged: (val) => setState(() => _searchQuery = val.trim().toLowerCase()),
                ),
              ),
              const SizedBox(height: 8),

              // Product List
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => ref.invalidate(productsProvider),
                  child: filteredProducts.isEmpty
                      ? Center(child: Text(_searchQuery.isEmpty ? 'No products' : 'No results'))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];
                            return GlassCard(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 52, height: 52,
                                          decoration: BoxDecoration(
                                            color: _getStatusColor(product).withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          clipBehavior: Clip.hardEdge,
                                          child: product.imageUrl != null
                                              ? Image.network(fullImageUrl(product.imageUrl), fit: BoxFit.cover, errorBuilder: (c, e, s) => Icon(Icons.medication, color: _getStatusColor(product)))
                                              : Icon(Icons.medication, color: _getStatusColor(product)),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(product.name, style: AppTextStyles.h4),
                                              Text(product.category ?? '', style: AppTextStyles.bodySmall.copyWith(color: AppColors.onSurfaceVariant)),
                                            ],
                                          ),
                                        ),
                                        PopupMenuButton<String>(
                                          onSelected: (action) {
                                            if (action == 'edit') {
                                              Navigator.push(context, MaterialPageRoute(
                                                builder: (_) => ProductFormScreen(product: product),
                                              )).then((_) => ref.invalidate(productsProvider));
                                            } else if (action == 'delete') {
                                              _confirmDelete(product);
                                            }
                                          },
                                          itemBuilder: (_) => [
                                            const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit, size: 18), SizedBox(width: 8), Text(AppStrings.edit)])),
                                            const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete, size: 18, color: Colors.red), SizedBox(width: 8), Text(AppStrings.delete, style: TextStyle(color: Colors.red))])),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        _InfoChip(label: AppStrings.quantity, value: '${product.stockQty}', color: product.isLowStock ? AppColors.error : AppColors.success),
                                        const SizedBox(width: 8),
                                        _InfoChip(label: AppStrings.price, value: '${product.unitPrice?.toStringAsFixed(0) ?? "—"} IQD', color: AppColors.primary),
                                        const SizedBox(width: 8),
                                        if (product.expiryDate != null)
                                          _InfoChip(
                                            label: AppStrings.expiry,
                                            value: '${product.expiryDate!.difference(DateTime.now()).inDays} days',
                                            color: product.isExpired ? AppColors.error : (product.isExpiringSoon ? AppColors.warning : AppColors.onSurfaceVariant),
                                          ),
                                      ],
                                    ),
                                    if (product.hasAlert) ...[
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppColors.errorLight,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          product.isExpired ? '⚠ Expired' : product.isLowStock ? '⚠ Low Stock' : '⚠ Expiring Soon',
                                          style: AppTextStyles.labelSmall.copyWith(color: AppColors.error),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (_) => const ProductFormScreen(),
          )).then((_) => ref.invalidate(productsProvider));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Color _getStatusColor(ProductModel p) {
    if (p.isExpired) return AppColors.error;
    if (p.isLowStock) return AppColors.warning;
    return AppColors.primary;
  }

  void _confirmDelete(ProductModel product) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppStrings.deleteProduct),
        content: Text('Are you sure you want to delete "${product.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(AppStrings.cancel)),
          ElevatedButton(
            onPressed: () async {
              await ref.read(productRepositoryProvider).deleteProduct(product.id);
              ref.invalidate(productsProvider);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: Text(AppStrings.delete),
          ),
        ],
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _AlertCard({required this.icon, required this.label, required this.count, required this.color, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$count', style: AppTextStyles.h3.copyWith(color: color)),
                Text(label, style: AppTextStyles.labelSmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _InfoChip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text('$label: $value', style: AppTextStyles.labelSmall.copyWith(color: color)),
    );
  }
}
