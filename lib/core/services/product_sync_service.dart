// ignore_for_file: avoid_print
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_service.dart';
import '../local_db/app_database.dart';
import '../models/product_model.dart';
import '../providers/data_providers.dart';

final productSyncServiceProvider = Provider((ref) {
  final api = ApiService.instance;
  final db = ref.watch(appDatabaseProvider);
  return ProductSyncService(api, db);
});

class ProductSyncService {
  final ApiService _api;
  final AppDatabase _localDb;

  ProductSyncService(this._api, this._localDb);

  Future<void> pullProducts() async {
    try {
      final response = await _api.dio.get('/products');
      final data = response.data as List;
      
      final serverIds = data.map((json) => json['id'] as String).toSet();

      final localProducts = data.map((json) {
        final p = ProductModel.fromJson(json);
        return LocalProduct(
          id: p.id,
          name: p.name,
          category: p.category,
          barcode: p.barcode,
          unitPrice: p.unitPrice,
          stockQty: p.stockQty,
          isLowStock: p.isLowStock,
          imageUrl: p.imageUrl,
          isActive: p.isActive,
          brandId: p.brandId,
        );
      }).toList();

      await _localDb.batch((batch) {
        batch.insertAllOnConflictUpdate(_localDb.localProducts, localProducts);
      });

      // Remove products that were deleted on the server
      if (serverIds.isNotEmpty) {
        await (_localDb.delete(_localDb.localProducts)
          ..where((p) => p.id.isNotIn(serverIds)))
            .go();
      }

      print('Successfully pulled ${localProducts.length} products to local DB');
    } catch (e) {
      print('Failed to pull products: $e');
    }
  }
}
