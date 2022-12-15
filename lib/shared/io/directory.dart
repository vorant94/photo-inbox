import 'dart:io';

extension DirectoryExt on Directory {
  Future<void> ensure({bool recursive = false}) async {
    if (!(await exists())) await create(recursive: recursive);
  }
}
