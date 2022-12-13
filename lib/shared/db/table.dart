import 'package:sqflite/sqflite.dart';

// there no inheritance of static methods in dart, so in order to
// abstract common table blueprint inheritors must be initializable, therefore
// in order to avoid redundant instances inheritors should also be singletones
abstract class Table<E extends Entity, CE extends CreateEntity,
    UE extends UpdateEntity> {
  const Table();

  Future<List<Entity>> getAll([Transaction? tnx]);

  Future<Entity> getOne(int id, [Transaction? tnx]);

  Future<Entity> insert(CE create, [Transaction? tnx]);

  Future<Entity> update(UE update, [Transaction? tnx]);
}

abstract class Entity {
  final int id;
  final DateTime createdDate;

  const Entity({
    required this.id,
    required this.createdDate,
  });

  Entity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        createdDate = DateTime.parse(json['createdDate']);

  // TODO add json validation
  Entity copyWith(Map<String, dynamic> json);

  UpdateEntity toUpdate();
}

abstract class CreateEntity {
  const CreateEntity();

  Map<String, dynamic> toJson();
}

abstract class UpdateEntity {
  late final int id;

  UpdateEntity.fromEntity(Entity entity) : id = entity.id;

  Map<String, dynamic> toJson();
}
