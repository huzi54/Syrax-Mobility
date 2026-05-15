enum SeatType { standard, vip, staff, blocked }

class BusLayoutTemplate {
  final String name;
  final int leftColumn;
  final int rightColumn;
  final int totalRows;
  final bool hasRearRow;
  final List<String> vipSeatIds;
  final List<String> staffSeatIds;
  final List<String> blockedSeatIds;

  BusLayoutTemplate({
    required this.name,
    required this.leftColumn,
    required this.rightColumn,
    required this.totalRows,
    this.hasRearRow = true,
    this.vipSeatIds = const [],
    this.staffSeatIds = const [],
    this.blockedSeatIds = const [],
  });
}
