import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'migrations/on_create.dart';
import 'migrations/on_upgrade.dart';

typedef WithDbFn<T> = Future<T> Function(Database db);

Future<T> withDb<T>(WithDbFn fn) async {
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

const _filename = 'photo-inbox.db';
const _version = 2;
