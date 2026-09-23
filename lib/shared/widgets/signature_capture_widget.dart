import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';
import 'package:pdos_app/core/theme/app_colors.dart';
import 'package:pdos_app/core/utils/signature_utils.dart';
import 'package:pdos_app/core/providers/data_providers.dart';
import 'package:pdos_app/core/providers/auth_provider.dart';
import 'package:pdos_app/core/local_db/app_database.dart';
import 'package:drift/drift.dart' as drift;

class SignatureCaptureWidget extends ConsumerStatefulWidget {
  final ValueChanged<String?>? onSign;
  final String? overrideInitialPointsJson;
  const SignatureCaptureWidget({super.key, this.onSign, this.overrideInitialPointsJson});

  @override
  ConsumerState<SignatureCaptureWidget> createState() => _SignatureCaptureWidgetState();
}

class _SignatureCaptureWidgetState extends ConsumerState<SignatureCaptureWidget> {
  late SignatureController _controller;

  bool _hasStroke = false;
  File? _defaultSignatureFile;
  bool _useDefaultSignature = false;
  bool _saveAsDefault = true;

  @override
  void initState() {
    super.initState();
    _controller = SignatureController(
      penStrokeWidth: 2,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );
    _controller.addListener(_onStrokeChanged);
    _loadDefaultSignature();
  }
  
  Future<void> _loadDefaultSignature() async {
    try {
      if (widget.overrideInitialPointsJson != null) {
        _controller.points = SignatureUtils.pointsFromJson(widget.overrideInitialPointsJson!);
        setState(() {});
        return;
      }
      
      final db = ref.read(appDatabaseProvider);
      final userId = ref.read(authNotifierProvider).user?.id;
      if (userId == null) return;
      
      final savedSig = await (db.select(db.localUserSignatures)..where((tbl) => tbl.id.equals(userId))).getSingleOrNull();
      
      if (savedSig != null) {
        final file = File(savedSig.imagePath);
        if (await file.exists()) {
          setState(() {
            _defaultSignatureFile = file;
            _useDefaultSignature = true;
          });
          // Also invoke onSign so the parent gets the path immediately
          widget.onSign?.call(file.path);
        }
      }
    } catch (e) {
      debugPrint('Error loading default signature: $e');
    }
  }

  void _onStrokeChanged() {
    final has = _controller.points.isNotEmpty;
    if (has != _hasStroke) setState(() => _hasStroke = has);
  }

  @override
  void dispose() {
    _controller.removeListener(_onStrokeChanged);
    _controller.dispose();
    super.dispose();
  }

  Future<String?> _saveAsImage() async {
    try {
      // 1. Balance Points
      final balancedPoints = SignatureUtils.balancePoints(_controller.points);
      
      // Create a temporary controller with balanced points to render the polished image
      final balancedController = SignatureController(
        penStrokeWidth: 2,
        penColor: Colors.black,
        exportBackgroundColor: Colors.white,
        points: balancedPoints,
      );
      
      final Uint8List? bytes = await balancedController.toPngBytes();
      balancedController.dispose();
      
      if (bytes == null) {
        debugPrint('Signature save failed: toPngBytes returned null');
        return null;
      }
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/signature_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(bytes);
      
      if (_saveAsDefault) {
        final db = ref.read(appDatabaseProvider);
        final userId = ref.read(authNotifierProvider).user?.id;
        if (userId != null) {
          final existing = await (db.select(db.localUserSignatures)..where((tbl) => tbl.id.equals(userId))).getSingleOrNull();
          if (existing != null) {
             final oldFile = File(existing.imagePath);
             if (await oldFile.exists()) await oldFile.delete();
          }
          
          await db.into(db.localUserSignatures).insertOnConflictUpdate(
            LocalUserSignaturesCompanion(
              id: drift.Value(userId),
              pointsJson: drift.Value(SignatureUtils.pointsToJson(balancedPoints)),
              imagePath: drift.Value(file.path),
              createdAt: drift.Value(existing?.createdAt ?? DateTime.now()),
              updatedAt: drift.Value(DateTime.now()),
              synced: const drift.Value(false),
            )
          );
          if (mounted) {
            setState(() {
              _defaultSignatureFile = file;
              _useDefaultSignature = true;
            });
          } else {
             _defaultSignatureFile = file;
             _useDefaultSignature = true;
          }
        }
      }
      
      if (!await file.exists()) {
        debugPrint('Signature save failed: file not written');
        return null;
      }
      return file.path;
    } catch (e) {
      debugPrint('Error saving signature: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_defaultSignatureFile != null)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            child: CheckboxListTile(
              title: const Text('Use my saved signature', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Use my previously saved signature', style: TextStyle(fontSize: 12)),
              value: _useDefaultSignature,
              activeColor: AppColors.primary,
              onChanged: (val) {
                setState(() {
                  _useDefaultSignature = val ?? false;
                  if (_useDefaultSignature && _defaultSignatureFile != null) {
                    widget.onSign?.call(_defaultSignatureFile!.path);
                  } else {
                    widget.onSign?.call(null);
                  }
                });
              },
            ),
          ),
          
        Container(
          height: 250,
          decoration: BoxDecoration(
            color: AppColors.onPrimary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.onSurfaceVariant.withValues(alpha: 0.3)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _useDefaultSignature && _defaultSignatureFile != null
                ? Container(
                    color: Colors.white,
                    child: Center(
                      child: Image.file(_defaultSignatureFile!, fit: BoxFit.contain),
                    ),
                  )
                : Signature(
                    controller: _controller,
                    backgroundColor: Colors.white,
                  ),
          ),
        ),
        
        if (!_useDefaultSignature) ...[
          const SizedBox(height: 12),
          CheckboxListTile(
            title: const Text('Save as default for future visits'),
            subtitle: const Text('Save as default for upcoming visits'),
            value: _saveAsDefault,
            activeColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (val) {
              setState(() {
                _saveAsDefault = val ?? false;
              });
            },
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.clear, size: 20),
                label: const Text('Clear'),
                onPressed: _hasStroke ? () { 
                  _controller.clear();
                  widget.onSign?.call(null);
                } : null,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.save, size: 20),
                label: const Text('Save Signature'),
                onPressed: _hasStroke
                    ? () async {
                        final path = await _saveAsImage();
                        if (path != null) {
                          widget.onSign?.call(path);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Signature saved successfully'), backgroundColor: Colors.green),
                            );
                          }
                        } else if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Failed to save signature - check debug logs'), backgroundColor: Colors.red),
                          );
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
