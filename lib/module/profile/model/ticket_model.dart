enum TicketStatus { open, pending, resolved }

class SupportTicketModel {
  final String ticketId;
  final String category;
  final String message;
  final String date;
  final TicketStatus status;

  SupportTicketModel({
    required this.ticketId,
    required this.category,
    required this.message,
    required this.date,
    required this.status,
  });
}
