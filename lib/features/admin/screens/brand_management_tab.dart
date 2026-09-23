import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme.dart';
import '../../../core/providers/brand_provider.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/models/brand_model.dart';
import 'package:intl/intl.dart';

class BrandManagementTab extends ConsumerStatefulWidget {
  const BrandManagementTab({super.key});

  @override
  ConsumerState<BrandManagementTab> createState() => _BrandManagementTabState();
}

class _BrandManagementTabState extends ConsumerState<BrandManagementTab> {
  bool _isLoading = false;

  Future<void> _toggleBrandStatus(BrandModel brand) async {
    setState(() => _isLoading = true);
    try {
      final api = ref.read(apiServiceProvider);
      final resp = await api.dio.patch('/brands/${brand.id}/toggle', data: {});
      if (resp.statusCode == 200) {
        ref.invalidate(brandsProvider);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${brand.name} is now ${!brand.isActive ? 'Active' : 'Inactive'}')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error toggling brand status: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showAddBrandDialog() {
    final nameController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(AppStrings.addNewBrand, style: AppTextStyles.h3),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: AppStrings.brandName,
            hintText: AppStrings.eGCebelia,
            prefixIcon: Icon(Icons.storefront_rounded),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () async {
              if (nameController.text.trim().isEmpty) return;
              Navigator.pop(ctx);
              
              setState(() => _isLoading = true);
              try {
                final api = ref.read(apiServiceProvider);
                final resp = await api.dio.post('/brands', data: {
                  'name': nameController.text.trim(),
                  'is_active': true,
                });
                if (resp.statusCode == 200 || resp.statusCode == 201) {
                  ref.invalidate(brandsProvider);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(AppStrings.brandAddedSuccessfully)),
                    );
                  }
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to add brand: $e'), backgroundColor: AppColors.error),
                  );
                }
              } finally {
                if (mounted) setState(() => _isLoading = false);
              }
            },
            child: Text(AppStrings.addBrand),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final brandsAsync = ref.watch(brandsProvider);

    return Scaffold(
      
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Brands',
                          style: AppTextStyles.h2.copyWith(color: AppColors.onBackground),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Manage system brands and their active status',
                          style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: _isLoading ? null : _showAddBrandDialog,
                    icon: Icon(Icons.add_rounded),
                    label: Text(AppStrings.newBrand),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            if (_isLoading)
              const LinearProgressIndicator(),

            Expanded(
              child: brandsAsync.when(
                data: (brands) {
                  if (brands.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.storefront_rounded, size: 64, color: AppColors.onSurfaceVariant.withValues(alpha: 0.5)),
                          const SizedBox(height: 16),
                          Text(AppStrings.noBrandsFound, style: AppTextStyles.h3),
                        ],
                      ),
                    );
                  }
                  
                  return RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(brandsProvider);
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      itemCount: brands.length,
                      itemBuilder: (context, index) {
                        final brand = brands[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(color: AppColors.outlineVariant, width: 1),
                          ),
                          color: AppColors.surface,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: brand.isActive ? AppColors.primaryContainer : AppColors.surfaceContainerHigh,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      brand.name.substring(0, 1).toUpperCase(),
                                      style: AppTextStyles.h3.copyWith(
                                        color: brand.isActive ? AppColors.primary : AppColors.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        brand.name,
                                        style: AppTextStyles.h3.copyWith(
                                          color: brand.isActive ? AppColors.onSurface : AppColors.onSurfaceVariant,
                                          decoration: brand.isActive ? null : TextDecoration.lineThrough,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Created ${DateFormat('MMM d, yyyy').format(brand.createdAt)}',
                                        style: AppTextStyles.labelMd.copyWith(color: AppColors.onSurfaceVariant),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: brand.isActive ? AppColors.success.withValues(alpha: 0.1) : AppColors.error.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    brand.isActive ? 'Active' : 'Inactive',
                                    style: AppTextStyles.labelSm.copyWith(
                                      color: brand.isActive ? AppColors.success : AppColors.error,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Switch(
                                  value: brand.isActive,
                                  onChanged: _isLoading ? null : (_) => _toggleBrandStatus(brand),
                                  activeThumbColor: AppColors.primary,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
                      const SizedBox(height: 16),
                      Text(AppStrings.failedToLoadBrands, style: AppTextStyles.h3),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: () => ref.invalidate(brandsProvider),
                        icon: Icon(Icons.refresh_rounded),
                        label: Text(AppStrings.retry),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
