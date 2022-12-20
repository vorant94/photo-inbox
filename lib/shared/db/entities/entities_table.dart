import 'package:sqflite/sqflite.dart';

import 'create_entity.dart';
import 'entity.dart';
import 'update_entity.dart';

// there no inheritance of static methods in dart, so in order to
// abstract common table blueprint inheritors must be initializable
//
// also because of this problem Entity.fromJson named constructors can't be
// inherited, so any table method that uses this mapping
// (e.g. every table method) cannot be extended, only reimplemented, so there
// are only private unnamed constructors in order to avoid extension of these classes
abstract class EntitiesTable<E extends Entity, CE extends CreateEntity,
    UE extends UpdateEntity> {
  Future<List<Entity>> getMany({Transaction? tnx});

  Future<Entity> getOne(int id, {Transaction? tnx});

  Future<Entity> create(CE create, {Transaction? tnx});

  Future<Entity> update(UE update, {Transaction? tnx});
}
