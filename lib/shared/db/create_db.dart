import 'package:sqflite/sqflite.dart';

typedef CreateDbFn = void Function(Batch batch);

const List<CreateDbFn> createDbFnList = [
  _createTodos,
];

const todosTableName = 'todos';

class TodoFields {
  static const id = _EntityFields.id;
  static const createdDate = _EntityFields.createdDate;
  static const imagePath = 'imagePath';
  static const tag = 'tag';
  static const isCompleted = 'isCompleted';

  TodoFields._();
}

void _createTodos(Batch batch) {
  batch.execute('''CREATE TABLE $todosTableName (
    ${TodoFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${TodoFields.imagePath} TEXT NOT NULL,
    ${TodoFields.createdDate} TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    ${TodoFields.tag} TEXT,
    ${TodoFields.isCompleted} BOOLEAN DEFAULT 0 NOT NULL CHECK (${TodoFields.isCompleted} IN (0, 1))
  )''');
}

class _EntityFields {
  static const id = 'id';
  static const createdDate = 'createdDate';

  _EntityFields._();
}
