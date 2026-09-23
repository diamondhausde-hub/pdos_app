import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme.dart';
import '../../../core/providers/data_providers.dart';

class AdminSettingsTab extends ConsumerStatefulWidget {
  const AdminSettingsTab({super.key});

  @override
  ConsumerState<AdminSettingsTab> createState() => _AdminSettingsTabState();
}

class _AdminSettingsTabState extends ConsumerState<AdminSettingsTab> {
  bool _loading = true;
  final TextEditingController _thresholdController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() => _loading = true);
    try {
      final api = ref.read(apiServiceProvider);
      // Wait, is there a GET /settings endpoint? Let's check backend later.
      final response = await api.dio.get('/settings');
      final settingsList = response.data as List;
      final setting = settingsList.where((s) => s['key'] == 'expense_approval_threshold').firstOrNull;
      if (setting != null) {
        _thresholdController.text = setting['value'].toString();
      }
    } catch (e) {
      // If setting doesn't exist, ignore
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _saveSettings() async {
    if (_thresholdController.text.isEmpty) return;
    
    setState(() => _isSaving = true);
    try {
      final api = ref.read(apiServiceProvider);
      await api.dio.put('/settings/expense_approval_threshold', data: {
        'value': double.tryParse(_thresholdController.text) ?? 50.0,
        
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.settingsSavedSuccessfully_9)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving settings: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.systemSettings)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.expenseApprovalThreshold, style: AppTextStyles.headlineMd),
            const SizedBox(height: 8),
            Text(AppStrings.expensesOverThisAmount,
                style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
            const SizedBox(height: 20),
            TextField(
              controller: _thresholdController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Threshold Amount (\$)!',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveSettings,
                child: _isSaving ? CircularProgressIndicator(color: AppColors.onPrimary) : Text(AppStrings.saveSettings),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
