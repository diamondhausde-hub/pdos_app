with open('lib/core/repositories/visit_repository.dart', 'r', encoding='utf-8') as f:
    text = f.read()

create_visit_original = '''    Future<void> createVisit(VisitModel visit) async {
      final companion = LocalVisit(
        id: visit.id,
        repId: visit.repId,
        centerId: visit.centerId,
        visitDate: visit.visitDate,
        arrivalTime: visit.arrivalTime,
        completionTime: visit.completionTime,
        status: visit.status.name,
        notes: visit.notes,
        latitude: visit.latitude,
        longitude: visit.longitude,
        appointmentId: null,
        createdAt: visit.createdAt,
        updatedAt: DateTime.now(),
        synced: false,
        isFlagged: false,
        isAbandoned: false,
        visitType: 'center',
      );'''

create_visit_new = '''    Future<void> createVisit(VisitModel visit) async {
      final companion = LocalVisit(
        id: visit.id,
        repId: visit.repId,
        centerId: visit.centerId,
        clientId: visit.clientId,
        visitDate: visit.visitDate,
        arrivalTime: visit.arrivalTime,
        completionTime: visit.completionTime,
        status: visit.status.name,
        notes: visit.notes,
        latitude: visit.latitude,
        longitude: visit.longitude,
        appointmentId: null,
        createdAt: visit.createdAt,
        updatedAt: DateTime.now(),
        synced: false,
        isFlagged: false,
        isAbandoned: false,
        visitType: visit.clientId != null ? 'doctor' : 'center',
      );'''

start_visit_original = '''    final newVisit = LocalVisit(
      id: visitId,
      repId: repId,
      centerId: centerId,
      appointmentId: appointmentId,
      visitDate: DateTime.now(),
      arrivalTime: DateTime.now(),
      status: 'in_progress', // ALWAYS start in_progress locally; server may flag it later.
      synced: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      latitude: latitude,
      longitude: longitude,
      isFlagged: false,
      isAbandoned: false,
      visitType: 'center',
    );'''

start_visit_new = '''    final newVisit = LocalVisit(
      id: visitId,
      repId: repId,
      centerId: centerId,
      clientId: clientId,
      appointmentId: appointmentId,
      visitDate: DateTime.now(),
      arrivalTime: DateTime.now(),
      status: 'in_progress', // ALWAYS start in_progress locally; server may flag it later.
      synced: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      latitude: latitude,
      longitude: longitude,
      isFlagged: false,
      isAbandoned: false,
      visitType: clientId != null ? 'doctor' : 'center',
    );'''

text = text.replace(create_visit_original, create_visit_new)
text = text.replace(start_visit_original, start_visit_new)

text = text.replace('''  Future<void> addVisitNote(String visitId, String note) async {
    try {
      await _api.dio.put('/visits//note', data: {''', '''  Future<void> addVisitNote(String visitId, String note) async {
    try {
      await _api.dio.patch('/visits//note', data: {''')

with open('lib/core/repositories/visit_repository.dart', 'w', encoding='utf-8') as f:
    f.write(text)

print("Done")
