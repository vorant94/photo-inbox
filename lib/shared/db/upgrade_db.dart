import 'package:sqflite/sqflite.dart';

typedef UpgradeDbFn = void Function(Batch batch);

const Map<int, List<UpgradeDbFn>> upgradeDbFnListMap = {};
