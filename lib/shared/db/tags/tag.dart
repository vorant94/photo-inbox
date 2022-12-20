import 'package:flutter/foundation.dart';

import '../entities/entity.dart';
import 'tag_fields.dart';
import 'update_tag.dart';

@immutable
class Tag implements Entity {
  const Tag._({
    required this.id,
    required this.createdDate,
    required this.name,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag._(
      id: json[TagFields.id],
      createdDate: DateTime.parse(json[TagFields.createdDate]),
      name: json[TagFields.name],
    );
  }

  @override
  final int id;
  @override
  final DateTime createdDate;
  final String name;

  @override
  Tag copyWith({
    int? id,
    DateTime? createdDate,
    String? name,
  }) {
    return Tag._(
      id: id ?? this.id,
      createdDate: createdDate ?? this.createdDate,
      name: name ?? this.name,
    );
  }

  @override
  UpdateTag toUpdate() => UpdateTag.fromEntity(this);

  @override
  String toString() => 'Tag('
      'id: $id, '
      'createdDate: $createdDate, '
      'name: $name'
      ')';
}
