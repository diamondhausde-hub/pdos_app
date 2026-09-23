import 'package:pdos_app/core/local_db/app_database.dart';
import 'package:drift/drift.dart';

class UserSignatureModel {
  final String userId;
  final String pointsJson;
  final String imagePath;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool synced;

  UserSignatureModel({
    required this.userId,
    required this.pointsJson,
    required this.imagePath,
    required this.createdAt,
    required this.updatedAt,
    required this.synced,
  });

  factory UserSignatureModel.fromJson(Map<String, dynamic> json) {
    return UserSignatureModel(
      userId: json['user_id'] as String,
      pointsJson: json['points_json'] ?? '[]', // Not received from server, so default
      imagePath: json['image_url'] as String, // From server this is an URL
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      synced: true, // If we get from JSON (server), it's synced
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'image_url': imagePath, // When sending to server, we send the file, this JSON isn't used directly for saving, but good for completeness
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory UserSignatureModel.fromLocal(LocalUserSignature local) {
    return UserSignatureModel(
      userId: local.id,
      pointsJson: local.pointsJson,
      imagePath: local.imagePath,
      createdAt: local.createdAt,
      updatedAt: local.updatedAt,
      synced: local.synced,
    );
  }

  LocalUserSignaturesCompanion toLocalCompanion() {
    return LocalUserSignaturesCompanion(
      id: Value(userId),
      pointsJson: Value(pointsJson),
      imagePath: Value(imagePath),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      synced: Value(synced),
    );
  }
}
