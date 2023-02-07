import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'show_all_mode.g.dart';

@riverpod
class ShowAllMode extends _$ShowAllMode {
  @override
  bool build() {
    return false;
  }

  void toggle() {
    state = !state;
  }
}
