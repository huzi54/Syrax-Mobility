// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:imo_mobility/module/book%20ride/view/ticket_screen.dart';
// import 'package:imo_mobility/routes/route.dart';

// import '../../../core/constants/constants.dart';
// import '../../../shared/widgets/my_app_bar.dart';

// class SeatSelectionScreen extends StatefulWidget {
//   @override
//   _SeatSelectionScreenState createState() => _SeatSelectionScreenState();
// }

// class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
//   // Seat status: 0 = Available, 1 = Booked, 2 = Selected
//   List<int> seatStates = List.generate(32, (index) => index % 5 == 0 ? 1 : 0);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: MyAppBar(
//         title: "Choose your seat",
//         backgroundColor: AppColors.scaffoldColor,
//         titleColor: AppColors.primaryColor,
//       ),

//       body: Column(
//         children: [
//           Expanded(
//             child: Container(
//               margin: EdgeInsets.all(20),
//               padding: EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: AppColors.white,
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               child: Column(
//                 children: [
//                   _buildHeaderLabels(),
//                   SizedBox(height: 20),
//                   Expanded(child: _buildSeatGrid()),
//                   _buildLegend(),
//                 ],
//               ),
//             ),
//           ),
//           _buildNextButton(),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeaderLabels() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: ["1", "2", "3", "4"]
//           .map(
//             (label) => Text(
//               label,
//               style: TextStyle(
//                 color: AppColors.bluePrimary.withOpacity(0.5),
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           )
//           .toList(),
//     );
//   }

//   Widget _buildSeatGrid() {
//     return GridView.builder(
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 4,
//         mainAxisSpacing: 15,
//         crossAxisSpacing: 15,
//       ),
//       itemCount: 32,
//       itemBuilder: (context, index) {
//         int status = seatStates[index];

//         // Dynamic colors based on your palette
//         Color color;
//         Border? border;

//         if (status == 1) {
//           color = AppColors.grayLight; // Booked
//           border = Border.all(color: AppColors.grayBorder);
//         } else if (status == 2) {
//           color = AppColors.orangePrimary; // Selected/Chosen
//           border = null;
//         } else {
//           color = AppColors.white; // Available
//           border = Border.all(color: AppColors.grayBorder, width: 1.5);
//         }

//         return GestureDetector(
//           onTap: () {
//             if (status != 1) {
//               setState(() => seatStates[index] = status == 0 ? 2 : 0);
//             }
//           },
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               SvgPicture.asset(
//                 "assets/images/icons/bus-seat.svg",
//                 width: 40,
//                 height: 40,
//                 colorFilter: ColorFilter.mode(
//                   status == 1
//                       ? AppColors.grayBorder.withValues(alpha: .5) // booked
//                       : status == 2
//                       ? AppColors
//                             .orangePrimary // selected
//                       : Colors.grey.shade300, // available (light grey)
//                   BlendMode.srcIn,
//                 ),
//               ),

//               // Close icon for booked
//               if (status == 1)
//                 Icon(
//                   Icons.linear_scale_sharp,
//                   size: 16,
//                   color: AppColors.orangePrimary,
//                 ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildLegend() {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 10),
//       decoration: BoxDecoration(
//         color: AppColors.grayLight.withOpacity(0.5),
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _legendItem("Available", AppColors.white, border: true),
//           _legendItem("Booked", AppColors.grayLight),
//           _legendItem("Chosen", AppColors.orangePrimary),
//         ],
//       ),
//     );
//   }

//   Widget _legendItem(String text, Color color, {bool border = false}) {
//     return Row(
//       children: [
//         Container(
//           width: 16,
//           height: 16,
//           decoration: BoxDecoration(
//             color: color,
//             borderRadius: BorderRadius.circular(4),
//             border: border ? Border.all(color: AppColors.grayBorder) : null,
//           ),
//         ),
//         SizedBox(width: 8),
//         Text(
//           text,
//           style: TextStyle(
//             fontSize: 12,
//             color: AppColors.bluePrimary,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildNextButton() {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.fromLTRB(40, 0, 40, 30),
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: AppColors.bluePrimary,
//           foregroundColor: AppColors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//           padding: EdgeInsets.symmetric(vertical: 18),
//           elevation: 5,
//         ),
//         onPressed: () {
//           AppNavigation.push(TicketDetailsScreen());
//         },
//         child: Text(
//           "Confirm Selection",
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }
