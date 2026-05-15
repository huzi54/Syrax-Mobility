import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imo_mobility/core/constants/constants.dart';
import 'package:imo_mobility/core/extensions/context_extension.dart';
import 'package:imo_mobility/module/profile/view/tickets_home_screen.dart';
import 'package:imo_mobility/routes/route.dart';
import 'package:imo_mobility/shared/widgets/my_app_bar.dart';
import 'package:imo_mobility/core/localization/locale_provider.dart';
import 'package:imo_mobility/core/localization/app_translations.dart';

class HelpSupportScreen extends ConsumerWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final langCode = ref.watch(localeProvider).languageCode;

    return Scaffold(
      appBar: MyAppBar(
        title: AppTranslations.of(context, 'help_support', langCode),
        titleColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  color: AppColors.orangePrimary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.support_agent_rounded,
                  size: 80,
                  color: AppColors.orangePrimary,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              AppTranslations.of(context, 'how_can_we_help', langCode),
              style: context.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppTranslations.of(context, 'team_available', langCode),
              style: context.bodyMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            _buildSupportTile(
              context,
              title: AppTranslations.of(context, 'support_tickets', langCode),
              subtitle: AppTranslations.of(
                context,
                'support_tickets_subtitle',
                langCode,
              ),
              icon: Icons.chat_bubble_outline_rounded,
              color: Colors.blue,
              onTap: () {
                AppNavigation.push(TicketMainScreen());
              },
            ),
            _buildSupportTile(
              context,
              title: AppTranslations.of(context, 'email_support', langCode),
              subtitle: "support@imomobility.com",
              icon: Icons.email_outlined,
              color: Colors.orange,
              onTap: () {},
            ),
            _buildSupportTile(
              context,
              title: AppTranslations.of(context, 'call_us', langCode),
              subtitle: "+92 300 1234567",
              icon: Icons.phone_in_talk_outlined,
              color: Colors.green,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          title,
          style: context.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subtitle,
          style: context.bodySmall?.copyWith(color: Colors.grey),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildFAQTile(BuildContext context, String question) {
    return ExpansionTile(
      title: Text(
        question,
        style: context.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            "You can manage your bookings through the 'Trip History' tab in your profile. Select the trip and follow the instructions.",
            style: context.bodySmall?.copyWith(color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
