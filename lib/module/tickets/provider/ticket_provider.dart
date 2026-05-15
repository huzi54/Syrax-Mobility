import 'package:flutter_riverpod/legacy.dart';

import '../model/ticket_model.dart';

// Ticket list ko manage karne wala notifier
class TicketNotifier extends StateNotifier<List<TicketModel>> {
  TicketNotifier() : super([]);

  // Naya ticket add karne ka function
  void addTicket(TicketModel ticket) {
    state = [...state, ticket];
  }
}

// Global provider
final ticketProvider = StateNotifierProvider<TicketNotifier, List<TicketModel>>(
  (ref) {
    return TicketNotifier();
  },
);
