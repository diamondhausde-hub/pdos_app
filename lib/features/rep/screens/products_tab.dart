import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/utils/image_url_helper.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/models/product_model.dart';
import 'product_detail_screen.dart';

class ProductsTab extends ConsumerStatefulWidget {
  const ProductsTab({super.key});

  @override
  ConsumerState<ProductsTab> createState() => _ProductsTabState();
}

class _ProductsTabState extends ConsumerState<ProductsTab> {
  String _searchQuery = '';
  String _categoryFilter = 'All';
  String _stockFilter = 'All';
  bool _isGridView = true;

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
                  decoration: InputDecoration(
                    hintText: AppStrings.searchProducts,
                    prefixIcon: Icon(Icons.search_rounded, color: AppColors.onSurfaceVariant),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.filter_list_rounded, color: AppColors.onSurfaceVariant),
                      onPressed: _showFilterSheet,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppColors.surfaceContainerLow,
                  ),
                  style: AppTextStyles.bodyMd,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: Icon(_isGridView ? Icons.grid_view_rounded : Icons.list_rounded,
                      color: AppColors.onSurfaceVariant, size: 20),
                  onPressed: () => setState(() => _isGridView = !_isGridView),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(productsProvider);
              await ref.read(productsProvider.future);
            },
            child: Builder(builder: (context) {
              if (!productsAsync.hasValue && productsAsync.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (productsAsync.hasError && !productsAsync.hasValue) {
                return Center(child: Text('Error: ${productsAsync.error}', style: TextStyle(color: AppColors.error)));
              }
              final products = productsAsync.value ?? [];
              final filtered = _filterProducts(products);
              if (filtered.isEmpty) {
                return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 56, height: 56,
                              decoration: BoxDecoration(color: AppColors.surfaceContainer, shape: BoxShape.circle),
                              child: Icon(Icons.search_off_rounded, size: 28, color: AppColors.onSurfaceVariant),
                            ),
                            const SizedBox(height: 16),
                            Text(AppStrings.noMatchingProducts,
                                style: AppTextStyles.bodyLg.copyWith(color: AppColors.onSurfaceVariant)),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return _isGridView ? _buildGridView(filtered, bottomInset) : _buildListView(filtered, bottomInset);
              }),
            ),
          ),
      ],
    );
  }

  Widget _buildGridView(List<ProductModel> products, double bottomInset) {
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 20 + bottomInset + 56),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _ProductCard(product: product, onTap: () => _openDetail(product));
      },
    );
  }

  Widget _buildListView(List<ProductModel> products, double bottomInset) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 20 + bottomInset + 56),
      itemCount: products.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final product = products[index];
        return _ProductListTile(product: product, onTap: () => _openDetail(product));
      },
    );
  }

  void _openDetail(ProductModel product) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)));
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _FilterSheet(
        categoryFilter: _categoryFilter,
        stockFilter: _stockFilter,
        onApply: (cat, stock) {
          setState(() {
            _categoryFilter = cat;
            _stockFilter = stock;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  List<ProductModel> _filterProducts(List<ProductModel> products) {
    var result = products.where((p) {
      final matchesSearch = p.name.toLowerCase().contains(_searchQuery) ||
          (p.category?.toLowerCase().contains(_searchQuery) ?? false) ||
          (p.barcode?.contains(_searchQuery) ?? false);
      final matchesCategory = _categoryFilter == 'All' || (p.category == _categoryFilter);
      final matchesStock = _stockFilter == 'All' || (_stockFilter == 'Low' && p.isLowStock);
      return matchesSearch && matchesCategory && matchesStock;
    }).toList();
    result.sort((a, b) {
      final aExpired = a.expiryDate != null && a.expiryDate!.isBefore(DateTime.now());
      final bExpired = b.expiryDate != null && b.expiryDate!.isBefore(DateTime.now());
      if (aExpired != bExpired) return aExpired ? -1 : 1;
      if (a.isLowStock != b.isLowStock) return a.isLowStock ? -1 : 1;
      return a.name.compareTo(b.name);
    });
    return result;
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;
  const _ProductCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isLowStock = product.isLowStock;
    final isExpired = product.expiryDate != null && product.expiryDate!.isBefore(DateTime.now());
    return GlassCard(
      padding: const EdgeInsets.all(12),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: product.imageUrl != null
                      ? Image.network(fullImageUrl(product.imageUrl),
                          fit: BoxFit.contain,
                          errorBuilder: (c, e, s) => Icon(Icons.medication_rounded, size: 40, color: AppColors.primary))
                      : Icon(Icons.medication_rounded, size: 40, color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(product.name,
                style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600, color: AppColors.onSurface),
                maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(product.category ?? 'General',
                      style: AppTextStyles.labelSm.copyWith(fontSize: 10, color: AppColors.onSurfaceVariant)),
                ),
                const Spacer(),
                Text('${product.stockQty}',
                    style: AppTextStyles.labelLg.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isLowStock ? AppColors.error : AppColors.success,
                    )),
              ],
            ),
            if (isLowStock || isExpired) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: (isExpired ? AppColors.error : AppColors.warning).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isExpired ? 'Expired' : 'Low Stock',
                  style: AppTextStyles.labelSm.copyWith(
                    fontSize: 10,
                    color: isExpired ? AppColors.error : AppColors.warning,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProductListTile extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;
  const _ProductListTile({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isLowStock = product.isLowStock;
    final isExpired = product.expiryDate != null && product.expiryDate!.isBefore(DateTime.now());
    return GlassCard(
      padding: const EdgeInsets.all(12),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 48, height: 48,
                child: product.imageUrl != null
                    ? Image.network(fullImageUrl(product.imageUrl),
                        fit: BoxFit.contain,
                        errorBuilder: (c, e, s) => Icon(Icons.medication_rounded, size: 24, color: AppColors.primary))
                    : Icon(Icons.medication_rounded, size: 24, color: AppColors.primary),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600, color: AppColors.onSurface),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(product.category ?? 'General',
                          style: AppTextStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant)),
                      const Spacer(),
                      Text('${product.stockQty} in stock',
                          style: AppTextStyles.labelSm.copyWith(
                            color: isLowStock ? AppColors.error : AppColors.success,
                            fontWeight: FontWeight.w600,
                          )),
                    ],
                  ),
                  if (isLowStock || isExpired)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(isExpired ? 'Expired' : 'Low Stock',
                          style: AppTextStyles.labelSm.copyWith(
                            fontSize: 11,
                            color: isExpired ? AppColors.error : AppColors.warning,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: AppColors.outlineVariant, size: 20),
          ],
        ),
      ),
    );
  }
}

class _FilterSheet extends StatefulWidget {
  final String categoryFilter;
  final String stockFilter;
  final void Function(String category, String stock) onApply;

  const _FilterSheet({required this.categoryFilter, required this.stockFilter, required this.onApply});

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late String _categoryFilter;
  late String _stockFilter;

  @override
  void initState() {
    super.initState();
    _categoryFilter = widget.categoryFilter;
    _stockFilter = widget.stockFilter;
  }

  @override
  Widget build(BuildContext context) {
    final categories = ['All', 'Tablets', 'Syrup', 'Cream', 'Injection', 'Other'];
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 20),
          Text(AppStrings.stock, style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600, color: AppColors.onSurface)),
          const SizedBox(height: 8),
          Row(
            children: ['All', 'In Stock', 'Low Stock'].map((f) {
              final active = _stockFilter == f;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => setState(() => _stockFilter = f),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: active ? AppColors.primary.withValues(alpha: 0.12) : AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(20),
                      border: active ? Border.all(color: AppColors.primary.withValues(alpha: 0.3)) : null,
                    ),
                    child: Text(f,
                        style: AppTextStyles.labelSm.copyWith(
                          color: active ? AppColors.primary : AppColors.onSurfaceVariant,
                          fontWeight: active ? FontWeight.bold : FontWeight.normal,
                        )),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Text(AppStrings.category, style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600, color: AppColors.onSurface)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categories.map((cat) {
              final active = _categoryFilter == cat;
              return GestureDetector(
                onTap: () => setState(() => _categoryFilter = cat),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: active ? AppColors.primary.withValues(alpha: 0.12) : AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(20),
                    border: active ? Border.all(color: AppColors.primary.withValues(alpha: 0.3)) : null,
                  ),
                  child: Text(cat,
                      style: AppTextStyles.labelSm.copyWith(
                        color: active ? AppColors.primary : AppColors.onSurfaceVariant,
                        fontWeight: active ? FontWeight.bold : FontWeight.normal,
                      )),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => widget.onApply(_categoryFilter, _stockFilter),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(AppStrings.applyFilters, style: AppTextStyles.bodyMd),
            ),
          ),
        ],
      ),
    );
  }
}
