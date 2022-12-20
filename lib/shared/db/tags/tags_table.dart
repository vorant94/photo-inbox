import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../entities/entities_table.dart';
import '../with_tnx.dart';
import 'create_tag.dart';
import 'tag.dart';
import 'tag_fields.dart';
import 'update_tag.dart';

@immutable
class TagsTable implements EntitiesTable<Tag, CreateTag, UpdateTag> {
  static const name = 'tags';

  const TagsTable();

  // TODO add support for both ids and names at the same time
  @override
  Future<List<Tag>> getMany({
    List<int>? ids,
    List<String>? names,
    Transaction? tnx,
  }) async {
    return await withTnx((tnx) async {
      String where = '';
      List<Object?> whereArgs = [];

      if (ids != null) {
        where += '${TagFields.id} IN(?)';
        whereArgs.add(ids.join(', '));
      }

      if (names != null) {
        where += '${TagFields.name} IN(?)';
        whereArgs.add(names.join(', '));
      }

      final maps = await tnx.query(
        TagsTable.name,
        where: where.isEmpty ? null : where,
        whereArgs: whereArgs.isEmpty ? null : whereArgs,
        orderBy: '${TagFields.createdDate} DESC',
      );

      return maps.map((map) => Tag.fromJson(map)).toList();
    }, tnx);
  }

  @override
  Future<Tag> getOne(int id, {Transaction? tnx}) async {
    return await withTnx((tnx) async {
      final tags = await getMany(ids: [id], tnx: tnx);

      if (tags.isEmpty) throw Exception('Not found');
      return tags.first;
    }, tnx);
  }

  @override
  Future<Tag> create(CreateTag createTag, {Transaction? tnx}) async {
    return await withTnx((tnx) async {
      final id = await tnx.insert(
        TagsTable.name,
        createTag.toJson(),
      );
      return getOne(id, tnx: tnx);
    }, tnx);
  }

  @override
  Future<Tag> update(UpdateTag tag, {Transaction? tnx}) async {
    return await withTnx((tnx) async {
      final count = await tnx.update(
        TagsTable.name,
        tag.toJson(),
        where: '${TagFields.id} = ?',
        whereArgs: [tag.id],
      );

      if (count != 1) throw Exception('Not found');

      return getOne(tag.id, tnx: tnx);
    }, tnx);
  }

  Future<Tag?> findOneByName(String name, {Transaction? tnx}) async {
    return await withTnx((tnx) async {
      final tags = await getMany(names: [name], tnx: tnx);

      return tags.isEmpty ? null : tags.first;
    }, tnx);
  }
}
