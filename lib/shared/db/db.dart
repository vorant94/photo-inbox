import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'migrations/on_create.dart';
import 'migrations/on_upgrade.dart';

// class here is just for sake of namespace, no need for singleton of the db
// instance itself since it is managed internally by sqflite itself
// also it cannot be an extension since extensions are not allowed in case of
// static methods
class Db {
  static const _filename = 'photo-inbox.db';
  static const _version = 1;

  Db._();

  static Future<T> withTnx<T>(WithTnxFn fn, [Transaction? tnx]) async {
    if (tnx is Transaction) return await fn(tnx);

    return withDb((db) async => await db.transaction(fn));
  }

  static Future<T> withDb<T>(WithDbFn fn) async {
    final dbDir = await getDatabasesPath();
    final dbPath = join(dbDir, _filename);
    // TODO implement _onDowngrade mechanism
    final db = await openDatabase(
      dbPath,
      version: _version,
      onCreate: onCreate,
      onUpgrade: onUpgrade,
    );

    final result = await fn(db);

    await db.close();

    return result;
  }
}

typedef WithDbFn<T> = Future<T> Function(Database db);

typedef WithTnxFn<T> = Future<T> Function(Transaction txn);
