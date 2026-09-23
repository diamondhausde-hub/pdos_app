// ignore_for_file: avoid_print
import 'package:drift/drift.dart' as drift;
import '../models/client_model.dart';
import '../local_db/app_database.dart';
import '../services/api_service.dart';

class ClientRepository {
  final ApiService _api = ApiService.instance;
  final AppDatabase _localDb;

  ClientRepository(this._localDb);

  Stream<List<ClientModel>> watchClients({String? repId, String? brandId}) {
    return _localDb.getClientsStream(repId: repId, brandId: brandId).map(
      (rows) => rows.map((r) => ClientModel.fromLocal(r)).toList(),
    );
  }

  Future<List<ClientModel>> searchClients(String query) async {
    final rows = await _localDb.searchClients(query);
    return rows.map((r) => ClientModel.fromLocal(r)).toList();
  }

  Future<void> createClient(ClientModel client) async {
    await _localDb.into(_localDb.localClients).insert(
      client.copyWith(synced: false).toLocalCompanion(),
      mode: drift.InsertMode.insertOrReplace,
    );
  }

  Future<ClientModel?> createClientOnServer(ClientModel client) async {
    try {
      // Reverted to unified /clients endpoint as backend is not yet split
      final response = await _api.dio.post('/clients', data: client.toJson());
      final saved = ClientModel.fromJson(response.data);
      await _localDb.into(_localDb.localClients).insert(
        saved.toLocalCompanion(),
        mode: drift.InsertMode.insertOrReplace,
      );
      return saved;
    } catch (e) {
      print('Error creating client on server: $e');
      return null;
    }
  }

  Future<void> updateClientLocally(String id, ClientModel updated) async {
    await _localDb.into(_localDb.localClients).insert(
      updated.copyWith(synced: false).toLocalCompanion(),
      mode: drift.InsertMode.insertOrReplace,
    );
  }

  Future<ClientModel?> getClientById(String id) async {
    final row = await (_localDb.select(_localDb.localClients)..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    return ClientModel.fromLocal(row);
  }
}
