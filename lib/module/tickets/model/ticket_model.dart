class TicketModel {
  final String passengerName;
  final String bookingReference;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final String fromCity;
  final String fromStation;
  final String toCity;
  final String toStation;
  final String busNumber;
  final String busPlate;
  final String seatNumber;

  TicketModel({
    required this.passengerName,
    required this.bookingReference,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.fromCity,
    required this.fromStation,
    required this.toCity,
    required this.toStation,
    required this.busNumber,
    required this.busPlate,
    required this.seatNumber,
  });
}
