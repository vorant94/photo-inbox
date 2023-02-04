import 'package:isar/isar.dart';

part 'todo.g.dart';

@collection
class Todo {
  Id id = Isar.autoIncrement;
  DateTime createdDate = DateTime.now();
  bool isCompleted = false;
  late String imagePath;
}
