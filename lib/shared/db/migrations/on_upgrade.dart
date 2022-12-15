import 'package:collection/collection.dart';
import 'package:sqflite/sqflite.dart';

Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
  final batch = db.batch();

  final upgradableVersions =
      _upgradeDbFnListMap.keys.sorted((a, b) => a.compareTo(b));

  for (var version in upgradableVersions) {
    if (version > oldVersion && version <= newVersion) {
      final upgradeFnList = _upgradeDbFnListMap[version]!;

      for (var fn in upgradeFnList) {
        fn(batch);
      }
    }
  }

  await batch.commit();
}

typedef _UpgradeDbFn = void Function(Batch batch);

const Map<int, List<_UpgradeDbFn>> _upgradeDbFnListMap = {};
