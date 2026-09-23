import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart' as drift;
import '../local_db/app_database.dart';

@immutable
class ClientModel {
  final String id;
  final String clientType;
  final String status;
  final String repId;
  final String? brandId;
  final String? facilityName;
  final String? facilityType;
  final String? doctorName;
  final String? specialty;
  final DateTime? birthDate;
  final String? classTier;
  final String? relationshipType;
  final String? description;
  final String? phoneNumber;
  final String? region;
  final String? area;
  final String? street;
  final String? nearbyLandmark;
  final double? latitude;
  final double? longitude;
  final String? photoUrl;
  final String? gender;            // 'male' | 'female'
  final int? rating;               // 1..5 stars
  final String? treatmentQuality;  // 'good' | 'average' | 'bad'
  
  final String? scientificInterests;
  final String? productInterests;
  final String? pharmacyType;
  final String? institutionType;
  final String? keyContactName;
  final String? keyContactPosition;
  final String? keyContactPhone;
  final String? departments;

  final DateTime createdAt;
  final DateTime updatedAt;
  final bool synced;

  const ClientModel({
    required this.id,
    this.clientType = 'doctor',
    this.status = 'active',
    required this.repId,
    this.brandId,
    this.facilityName,
    this.facilityType,
    this.doctorName,
    this.specialty,
    this.birthDate,
    this.classTier,
    this.relationshipType,
    this.description,
    this.phoneNumber,
    this.region,
    this.area,
    this.street,
    this.nearbyLandmark,
    this.latitude,
    this.longitude,
    this.photoUrl,
    this.gender,
    this.rating,
    this.treatmentQuality,
    this.scientificInterests,
    this.productInterests,
    this.pharmacyType,
    this.institutionType,
    this.keyContactName,
    this.keyContactPosition,
    this.keyContactPhone,
    this.departments,
    required this.createdAt,
    required this.updatedAt,
    this.synced = true,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'] as String,
      clientType: json['client_type'] as String? ?? 'doctor',
      status: json['status'] as String? ?? 'active',
      repId: json['rep_id'] as String,
        brandId: json['brand_id'] as String?,
      facilityName: json['facility_name'] as String?,
      facilityType: json['facility_type'] as String?,
      doctorName: json['doctor_name'] as String?,
      specialty: json['specialty'] as String?,
      birthDate: json['birth_date'] != null ? DateTime.parse(json['birth_date'] as String) : null,
      classTier: json['class_tier'] as String?,
      relationshipType: json['relationship_type'] as String?,
      description: json['description'] as String?,
      phoneNumber: json['phone_number'] as String?,
      region: json['region'] as String?,
      area: json['area'] as String?,
      street: json['street'] as String?,
      nearbyLandmark: json['nearby_landmark'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      photoUrl: json['photo_url'] as String?,
      gender: json['gender'] as String?,
      rating: json['rating'] as int?,
      treatmentQuality: json['treatment_quality'] as String?,
      scientificInterests: json['scientific_interests'] as String?,
      productInterests: json['product_interests'] as String?,
      pharmacyType: json['pharmacy_type'] as String?,
      institutionType: json['institution_type'] as String?,
      keyContactName: json['key_contact_name'] as String?,
      keyContactPosition: json['key_contact_position'] as String?,
      keyContactPhone: json['key_contact_phone'] as String?,
      departments: json['departments'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      synced: true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_type': clientType,
      'status': status,
      'rep_id': repId,
        'brand_id': brandId,
      'facility_name': facilityName,
      'facility_type': facilityType,
      'doctor_name': doctorName,
      'specialty': specialty,
      'birth_date': birthDate?.toIso8601String(),
      'class_tier': classTier,
      'relationship_type': relationshipType,
      'description': description,
      'phone_number': phoneNumber,
      'region': region,
      'area': area,
      'street': street,
      'nearby_landmark': nearbyLandmark,
      'latitude': latitude,
      'longitude': longitude,
      'photo_url': photoUrl,
      'gender': gender,
      'rating': rating,
      'treatment_quality': treatmentQuality,
      'scientific_interests': scientificInterests,
      'product_interests': productInterests,
      'pharmacy_type': pharmacyType,
      'institution_type': institutionType,
      'key_contact_name': keyContactName,
      'key_contact_position': keyContactPosition,
      'key_contact_phone': keyContactPhone,
      'departments': departments,
    };
  }

  ClientModel copyWith({
    String? id,
    String? clientType,
    String? status,
    String? repId,
    String? brandId,
    String? facilityName,
    String? facilityType,
    String? doctorName,
    String? specialty,
    DateTime? birthDate,
    String? classTier,
    String? relationshipType,
    String? description,
    String? phoneNumber,
    String? region,
    String? area,
    String? street,
    String? nearbyLandmark,
    double? latitude,
    double? longitude,
    String? photoUrl,
    String? gender,
    int? rating,
    String? treatmentQuality,
    String? scientificInterests,
    String? productInterests,
    String? pharmacyType,
    String? institutionType,
    String? keyContactName,
    String? keyContactPosition,
    String? keyContactPhone,
    String? departments,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? synced,
  }) {
    return ClientModel(
      id: id ?? this.id,
      clientType: clientType ?? this.clientType,
      status: status ?? this.status,
      repId: repId ?? this.repId,
        brandId: brandId ?? this.brandId,
      facilityName: facilityName ?? this.facilityName,
      facilityType: facilityType ?? this.facilityType,
      doctorName: doctorName ?? this.doctorName,
      specialty: specialty ?? this.specialty,
      birthDate: birthDate ?? this.birthDate,
      classTier: classTier ?? this.classTier,
      relationshipType: relationshipType ?? this.relationshipType,
      description: description ?? this.description,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      region: region ?? this.region,
      area: area ?? this.area,
      street: street ?? this.street,
      nearbyLandmark: nearbyLandmark ?? this.nearbyLandmark,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      photoUrl: photoUrl ?? this.photoUrl,
      gender: gender ?? this.gender,
      rating: rating ?? this.rating,
      treatmentQuality: treatmentQuality ?? this.treatmentQuality,
      scientificInterests: scientificInterests ?? this.scientificInterests,
      productInterests: productInterests ?? this.productInterests,
      pharmacyType: pharmacyType ?? this.pharmacyType,
      institutionType: institutionType ?? this.institutionType,
      keyContactName: keyContactName ?? this.keyContactName,
      keyContactPosition: keyContactPosition ?? this.keyContactPosition,
      keyContactPhone: keyContactPhone ?? this.keyContactPhone,
      departments: departments ?? this.departments,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      synced: synced ?? this.synced,
    );
  }

  factory ClientModel.fromLocal(LocalClient local) {
    return ClientModel(
      id: local.id,
      clientType: local.clientType,
      status: local.status,
      repId: local.repId,
        brandId: local.brandId,
      facilityName: local.facilityName,
      facilityType: local.facilityType,
      doctorName: local.doctorName,
      specialty: local.specialty,
      birthDate: local.birthDate,
      classTier: local.classTier,
      relationshipType: local.relationshipType,
      description: local.description,
      phoneNumber: local.phoneNumber,
      region: local.region,
      area: local.area,
      street: local.street,
      nearbyLandmark: local.nearbyLandmark,
      latitude: local.latitude,
      longitude: local.longitude,
      photoUrl: local.photoUrl,
      gender: local.gender,
      rating: local.rating,
      treatmentQuality: local.treatmentQuality,
      scientificInterests: local.scientificInterests,
      productInterests: local.productInterests,
      pharmacyType: local.pharmacyType,
      institutionType: local.institutionType,
      keyContactName: local.keyContactName,
      keyContactPosition: local.keyContactPosition,
      keyContactPhone: local.keyContactPhone,
      departments: local.departments,
      createdAt: local.createdAt,
      updatedAt: local.updatedAt,
      synced: local.synced,
    );
  }

  LocalClientsCompanion toLocalCompanion() {
    return LocalClientsCompanion.insert(
      id: id,
      clientType: drift.Value(clientType),
      status: drift.Value(status),
      repId: repId,
        brandId: drift.Value(brandId),
      facilityName: drift.Value(facilityName),
      facilityType: drift.Value(facilityType),
      doctorName: drift.Value(doctorName),
      specialty: drift.Value(specialty),
      birthDate: drift.Value(birthDate),
      classTier: drift.Value(classTier),
      relationshipType: drift.Value(relationshipType),
      description: drift.Value(description),
      phoneNumber: drift.Value(phoneNumber),
      region: drift.Value(region),
      area: drift.Value(area),
      street: drift.Value(street),
      nearbyLandmark: drift.Value(nearbyLandmark),
      latitude: drift.Value(latitude),
      longitude: drift.Value(longitude),
      photoUrl: drift.Value(photoUrl),
      gender: drift.Value(gender),
      rating: drift.Value(rating),
      treatmentQuality: drift.Value(treatmentQuality),
      scientificInterests: drift.Value(scientificInterests),
      productInterests: drift.Value(productInterests),
      pharmacyType: drift.Value(pharmacyType),
      institutionType: drift.Value(institutionType),
      keyContactName: drift.Value(keyContactName),
      keyContactPosition: drift.Value(keyContactPosition),
      keyContactPhone: drift.Value(keyContactPhone),
      departments: drift.Value(departments),
      createdAt: createdAt,
      updatedAt: updatedAt,
      synced: drift.Value(synced),
    );
  }
}
