import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/providers/brand_provider.dart';
import '../../../core/models/user_model.dart';
import '../../../core/models/brand_model.dart';
import '../../../core/models/product_model.dart';
import '../../../core/models/team_directory_model.dart';
import '../../../core/widgets/glass_card.dart';
import '../../supervisor/screens/rep_route_screen.dart';
import '../../supervisor/screens/rep_report_screen.dart';
import '../../../core/services/api_service.dart';
import '../../../core/utils/image_url_helper.dart';
import '../../shared/screens/public_profile_screen.dart';

class TeamDirectoryTab extends ConsumerStatefulWidget {
  const TeamDirectoryTab({super.key});

  @override
  ConsumerState<TeamDirectoryTab> createState() => _TeamDirectoryTabState();
}

class _TeamDirectoryTabState extends ConsumerState<TeamDirectoryTab> {
  String get _searchQuery => _searchCtrl.text.toLowerCase().trim();
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brandsAsync = ref.watch(brandsProvider);
    final selectedBrandId = ref.watch(selectedBrandIdProvider);
    final teamAsync = ref.watch(teamDirectoryProvider);
    final productsAsync = ref.watch(productsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        _buildSummaryBar(teamAsync),
        _buildBrandCarousel(brandsAsync, selectedBrandId, isDark),
        if (selectedBrandId != null)
          Expanded(child: _buildTeamAndProducts(teamAsync, productsAsync, isDark))
        else
          Expanded(child: _buildSelectBrandPlaceholder(isDark)),
      ],
    );
  }

  Widget _buildSummaryBar(AsyncValue<List<TeamDirectoryNode>> teamAsync) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: teamAsync.when(
        data: (team) {
          int totalSups = team.length;
          int totalReps = team.fold(0, (sum, node) => sum + node.reps.length);
          int activeSups = team.where((n) => n.supervisor.isActive).length;
          int activeReps = team.fold(0, (sum, node) => sum + node.reps.where((r) => r.isActive).length);

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatColumn(value: '$totalSups', label: 'Supervisors', icon: Icons.shield),
              _StatColumn(value: '$totalReps', label: 'Reps', icon: Icons.groups),
              _StatColumn(value: '${activeSups + activeReps}', label: 'Active', icon: Icons.circle, iconColor: AppColors.success),
            ],
          );
        },
        loading: () => Center(child: CircularProgressIndicator(color: AppColors.onPrimary)),
        error: (e, s) => Text('Error', style: TextStyle(color: AppColors.onPrimary)),
      ),
    );
  }

  Widget _buildBrandCarousel(AsyncValue<List<BrandModel>> brandsAsync, String? selectedBrandId, bool isDark) {
    return brandsAsync.when(
      loading: () => const SizedBox(height: 80, child: Center(child: CircularProgressIndicator())),
      error: (e, _) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text('Error loading brands: $e', style: TextStyle(color: Colors.red)),
      ),
      data: (brands) {
        if (brands.isEmpty) {
          return Padding(
            padding: EdgeInsets.all(16),
            child: Text('No brands available', style: TextStyle(color: AppColors.onSurfaceVariant)),
          );
        }

        return Container(
          height: 90,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: brands.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _BrandCard(
                  brand: null,
                  isSelected: selectedBrandId == null,
                  onTap: () => ref.read(selectedBrandIdProvider.notifier).state = null,
                );
              }
              final brand = brands[index - 1];
              return _BrandCard(
                brand: brand,
                isSelected: selectedBrandId == brand.id,
                onTap: () => ref.read(selectedBrandIdProvider.notifier).state = brand.id,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTeamAndProducts(
    AsyncValue<List<TeamDirectoryNode>> teamAsync,
    AsyncValue<List<ProductModel>> productsAsync,
    bool isDark,
  ) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: TabBar(
              labelStyle: AppTextStyles.labelLg.copyWith(fontWeight: FontWeight.w600),
              unselectedLabelStyle: AppTextStyles.labelLg,
              indicator: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: AppColors.onSurface.withValues(alpha: 0.04), blurRadius: 8, offset: Offset(0, 2)),
                ],
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(icon: Icon(Icons.people_rounded), text: 'Team'),
                Tab(icon: Icon(Icons.inventory_2_rounded), text: 'Products'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: TabBarView(
              children: [
                _buildTeamList(teamAsync),
                _buildProductsGrid(productsAsync, isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamList(AsyncValue<List<TeamDirectoryNode>> teamAsync) {
    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(teamDirectoryProvider),
      child: teamAsync.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (team) {
          if (team.isEmpty) {
            return const Center(child: Text('No team members for this brand'));
          }

          final filtered = team.map((node) {
            final matchingReps = _searchQuery.isEmpty
                ? node.reps
                : node.reps.where((r) =>
                    r.fullName.toLowerCase().contains(_searchQuery) ||
                    r.email.toLowerCase().contains(_searchQuery)).toList();
            final supMatches = _searchQuery.isEmpty ||
                node.supervisor.fullName.toLowerCase().contains(_searchQuery) ||
                node.supervisor.email.toLowerCase().contains(_searchQuery);
            return MapEntry(node, supMatches ? node.reps : matchingReps);
          }).where((e) => _searchQuery.isEmpty || e.key.reps.isNotEmpty).toList();

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final entry = filtered[index];
              final node = entry.key;
              final sup = node.supervisor;
              final reps = entry.value;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GlassCard(
                  padding: const EdgeInsets.all(4),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    leading: CircleAvatar(
                      radius: 22,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      child: Text(
                        sup.fullName.isNotEmpty ? sup.fullName[0].toUpperCase() : '?',
                        style: AppTextStyles.bodyLg.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(sup.fullName, style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600)),
                    subtitle: Row(
                      children: [
                        Icon(Icons.shield, size: 14, color: AppColors.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Text('${reps.length} Reps', style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
                      ],
                    ),
                    childrenPadding: const EdgeInsets.only(bottom: 8),
                    children: [
                      ListTile(
                        dense: true,
                        leading: Icon(Icons.person_outline, size: 20, color: AppColors.primary),
                        title: Text('Supervisor Profile', style: AppTextStyles.bodyMd.copyWith(color: AppColors.primary)),
                        trailing: Icon(Icons.chevron_right, size: 18),
                        onTap: () => _showUserDetail(context, sup, true),
                      ),
                      const Divider(height: 1, indent: 16, endIndent: 16),
                      ...reps.map((rep) => ListTile(
                        dense: true,
                        leading: CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.success.withValues(alpha: 0.1),
                          child: Text(
                            rep.fullName.isNotEmpty ? rep.fullName[0].toUpperCase() : '?',
                            style: AppTextStyles.labelSm.copyWith(color: AppColors.success, fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(rep.fullName, style: AppTextStyles.bodyMd),
                        subtitle: Text(rep.region ?? 'No region', style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
                        trailing: Icon(Icons.chevron_right, size: 16),
                        onTap: () => _showUserDetail(context, rep, false),
                      )),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildProductsGrid(AsyncValue<List<ProductModel>> productsAsync, bool isDark) {
    return productsAsync.when(
      loading: () => Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (products) {
        if (products.isEmpty) {
          return const Center(child: Text('No products for this brand'));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.8,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return GlassCard(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: product.imageUrl != null
                          ? Image.network(
                              fullImageUrl(product.imageUrl),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (_, _, _) => _productPlaceholder(product),
                            )
                          : _productPlaceholder(product),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.name, style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 2),
                        if (product.category != null)
                          Text(product.category!, style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant), maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.inventory_2, size: 14, color: product.isLowStock ? AppColors.error : AppColors.success),
                            const SizedBox(width: 4),
                            Text('${product.stockQty} ${product.isLowStock ? '(Low)' : ''}', style: AppTextStyles.labelSm.copyWith(color: product.isLowStock ? AppColors.error : AppColors.onSurfaceVariant)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _productPlaceholder(ProductModel product) {
    return Container(
      color: AppColors.primary.withValues(alpha: 0.05),
      child: Center(
        child: Icon(Icons.inventory_2_rounded, size: 48, color: AppColors.primary.withValues(alpha: 0.3)),
      ),
    );
  }

  Widget _buildSelectBrandPlaceholder(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.touch_app_rounded, size: 40, color: AppColors.primary.withValues(alpha: 0.5)),
          ),
          const SizedBox(height: 24),
          Text('Select a Brand', style: AppTextStyles.headlineMd.copyWith(color: AppColors.onSurfaceVariant)),
          const SizedBox(height: 8),
          Text('Choose a brand above to view its team\nand products', style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  void _showUserDetail(BuildContext context, UserModel user, bool isSupervisor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (ctx, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.outlineVariant.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.primaryContainer.withValues(alpha: 0.2),
                    child: Text(
                      user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : '?',
                      style: AppTextStyles.headlineMd.copyWith(color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.fullName, style: AppTextStyles.headlineSm),
                        Text(isSupervisor ? 'Supervisor' : 'Sales Rep', style: AppTextStyles.bodyMd.copyWith(color: AppColors.primary)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text('Details', style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              _DetailRow(label: 'Email', value: user.email),
              _DetailRow(label: 'Phone', value: user.phone ?? 'N/A'),
              _DetailRow(label: 'Region', value: user.region ?? 'N/A'),
              _DetailRow(label: 'Status', value: user.isActive ? 'Active' : 'Inactive'),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => PublicProfileScreen(userId: user.id)));
                  },
                  icon: Icon(Icons.person_search_rounded),
                  label: Text('View Public Profile'),
                ),
              ),
              const SizedBox(height: 12),
              if (!isSupervisor) ...[
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => RepRouteScreen(rep: user)));
                    },
                    icon: Icon(Icons.route),
                    label: Text('View Movements'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => RepReportScreen(rep: user)));
                    },
                    icon: Icon(Icons.assessment),
                    label: Text('Detailed Report'),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _requestDeactivation(context, user.id),
                  icon: Icon(Icons.block),
                  label: Text('Request Deactivation'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade100, foregroundColor: Colors.red.shade900),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _requestDeactivation(BuildContext context, String userId) async {
    try {
      await ApiService.instance.dio.post('/users/$userId/request-deactivation');
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Deactivation request sent to Admins')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error sending request: $e')));
      }
    }
  }
}

class _BrandCard extends StatelessWidget {
  final BrandModel? brand;
  final bool isSelected;
  final VoidCallback onTap;

  const _BrandCard({required this.brand, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        width: 120,
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.15),
                    AppColors.primary.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : (isDark ? AppColors.darkCard : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary.withValues(alpha: 0.4) : (isDark ? AppColors.onSurface : AppColors.outlineVariant.withValues(alpha: 0.3)),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.15), blurRadius: 12, offset: Offset(0, 4))]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: brand != null
                    ? Text(
                        brand!.name.isNotEmpty ? brand!.name[0].toUpperCase() : 'B',
                        style: AppTextStyles.headlineSm.copyWith(
                          color: isSelected ? Colors.white : AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Icon(Icons.all_inclusive_rounded, size: 22, color: isSelected ? Colors.white : AppColors.primary),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              brand?.name ?? 'All Brands',
              style: AppTextStyles.labelSm.copyWith(
                color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color? iconColor;

  const _StatColumn({required this.value, required this.label, required this.icon, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: iconColor ?? Colors.white70, size: 24),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.onPrimary)),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.white70)),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
          Text(value, style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
