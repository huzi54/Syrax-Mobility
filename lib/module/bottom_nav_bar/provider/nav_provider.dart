import 'package:flutter_riverpod/legacy.dart';

class BottomNavNotifier extends StateNotifier<int> {
  BottomNavNotifier() : super(0);

  void changeIndex(int index) {
    state = index;
  }
}

final bottomNavProvider = StateNotifierProvider<BottomNavNotifier, int>((ref) {
  return BottomNavNotifier();
});

final isProfileActiveProvider = StateProvider<bool>((ref) {
  // initial value false
  return false;
});
