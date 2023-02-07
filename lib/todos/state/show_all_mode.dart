import 'package:get_it/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'show_all_mode.g.dart';

@riverpod
class ShowAllMode extends _$ShowAllMode {
  final _prefsKey = 'showAllMode';

  @override
  bool build() {
    final prefs = GetIt.I<SharedPreferences>();

    return prefs.getBool(_prefsKey) ?? false;
  }

  Future<void> toggle() async {
    final prefs = GetIt.I<SharedPreferences>();

    await prefs.setBool(_prefsKey, !state);

    state = !state;
  }
}
