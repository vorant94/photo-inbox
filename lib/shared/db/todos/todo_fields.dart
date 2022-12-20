import 'package:flutter/foundation.dart';

import '../entities/entity_fields.dart';

@immutable
class TodoFields {
  static const id = EntityFields.id;
  static const createdDate = EntityFields.createdDate;
  static const imagePath = 'image_path';
  static const tagId = 'tag_id';
  static const isCompleted = 'is_completed';

  // inner join fields
  static const tag = 'tag';
}
