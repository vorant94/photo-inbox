import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

// there no inheritance of static methods in dart, so in order to
// abstract common table blueprint inheritors must be initializable, therefore
// in order to avoid redundant instances inheritors should also be singletones
//
// also because of this problem Entity.fromJson named constructors can't be
// inherited, so any table method that uses this mapping
// (e.g. every table method) cannot be extended, only reimplemented, so there
// are only private unnamed constructors in order to avoid extension of these classes
@immutable
abstract class EntitiesTable<E extends Entity, CE extends CreateEntity,
    UE extends UpdateEntity> {
  abstract final String name;

  const EntitiesTable._();

  Future<List<Entity>> getMany([Transaction? tnx]);

  Future<Entity> getOne(int id, [Transaction? tnx]);

  Future<Entity> create(CE create, [Transaction? tnx]);

  Future<Entity> update(UE update, [Transaction? tnx]);
}

@immutable
abstract class Entity {
  abstract final int id;
  abstract final DateTime createdDate;

  const Entity._();

  // TODO add json validation
  // there is no Partial<T> helper in the dart
  // so the only option here is to use Map<String, dynamic>
  Entity copyWith(Map<String, dynamic> json);

  UpdateEntity toUpdate();
}

@immutable
abstract class CreateEntity {
  const CreateEntity._();

  Map<String, dynamic> toJson();
}

@immutable
abstract class UpdateEntity {
  abstract final int id;

  const UpdateEntity._();

  Map<String, dynamic> toJson();
}

@immutable
class EntityFields {
  static const id = 'id';
  static const createdDate = 'createdDate';

  const EntityFields._();
}
