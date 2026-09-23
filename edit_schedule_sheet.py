import re

with open('lib/features/shared/widgets/schedule_appointment_sheet.dart', 'r', encoding='utf-8') as f:
    text = f.read()

replacement = '''Future<void> showScheduleAppointmentSheet(
  BuildContext context,
  WidgetRef ref, {
  String? initialClientId,
  String? initialCenterId,
  AppointmentModel? initialAppointment,
  ClientModel? initialClientObj,
}) async {
  ClientModel? selectedClient = initialClientObj;
  if (selectedClient == null && initialClientId != null) {
    final clients = ref.read(clientsStreamProvider).asData?.value ?? [];
    selectedClient = clients.where((c) => c.id == initialClientId).firstOrNull;
  }

  CenterModel? selectedCenter;
  if (initialCenterId != null) {
    final centers = ref.read(centersProvider).asData?.value ?? [];
    selectedCenter = centers.where((c) => c.id == initialCenterId).firstOrNull;
  }'''

original_search = '''Future<void> showScheduleAppointmentSheet(
  BuildContext context,
  WidgetRef ref, {
  String? initialClientId,
  String? initialCenterId,
  AppointmentModel? initialAppointment,
}) async {
  ClientModel? selectedClient;
  if (initialClientId != null) {
    final clients = ref.read(clientsStreamProvider).asData?.value ?? [];
    selectedClient = clients.where((c) => c.id == initialClientId).firstOrNull;
  }

  CenterModel? selectedCenter;
  if (initialCenterId != null) {
    final centers = ref.read(centersProvider).asData?.value ?? [];
    selectedCenter = centers.where((c) => c.id == initialCenterId).firstOrNull;
  }'''

if original_search in text:
    text = text.replace(original_search, replacement)
    with open('lib/features/shared/widgets/schedule_appointment_sheet.dart', 'w', encoding='utf-8') as f:
        f.write(text)
    print("Done")
else:
    print("Search string not found")

