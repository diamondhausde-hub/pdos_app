import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/models/expense_model.dart';
import 'package:path_provider/path_provider.dart';

class VisitWizardExpenses extends StatefulWidget {
  final List<ExpenseModel> expenses;
  final ValueChanged<List<ExpenseModel>> onChanged;
  final String visitId;
  final String repId;

  const VisitWizardExpenses({
    super.key,
    required this.expenses,
    required this.onChanged,
    required this.visitId,
    required this.repId,
  });

  @override
  State<VisitWizardExpenses> createState() => _VisitWizardExpensesState();
}

class _VisitWizardExpensesState extends State<VisitWizardExpenses> {
  late List<ExpenseModel> _currentExpenses;

  @override
  void initState() {
    super.initState();
    _currentExpenses = List.from(widget.expenses);
  }

  void _notifyParent() {
    widget.onChanged(List.from(_currentExpenses));
  }

  Future<void> _showAddExpenseDialog() async {
    final amountCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String category = 'transport';
    String? receiptPath;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Text(AppStrings.addExpense),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: category,
                    decoration: const InputDecoration(labelText: AppStrings.category),
                    items: const [
                      DropdownMenuItem(value: 'transport', child: Text(AppStrings.transport)),
                      DropdownMenuItem(value: 'meals', child: Text(AppStrings.meals)),
                      DropdownMenuItem(value: 'supplies', child: Text(AppStrings.supplies)),
                      DropdownMenuItem(value: 'other', child: Text(AppStrings.other)),
                    ],
                    onChanged: (val) => setStateDialog(() => category = val!),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: amountCtrl,
                    decoration: const InputDecoration(labelText: AppStrings.amount, prefixText: '\$'),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: descCtrl,
                    decoration: const InputDecoration(labelText: AppStrings.descriptionOptional),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  if (receiptPath != null)
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(File(receiptPath!), height: 100, width: double.infinity, fit: BoxFit.cover),
                        ),
                        Positioned(
                          right: 8,
                          top: 8,
                          child: GestureDetector(
                            onTap: () => setStateDialog(() => receiptPath = null),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.onSurfaceVariant,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.close, color: AppColors.onPrimary, size: 16),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    OutlinedButton.icon(
                      onPressed: () async {
                        final picker = ImagePicker();
                        final picked = await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
                        if (picked != null) {
                          final appDir = await getApplicationDocumentsDirectory();
                          final receiptsDir = Directory('${appDir.path}/receipts');
                          if (!await receiptsDir.exists()) await receiptsDir.create(recursive: true);
                          final saved = await File(picked.path).copy('${receiptsDir.path}/${const Uuid().v4()}.jpg');
                          setStateDialog(() => receiptPath = saved.path);
                        }
                      },
                      icon: Icon(Icons.receipt_long_rounded),
                      label: Text(AppStrings.addReceiptPhoto),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(AppStrings.cancel),
              ),
              ElevatedButton(
                onPressed: () {
                  final amt = double.tryParse(amountCtrl.text);
                  if (amt == null || amt <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.enterAValidAmount)));
                    return;
                  }
                  
                  final newExpense = ExpenseModel(
                    id: const Uuid().v4(),
                    visitId: widget.visitId,
                    repId: widget.repId,
                    category: category,
                    amount: amt,
                    description: descCtrl.text.isNotEmpty ? descCtrl.text : null,
                    receiptImageUrl: receiptPath,
                    createdAt: DateTime.now(),
                  );
                  
                  setState(() {
                    _currentExpenses.add(newExpense);
                  });
                  _notifyParent();
                  Navigator.pop(ctx);
                },
                child: Text(AppStrings.add),
              ),
            ],
          );
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppStrings.expenses, style: AppTextStyles.headlineSm),
              ElevatedButton.icon(
                onPressed: _showAddExpenseDialog,
                icon: Icon(Icons.add_rounded, size: 18),
                label: Text(AppStrings.addExpense),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ],
          ),
        ),
        if (_currentExpenses.isEmpty)
          SizedBox(
            height: 200,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.receipt_long_outlined, size: 64, color: AppColors.onSurfaceVariant.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  Text(AppStrings.noExpensesAdded, style: AppTextStyles.bodyLg.copyWith(color: AppColors.onSurfaceVariant)),
                ],
              ),
            ),
          )
        else
          SizedBox(
            height: 300,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _currentExpenses.length,
              itemBuilder: (ctx, index) {
                final e = _currentExpenses[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(e.categoryIcon, color: AppColors.primary),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(e.category.toUpperCase(), style: AppTextStyles.labelMd),
                              if (e.description != null && e.description!.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(e.description!, style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
                              ]
                            ],
                          ),
                        ),
                        Text('\$${e.amount.toStringAsFixed(2)}', style: AppTextStyles.headlineSm.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: Icon(Icons.delete_outline, color: AppColors.error),
                          onPressed: () {
                            setState(() => _currentExpenses.removeAt(index));
                            _notifyParent();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
