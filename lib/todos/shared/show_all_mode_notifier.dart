import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShowAllModeNotifier extends StateNotifier<bool> {
  ShowAllModeNotifier() : super(true);

  void toggleShowAllMode() {
    state = !state;
  }
}

final showAllModeNotifier = showAllModeProvider.notifier;

final showAllModeProvider = StateNotifierProvider<ShowAllModeNotifier, bool>(
    (ref) => ShowAllModeNotifier());
