import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../model/bus_layout_model.dart';

class SeatWidget extends StatelessWidget {
  final String id;
  final SeatType type;
  final bool isSelected;
  final VoidCallback? onTap;

  const SeatWidget({
    super.key,
    required this.id,
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String assetPath = "assets/images/icons/available-seat.svg";

    if (isSelected) {
      assetPath = "assets/images/icons/selected-seat.svg";
    } else if (type == SeatType.staff || type == SeatType.blocked) {
      assetPath = "assets/images/icons/booked-seat.svg";
    } else if (type == SeatType.vip) {
      assetPath = "assets/images/icons/vip-seat.svg";
    }

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            /// Seat number on TOP (fontSize 10)
            Text(
              id,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 2),
            SvgPicture.asset(assetPath, width: 35, height: 35),
          ],
        ),
      ),
    );
  }
}
