import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/models/product_model.dart';
import '../../../core/models/user_model.dart';

class AddTargetSheet extends ConsumerStatefulWidget {
  const AddTargetSheet({super.key});

  @override
  ConsumerState<AddTargetSheet> createState() => _AddTargetSheetState();
}

class _AddTargetSheetState extends ConsumerState<AddTargetSheet> {
  final _formKey = GlobalKey<FormState>();

  ProductModel? _selectedProduct;
  UserModel? _selectedRep; // null means 'Global'

  DateTime _periodStart = DateTime.now();
  DateTime _periodEnd = DateTime.now().add(const Duration(days: 30));

  final _qtyController = TextEditingController();

  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedProduct == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text(AppStrings.pleaseSelectAProduct)));
      return;
    }
    if (_selectedRep == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text(AppStrings.pleaseSelectARep)));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(targetRepositoryProvider);
      await repo.createTarget({
        'product_id': _selectedProduct!.id,
        'rep_id': _selectedRep?.id, // null makes it a global target
        'period_start': _periodStart.toIso8601String(),
        'period_end': _periodEnd.toIso8601String(),
        'target_qty': int.parse(_qtyController.text),
      });

      ref.invalidate(targetsProvider);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppStrings.targetAssignedSuccessfully_37),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('An error occurred: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);
    final usersAsync = ref.watch(usersListProvider);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppStrings.assignNewTarget, style: AppTextStyles.headlineMd),
              const SizedBox(height: 24),

              // Product Dropdown
              productsAsync.when(
                loading: () => const CircularProgressIndicator(),
                error: (e, s) => Text('Error loading products: $e'),
                data: (products) => DropdownButtonFormField<ProductModel>(
                  decoration: const InputDecoration(
                    labelText: AppStrings.targetProduct,
                  ),
                  initialValue: _selectedProduct,
                  items: products
                      .map(
                        (p) => DropdownMenuItem(value: p, child: Text(p.name)),
                      )
                      .toList(),
                  onChanged: (val) => setState(() => _selectedProduct = val),
                  validator: (val) => val == null ? 'Required' : null,
                ),
              ),
              const SizedBox(height: 16),

              // Rep Dropdown
              usersAsync.when(
                loading: () => const CircularProgressIndicator(),
                error: (e, s) => Text('Error loading employees: $e'),
                data: (users) {
                  final reps = users
                      .where((u) => u.role.name == 'rep')
                      .toList();
                  return DropdownButtonFormField<UserModel?>(
                    decoration: const InputDecoration(
                      labelText: AppStrings.rep,
                      helperText: 'Select a rep to assign target',
                    ),
                    initialValue: _selectedRep,
                    items: [
                      const DropdownMenuItem<UserModel?>(
                        value: null,
                        child: Text(
                          'Everyone (Global Target)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      ...reps.map(
                        (r) =>
                            DropdownMenuItem(value: r, child: Text(r.fullName)),
                      ),
                    ],
                    onChanged: (val) {
                      setState(() => _selectedRep = val);
                    },
                  );
                },
              ),
              const SizedBox(height: 16),

              // Quantity
              TextFormField(
                controller: _qtyController,
                decoration: const InputDecoration(
                  labelText: AppStrings.targetQuantity,
                  prefixIcon: Icon(Icons.numbers),
                ),
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Required';
                  if (int.tryParse(val) == null) return 'Must be a number';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Dates
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final d = await showDatePicker(
                          context: context,
                          initialDate: _periodStart,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (d != null) setState(() => _periodStart = d);
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: AppStrings.startDate,
                        ),
                        child: Text(
                          '${_periodStart.year}-${_periodStart.month.toString().padLeft(2, '0')}-${_periodStart.day.toString().padLeft(2, '0')}',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final d = await showDatePicker(
                          context: context,
                          initialDate: _periodEnd,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (d != null) setState(() => _periodEnd = d);
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: AppStrings.endDate,
                        ),
                        child: Text(
                          '${_periodEnd.year}-${_periodEnd.month.toString().padLeft(2, '0')}-${_periodEnd.day.toString().padLeft(2, '0')}',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Submit
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? CircularProgressIndicator(color: AppColors.onPrimary)
                      : Text(AppStrings.assignTarget),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
