import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShowAllModeNotifier extends StateNotifier<bool> {
  ShowAllModeNotifier() : super(true);

  void toggle() {
    state = !state;
  }
}

final showAllModeProvider = StateNotifierProvider<ShowAllModeNotifier, bool>(
    (ref) => ShowAllModeNotifier());
