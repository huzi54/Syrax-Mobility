import 'package:flutter/material.dart';
import 'package:imo_mobility/core/extensions/app_extensions.dart';
import 'package:imo_mobility/core/extensions/context_extension.dart';

/// A reusable header widget with user avatar, greeting, location, and notifications
class HomeHeaderWidget extends StatelessWidget {
  final String userName;
  final String location;
  final VoidCallback? onNotificationTap;
  final ValueChanged<String>? onLocationChanged;

  const HomeHeaderWidget({
    super.key,
    required this.userName,
    required this.location,
    this.onNotificationTap,
    this.onLocationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // Unfocus TextField when tapping anywhere outside
        FocusScope.of(context).unfocus();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 32,
              backgroundColor: Colors.blue,
              foregroundImage: AssetImage('assets/images/default-dp.png'),
              child: Icon(Icons.person, size: 25, color: Colors.white),
            ),
            10.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Welcome,",
                    style: context.bodyLarge?.copyWith(
                      // fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  Text(
                    userName,
                    style: context.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                  8.verticalSpace,
                ],
              ),
            ),
            GestureDetector(
              onTap: onNotificationTap,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.notifications),
              ),
            ),
            GestureDetector(
              onTap: onNotificationTap,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.map_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
