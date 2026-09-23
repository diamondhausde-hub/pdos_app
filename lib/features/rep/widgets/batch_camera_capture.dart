import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/theme/theme.dart';
import 'package:pdos_app/core/theme/app_colors.dart';

class BatchCameraCapture extends StatefulWidget {
  final int maxPhotos;
  final List<String> initialPhotos;

  const BatchCameraCapture({
    super.key,
    this.maxPhotos = 10,
    this.initialPhotos = const [],
  });

  @override
  State<BatchCameraCapture> createState() => _BatchCameraCaptureState();
}

class _BatchCameraCaptureState extends State<BatchCameraCapture> {
  CameraController? _controller;
  final List<String> _capturedPaths = [];
  bool _isInitialized = false;
  String? _tempDir;

  @override
  void initState() {
    super.initState();
    _capturedPaths.addAll(widget.initialPhotos);
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty || !mounted) return;

      _controller = CameraController(cameras[0], ResolutionPreset.medium);
      await _controller!.initialize();
      if (mounted) setState(() => _isInitialized = true);
    } catch (_) {}
  }

  Future<String?> _compressImage(String sourcePath) async {
    final dir = await getApplicationDocumentsDirectory();
    _tempDir ??= '${dir.path}/batch_temp';
    await Directory(_tempDir!).create(recursive: true);
    final outPath = '$_tempDir/${DateTime.now().millisecondsSinceEpoch}_compressed.jpg';
    final result = await FlutterImageCompress.compressAndGetFile(
      sourcePath,
      outPath,
      quality: 70,
      minWidth: 800,
    );
    return result?.path ?? outPath;
  }

  Future<void> _captureOne() async {
    if (_controller == null || !_isInitialized) return;
    if (_capturedPaths.length >= widget.maxPhotos) return;

    try {
      final photo = await _controller!.takePicture();
      final compressed = await _compressImage(photo.path);
      if (compressed != null && mounted) {
        setState(() => _capturedPaths.add(compressed));
      }
    } catch (_) {}
  }

  void _deletePhoto(int index) {
    final path = _capturedPaths[index];
    File(path).deleteSync();
    setState(() => _capturedPaths.removeAt(index));
  }

  void _onDone() => Navigator.pop(context, _capturedPaths);

  void _onCancel() {
    for (final path in _capturedPaths) {
      File(path).deleteSync();
    }
    Navigator.pop(context, <String>[]);
  }

  @override
  void dispose() {
    _controller?.dispose();
    if (_tempDir != null) {
      Directory(_tempDir!).deleteSync(recursive: true);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onSurface,
      body: !_isInitialized
          ? Center(child: CircularProgressIndicator(color: AppColors.onPrimary))
          : Stack(
              children: [
                CameraPreview(_controller!),

                // Top bar
                Positioned(
                  top: 48,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.close, color: AppColors.onPrimary),
                          onPressed: _onCancel,
                        ),
                        const Spacer(),
                        Text(
                          '${_capturedPaths.length}/${widget.maxPhotos}',
                          style: TextStyle(color: AppColors.onPrimary, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),

                // Capture hint
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.onSurfaceVariant,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      'Tap the button to capture',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ),
                ),

                // Bottom bar
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Thumbnails strip
                      if (_capturedPaths.isNotEmpty)
                        SizedBox(
                          height: 80,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _capturedPaths.length,
                            itemBuilder: (ctx, idx) {
                              final isLast = idx == _capturedPaths.length - 1;
                              return Padding(
                                padding: EdgeInsets.only(right: isLast ? 0 : 8),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        File(_capturedPaths[idx]),
                                        width: 72,
                                        height: 72,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      right: -4,
                                      top: -4,
                                      child: GestureDetector(
                                        onTap: () => _deletePhoto(idx),
                                        child: Container(
                                          width: 22,
                                          height: 22,
                                          decoration: BoxDecoration(
                                            color: AppColors.onSurface,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(Icons.close, size: 14, color: AppColors.onPrimary),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      const SizedBox(height: 20),
                      // Capture and Done buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_capturedPaths.isNotEmpty) ...[
                            const SizedBox(width: 72),
                            const SizedBox(width: 24),
                          ],
                          GestureDetector(
                            onTap: _capturedPaths.length < widget.maxPhotos ? _captureOne : null,
                            child: Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.onPrimary,
                                border: Border.all(color: Colors.white70, width: 4),
                              ),
                              child: Center(
                                child: Icon(
                                  _capturedPaths.length >= widget.maxPhotos
                                      ? Icons.check
                                      : Icons.camera_alt,
                                  color: AppColors.onSurface,
                                  size: 32,
                                ),
                              ),
                            ),
                          ),
                          if (_capturedPaths.isNotEmpty) ...[
                            const SizedBox(width: 24),
                            ElevatedButton(
                              onPressed: _onDone,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                              ),
                              child: Text(
                                'Done (${_capturedPaths.length})',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
