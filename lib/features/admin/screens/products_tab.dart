import 'package:pdos_app/core/localization/app_strings.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/theme.dart';
import '../../../core/models/product_model.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/utils/image_url_helper.dart';

class AdminProductsTab extends ConsumerStatefulWidget {
  const AdminProductsTab({super.key});

  @override
  ConsumerState<AdminProductsTab> createState() => _AdminProductsTabState();
}

class _AdminProductsTabState extends ConsumerState<AdminProductsTab> {
  String _searchQuery = '';
  String _categoryFilter = 'All';
  String _stockFilter = 'All';

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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                    filled: true,
                    fillColor: AppColors.surfaceContainerLow,
                  ),
                  style: AppTextStyles.bodyMd,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: IconButton(
                  icon: Icon(Icons.add_rounded, color: AppColors.primary),
                  onPressed: () => _showCreateProductDialog(),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 36,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _FilterChip(
                  label: _stockFilter == 'Low' ? 'Low Stock' : 'In Stock',
                  selected: _stockFilter != 'All',
                  onTap: () => setState(() => _stockFilter = _stockFilter == 'All' ? 'Low' : 'All'),
                  color: _stockFilter == 'Low' ? AppColors.error : AppColors.success,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: _buildCategoryChips(),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(productsProvider);
              await ref.read(productsProvider.future);
            },
            child: productsAsync.when(
              loading: () => Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err', style: TextStyle(color: AppColors.error))),
              data: (products) {
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
                return GridView.builder(
                  padding: EdgeInsets.fromLTRB(20, 4, 20, 20 + bottomInset + 56),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final product = filtered[index];
                    final isLowStock = product.isLowStock;
                    final isExpired = product.expiryDate != null && product.expiryDate!.isBefore(DateTime.now());
                    return GlassCard(
                      padding: const EdgeInsets.all(12),
                      child: InkWell(
                        onTap: () => _showCreateProductDialog(product: product),
                        borderRadius: BorderRadius.circular(20),
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
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildCategoryChips() {
    const categories = ['All', 'Tablets', 'Syrup', 'Cream', 'Injection', 'Other'];
    return categories.map((cat) {
      final selected = _categoryFilter == cat;
      return Padding(
        padding: const EdgeInsets.only(right: 6),
        child: GestureDetector(
          onTap: () => setState(() => _categoryFilter = cat),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: selected ? AppColors.primary.withValues(alpha: 0.12) : AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(20),
              border: selected ? Border.all(color: AppColors.primary.withValues(alpha: 0.3)) : null,
            ),
            child: Text(cat,
                style: AppTextStyles.labelSm.copyWith(
                  color: selected ? AppColors.primary : AppColors.onSurfaceVariant,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                )),
          ),
        ),
      );
    }).toList();
  }

  List<ProductModel> _filterProducts(List<ProductModel> products) {
    var result = products.where((p) {
      final matchesSearch = p.name.toLowerCase().contains(_searchQuery) ||
          (p.category?.toLowerCase().contains(_searchQuery) ?? false);
      final matchesCategory = _categoryFilter == 'All' || (p.category == _categoryFilter);
      final matchesStock = _stockFilter == 'All' || (_stockFilter == 'Low' && p.isLowStock);
      return matchesSearch && matchesCategory && matchesStock;
    }).toList();
    result.sort((a, b) {
      final aExpired = a.expiryDate != null && a.expiryDate!.isBefore(DateTime.now());
      final bExpired = b.expiryDate != null && b.expiryDate!.isBefore(DateTime.now());
      if (aExpired != bExpired) return aExpired ? -1 : 1;
      if (a.isLowStock != b.isLowStock) return a.isLowStock ? -1 : 1;
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    return result;
  }

  void _showCreateProductDialog({ProductModel? product}) {
    final nameCtrl = TextEditingController(text: product?.name);
    final categoryCtrl = TextEditingController(text: product?.category);
    final priceCtrl = TextEditingController(
      text: product?.unitPrice?.toString(),
    );
    final minCtrl = TextEditingController(
      text: product?.minThreshold.toString() ?? '100',
    );
    final stockCtrl = TextEditingController(
      text: product?.stockQty.toString() ?? '0',
    );
    File? pickedImage;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.surfaceContainerLowest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            product == null ? 'Add New Product' : 'Edit Product',
            style: AppTextStyles.headlineSm.copyWith(
              color: AppColors.onSurface,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () async {
                    final picker = ImagePicker();
                    final xfile = await picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (xfile != null) {
                      setDialogState(() => pickedImage = File(xfile.path));
                    }
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: pickedImage != null
                        ? Image.file(pickedImage!, fit: BoxFit.cover)
                        : (product?.imageUrl != null
                              ? Image.network(
                                  fullImageUrl(product!.imageUrl),
                                  fit: BoxFit.cover,
                                  errorBuilder: (c, e, s) => Icon(
                                    Icons.add_a_photo,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                )
                              : Icon(
                                  Icons.add_a_photo,
                                  color: AppColors.onSurfaceVariant,
                                  size: 36,
                                )),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameCtrl,
                  style: AppTextStyles.bodyMd,
                  decoration: InputDecoration(
                    labelText: AppStrings.productName,
                    filled: true,
                    fillColor: AppColors.surfaceContainer,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: categoryCtrl,
                  style: AppTextStyles.bodyMd,
                  decoration: InputDecoration(
                    labelText: AppStrings.category,
                    filled: true,
                    fillColor: AppColors.surfaceContainer,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: priceCtrl,
                        keyboardType: TextInputType.number,
                        style: AppTextStyles.bodyMd,
                        decoration: InputDecoration(
                          labelText: 'Unit Price (\$)',
                          filled: true,
                          fillColor: AppColors.surfaceContainer,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: minCtrl,
                        keyboardType: TextInputType.number,
                        style: AppTextStyles.bodyMd,
                        decoration: InputDecoration(
                          labelText: AppStrings.minThreshold,
                          filled: true,
                          fillColor: AppColors.surfaceContainer,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: stockCtrl,
                  keyboardType: TextInputType.number,
                  style: AppTextStyles.bodyMd,
                  decoration: InputDecoration(
                    labelText: AppStrings.initialStockQty,
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () async {
                try {
                  final newProduct = ProductModel(
                    id: product?.id ?? '',
                    name: nameCtrl.text.trim(),
                    category: categoryCtrl.text.trim(),
                    unitPrice: double.tryParse(priceCtrl.text),
                    minThreshold: int.tryParse(minCtrl.text) ?? 100,
                    stockQty: int.tryParse(stockCtrl.text) ?? 0,
                    createdAt: product?.createdAt ?? DateTime.now(),
                    updatedAt: DateTime.now(),
                  );
                  String? newId = product?.id;
                  if (product == null) {
                    newId = await ref
                        .read(productRepositoryProvider)
                        .createProduct(newProduct);
                  } else {
                    await ref
                        .read(productRepositoryProvider)
                        .updateProduct(product.id, newProduct.toJson());
                  }
                  if (newId != null && pickedImage != null) {
                    await ref
                        .read(productRepositoryProvider)
                        .uploadProductImage(newId, pickedImage!.path);
                  }
                  ref.invalidate(productsProvider);
                  if (ctx.mounted) Navigator.pop(ctx);
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        product == null ? 'Product created' : 'Product updated',
                      ),
                    ),
                  );
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Failed: $e')));
                }
              },
              child: Text(AppStrings.save),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color color;

  const _FilterChip({required this.label, required this.selected, required this.onTap, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.12) : AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(20),
          border: selected ? Border.all(color: color.withValues(alpha: 0.3)) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(Icons.check, size: 14, color: color),
              ),
            Text(label,
                style: AppTextStyles.labelSm.copyWith(
                  color: selected ? color : AppColors.onSurfaceVariant,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                )),
          ],
        ),
      ),
    );
  }
}
