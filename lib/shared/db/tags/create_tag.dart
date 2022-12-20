import 'package:flutter/foundation.dart';

import '../entities/create_entity.dart';
import 'tag_fields.dart';

@immutable
class CreateTag implements CreateEntity {
  const CreateTag({
    required this.name,
  });

  final String name;

  @override
  Map<String, dynamic> toJson() => {
        TagFields.name: name,
      };
}
