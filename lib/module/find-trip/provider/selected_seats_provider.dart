import 'package:flutter_riverpod/legacy.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final passengerCountProvider = StateProvider<int>((ref) => 1);

class SeatSelectionNotifier extends StateNotifier<List<String>> {
  SeatSelectionNotifier(this.ref) : super([]);

  final Ref ref;

  void toggleSeat(String seatId) {
    final maxSeats = ref.read(passengerCountProvider);

    if (state.contains(seatId)) {
      state = state.where((e) => e != seatId).toList();
      return;
    }

    if (state.length >= maxSeats) return;

    state = [...state, seatId];
  }

  void clearSeats() {
    state = [];
  }
}

final selectedSeatsProvider =
    StateNotifierProvider<SeatSelectionNotifier, List<String>>(
      (ref) => SeatSelectionNotifier(ref),
    );
