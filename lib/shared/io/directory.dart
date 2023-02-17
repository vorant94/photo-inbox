import 'dart:io';

extension Ensure on Directory {
  Future<void> ensure({bool recursive = false}) async {
    if (!(await exists())) await create(recursive: recursive);
  }
}
