import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../core/constants/cities_list.dart';
import '../model/selectable_date_model.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// StateNotifier to manage selected date and dates list
/// StateNotifier for dates
class BookRideNotifier extends StateNotifier<List<SelectableDate>> {
  DateTime? selectedCalendarDate;

  BookRideNotifier() : super([]) {
    _initializeDates();
  }

  void _initializeDates() {
    final today = DateTime.now();
    state = List.generate(4, (index) {
      return SelectableDate(
        date: today.add(Duration(days: index)),
        isSelected: index == 0,
      );
    });
  }

  /// Get currently selected date for calendar
  DateTime get calendarInitialDate {
    // 1. If user selected from calendar, return that
    if (selectedCalendarDate != null) return selectedCalendarDate!;
    // 2. Else return first selected default tile
    final defaultSelected = state.firstWhere(
      (d) => d.isSelected,
      orElse: () => state[0],
    );
    return defaultSelected.date;
  }

  /// Select default tile
  void selectDate(int index) {
    selectedCalendarDate = null; // clear calendar selection
    state = [
      for (int i = 0; i < state.length; i++)
        SelectableDate(date: state[i].date, isSelected: i == index),
    ];
  }

  /// Update calendar-selected date (from bottom sheet)
  void updateSelectedDate(DateTime newDate) {
    selectedCalendarDate = newDate;
    // unselect all default tiles
    state = state
        .map((d) => SelectableDate(date: d.date, isSelected: false))
        .toList();
  }
}

final bookRideProvider =
    StateNotifierProvider<BookRideNotifier, List<SelectableDate>>((ref) {
      return BookRideNotifier();
    });

// -------------------- City Search Provider --------------------
class CitySearchNotifier extends StateNotifier<List<String>> {
  CitySearchNotifier() : super(franceCities);

  void search(String query) {
    if (query.isEmpty) {
      state = franceCities;
    } else {
      state = franceCities
          .where((city) => city.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  void reset() {
    state = franceCities;
  }
}

final citySearchProvider =
    StateNotifierProvider<CitySearchNotifier, List<String>>(
      (ref) => CitySearchNotifier(),
    );

// final selectedFromCityProvider = StateProvider<String?>((ref) => null);
// final selectedToCityProvider = StateProvider<String?>((ref) => null);

// final citySwapProvider = Provider((ref) {
//   return () {
//     final fromNotifier = ref.read(selectedFromCityProvider.notifier);
//     final toNotifier = ref.read(selectedToCityProvider.notifier);

//     final temp = fromNotifier.state;
//     fromNotifier.state = toNotifier.state;
//     toNotifier.state = temp;
//   };
// });

class CitySelectionState {
  final String? fromCity;
  final String? toCity;

  CitySelectionState({this.fromCity, this.toCity});

  CitySelectionState copyWith({String? fromCity, String? toCity}) {
    return CitySelectionState(
      fromCity: fromCity ?? this.fromCity,
      toCity: toCity ?? this.toCity,
    );
  }
}

class CitySelectionNotifier extends StateNotifier<CitySelectionState> {
  CitySelectionNotifier() : super(CitySelectionState());

  // Set From city
  void setFromCity(String city) {
    state = state.copyWith(fromCity: city);
  }

  // Set To city
  void setToCity(String city) {
    state = state.copyWith(toCity: city);
  }

  // Swap From & To
  void swapCities() {
    state = state.copyWith(fromCity: state.toCity, toCity: state.fromCity);
  }

  // Reset both
  void resetCities() {
    state = CitySelectionState(fromCity: null, toCity: null);
  }
}

// Legacy StateNotifierProvider
final citySelectionProvider =
    StateNotifierProvider<CitySelectionNotifier, CitySelectionState>(
      (ref) => CitySelectionNotifier(),
    );

final isTimingViewingProvider = NotifierProvider<IsTimingViewingNotifier, bool>(
  IsTimingViewingNotifier.new,
);

class IsTimingViewingNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false; // initial value
  }

  void toggle() {
    state = !state;
  }

  void setTrue() {
    state = true;
  }

  void setFalse() {
    state = false;
  }
}

class TicketState {
  final bool isLoading;

  TicketState({this.isLoading = false});

  TicketState copyWith({bool? isLoading}) {
    return TicketState(isLoading: isLoading ?? this.isLoading);
  }
}

class TicketNotifier extends StateNotifier<TicketState> {
  TicketNotifier() : super(TicketState());

  Future<void> downloadTicket(Uint8List imageBytes) async {
    state = state.copyWith(isLoading: true);

    final directory = await getApplicationDocumentsDirectory();
    final file = File("${directory.path}/ticket.png");
    await file.writeAsBytes(imageBytes);

    state = state.copyWith(isLoading: false);
  }

  Future<void> shareTicket(Uint8List imageBytes) async {
    state = state.copyWith(isLoading: true);

    final directory = await getTemporaryDirectory();
    final file = File("${directory.path}/ticket.png");
    await file.writeAsBytes(imageBytes);

    await Share.shareXFiles([XFile(file.path)]);

    state = state.copyWith(isLoading: false);
  }
}

final ticketProvider = StateNotifierProvider<TicketNotifier, TicketState>(
  (ref) => TicketNotifier(),
);
