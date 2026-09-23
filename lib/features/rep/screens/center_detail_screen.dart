import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/theme/theme.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/providers/brand_provider.dart';
import '../../../core/models/center_model.dart';
import '../../../core/models/user_model.dart';
import '../../../core/widgets/glass_card.dart';

class CenterDetailScreen extends ConsumerWidget {
  final String centerId;
  const CenterDetailScreen({super.key, required this.centerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final centerAsync = ref.watch(centerByIdProvider(centerId));
    final appointmentsAsync = ref.watch(appointmentsProvider);
    final usersAsync = ref.watch(usersListProvider);
    final brandsAsync = ref.watch(brandsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.storeDetails),
      ),
      body: centerAsync.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) {
          debugPrint('CenterDetailScreen error: $err');
          return const Center(child: Text(AppStrings.lbl_38));
        },
        data: (center) {
          if (center == null) return const Center(child: Text(AppStrings.lbl_38));

          final centerAppts = appointmentsAsync.asData?.value
              .where((a) => a.centerId == centerId)
              .toList() ?? [];
          final users = usersAsync.asData?.value ?? [];
          final assignedRep = center.assignedRepId != null
              ? users.where((u) => u.id == center.assignedRepId).firstOrNull
              : null;
          final brand = center.brandId != null
              ? brandsAsync.asData?.value.where((b) => b.id == center.brandId).firstOrNull
              : null;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeaderCard(center: center, brand: brand, isDark: isDark),
                const SizedBox(height: 16),
                _InfoSection(center: center, assignedRep: assignedRep, visitCount: centerAppts.length, isDark: isDark),
                const SizedBox(height: 16),
                _AssignedRepCard(assignedRep: assignedRep, isDark: isDark),
                if (center.latitude != null && center.longitude != null) ...[
                  const SizedBox(height: 16),
                  _MapSection(lat: center.latitude!, lng: center.longitude!, name: center.name, isDark: isDark),
                ],
                if (centerAppts.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  SectionTitle(title: 'Visit History (${centerAppts.length})'),
                  const SizedBox(height: 12),
                  ...centerAppts.map((appt) => _VisitCard(appt: appt, isDark: isDark, onTap: () {
                    context.push('/rep/active_visit/${appt.id}?centerId=${appt.centerId}');
                  })),
                ],
                if (centerAppts.isEmpty) ...[
                  const SizedBox(height: 24),
                  SectionTitle(title: AppStrings.visitHistory),
                  const SizedBox(height: 12),
                  GlassCard(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Column(
                      children: [
                        Icon(Icons.history_rounded, size: 40, color: AppColors.onSurfaceVariant.withValues(alpha: 0.5)),
                        const SizedBox(height: 8),
                        Text(AppStrings.noVisitsYet, style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final CenterModel center;
  final dynamic brand;
  final bool isDark;
  const _HeaderCard({required this.center, required this.brand, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: AppColors.glowShadow,
            ),
            child: Icon(Icons.store_rounded, color: AppColors.onPrimary, size: 40),
          ),
          const SizedBox(height: 16),
          Text(center.name, style: AppTextStyles.headlineMd.copyWith(color: AppColors.onSurface), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: (center.status == 'active' ? AppColors.success : AppColors.error).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  center.status == 'active' ? 'Active' : center.status,
                  style: AppTextStyles.labelSm.copyWith(
                    color: center.status == 'active' ? AppColors.success : AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (brand != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.business_rounded, size: 13, color: AppColors.info),
                    const SizedBox(width: 4),
                    Text(brand.name, style: AppTextStyles.labelSm.copyWith(color: AppColors.info)),
                  ]),
                ),
              ],
            ],
          ),
          if (center.region != null || center.address != null) ...[
            const SizedBox(height: 8),
            Text(
              [center.region, center.address].where((e) => e != null && e.isNotEmpty).join(' - '),
              style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final CenterModel center;
  final UserModel? assignedRep;
  final int visitCount;
  final bool isDark;
  const _InfoSection({required this.center, this.assignedRep, required this.visitCount, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.storeInformation, style: AppTextStyles.headlineSm.copyWith(color: AppColors.onSurface)),
          const SizedBox(height: 16),
          _InfoRow(icon: Icons.pin_drop_rounded, label: AppStrings.region, value: center.region ?? 'Not set'),
          Divider(height: 20, color: AppColors.outlineVariant),
          _InfoRow(icon: Icons.location_on_rounded, label: AppStrings.address, value: center.address ?? 'Not set'),
          Divider(height: 20, color: AppColors.outlineVariant),
          _InfoRow(icon: Icons.calendar_today_rounded, label: AppStrings.totalVisits, value: '$visitCount'),
          Divider(height: 20, color: AppColors.outlineVariant),
          _InfoRow(icon: Icons.verified_user_rounded, label: AppStrings.status, value: center.status.toUpperCase()),
          Divider(height: 20, color: AppColors.outlineVariant),
          _InfoRow(icon: Icons.date_range_rounded, label: AppStrings.created, value: _formatDate(center.createdAt)),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant)),
            const SizedBox(height: 2),
            Text(value, style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }
}

class _AssignedRepCard extends StatelessWidget {
  final UserModel? assignedRep;
  final bool isDark;
  const _AssignedRepCard({this.assignedRep, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.assignedRepresentative, style: AppTextStyles.headlineSm.copyWith(color: AppColors.onSurface)),
          const SizedBox(height: 12),
          if (assignedRep != null)
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.repColor.withValues(alpha: 0.15),
                  child: Text(
                    assignedRep!.fullName.isNotEmpty
                        ? assignedRep!.fullName.split(' ').map((e) => e[0]).take(2).join()
                        : '?',
                    style: AppTextStyles.labelLg.copyWith(color: AppColors.repColor, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(assignedRep!.fullName, style: AppTextStyles.bodyLg.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text(assignedRep!.email, style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
                    ],
                  ),
                ),
              ],
            ),
          if (assignedRep == null)
            Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Icon(Icons.person_off_rounded, size: 22, color: AppColors.onSurfaceVariant),
                ),
                const SizedBox(width: 12),
                Text(AppStrings.noRepAssigned, style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
              ],
            ),
        ],
      ),
    );
  }
}

class _MapSection extends StatelessWidget {
  final double lat;
  final double lng;
  final String name;
  final bool isDark;
  const _MapSection({required this.lat, required this.lng, required this.name, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: 220,
          child: FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(lat, lng),
              initialZoom: 15,
              interactionOptions: const InteractionOptions(flags: InteractiveFlag.drag),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.pdos.app',
              ),
              MarkerLayer(markers: [
                Marker(
                  point: LatLng(lat, lng),
                  width: 50, height: 50,
                  child: Icon(Icons.location_on, size: 50, color: AppColors.primary),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

class _VisitCard extends StatelessWidget {
  final dynamic appt;
  final bool isDark;
  final VoidCallback onTap;
  const _VisitCard({required this.appt, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDone = appt.status.toString().contains('done');
    return GlassCard(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 8),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: isDone ? AppColors.success.withValues(alpha: 0.12) : AppColors.warning.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              isDone ? Icons.check_circle_rounded : Icons.schedule_rounded,
              color: isDone ? AppColors.success : AppColors.warning,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(appt.apptTime, style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w600, color: AppColors.onSurface)),
                const SizedBox(height: 2),
                Text(
                  _formatVisitDate(appt.apptDate),
                  style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
                ),
                if (appt.clientName != null && appt.clientName!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(appt.clientName!, style: AppTextStyles.labelSm.copyWith(color: AppColors.info)),
                ],
              ],
            ),
          ),
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.outlineVariant),
          ),
        ],
      ),
    );
  }

  String _formatVisitDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(title, style: AppTextStyles.headlineSm.copyWith(color: AppColors.onSurface)),
    );
  }
}
