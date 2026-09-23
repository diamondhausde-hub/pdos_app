// ignore_for_file: avoid_print
import '../services/api_service.dart';
import '../models/product_model.dart';
import '../local_db/app_database.dart';
import 'package:drift/drift.dart' as drift;
import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ProductRepository {
  final ApiService _api = ApiService.instance;
  final AppDatabase _localDb;

  ProductRepository(this._localDb);

  Future<List<ProductModel>> getProducts() async {
    try {
      final locals = await _localDb.select(_localDb.localProducts).get();
      return locals.map((l) => ProductModel(
        id: l.id,
        name: l.name,
        category: l.category,
        barcode: l.barcode,
        unitPrice: l.unitPrice,
        stockQty: l.stockQty,
        imageUrl: l.imageUrl,
        isActive: l.isActive,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      )).toList();
    } catch (e) {
      print('Error reading local products: $e');
      return [];
    }
  }

  Future<void> updateProduct(String id, Map<String, dynamic> data) async {
    try {
      final response = await _api.dio.put('/products/$id', data: data);
      final updated = ProductModel.fromJson(response.data);
      await _localDb.into(_localDb.localProducts).insertOnConflictUpdate(LocalProductsCompanion(
        id: drift.Value(updated.id),
        name: drift.Value(updated.name),
        category: drift.Value(updated.category),
        barcode: drift.Value(updated.barcode),
        unitPrice: drift.Value(updated.unitPrice),
        stockQty: drift.Value(updated.stockQty),
        isLowStock: drift.Value(updated.isLowStock),
        imageUrl: drift.Value(updated.imageUrl),
        isActive: drift.Value(updated.isActive),
      ));
    } catch (e) {
      print('Error updating product: $e');
    }
  }

  Future<String?> createProduct(ProductModel product) async {
    try {
      final response = await _api.dio.post('/products', data: product.toJson());
      final created = ProductModel.fromJson(response.data);
      await _localDb.into(_localDb.localProducts).insertOnConflictUpdate(LocalProductsCompanion(
        id: drift.Value(created.id),
        name: drift.Value(created.name),
        category: drift.Value(created.category),
        barcode: drift.Value(created.barcode),
        unitPrice: drift.Value(created.unitPrice),
        stockQty: drift.Value(created.stockQty),
        isLowStock: drift.Value(created.isLowStock),
        imageUrl: drift.Value(created.imageUrl),
        isActive: drift.Value(created.isActive),
      ));
      return created.id;
    } catch (e) {
      print('Error creating product: $e');
      return null;
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _api.dio.delete('/products/$id');
      await (_localDb.delete(_localDb.localProducts)..where((t) => t.id.equals(id))).go();
    } catch (e) {
      print('Error deleting product: $e');
    }
  }

  Future<String?> uploadProductImage(String productId, String filePath) async {
    try {
      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        filePath,
        '${filePath}_compressed.jpg',
        quality: 80,
        minWidth: 1000,
      );

      if (compressedFile == null) return null;

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(compressedFile.path),
      });

      final response = await _api.dio.post(
        '/products/$productId/image',
        data: formData,
      );

      return response.data['image_url'] as String?;
    } catch (e) {
      print('Error uploading image: $e');
      rethrow;
    }
  }
}