with open('lib/core/services/sync_orchestrator.dart', 'r', encoding='utf-8') as f:
    text = f.read()

text = text.replace('''      await Future.wait([
        syncService.syncNow(),
        scheduleSyncService.pushAppointments(),
      ]);''', '''      await scheduleSyncService.pushAppointments();
      await syncService.syncNow();''')

with open('lib/core/services/sync_orchestrator.dart', 'w', encoding='utf-8') as f:
    f.write(text)

print("Done")
