import 'update_entity.dart';

abstract class Entity {
  abstract final int id;
  abstract final DateTime createdDate;

  Entity copyWith();

  UpdateEntity toUpdate();

  @override
  String toString();
}
