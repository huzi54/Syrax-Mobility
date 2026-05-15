enum SeatType { standard, vip, staff, blocked }

class SeatModel {
  final String id;
  final SeatType type;
  final bool isBooked;

  SeatModel({
    required this.id,
    this.type = SeatType.standard,
    this.isBooked = false,
  });
}

class BusLayoutTemplate {
  final String name;
  final int leftColumn; // e.g., 2 for 2x2
  final int rightColumn; // e.g., 2 for 2x2
  final bool hasRearRow; // Rear row 5 seats
  final List<String> vipSeatIds;
  final List<String> staffSeatIds;

  BusLayoutTemplate({
    required this.name,
    required this.leftColumn,
    required this.rightColumn,
    this.hasRearRow = true,
    this.vipSeatIds = const [],
    this.staffSeatIds = const [],
  });
}
