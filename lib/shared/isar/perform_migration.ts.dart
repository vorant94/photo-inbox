import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:mobile/inbox/models/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension PerformMigration on Isar {
  Future<void> performMigration() async {
    final prefs = GetIt.I.get<SharedPreferences>();
    final version = prefs.getInt(_isarVersionKey);

    switch (version) {
      case null:
        await _migrateToV1();
        break;
      case 1:
        break;
    }
  }

  Future<void> _migrateToV1() async {
    final prefs = GetIt.I.get<SharedPreferences>();

    final todoCount = await todos.count();

    for (var i = 0; i < todoCount; i += 50) {
      final records = await todos.where().offset(i).limit(50).findAll();

      await writeTxn(() async {
        for (final record in records) {
          record.aspectRatio = 9 / 16;
          await todos.putAll(records);
        }
      });
    }

    await prefs.setInt(_isarVersionKey, 1);
  }
}

const _isarVersionKey = 'isar_version';
