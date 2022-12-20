import 'package:flutter/foundation.dart';

import '../entities/update_entity.dart';
import 'tag.dart';
import 'tag_fields.dart';

@immutable
class UpdateTag implements UpdateEntity {
  UpdateTag.fromEntity(Tag tag)
      : id = tag.id,
        name = tag.name;

  @override
  final int id;
  final String name;

  @override
  Map<String, dynamic> toJson() => {
        TagFields.id: id,
        TagFields.name: name,
      };
}
