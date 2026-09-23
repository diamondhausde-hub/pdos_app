import 'package:pdos_app/core/localization/app_strings.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/theme.dart';
import '../../../core/models/product_model.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/widgets/glass_card.dart';

class ProductFormScreen extends ConsumerStatefulWidget {
  final ProductModel? product;

  const ProductFormScreen({super.key, this.product});

  @override
  ConsumerState<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends ConsumerState<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _qtyCtrl;
  late final TextEditingController _thresholdCtrl;
  late final TextEditingController _categoryCtrl;
  String? _imagePath;
  DateTime? _expiryDate;
  bool _saving = false;

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _priceCtrl = TextEditingController(
      text: p?.unitPrice?.toStringAsFixed(2) ?? '',
    );
    _qtyCtrl = TextEditingController(text: p?.stockQty.toString() ?? '');
    _thresholdCtrl = TextEditingController(
      text: p?.minThreshold.toString() ?? '10',
    );
    _categoryCtrl = TextEditingController(text: p?.category ?? '');
    _expiryDate = p?.expiryDate;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _qtyCtrl.dispose();
    _thresholdCtrl.dispose();
    _categoryCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
    );
    if (file != null) setState(() => _imagePath = file.path);
  }

  Future<void> _pickExpiryDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _expiryDate ?? DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (date != null) setState(() => _expiryDate = date);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    try {
      final repo = ref.read(productRepositoryProvider);
      final product = ProductModel(
        id: widget.product?.id ?? '',
        name: _nameCtrl.text.trim(),
        category: _categoryCtrl.text.trim().isEmpty
            ? null
            : _categoryCtrl.text.trim(),
        unitPrice: double.tryParse(_priceCtrl.text),
        stockQty: int.tryParse(_qtyCtrl.text) ?? 0,
        minThreshold: int.tryParse(_thresholdCtrl.text) ?? 10,
        expiryDate: _expiryDate,
        imageUrl: widget.product?.imageUrl,
        createdAt: widget.product?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      String? newId;
      if (_isEditing) {
        await repo.updateProduct(widget.product!.id, product.toJson());
      } else {
        newId = await repo.createProduct(product);
        if (newId == null) throw Exception('Failed to create product');
      }

      if (_imagePath != null) {
        final productId = _isEditing ? widget.product!.id : newId;
        if (productId != null) {
          await repo.uploadProductImage(productId, _imagePath!);
        }
      }

      ref.invalidate(productsProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEditing ? 'Product updated' : 'Product added'),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
              title: Text(_isEditing ? 'Edit Product' : 'Add New Product'),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: GlassCard(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Product Image
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            height: 160,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
                            ),
                            child: _imagePath != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.file(
                                      File(_imagePath!),
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : widget.product?.imageUrl != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.network(
                                      widget.product!.imageUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, _, _) =>
                                          _imagePlaceholder(),
                                    ),
                                  )
                                : _imagePlaceholder(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap to select an image',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Name
                        TextFormField(
                          controller: _nameCtrl,
                          decoration: const InputDecoration(
                            labelText: AppStrings.productName,
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) => v == null || v.trim().isEmpty
                              ? 'Please enter the product name'
                              : null,
                        ),
                        const SizedBox(height: 16),

                        // Category + Price
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _categoryCtrl,
                                decoration: const InputDecoration(
                                  labelText: AppStrings.category,
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _priceCtrl,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: AppStrings.price,
                                  border: OutlineInputBorder(),
                                  prefixText: 'IQD ',
                                ),
                                validator: (v) => v == null || v.trim().isEmpty
                                    ? 'Field required'
                                    : double.tryParse(v) == null
                                    ? 'Enter a valid number'
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Quantity + Threshold
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _qtyCtrl,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: AppStrings.quantity,
                                  border: OutlineInputBorder(),
                                ),
                                validator: (v) =>
                                    v != null &&
                                        v.trim().isNotEmpty &&
                                        int.tryParse(v) == null
                                    ? 'Enter a valid number'
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _thresholdCtrl,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: AppStrings.minThreshold,
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Expiry Date
                        InkWell(
                          onTap: _pickExpiryDate,
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: AppStrings.expiryDate,
                              border: OutlineInputBorder(),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _expiryDate != null
                                      ? '${_expiryDate!.year}-${_expiryDate!.month.toString().padLeft(2, '0')}-${_expiryDate!.day.toString().padLeft(2, '0')}'
                                      : 'Select Date',
                                ),
                                const Icon(Icons.calendar_today, size: 18),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Save Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _saving ? null : _save,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                            ),
                            child: _saving
                                ? SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.onPrimary,
                                    ),
                                  )
                                : Text(
                                    _isEditing ? 'Save Changes' : 'Add Product',
                                    style: AppTextStyles.labelLarge,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_photo_alternate, size: 48, color: AppColors.outline),
        const SizedBox(height: 8),
        Text(
          'Product Image',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.outline),
        ),
      ],
    );
  }
}
