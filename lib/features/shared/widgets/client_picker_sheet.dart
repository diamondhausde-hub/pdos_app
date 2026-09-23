import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/models/client_model.dart';
import '../../../core/widgets/glass_card.dart';

Future<ClientModel?> showClientPickerSheet(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet<ClientModel>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => _ClientPickerSheetBody(),
  );
}

class _ClientPickerSheetBody extends ConsumerStatefulWidget {
  @override
  ConsumerState<_ClientPickerSheetBody> createState() => _ClientPickerSheetBodyState();
}

class _ClientPickerSheetBodyState extends ConsumerState<_ClientPickerSheetBody> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final clientsAsync = ref.watch(clientsStreamProvider);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(AppStrings.selectClient, style: AppTextStyles.headlineMd),
          const SizedBox(height: 16),
          TextField(
            onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
            decoration: InputDecoration(
              hintText: AppStrings.searchByNameOr,
              prefixIcon: Icon(Icons.search_rounded, color: AppColors.onSurfaceVariant),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              filled: true, fillColor: AppColors.surfaceContainer,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 300,
            child: clientsAsync.when(
              loading: () => Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (clients) {
                final filtered = clients.where((c) {
                  if (_searchQuery.isEmpty) return true;
                  final q = _searchQuery;
                  return (c.doctorName?.toLowerCase().contains(q) ?? false) ||
                      (c.facilityName?.toLowerCase().contains(q) ?? false) ||
                      (c.phoneNumber?.contains(q) ?? false);
                }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.people_outline, size: 48, color: AppColors.onSurfaceVariant.withValues(alpha: 0.3)),
                        const SizedBox(height: 8),
                        Text(AppStrings.noClientsFound, style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
                        TextButton(
                          onPressed: () async {
                            await context.push('/clients/new');
                            ref.invalidate(clientsStreamProvider);
                            setState(() {});
                          },
                          child: Text(AppStrings.addNewClient),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: filtered.length + 1,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    if (index == filtered.length) {
                      return TextButton.icon(
                        onPressed: () async {
                          await context.push('/clients/new');
                          ref.invalidate(clientsStreamProvider);
                          setState(() {});
                        },
                        icon: Icon(Icons.add_rounded),
                        label: Text(AppStrings.addNewClient),
                      );
                    }
                    final client = filtered[index];
                    final name = client.doctorName ?? client.facilityName ?? 'Unnamed';
                    final subtitle = [
                      if (client.specialty != null) client.specialty,
                      if (client.region != null) client.region,
                    ].join(' · ');

                    return GlassCard(
                      padding: const EdgeInsets.all(12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => Navigator.pop(context, client),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                              child: Text(name[0].toUpperCase(), style: AppTextStyles.bodyMd.copyWith(color: AppColors.primary)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(name, style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600)),
                                  if (subtitle.isNotEmpty)
                                    Text(subtitle, style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
                                ],
                              ),
                            ),
                            if (client.classTier != null)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(client.classTier!, style: AppTextStyles.labelSm.copyWith(color: AppColors.primary)),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
