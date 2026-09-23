import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdos_app/core/local_db/app_database.dart';
import 'package:pdos_app/core/providers/data_providers.dart';
import 'package:pdos_app/core/providers/auth_provider.dart';
import 'package:pdos_app/core/theme/app_colors.dart';
import 'package:pdos_app/shared/widgets/signature_capture_widget.dart';

class MySignatureScreen extends ConsumerStatefulWidget {
  const MySignatureScreen({super.key});

  @override
  ConsumerState<MySignatureScreen> createState() => _MySignatureScreenState();
}

class _MySignatureScreenState extends ConsumerState<MySignatureScreen> {
  bool _isEditing = false;

  Future<void> _deleteSignature(LocalUserSignature sig) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Delete Signature?'),
        content: const Text('Are you sure you want to delete your saved signature? You will have to draw it again for future visits.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(c, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final db = ref.read(appDatabaseProvider);
      
      // Delete local file
      final file = File(sig.imagePath);
      if (await file.exists()) {
        await file.delete();
      }
      
      // Delete from DB
      await (db.delete(db.localUserSignatures)..where((tbl) => tbl.id.equals(sig.id))).go();
      
      // Server deletion happens via sync or we can execute api call here directly,
      // but sync is safer for offline. Wait, the implementation plan said:
      // "Delete Button: Clears the signature from the local DB, deletes the local file, and queues a DELETE request to the server (or executes it immediately)."
      try {
        await ref.read(apiServiceProvider).dio.delete('/users/me/signatures');
      } catch (e) {
        debugPrint('Failed to delete on server: $e');
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Signature deleted.')));
        setState(() {}); // refresh stream
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authNotifierProvider).user;
    if (user == null) return const Scaffold();

    final db = ref.watch(appDatabaseProvider);
    final sigStream = (db.select(db.localUserSignatures)..where((tbl) => tbl.id.equals(user.id))).watchSingleOrNull();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Signature'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: StreamBuilder<LocalUserSignature?>(
        stream: sigStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final sig = snapshot.data;

          if (_isEditing || sig == null) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sig == null ? 'Draw your signature' : 'Edit your signature',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('This signature will be saved as your default for all future visits.'),
                  const SizedBox(height: 24),
                  SignatureCaptureWidget(
                    overrideInitialPointsJson: sig?.pointsJson,
                    onSign: (path) {
                      if (path != null) {
                         setState(() {
                           _isEditing = false;
                         });
                      }
                    },
                  ),
                  if (sig != null) ...[
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed: () => setState(() => _isEditing = false),
                        child: const Text('Cancel Edit'),
                      ),
                    ),
                  ]
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.verified, color: AppColors.success, size: 64),
                const SizedBox(height: 16),
                const Text('Your Default Signature', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('This is your current saved signature.', textAlign: TextAlign.center),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.outline),
                  ),
                  child: Image.file(
                    File(sig.imagePath),
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    errorBuilder: (c, e, s) => const Icon(Icons.broken_image, size: 100, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.edit),
                        label: const Text('Replace'),
                        onPressed: () => setState(() => _isEditing = true),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.delete),
                        label: const Text('Delete'),
                        onPressed: () => _deleteSignature(sig),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
