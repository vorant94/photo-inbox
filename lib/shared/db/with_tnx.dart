import 'package:sqflite/sqflite.dart';

import 'with_db.dart';

typedef WithTnxFn<T> = Future<T> Function(Transaction tnx);

Future<T> withTnx<T>(WithTnxFn fn, [Transaction? tnx]) async {
  if (tnx != null) return await fn(tnx);

  return withDb((db) async => await db.transaction(fn));
}
