import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imo_mobility/core/constants/constants.dart';
import 'package:imo_mobility/core/extensions/app_extensions.dart';
import 'package:imo_mobility/core/extensions/context_extension.dart';
import 'package:imo_mobility/module/auth/views/login_screen.dart';
import 'package:imo_mobility/module/find-trip/views/trip_history_screen.dart';
import 'package:imo_mobility/module/profile/view/notifications_settings_ui.dart';
import 'package:imo_mobility/module/profile/view/settings_screen.dart';
import 'package:imo_mobility/routes/route.dart';
import 'package:imo_mobility/shared/widgets/my_app_bar.dart';
// Localization Imports
import 'package:imo_mobility/core/localization/locale_provider.dart';
import 'package:imo_mobility/core/localization/app_translations.dart';

import '../../bottom_nav_bar/provider/nav_provider.dart';
import '../../bottom_nav_bar/view/app_btm_nav_bar.dart';
import '../widget/lan_switch_btn.dart';
import 'help_support_screen.dart';

final userProfileProvider = Provider(
  (ref) => {
    'name': 'Moctar Sahande',
    'email': 'moctar@sirax.com',
    'trips': '43',
    'points': '234',
  },
);

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userProfileProvider);
    // Get current language code
    final langCode = ref.watch(localeProvider).languageCode;
    final isProfileActive = ref.watch(isProfileActiveProvider);
    final locale = ref.watch(localeProvider);
    final bool isFrench = locale.languageCode == 'fr';

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: PopScope(
          canPop: !isProfileActive,
          onPopInvokedWithResult: (didPop, result) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              AppNavigation.pushAndRemoveUntil(const AppBottomNavBar());
            });
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                70.verticalSpace,
                if (!isProfileActive)
                  Align(
                    alignment: AlignmentGeometry.bottomLeft,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.primaryColor,
                      ),
                      color: AppColors.primaryColor,
                      onPressed: () => AppNavigation.pushAndRemoveUntil(
                        const AppBottomNavBar(),
                      ),
                    ),
                  ),
                // --- Profile Section ---
                20.verticalSpace,
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.orangePrimary,
                        width: 2,
                      ),
                    ),
                    child: const CircleAvatar(
                      radius: 55,
                      backgroundColor: Color(0xFFEEEEEE),
                      backgroundImage: AssetImage('assets/images/user-dp.png'),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                Text(
                  userData['name']!,
                  style: context.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  userData['email']!,
                  style: context.bodyMedium?.copyWith(color: Colors.grey),
                ),

                // --- Stats Section ---
                const SizedBox(height: 30),

                // --- Menu Options ---
                ProfileTile(
                  icon: Icons.account_circle_outlined,
                  title: AppTranslations.of(context, 'editProfile', langCode),
                  onTap: () => AppNavigation.push(const SettingsScreen()),
                ),

                ProfileTile(
                  icon: Icons.history_rounded,
                  title: AppTranslations.of(context, 'trip_history', langCode),
                  onTap: () => AppNavigation.push(const TripHistoryScreen()),
                ),
                ProfileTile(
                  icon: Icons.payment_rounded,
                  title: AppTranslations.of(
                    context,
                    'payment_methods',
                    langCode,
                  ),
                  onTap: () {},
                ),
                ProfileTile(
                  icon: Icons.support_agent_rounded,
                  title: AppTranslations.of(context, 'help_support', langCode),
                  onTap: () => AppNavigation.push(const HelpSupportScreen()),
                ),

                ProfileTile(
                  icon: Icons.language,
                  title: AppTranslations.of(context, 'language', langCode),
                  subTitle: isFrench ? "Français" : "English",
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return SizedBox(
                          height: 150, // 👈 yahan height increase karo
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: Text(
                                  "English",
                                  style: context.titleSmall,
                                ),
                                trailing: !isFrench
                                    ? const Icon(Icons.check)
                                    : null,
                                onTap: () {
                                  ref.read(localeProvider.notifier).state =
                                      const Locale('en');
                                  Navigator.pop(context);
                                },
                              ),

                              ListTile(
                                title: Text(
                                  "Français",
                                  style: context.titleSmall,
                                ),
                                trailing: isFrench
                                    ? const Icon(Icons.check)
                                    : null,
                                onTap: () {
                                  ref.read(localeProvider.notifier).state =
                                      const Locale('fr');
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                10.verticalSpace,
                Text(
                  "${AppTranslations.of(context, 'app_version', langCode)}: 1.0.1+1",
                  style: context.bodySmall,
                ),

                // ProfileTile(
                //   icon: Icons.support_agent_rounded,
                //   title: AppTranslations.of(context, 'help_support', langCode),
                //   onTap: () => AppNavigation.push(const HelpSupportScreen()),
                // ),
                const SizedBox(height: 40),

                // --- Logout Button ---
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    onPressed: () => _showLogoutDialog(context, ref),
                    icon: const Icon(Icons.logout_rounded, color: Colors.white),
                    label: Text(
                      AppTranslations.of(context, 'logout', langCode),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE74C3C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Stats Widget
  Widget _buildStatItem(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: context.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.bluePrimary,
          ),
        ),
        Text(label, style: context.bodySmall?.copyWith(color: Colors.grey)),
      ],
    );
  }

  // Reusable Menu Tile

  // Widget _buildProfileTile(
  //   BuildContext context, {
  //   required IconData icon,
  //   required String title,
  //   String? subTitle,
  //   required VoidCallback onTap,
  // }) {
  //   return Column(
  //     children: [
  //       ListTile(
  //         contentPadding: EdgeInsets.zero,

  //         leading: Container(
  //           padding: const EdgeInsets.all(10),
  //           decoration: BoxDecoration(
  //             color: AppColors.grayLight,
  //             borderRadius: BorderRadius.circular(12),
  //           ),
  //           child: Icon(icon, color: AppColors.bluePrimary),
  //         ),

  //         title: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               title,
  //               style: context.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
  //             ),
  //             if (subTitle != null)
  //               Text(
  //                 subTitle,
  //                 style: context.bodyExtraSmall?.copyWith(
  //                   fontWeight: FontWeight.w300,
  //                 ),
  //               ),
  //           ],
  //         ),

  //         trailing: const Icon(
  //           Icons.arrow_forward_ios_rounded,
  //           size: 16,
  //           color: Colors.grey,
  //         ),

  //         onTap: onTap,
  //       ),

  //       /// Separator
  //       Divider(
  //         height: 1,
  //         thickness: 1,
  //         color: AppColors.grayBorder.withValues(alpha: 1),
  //       ),
  //     ],
  //   );
  // }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    final langCode = ref.read(localeProvider).languageCode;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(AppTranslations.of(context, 'logout', langCode)),
        content: Text(AppTranslations.of(context, 'logout_confirm', langCode)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppTranslations.of(context, 'cancel', langCode)),
          ),
          TextButton(
            onPressed: () => AppNavigation.pushAndRemoveUntil(LoginScreen()),
            child: Text(
              AppTranslations.of(context, 'logout', langCode),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileTile extends ConsumerWidget {
  final IconData icon;
  final String title;
  final String? subTitle;
  final VoidCallback onTap;

  const ProfileTile({
    super.key,
    required this.icon,
    required this.title,
    this.subTitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final bool isFrench = locale.languageCode == 'fr';
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,

          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.grayLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.bluePrimary),
          ),

          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),

              if (subTitle != null)
                Text(
                  subTitle!,
                  style: context.bodyExtraSmall?.copyWith(
                    fontWeight: FontWeight.w300,
                  ),
                ),
            ],
          ),

          trailing: const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: Colors.grey,
          ),

          onTap: onTap,
        ),

        Divider(
          height: 1,
          thickness: 1,
          color: AppColors.grayBorder.withValues(alpha: 1),
        ),
      ],
    );
  }
}
