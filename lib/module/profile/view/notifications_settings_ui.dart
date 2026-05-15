import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:imo_mobility/core/constants/constants.dart';
import 'package:imo_mobility/shared/widgets/my_app_bar.dart';

import '../../../core/extensions/context_extension.dart';

// --- STATE MANAGEMENT ---
final pushNotifyProvider = StateProvider<bool>((ref) => true);
final emailNotifyProvider = StateProvider<bool>((ref) => false);

class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: MyAppBar(title: "Notifications"),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, "PREFERENCES"),

            _buildSwitchTile(
              context,
              ref,
              title: "Push Notifications",
              subtitle: "Receive instant updates",
              provider: pushNotifyProvider,
            ),

            _buildSwitchTile(
              context,
              ref,
              title: "Email Reports",
              subtitle: "Get summary in your inbox",
              provider: emailNotifyProvider,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
      child: Text(
        title,
        style: context.headlineSmall?.copyWith(
          color: AppColors.greyColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required String subtitle,
    required StateProvider<bool> provider,
  }) {
    final bool isEnabled = ref.watch(provider);

    return Column(
      children: [
        SwitchListTile(
          value: isEnabled,
          onChanged: (newValue) => ref.read(provider.notifier).state = newValue,
          title: Text(
            title,
            // HeadlineSmall used for Title
            style: context.headlineSmall?.copyWith(
              color: AppColors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            subtitle,
            // HeadlineSmall used for Subtitle
            style: context.headlineSmall?.copyWith(
              color: AppColors.greyColor,
              fontSize: 13,
            ),
          ),
          // activeColor: AppColors.orangePrimary,
          // activeThumbColor: AppColors.orangePrimary,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 5,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Divider(height: 1, thickness: 0.5, color: AppColors.greyColor),
        ),
      ],
    );
  }
}
