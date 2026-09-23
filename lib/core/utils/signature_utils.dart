import 'dart:convert';
import 'dart:ui';
import 'package:signature/signature.dart';

class SignatureUtils {
  static const double targetWidth = 400;
  static const double targetHeight = 200;
  static const double padding = 20;

  /// Balances a list of points (crops and centers them within a 400x200 canvas)
  static List<Point> balancePoints(List<Point> originalPoints) {
    if (originalPoints.isEmpty) return [];

    double minX = double.infinity, minY = double.infinity;
    double maxX = double.negativeInfinity, maxY = double.negativeInfinity;

    for (final p in originalPoints) {
      if (p.type == PointType.tap || p.type == PointType.move) {
        if (p.offset.dx < minX) minX = p.offset.dx;
        if (p.offset.dx > maxX) maxX = p.offset.dx;
        if (p.offset.dy < minY) minY = p.offset.dy;
        if (p.offset.dy > maxY) maxY = p.offset.dy;
      }
    }

    double width = maxX - minX;
    double height = maxY - minY;
    if (width == 0 && height == 0) return originalPoints; // Single dot

    double scale = 1.0;
    if (width > targetWidth - padding * 2) {
      scale = (targetWidth - padding * 2) / width;
    }
    if (height * scale > targetHeight - padding * 2) {
      scale = (targetHeight - padding * 2) / height;
    }

    double scaledWidth = width * scale;
    double scaledHeight = height * scale;

    double offsetX = (targetWidth - scaledWidth) / 2 - (minX * scale);
    double offsetY = (targetHeight - scaledHeight) / 2 - (minY * scale);

    return originalPoints.map((p) {
      if (p.type == PointType.tap || p.type == PointType.move) {
        return Point(
          Offset(p.offset.dx * scale + offsetX, p.offset.dy * scale + offsetY),
          p.type,
          p.pressure,
        );
      }
      return p; // Keep pen up events as is
    }).toList();
  }

  /// Convert points to JSON keeping PointType
  static String pointsToJson(List<Point> points) {
    final list = points.map((p) => {
      'dx': p.offset.dx,
      'dy': p.offset.dy,
      'type': p.type.index,
      'pressure': p.pressure,
    }).toList();
    return jsonEncode(list);
  }

  /// Parse JSON to points
  static List<Point> pointsFromJson(String jsonStr) {
    if (jsonStr.isEmpty) return [];
    try {
      final list = jsonDecode(jsonStr) as List;
      return list.map((e) {
        final map = e as Map<String, dynamic>;
        return Point(
          Offset((map['dx'] as num).toDouble(), (map['dy'] as num).toDouble()),
          PointType.values[map['type'] as int],
          (map['pressure'] as num?)?.toDouble() ?? 1.0,
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }
}
