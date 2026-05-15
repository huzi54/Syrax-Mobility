import 'package:flutter_riverpod/legacy.dart';

import '../model/ticket_model.dart';

final supportTicketProvider =
    StateNotifierProvider<SupportTicketNotifier, List<SupportTicketModel>>((
      ref,
    ) {
      return SupportTicketNotifier();
    });

class SupportTicketNotifier extends StateNotifier<List<SupportTicketModel>> {
  SupportTicketNotifier()
    : super([
        // Static Dummy Data for "My Tickets"
        SupportTicketModel(
          ticketId: "TK-9921",
          category: "Parcel Tracking Issue",
          message: "My parcel is stuck at the Paris hub for 3 days.",
          date: "04 March, 2026",
          status: TicketStatus.pending,
        ),
        SupportTicketModel(
          ticketId: "TK-8842",
          category: "Payment Failure",
          message: "Amount deducted but ticket not issued.",
          date: "01 March, 2026",
          status: TicketStatus.resolved,
        ),
      ]);

  void addTicket(SupportTicketModel ticket) {
    state = [ticket, ...state];
  }
}

class MessageLengthNotifier extends StateNotifier<int> {
  MessageLengthNotifier() : super(0);

  final int maxLength = 250;

  void updateLength(String text) {
    state = text.length;
  }

  int get remaining => maxLength - state;
}

final messageLengthProvider = StateNotifierProvider<MessageLengthNotifier, int>(
  (ref) {
    return MessageLengthNotifier();
  },
);
