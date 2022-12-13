import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'create_db.dart';
import 'upgrade_db.dart';

// class here is just for sake of namespace (everything is static only),
// no need for singleton of the db instance itself since it is managed
// internally by sqflite itself
class Db {
  static const _filename = 'photo-inbox.db';
  static const _version = 1;

  Db._();

  static Future<T> withTnx<T>(WithTnxFn fn, [Transaction? tnx]) async {
    if (tnx is Transaction) return await fn(tnx);

    return withDb((db) async {
      return await db.transaction(fn);
    });
  }

  static Future<T> withDb<T>(WithDbFn fn) async {
    final db = await _open();

    final result = await fn(db);

    await _close(db);

    return result;
  }

  static Future<Database> _open() async {
    final dbDir = await getDatabasesPath();
    final dbPath = join(dbDir, _filename);

    return await openDatabase(
      dbPath,
      version: _version,
      onCreate: (db, version) async {
        final batch = db.batch();

        for (var fn in createDbFnList) {
          fn(batch);
        }

        await batch.commit();
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        final batch = db.batch();

        final upgradableVersions = upgradeDbFnListMap.keys.toList();
        upgradableVersions.sort((a, b) => a.compareTo(b));

        for (var version in upgradableVersions) {
          if (version > oldVersion && version <= newVersion) {
            final upgradeFnList = upgradeDbFnListMap[version]!;

            for (var fn in upgradeFnList) {
              fn(batch);
            }
          }
        }

        await batch.commit();
      },
    );
  }

  static Future<void> _close(Database db) async {
    await db.close();
  }
}

typedef WithDbFn<T> = Future<T> Function(Database db);

typedef WithTnxFn<T> = Future<T> Function(Transaction txn);
