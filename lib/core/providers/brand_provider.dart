import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/brand_model.dart';
import 'data_providers.dart';
import 'auth_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Selected Brand State (for General Manager's brand switcher)
// null = all brands combined; a specific brand_id = filter to that brand
// ─────────────────────────────────────────────────────────────────────────────
final selectedBrandIdProvider = StateProvider<String?>((ref) => null);

// ─────────────────────────────────────────────────────────────────────────────
// Brands list — fetched from GET /brands
// Only visible to admin and general_manager
// ─────────────────────────────────────────────────────────────────────────────
final brandsProvider = FutureProvider<List<BrandModel>>((ref) async {
  final api = ref.read(apiServiceProvider);
  final resp = await api.dio.get('/brands');
  if (resp.statusCode == 200) {
    final List<dynamic> data = resp.data as List<dynamic>;
    return data.map((e) => BrandModel.fromJson(e as Map<String, dynamic>)).toList();
  }
  return [];
});

// ─────────────────────────────────────────────────────────────────────────────
// Convenience: the currently selected BrandModel object (null = all brands)
// ─────────────────────────────────────────────────────────────────────────────
final selectedBrandProvider = Provider<BrandModel?>((ref) {
  final selectedId = ref.watch(selectedBrandIdProvider);
  if (selectedId == null) return null;
  final brands = ref.watch(brandsProvider).asData?.value ?? [];
  try {
    return brands.firstWhere((b) => b.id == selectedId);
  } catch (_) {
    return null;
  }
});

// ─────────────────────────────────────────────────────────────────────────────
// The brand of the current user (if any)
// ─────────────────────────────────────────────────────────────────────────────
final myBrandProvider = FutureProvider<BrandModel?>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null || user.brandId == null) return null;
  
  final api = ref.watch(apiServiceProvider);
  try {
    // Try to find it in the brandsProvider first
    final brands = ref.watch(brandsProvider).asData?.value;
    if (brands != null) {
      return brands.firstWhere((b) => b.id == user.brandId);
    }
  } catch (_) {}
  
  // Otherwise, fetch it directly
  try {
    final resp = await api.dio.get('/brands/${user.brandId}');
    if (resp.statusCode == 200) {
      return BrandModel.fromJson(resp.data as Map<String, dynamic>);
    }
  } catch (_) {}
  
  return null;
});
