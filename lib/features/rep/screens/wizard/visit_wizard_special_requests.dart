import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/models/visit_model.dart'; // Ensure SpecialRequestModel is available here

class VisitWizardSpecialRequests extends StatefulWidget {
  final List<SpecialRequestModel> requests;
  final ValueChanged<List<SpecialRequestModel>> onChanged;
  final String visitId;

  const VisitWizardSpecialRequests({
    super.key,
    required this.requests,
    required this.onChanged,
    required this.visitId,
  });

  @override
  State<VisitWizardSpecialRequests> createState() => _VisitWizardSpecialRequestsState();
}

class _VisitWizardSpecialRequestsState extends State<VisitWizardSpecialRequests> {
  late List<SpecialRequestModel> _currentRequests;

  @override
  void initState() {
    super.initState();
    _currentRequests = List.from(widget.requests);
  }

  void _notifyParent() {
    widget.onChanged(List.from(_currentRequests));
  }

  Future<void> _showAddRequestDialog() async {
    final descCtrl = TextEditingController();
    String type = 'brochure';

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Text(AppStrings.addSpecialRequest),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: type,
                    decoration: const InputDecoration(labelText: AppStrings.requestType),
                    items: const [
                      DropdownMenuItem(value: 'brochure', child: Text(AppStrings.brochure)),
                      DropdownMenuItem(value: 'gift', child: Text(AppStrings.gift)),
                      DropdownMenuItem(value: 'stand', child: Text(AppStrings.standDisplay)),
                      DropdownMenuItem(value: 'other', child: Text(AppStrings.other)),
                    ],
                    onChanged: (val) => setStateDialog(() => type = val!),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: descCtrl,
                    decoration: const InputDecoration(labelText: AppStrings.detailsDescription),
                    maxLines: 3,
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
                  final newReq = SpecialRequestModel(
                    id: const Uuid().v4(),
                    visitId: widget.visitId,
                    requestType: type,
                    description: descCtrl.text.isNotEmpty ? descCtrl.text : null,
                    createdAt: DateTime.now(),
                  );
                  
                  setState(() {
                    _currentRequests.add(newReq);
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

  IconData _getIconForType(String type) {
    switch(type) {
      case 'brochure': return Icons.menu_book_rounded;
      case 'gift': return Icons.card_giftcard_rounded;
      case 'stand': return Icons.branding_watermark_rounded;
      default: return Icons.star_rounded;
    }
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
              Text(AppStrings.specialRequests, style: AppTextStyles.headlineSm),
              ElevatedButton.icon(
                onPressed: _showAddRequestDialog,
                icon: Icon(Icons.add_rounded, size: 18),
                label: Text(AppStrings.addRequest),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ],
          ),
        ),
        if (_currentRequests.isEmpty)
          SizedBox(
            height: 200,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.card_giftcard_rounded, size: 64, color: AppColors.onSurfaceVariant.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  Text(AppStrings.noSpecialRequests, style: AppTextStyles.bodyLg.copyWith(color: AppColors.onSurfaceVariant)),
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
              itemCount: _currentRequests.length,
              itemBuilder: (ctx, index) {
                final r = _currentRequests[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(_getIconForType(r.requestType), color: AppColors.secondary),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(r.requestType.toUpperCase(), style: AppTextStyles.labelMd),
                              if (r.description != null && r.description!.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(r.description!, style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
                              ]
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline, color: AppColors.error),
                          onPressed: () {
                            setState(() => _currentRequests.removeAt(index));
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
