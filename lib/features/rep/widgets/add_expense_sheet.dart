import 'package:pdos_app/core/localization/app_strings.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import '../../../core/theme/theme.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/models/visit_model.dart';

class AddExpenseSheet extends ConsumerStatefulWidget {
  const AddExpenseSheet({super.key});

  @override
  ConsumerState<AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends ConsumerState<AddExpenseSheet> {
  final _amountController = TextEditingController();
  final _descController = TextEditingController();
  
  String _selectedCategory = 'transport';
  VisitModel? _selectedVisit;
  File? _receiptImage;
  bool _isLoading = false;

  final _categories = ['transport', 'meals', 'supplies', 'other'];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    
    if (pickedFile != null) {
      final tempDir = await getTemporaryDirectory();
      final targetPath = p.join(tempDir.path, '${const Uuid().v4()}.jpg');
      
      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        pickedFile.path,
        targetPath,
        quality: 70,
        minWidth: 800,
        minHeight: 800,
      );
      
      if (compressedFile != null) {
        setState(() => _receiptImage = File(compressedFile.path));
      }
    }
  }

  Future<void> _submit() async {
    if (_selectedVisit == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.pleaseSelectAVisit)));
      return;
    }
    
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.pleaseEnterAValid)));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final repo = ref.read(expenseRepositoryProvider);
      
      String? savedImagePath;
      if (_receiptImage != null) {
        final appDir = await getApplicationDocumentsDirectory();
        final receiptsDir = Directory(p.join(appDir.path, 'receipts'));
        if (!await receiptsDir.exists()) await receiptsDir.create();
        
        final savedImage = await _receiptImage!.copy(p.join(receiptsDir.path, p.basename(_receiptImage!.path)));
        savedImagePath = savedImage.path;
      }

      await repo.createExpenseLocally(
        visitId: _selectedVisit!.id,
        category: _selectedCategory,
        amount: amount,
        description: _descController.text.trim().isEmpty ? null : _descController.text.trim(),
        receiptImagePath: savedImagePath,
      );
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.expenseSavedLocallyAnd)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final visitsAsync = ref.watch(recentVisitsProvider);
    
    return Container(
      padding: EdgeInsets.only(
        left: 24, right: 24, top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppStrings.recordExpense, style: AppTextStyles.headlineMd.copyWith(color: AppColors.onSurface)),
              IconButton(icon: Icon(Icons.close), onPressed: () => Navigator.pop(context)),
            ],
          ),
          const SizedBox(height: 24),
          
          visitsAsync.when(
            data: (visits) {
              final recentVisits = visits.where((v) => v.status == VisitStatus.completed).take(10).toList();
              if (recentVisits.isEmpty) {
                return Text(AppStrings.noRecentCompletedVisits, style: TextStyle(color: AppColors.error));
              }
              _selectedVisit ??= recentVisits.first;
              
              return DropdownButtonFormField<VisitModel>(
                initialValue: _selectedVisit,
                decoration: InputDecoration(
                  labelText: AppStrings.relatedVisit,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: recentVisits.map((v) => DropdownMenuItem(
                  value: v,
                  child: Text('Visit on ${v.visitDate.toString().substring(0,10)}'),
                )).toList(),
                onChanged: (v) => setState(() => _selectedVisit = v),
              );
            },
            loading: () => Center(child: CircularProgressIndicator()),
            error: (e, s) => Text('Error loading visits: $e'),
          ),
          
          const SizedBox(height: 16),
          
          DropdownButtonFormField<String>(
            initialValue: _selectedCategory,
            decoration: InputDecoration(
              labelText: AppStrings.category,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            items: _categories.map((c) => DropdownMenuItem(
              value: c,
              child: Text(c.toUpperCase()),
            )).toList(),
            onChanged: (c) => setState(() => _selectedCategory = c!),
          ),
          
          const SizedBox(height: 16),
          TextFormField(
            controller: _amountController,
            decoration: InputDecoration(
              labelText: 'Amount (\$)',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          
          const SizedBox(height: 16),
          TextFormField(
            controller: _descController,
            decoration: InputDecoration(
              labelText: AppStrings.descriptionOptional,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          
          const SizedBox(height: 16),
          InkWell(
            onTap: _pickImage,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.outlineVariant),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _receiptImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(_receiptImage!, fit: BoxFit.cover),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt_rounded, color: AppColors.primary, size: 32),
                        const SizedBox(height: 8),
                        Text(AppStrings.captureReceipt, style: AppTextStyles.bodyMd.copyWith(color: AppColors.primary)),
                      ],
                    ),
            ),
          ),
          
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isLoading 
                ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: AppColors.onPrimary, strokeWidth: 2))
                : Text(AppStrings.saveExpense),
            ),
          ),
        ],
      ),
    );
  }
}
