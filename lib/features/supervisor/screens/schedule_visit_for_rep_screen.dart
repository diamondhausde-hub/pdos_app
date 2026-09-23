import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/user_model.dart';
import '../../../core/models/center_model.dart';
import '../../../core/models/product_model.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/glass_card.dart';

class ScheduleVisitForRepScreen extends ConsumerStatefulWidget {
  final UserModel rep;
  const ScheduleVisitForRepScreen({super.key, required this.rep});

  @override
  ConsumerState<ScheduleVisitForRepScreen> createState() => _ScheduleVisitForRepScreenState();
}

class _ScheduleVisitForRepScreenState extends ConsumerState<ScheduleVisitForRepScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime = TimeOfDay.now();
  CenterModel? _selectedCenter;
  ProductModel? _selectedProduct;
  final _notesController = TextEditingController();

  Future<void> _scheduleAppointment() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.pleaseSelectDateAnd)));
      return;
    }

    final dt = DateTime(
      _selectedDate!.year, _selectedDate!.month, _selectedDate!.day,
      _selectedTime!.hour, _selectedTime!.minute,
    );

    try {
      await ref.read(appointmentRepositoryProvider).createAppointmentForRep(
        repId: widget.rep.id,
        centerId: _selectedCenter?.id,
        dateTime: dt,
        notes: _notesController.text,
        suggestedProductId: _selectedProduct?.id,
      );
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.lbl_17)));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to schedule appointment: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final centersAsync = ref.watch(centersProvider);
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.lbl_18, style: AppTextStyles.h3),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GlassCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: Text(widget.rep.fullName[0], style: TextStyle(color: AppColors.onPrimary)),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.rep.fullName, style: AppTextStyles.h4),
                        Text(widget.rep.email, style: AppTextStyles.bodySm),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(AppStrings.lbl_19, style: AppTextStyles.h4),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: Icon(Icons.calendar_today),
                      label: Text(_selectedDate != null ? '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}' : 'Select Date'),
                      onPressed: () async {
                        final d = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (d != null) setState(() => _selectedDate = d);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: Icon(Icons.access_time),
                      label: Text(_selectedTime != null ? _selectedTime!.format(context) : 'Select Time'),
                      onPressed: () async {
                        final t = await showTimePicker(
                          context: context,
                          initialTime: _selectedTime ?? TimeOfDay.now(),
                        );
                        if (t != null) setState(() => _selectedTime = t);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              centersAsync.when(
                data: (centers) => DropdownButtonFormField<CenterModel>(
                  decoration: const InputDecoration(labelText: AppStrings.lbl_21, border: OutlineInputBorder()),
                  initialValue: _selectedCenter,
                  items: centers.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
                  onChanged: (v) => setState(() => _selectedCenter = v),
                ),
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Text('Error loading centers: $e'),
              ),
              const SizedBox(height: 24),
              productsAsync.when(
                data: (products) => DropdownButtonFormField<ProductModel>(
                  decoration: const InputDecoration(labelText: AppStrings.lbl_22, border: OutlineInputBorder()),
                  initialValue: _selectedProduct,
                  items: products.map((p) => DropdownMenuItem(value: p, child: Text(p.name))).toList(),
                  onChanged: (v) => setState(() => _selectedProduct = v),
                ),
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Text('Error loading products: $e'),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: AppStrings.lbl_23, border: OutlineInputBorder()),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: _scheduleAppointment,
                  child: Text(AppStrings.lbl_20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
