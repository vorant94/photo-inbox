import 'package:mobile/shared/db/tables/todos_table.dart';
import 'package:sqflite/sqflite.dart';

Future<void> onCreate(Database db, int version) async {
  final batch = db.batch();

  for (var fn in _createDbFnList) {
    fn(batch);
  }

  await batch.commit();
}

typedef _CreateDbFn = void Function(Batch batch);

const List<_CreateDbFn> _createDbFnList = [
  _createTodos,
];

void _createTodos(Batch batch) {
  final table = TodosTable();

  batch.execute('''CREATE TABLE ${table.name} (
    ${TodoFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${TodoFields.imagePath} TEXT NOT NULL,
    ${TodoFields.createdDate} TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    ${TodoFields.tag} TEXT,
    ${TodoFields.isCompleted} BOOLEAN DEFAULT 0 NOT NULL CHECK (${TodoFields.isCompleted} IN (0, 1))
  )''');
}
