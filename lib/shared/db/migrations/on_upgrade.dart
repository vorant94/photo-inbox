import 'package:collection/collection.dart';
import 'package:sqflite/sqflite.dart';

Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
  final batch = db.batch();

  final upgradableVersions =
      _upgradeDbFnListMap.keys.sorted((a, b) => a.compareTo(b));

  for (var version in upgradableVersions) {
    if (version > oldVersion && version <= newVersion) {
      final upgradeFnList = _upgradeDbFnListMap[version]!;

      for (var fn in upgradeFnList) {
        fn(batch);
      }
    }
  }

  await batch.commit();
}

typedef _UpgradeDbFn = void Function(Batch batch);

const Map<int, List<_UpgradeDbFn>> _upgradeDbFnListMap = {
  2: [
    _renameTodosColumnsToUnderscoreCase,
    _createTagsAndAddReferenceToTodos,
  ]
};

void _renameTodosColumnsToUnderscoreCase(Batch batch) {
  batch.execute('ALTER TABLE todos RENAME COLUMN createdDate TO created_date;');
  batch.execute('ALTER TABLE todos RENAME COLUMN imagePath TO image_path;');
  batch.execute('ALTER TABLE todos RENAME COLUMN isCompleted TO is_completed;');
}

void _createTagsAndAddReferenceToTodos(Batch batch) {
  batch.execute('''
    CREATE TABLE tags (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
      name TEXT NOT NULL
    );
  ''');

  batch.execute('''
    CREATE TEMPORARY TABLE temp AS
    SELECT id, created_date, image_path, is_completed
    FROM todos;
  ''');
  batch.execute('DROP TABLE todos;');

  batch.execute('''
    CREATE TABLE todos (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
      image_path TEXT NOT NULL,
      tag_id INTEGER,
      is_completed BOOLEAN DEFAULT 0 NOT NULL CHECK (is_completed IN (0, 1)),
      FOREIGN KEY (tag_id) REFERENCES tags (id)
    );
  ''');

  batch.execute('''
    INSERT INTO todos (id, created_date, image_path, is_completed)
    SELECT id, created_date, image_path, is_completed
    FROM temp;
  ''');
}
