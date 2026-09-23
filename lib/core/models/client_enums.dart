enum ClientType {
  doctor,
  pharmacy,
  institution,
}

enum ClientStatus {
  active,
  inactive,
}

enum PharmacyType {
  retail,
  chain,
  polyclinicPharmacy,
  other,
}

enum InstitutionType {
  hospital,
  clinic,
  polyclinic,
  medicalCenter,
  other,
}

enum MedicalSpecialty {
  generalPractitioner,
  dermatology,
  pediatrics,
  internalMedicine,
  cardiology,
  neurology,
  orthopedics,
  other,
}

enum CustomerClassification {
  a,
  b,
  c,
  d,
}

/// Helper extensions to easily convert enum to string and string to enum
extension ClientTypeExt on ClientType {
  String get value => name;
}

extension ClientStatusExt on ClientStatus {
  String get value => name;
}

ClientType clientTypeFromString(String? val) {
  return ClientType.values.firstWhere((e) => e.name == val, orElse: () => ClientType.doctor);
}

ClientStatus clientStatusFromString(String? val) {
  return ClientStatus.values.firstWhere((e) => e.name == val, orElse: () => ClientStatus.active);
}
