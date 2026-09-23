import 'package:pdos_app/core/localization/app_strings.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/utils/mention_handler.dart';
import '../../../core/local_db/app_database.dart';
import 'package:drift/drift.dart' as drift;
import '../../../core/providers/data_providers.dart';
import '../../../core/models/client_model.dart';
import '../../../core/utils/image_url_helper.dart';
import '../../../core/services/api_service.dart';
import '../../../core/widgets/supervisor_badge.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/models/user_model.dart';



final visitDetailProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, String>((ref, visitId) async {
  final db = ref.watch(appDatabaseProvider);
  LocalVisit? visit = await (db.select(db.localVisits)..where((t) => t.id.equals(visitId))).getSingleOrNull();
  
  // If not found by id, try fetching by appointment id
  visit ??= await (db.select(db.localVisits)..where((t) => t.appointmentId.equals(visitId))).getSingleOrNull();

  // If still null, try fetching from remote API
  if (visit == null) {
    try {
      final api = ref.read(apiServiceProvider);
      final response = await api.dio.get('/visits/$visitId');
      final data = response.data;
      
      final v = LocalVisit(
        id: data['id'],
        repId: data['rep_id'],
        centerId: data['center_id'],
        clientId: data['client_id'],
        visitDate: DateTime.parse(data['visit_date']),
        arrivalTime: data['arrival_time'] != null ? DateTime.parse(data['arrival_time']) : null,
        completionTime: data['completion_time'] != null ? DateTime.parse(data['completion_time']) : null,
        status: data['status'] ?? 'planned',
        notes: data['notes'],
        isFlagged: false,
        synced: true,
        createdAt: data['created_at'] != null ? DateTime.parse(data['created_at']) : DateTime.now(),
        updatedAt: DateTime.now(),
        isAbandoned: false,
        visitType: data['visit_type'] ?? 'center',
        visitReason: data['visit_reason'],
        interestedProductIds: (data['interested_product_ids'] as List?)?.join(','),
      );

      final centerName = data['center_name'] ?? 'Unknown Center';
      
      final sales = (data['items'] as List?)?.map((i) => LocalVisitItem(
        id: i['id'] ?? '',
        visitId: v.id,
        productId: i['product_id'] ?? '',
        qtySold: i['qty_sold'] ?? 0,
        qtyFree: i['qty_free'] ?? 0,
        priceAtSale: (i['price_at_sale'] ?? 0).toDouble(),
        synced: true,
        createdAt: DateTime.now(),
        isAbandoned: false,
      )).toList() ?? [];
      
      final specialRequests = (data['special_requests'] as List?)?.map((sr) => LocalSpecialRequest(
        id: sr['id'] ?? '',
        visitId: v.id,
        requestType: sr['request_type'] ?? 'other',
        description: sr['content'] ?? '',
        synced: true,
        createdAt: DateTime.now(),
        isAbandoned: false,
      )).toList() ?? [];
      
      final photos = (data['photos'] as List?)?.map((p) => LocalVisitPhoto(
        id: p['id'] ?? '',
        visitId: v.id,
        photoPath: p['photo_url'] ?? '',
        uploadedUrl: p['photo_url'],
        synced: true,
        createdAt: DateTime.now(),
        isAbandoned: false,
      )).toList() ?? [];
      
      List<LocalExpense> expenses = [];
      try {
        final expRes = await api.dio.get('/visits/$visitId/expenses');
        expenses = (expRes.data as List?)?.map((e) => LocalExpense(
          id: e['id'] ?? '',
          visitId: v.id,
          repId: v.repId,
          category: e['category'] ?? 'other',
          amount: (e['amount'] ?? 0).toDouble(),
          description: e['description'] ?? '',
          receiptImagePath: e['receipt_image_url'],
          status: e['status'] ?? 'pending',
          requiresAdminApproval: false,
          synced: true,
          createdAt: DateTime.now(),
          isAbandoned: false,
        )).toList().cast<LocalExpense>() ?? <LocalExpense>[];
      } catch (_) {}

      // Resolve the doctor (client) for doctor visits
      ClientModel? remoteClient;
      List<LocalProduct> interestedProducts = [];
      if (v.clientId != null) {
        try {
          remoteClient = await ref.read(clientRepositoryProvider).getClientById(v.clientId!);
        } catch (_) {}
        if (remoteClient == null) {
          try {
            final res = await api.dio.get('/clients');
            final match = (res.data as List).where((c) => c['id'] == v.clientId).firstOrNull;
            if (match != null) remoteClient = ClientModel.fromJson(match);
          } catch (_) {}
        }
      }
      if (v.interestedProductIds != null && v.interestedProductIds!.isNotEmpty) {
        final ids = v.interestedProductIds!.split(',').toSet();
        interestedProducts = await (db.select(db.localProducts)
              ..where((t) => t.id.isIn(ids)))
            .get();
      }

      return {
        'visit': v,
        'center': null,
        'centerName': centerName,
        'client': remoteClient,
        'interestedProducts': interestedProducts,
        'sales': sales,
        'stock': <LocalPharmacyStockCheck>[], // Not easily available remotely right now
        'photos': photos, 
        'expenses': expenses,
        'specialRequests': specialRequests,
      };
    } catch (e) {
      throw Exception('Visit not found locally and failed to fetch remotely: $e');
    }
  }

  // If found locally, proceed with local loading
  final v = visit;

  LocalCenter? centerLocal = await (db.select(db.localCenters)..where((t) => t.id.equals(v.centerId))).getSingleOrNull();
  String centerName = centerLocal?.name ?? 'Unknown Center';
  if (centerLocal == null) {
    try {
      final centerRepo = ref.read(centerRepositoryProvider);
      final remote = await centerRepo.getCenterById(v.centerId);
      if (remote != null) centerName = remote.name;
    } catch (_) {}
  }

  ClientModel? client;
  if (v.appointmentId != null) {
    final appt = await (db.select(db.localAppointments)..where((t) => t.id.equals(v.appointmentId!))).getSingleOrNull();
    if (appt?.clientId != null) {
      client = await ref.read(clientRepositoryProvider).getClientById(appt!.clientId!);
    }
  }
  // Doctor-visit flow: the visit references its doctor directly.
  if (client == null && v.clientId != null) {
    try {
      client = await ref.read(clientRepositoryProvider).getClientById(v.clientId!);
    } catch (_) {}
  }
  final sales = await (db.select(db.localVisitItems)..where((t) => t.visitId.equals(v.id))).get();
  final stock = await (db.select(db.localPharmacyStockChecks)..where((t) => t.visitId.equals(v.id))).get();
  
  final allProductIds = <String>{};
  for (var s in sales) { allProductIds.add(s.productId); }
  for (var s in stock) {
    if (s.productId != null) allProductIds.add(s.productId!);
  }
  if (v.interestedProductIds != null && v.interestedProductIds!.isNotEmpty) {
    allProductIds.addAll(v.interestedProductIds!.split(','));
  }

  List<LocalProduct> relatedProducts = [];
  if (allProductIds.isNotEmpty) {
    relatedProducts = await (db.select(db.localProducts)..where((t) => t.id.isIn(allProductIds))).get();
  }
  
  final productMap = {for (var p in relatedProducts) p.id: p};

  List<LocalProduct> interestedProducts = [];
  if (v.interestedProductIds != null && v.interestedProductIds!.isNotEmpty) {
    final ids = v.interestedProductIds!.split(',').toSet();
    interestedProducts = relatedProducts.where((p) => ids.contains(p.id)).toList();
  }
  final photos = await (db.select(db.localVisitPhotos)..where((t) => t.visitId.equals(v.id))).get();
  final expenses = await (db.select(db.localExpenses)..where((t) => t.visitId.equals(v.id))).get();
  final specialRequests = await (db.select(db.localSpecialRequests)..where((t) => t.visitId.equals(v.id))).get();
  
  return {
    'visit': v, 
    'center': centerLocal, 
    'centerName': centerName, 
    'client': client, 
    'interestedProducts': interestedProducts,
    'productMap': productMap,
    'sales': sales, 
    'stock': stock, 
    'photos': photos,
    'expenses': expenses,
    'specialRequests': specialRequests,
  };
});



class VisitDetailScreen extends ConsumerWidget {
  final String visitId;
  const VisitDetailScreen({super.key, required this.visitId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(visitDetailProvider(visitId));
    final currentUser = ref.watch(currentUserProvider);
    final canReview = currentUser?.role == UserRole.supervisor || currentUser?.role == UserRole.generalManager || currentUser?.role == UserRole.admin;

    return Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.visitDetails),
              detailAsync.whenOrNull(
                data: (data) {
                  final LocalVisit visit = data['visit'];
                  return Container(
                    margin: const EdgeInsets.only(top: 2),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: visit.referenceCode != null ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      visit.referenceCode ?? 'Pending sync',
                      style: AppTextStyles.labelSm.copyWith(
                        color: visit.referenceCode != null ? AppColors.primary : AppColors.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  );
                },
              ) ?? const SizedBox.shrink(),
            ],
          ),
        ),
        body: detailAsync.when(
          loading: () => Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
          data: (data) {
            final LocalVisit visit = data['visit'];
            final LocalCenter? center = data['center'] as LocalCenter?;
            final String centerName = data['centerName'] as String? ?? center?.name ?? 'Unknown Center';
            final ClientModel? client = data['client'] as ClientModel?;
            final List<LocalVisitItem> sales = data['sales'];
            final List<LocalPharmacyStockCheck> stock = data['stock'];
            final List<LocalVisitPhoto> photos = data['photos'];
            final List<dynamic> expenses = data['expenses'] ?? [];
            final List<dynamic> specialRequests = data['specialRequests'] ?? [];
            final Map<String, LocalProduct> productMap = data['productMap'] ?? {};
            final List<LocalProduct> interestedProducts =
                (data['interestedProducts'] as List?)?.cast<LocalProduct>() ?? [];
            final dateFormat = DateFormat('MMM dd, yyyy - hh:mm a');
            
            // Group Sales
            final Map<String, Map<String, int>> groupedSales = {};
            for (var s in sales) {
              groupedSales.putIfAbsent(s.productId, () => {'sold': 0, 'free': 0});
              groupedSales[s.productId]!['sold'] = groupedSales[s.productId]!['sold']! + s.qtySold;
              groupedSales[s.productId]!['free'] = groupedSales[s.productId]!['free']! + s.qtyFree;
            }

            // Group Stock
            final Map<String, int> groupedStock = {};
            for (var s in stock) {
              final pid = s.productId ?? 'unknown';
              groupedStock[pid] = (groupedStock[pid] ?? 0) + s.observedQty;
            }

            String durationStr = 'N/A';
            if (visit.arrivalTime != null && visit.completionTime != null) {
              final diff = visit.completionTime!.difference(visit.arrivalTime!);
              durationStr = '${diff.inMinutes} minutes';
            }

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                if (!visit.synced)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(children: [
                      Icon(Icons.sync_problem_rounded, color: AppColors.warning, size: 20),
                      const SizedBox(width: 8),
                      Expanded(child: Text(AppStrings.pendingSyncWithServer, style: AppTextStyles.bodySm.copyWith(color: AppColors.warning))),
                    ]),
                  ),

                if (visit.supervisorNote != null || canReview)
                  GlassCard(
                    variant: GlassVariant.primary,
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: (visit.isFlagged ? AppColors.error : AppColors.info).withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(visit.isFlagged ? Icons.flag_rounded : Icons.rate_review_rounded,
                                    color: visit.isFlagged ? AppColors.error : AppColors.info, size: 20),
                              ),
                              const SizedBox(width: 10),
                              Text(visit.isFlagged ? 'Flagged Note' : 'Supervisor Review',
                                  style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w600,
                                      color: visit.isFlagged ? AppColors.error : AppColors.info)),
                            ]),
                            if (canReview)
                              IconButton(
                                icon: Icon(Icons.edit_note_rounded),
                                color: visit.isFlagged ? AppColors.error : AppColors.info,
                                onPressed: () => _showAddNoteDialog(context, ref, visit),
                              ),
                          ],
                        ),
                        if (visit.supervisorNote != null && visit.supervisorNote!.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          RichText(
                            text: TextSpan(
                              children: MentionHandler.buildSpans(
                                context,
                                visit.supervisorNote!,
                                ref,
                                defaultStyle: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurface),
                              ),
                            ),
                          ),
                        ] else if (canReview) ...[
                          const SizedBox(height: 10),
                          Text(AppStrings.noNoteAddedYet, style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant, fontStyle: FontStyle.italic)),
                        ],
                      ],
                    ),
                  ),

                _VisitNotesSection(visitId: visitId),

                if (visit.visitType == 'doctor')
                  _DoctorVisitSection(visit: visit, client: client, interestedProducts: interestedProducts),

                if (client != null)
                  GlassCard(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Container(
                            width: 52, height: 52,
                            decoration: BoxDecoration(color: AppColors.tertiary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)),
                            child: Icon(Icons.person_rounded, color: AppColors.tertiary, size: 28),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(client.doctorName ?? client.facilityName ?? 'Client', style: AppTextStyles.headlineSm.copyWith(color: AppColors.onSurface)),
                              if (client.phoneNumber != null)
                                Text(client.phoneNumber!, style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
                            ]),
                          ),
                        ]),
                      ],
                    ),
                  ),
                GlassCard(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Container(
                          width: 52, height: 52,
                          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)),
                          child: Icon(Icons.store_rounded, color: AppColors.primary, size: 28),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(centerName, style: AppTextStyles.headlineSm.copyWith(color: AppColors.onSurface)),
                            Text(center?.address ?? 'No address', style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
                          ]),
                        ),
                      ]),
                    ],
                  ),
                ),

                GlassCard(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                          child: Icon(Icons.info_rounded, color: AppColors.info, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Text(AppStrings.visitInformation, style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w600, color: AppColors.onSurface)),
                      ]),
                      Divider(height: 24, color: AppColors.outlineVariant),
                      _InfoRow(label: AppStrings.status, value: visit.status.toUpperCase()),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: SupervisorVisitBadge(repId: visit.repId),
                      ),
                      const SizedBox(height: 8),
                      _InfoRow(label: AppStrings.arrived, value: visit.arrivalTime != null ? dateFormat.format(visit.arrivalTime!) : 'N/A'),
                      const SizedBox(height: 8),
                      _InfoRow(label: AppStrings.completed, value: visit.completionTime != null ? dateFormat.format(visit.completionTime!) : 'N/A'),
                      const SizedBox(height: 8),
                      _InfoRow(label: AppStrings.duration, value: durationStr),
                    ],
                  ),
                ),

                if (groupedSales.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 8),
                    child: Text('Sales (${groupedSales.length})', style: AppTextStyles.headlineSm.copyWith(color: AppColors.onSurface)),
                  ),
                  ...groupedSales.entries.map((entry) {
                    final pId = entry.key;
                    final qtySold = entry.value['sold'] ?? 0;
                    final qtyFree = entry.value['free'] ?? 0;
                    final pName = productMap[pId]?.name ?? pId;
                    
                    return GlassCard(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      child: Row(children: [
                        Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                          child: Icon(Icons.shopping_cart_rounded, color: AppColors.success, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(pName, style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600, color: AppColors.onSurface)),
                            Text('Sold: $qtySold | Free: $qtyFree', style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
                          ]),
                        ),
                      ]),
                    );
                  }),
                  const SizedBox(height: 16),
                ],

                if (groupedStock.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 8),
                    child: Text('Stock Checks (${groupedStock.length})', style: AppTextStyles.headlineSm.copyWith(color: AppColors.onSurface)),
                  ),
                  ...groupedStock.entries.map((entry) {
                    final pId = entry.key;
                    final observedQty = entry.value;
                    final pName = pId == 'unknown' ? 'Competitor Product' : (productMap[pId]?.name ?? pId);

                    return GlassCard(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      child: Row(children: [
                        Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                          child: Icon(Icons.inventory_2_rounded, color: AppColors.secondary, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(pName, style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600, color: AppColors.onSurface)),
                            Text('Observed Stock: $observedQty', style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
                          ]),
                        ),
                      ]),
                    );
                  }),
                ],

                  if (photos.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 8),
                      child: Text('Shelf Photos (${photos.length})', style: AppTextStyles.headlineSm.copyWith(color: AppColors.onSurface)),
                    ),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: photos.length,
                        itemBuilder: (context, index) {
                          final p = photos[index];
                          Widget imageWidget;
                          if (!p.synced) {
                            imageWidget = Image.file(File(p.photoPath), fit: BoxFit.cover);
                          } else if (p.uploadedUrl != null) {
                            imageWidget = Center(child: Icon(Icons.cloud_done_rounded, color: AppColors.success, size: 32));
                          } else {
                            imageWidget = Center(child: Icon(Icons.image_not_supported_rounded, color: AppColors.onSurfaceVariant, size: 32));
                          }

                          return Container(
                            margin: const EdgeInsets.only(right: 8),
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: AppColors.surfaceContainer,
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                imageWidget,
                                if (p.synced)
                                  Positioned(
                                    top: 4, right: 4,
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(color: AppColors.onSurface.withValues(alpha: 0.38), shape: BoxShape.circle),
                                      child: Icon(Icons.cloud_done_rounded, color: AppColors.success, size: 16),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  if (visit.signaturePath != null || visit.signatureUrl != null) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 8),
                      child: Text(AppStrings.clientSignature, style: AppTextStyles.headlineSm.copyWith(color: AppColors.onSurface)),
                    ),
                    GlassCard(
                      padding: const EdgeInsets.all(16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: visit.signatureUrl != null
                          ? Image.network(
                              fullImageUrl(visit.signatureUrl!),
                              width: double.infinity,
                              height: 150,
                              fit: BoxFit.contain,
                              errorBuilder: (_, _, _) => Center(
                                child: Icon(Icons.image_not_supported_rounded, color: AppColors.onSurfaceVariant, size: 32),
                              ),
                            )
                          : Image.file(
                              File(visit.signaturePath!),
                              width: double.infinity,
                              height: 150,
                              fit: BoxFit.contain,
                              errorBuilder: (_, _, _) => Center(
                                child: Icon(Icons.image_not_supported_rounded, color: AppColors.onSurfaceVariant, size: 32),
                              ),
                            ),
                      ),
                    ),
                  ],
                if (expenses.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 8, top: 16),
                    child: Text('Expenses (${expenses.length})', style: AppTextStyles.headlineSm.copyWith(color: AppColors.onSurface)),
                  ),
                  ...expenses.map((e) => GlassCard(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                        child: Icon(Icons.receipt_long_rounded, color: AppColors.error, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(e.category, style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600, color: AppColors.onSurface)),
                              Text('\$${e.amount.toStringAsFixed(2)}', style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text('Status: ${e.status}', style: AppTextStyles.bodySm.copyWith(color: e.status == 'pending' ? AppColors.warning : AppColors.onSurfaceVariant)),
                          if (e.description != null) ...[
                            const SizedBox(height: 4),
                            Text(e.description, style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
                          ],
                        ]),
                      ),
                      if (e.status == 'pending') ...[
                        const SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.cancel_rounded, color: AppColors.error),
                          tooltip: AppStrings.cancelExpense_45,
                          onPressed: () => _showCancelExpenseDialog(context, ref, e.id),
                        ),
                      ],
                    ]),
                  )),
                ],

                if (specialRequests.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 8, top: 16),
                    child: Text('Special Requests (${specialRequests.length})', style: AppTextStyles.headlineSm.copyWith(color: AppColors.onSurface)),
                  ),
                  ...specialRequests.map((sr) => GlassCard(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    child: Row(children: [
                      Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                        child: Icon(Icons.star_rounded, color: AppColors.info, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(sr.requestType, style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600, color: AppColors.onSurface)),
                          if (sr.description != null) ...[
                            const SizedBox(height: 4),
                            Text(sr.description, style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
                          ],
                        ]),
                      ),
                    ]),
                  )),
                ],
              ],
            );
          },
        ),
        floatingActionButton: detailAsync.whenOrNull(
          data: (data) {
            final LocalVisit visit = data['visit'];
            if (visit.status != 'completed') return null;
            return FloatingActionButton.extended(
              onPressed: () async {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.downloadingPdf)));
                try {
                  final response = await ApiService.instance.dio.get(
                    '/visits/${visit.id}/invoice',
                    options: Options(
                      responseType: ResponseType.bytes,
                      receiveTimeout: const Duration(seconds: 15),
                    ),
                  );
                  final dir = await getApplicationDocumentsDirectory();
                  final file = File('${dir.path}/invoice_${visit.id}.pdf');
                  await file.writeAsBytes(response.data);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Report saved: ${file.path}'), backgroundColor: AppColors.success),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to download PDF: $e')));
                  }
                }
              },
              icon: Icon(Icons.picture_as_pdf_rounded),
              label: Text(AppStrings.downloadReport),
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
            );
          },
        ),
    );
  }

  Future<void> _showCancelExpenseDialog(BuildContext context, WidgetRef ref, String expenseId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppStrings.cancelExpense),
        content: Text(AppStrings.areYouSureYou),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(AppStrings.no)),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true), 
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(AppStrings.yesCancel)
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      try {
        final api = ref.read(apiServiceProvider);
        await api.dio.patch('/expenses/$expenseId/status', data: {'status': 'cancelled_by_rep'});
        
        // Update local DB
        final db = ref.read(appDatabaseProvider);
        await (db.update(db.localExpenses)..where((t) => t.id.equals(expenseId)))
            .write(const LocalExpensesCompanion(status: drift.Value('cancelled_by_rep')));
            
        ref.invalidate(visitDetailProvider(visitId));
        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.expenseCancelled)));
      } catch (e) {
        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to cancel: $e')));
      }
    }
  }

  Future<void> _showAddNoteDialog(BuildContext context, WidgetRef ref, LocalVisit visit) async {
    final noteCtrl = TextEditingController(text: visit.supervisorNote);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppStrings.supervisorNote),
        content: TextField(
          controller: noteCtrl,
          decoration: const InputDecoration(hintText: AppStrings.enterYourNoteHere),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(AppStrings.cancel)),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true), 
            child: Text(AppStrings.save)
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      try {
        final api = ref.read(apiServiceProvider);
        await api.dio.put('/visits/${visit.id}/note', data: {'review_note': noteCtrl.text});
        
        // Update local DB
        final db = ref.read(appDatabaseProvider);
        await (db.update(db.localVisits)..where((t) => t.id.equals(visit.id)))
            .write(LocalVisitsCompanion(supervisorNote: drift.Value(noteCtrl.text)));
            
        ref.invalidate(visitDetailProvider(visitId));
        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.noteSavedSuccessfully)));
      } catch (e) {
        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save note: $e')));
      }
    }
  }
}

class _DoctorVisitSection extends StatelessWidget {
  final LocalVisit visit;
  final ClientModel? client;
  final List<LocalProduct> interestedProducts;

  const _DoctorVisitSection({
    required this.visit,
    required this.client,
    required this.interestedProducts,
  });

  Color _treatmentColor(String q) {
    switch (q) {
      case 'good':
        return AppColors.success;
      case 'bad':
        return AppColors.error;
      default:
        return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = client;
    return GlassCard(
      variant: GlassVariant.primary,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          Row(children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.medical_services_rounded, color: AppColors.secondary, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(AppStrings.doctorVisit,
                    style: AppTextStyles.headlineSm.copyWith(
                        fontWeight: FontWeight.w800, color: AppColors.secondary, letterSpacing: 0.5)),
                if (c?.doctorName != null)
                  Text('Dr. ${c!.doctorName}',
                      style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurface)),
              ]),
            ),
            if (c?.classTier != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('Class ${c!.classTier}',
                    style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w800, color: AppColors.primary)),
              ),
          ]),

          const Divider(height: 26, color: AppColors.outlineVariant),

          // ── Reason ──
          if (visit.visitReason != null && visit.visitReason!.isNotEmpty) ...[
            _row(Icons.help_outline_rounded, 'Reason', visit.visitReason!),
            const SizedBox(height: 14),
          ],

          // ── Doctor profile extras ──
          if (c != null) ...[
            if (c.specialty != null && c.specialty!.isNotEmpty)
              _row(Icons.medical_information_rounded, 'Specialty', c.specialty!),
            if (c.gender != null && c.gender!.isNotEmpty) ...[
              const SizedBox(height: 10),
              _row(c.gender == 'female' ? Icons.female_rounded : Icons.male_rounded,
                  'Gender', c.gender![0].toUpperCase() + c.gender!.substring(1)),
            ],
            if (c.birthDate != null) ...[
              const SizedBox(height: 10),
              _row(Icons.cake_rounded, 'Date of Birth',
                  DateFormat('yyyy-MM-dd').format(c.birthDate!)),
            ],
            const SizedBox(height: 16),
          ],

          // ── Star rating ──
          Row(children: [
            ...List.generate(5, (i) => Icon(
                  i < (c?.rating ?? 0) ? Icons.star_rounded : Icons.star_border_rounded,
                  color: i < (c?.rating ?? 0) ? Colors.amber : AppColors.onSurfaceVariant,
                  size: 22,
                )),
            const SizedBox(width: 8),
            Text('${c?.rating ?? 0}/5',
                style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w700, color: AppColors.onSurface)),
          ]),
          if (c?.treatmentQuality != null && c!.treatmentQuality!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(children: [
              Text(AppStrings.treatment, style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _treatmentColor(c.treatmentQuality!).withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  c.treatmentQuality![0].toUpperCase() + c.treatmentQuality!.substring(1),
                  style: AppTextStyles.bodySm.copyWith(
                      fontWeight: FontWeight.w700, color: _treatmentColor(c.treatmentQuality!)),
                ),
              ),
            ]),
          ],
          if (c?.description != null && c!.description!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.outlineVariant),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(AppStrings.noteAboutThisDoctor,
                    style: AppTextStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant)),
                const SizedBox(height: 4),
                Text(c.description!, style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurface)),
              ]),
            ),
          ],

          const Divider(height: 26, color: AppColors.outlineVariant),

          // ── Reason / report / interests ──
          if (visit.visitReason != null && visit.visitReason!.isNotEmpty)
            _labeledBlock('Reason for Visit', visit.visitReason!),
          if (visit.notes != null && visit.notes!.isNotEmpty)
            _labeledBlock('Interview Report', visit.notes!),
          if (interestedProducts.isNotEmpty) ...[
            Text('Interested Products (${interestedProducts.length})',
                style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6, runSpacing: 6,
              children: interestedProducts.map((p) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(p.name,
                    style: AppTextStyles.bodySm.copyWith(fontWeight: FontWeight.w600, color: AppColors.primary)),
              )).toList(),
            ),
          ] else ...[
            Row(children: [
              Icon(Icons.inventory_2_rounded, size: 16, color: AppColors.onSurfaceVariant),
              const SizedBox(width: 6),
              Text(AppStrings.allProductsMarkedAs,
                  style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
            ]),
          ],
        ],
      ),
    );
  }

  Widget _row(IconData icon, String label, String value) {
    return Row(children: [
      Icon(icon, size: 17, color: AppColors.onSurfaceVariant),
      const SizedBox(width: 8),
      Text('$label: ', style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
      Expanded(child: Text(value,
          style: AppTextStyles.bodySm.copyWith(fontWeight: FontWeight.w600, color: AppColors.onSurface))),
    ]);
  }

  Widget _labeledBlock(String label, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
            style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant)),
        const SizedBox(height: 4),
        Text(text, style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurface)),
      ]),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label; final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
        Text(value, style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600, color: AppColors.onSurface)),
      ],
    );
  }
}

class _VisitNotesSection extends ConsumerWidget {
  final String visitId;

  const _VisitNotesSection({required this.visitId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(visitNotesProvider(visitId));

    return notesAsync.when(
      data: (notes) {
        if (notes.isEmpty) return const SizedBox.shrink();
        return GlassCard(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.edit_note_rounded, color: AppColors.info, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Text(AppStrings.lbl_44, style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w600, color: AppColors.onSurface)),
                ],
              ),
              const SizedBox(height: 10),
              for (final n in notes) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.south_west_rounded, size: 12, color: AppColors.info),
                    const SizedBox(width: 6),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${n.senderName ?? 'User'}: ',
                              style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold),
                            ),
                            ...MentionHandler.buildSpans(
                              context,
                              n.content,
                              ref,
                              defaultStyle: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurface),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (n != notes.last) const SizedBox(height: 6),
              ],
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
