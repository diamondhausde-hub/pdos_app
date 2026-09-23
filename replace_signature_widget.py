import os
import re

with open("lib/shared/widgets/signature_capture_widget.dart", "r", encoding="utf-8") as f:
    content = f.read()

replacement = """import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';
import 'package:pdos_app/core/theme/app_colors.dart';

class SignatureCaptureWidget extends StatefulWidget {
  final ValueChanged<String?>? onSign;
  const SignatureCaptureWidget({super.key, this.onSign});

  @override
  State<SignatureCaptureWidget> createState() => _SignatureCaptureWidgetState();
}

class _SignatureCaptureWidgetState extends State<SignatureCaptureWidget> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  bool _hasStroke = false;
  File? _defaultSignatureFile;
  bool _useDefaultSignature = false;
  bool _saveAsDefault = true;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onStrokeChanged);
    _loadDefaultSignature();
  }
  
  Future<void> _loadDefaultSignature() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/default_signature.png');
      if (await file.exists()) {
        setState(() {
          _defaultSignatureFile = file;
        });
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
      final Uint8List? bytes = await _controller.toPngBytes();
      if (bytes == null) {
        debugPrint('Signature save failed: toPngBytes returned null');
        return null;
      }
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/signature_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(bytes);
      
      if (_saveAsDefault) {
        final defaultFile = File('${dir.path}/default_signature.png');
        await defaultFile.writeAsBytes(bytes);
        _defaultSignatureFile = defaultFile;
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
              subtitle: const Text('استخدام توقيعي المحفوظ سابقاً', style: TextStyle(fontSize: 12)),
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
            subtitle: const Text('حفظ كافتراضي للزيارات القادمة'),
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
"""

with open("lib/shared/widgets/signature_capture_widget.dart", "w", encoding="utf-8") as f:
    f.write(replacement)
