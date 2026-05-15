import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imo_mobility/core/extensions/context_extension.dart';
import 'package:imo_mobility/module/auth/views/login_screen.dart';
import 'package:imo_mobility/routes/route.dart';
import 'package:imo_mobility/shared/widgets/buttons/app_button.dart';
// Localization Imports
import 'package:imo_mobility/core/localization/locale_provider.dart';
import 'package:imo_mobility/core/localization/app_translations.dart';

import '../../../core/constants/constants.dart';
import '../data/onboarding_data.dart';
import '../model/onboarding_model.dart';
import '../providers/onboarding_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentPageIndex = ref.watch(onboardingProvider);
    final onboardingNotifier = ref.read(onboardingProvider.notifier);
    // Watch language
    final langCode = ref.watch(localeProvider).languageCode;

    ref.listen<int>(onboardingProvider, (previous, next) {
      if (_pageController.hasClients && _pageController.page?.round() != next) {
        _pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            AnimatedOpacity(
              opacity: currentPageIndex > 0 ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Image.asset('assets/images/app-logo.png', height: 50),
              ),
            ),

            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return PageView.builder(
                    controller: _pageController,
                    itemCount: onboardingData.length,
                    onPageChanged: (index) => onboardingNotifier.setPage(index),
                    itemBuilder: (context, index) {
                      final page = onboardingData[index];
                      // Keys generate karein index ke mutabiq
                      final String titleKey = 'onboard_title_$index';
                      final String descKey = 'onboard_desc_$index';

                      return index == 0
                          ? _buildSplashScreen(context, descKey, langCode)
                          : _buildOnboardingPage(
                              context,
                              page,
                              titleKey,
                              descKey,
                              langCode,
                              constraints,
                            );
                    },
                  );
                },
              ),
            ),

            _buildBottomControls(
              context,
              onboardingData,
              currentPageIndex,
              langCode,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSplashScreen(
    BuildContext context,
    String descKey,
    String langCode,
  ) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 250,
            width: 250,
            child: Hero(
              tag: 'app-logo',
              child: Image.asset('assets/images/app-logo.png'),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            AppTranslations.of(context, descKey, langCode),
            style: context.bodyLarge?.copyWith(
              color: AppColors.black.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage(
    BuildContext context,
    OnboardingPage page,
    String titleKey,
    String descKey,
    String langCode,
    BoxConstraints constraints,
  ) {
    return Column(
      children: [
        Expanded(
          flex: constraints.maxHeight < 600 ? 2 : 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: AspectRatio(
              aspectRatio: 16 / 10,
              child: Image.asset(page.imagePath, fit: BoxFit.contain),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              children: [
                Text(
                  AppTranslations.of(context, titleKey, langCode),
                  textAlign: TextAlign.center,
                  style: context.headlineSmall?.copyWith(
                    color: AppColors.bluePrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  AppTranslations.of(context, descKey, langCode),
                  textAlign: TextAlign.center,
                  style: context.bodyLarge?.copyWith(
                    color: AppColors.black.withOpacity(0.6),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomControls(
    BuildContext context,
    List<OnboardingPage> pages,
    int currentPageIndex,
    String langCode,
  ) {
    final bool isLastPage = currentPageIndex == pages.length - 1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(pages.length, (index) {
              final isSelected = currentPageIndex == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                height: 8,
                width: isSelected ? 24 : 8,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.bluePrimary
                      : AppColors.grayBorder,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),

          AppButtons.elevated(
            borderRadius: 100,
            size: const Size(double.infinity, 50),
            onPressed: () {
              if (isLastPage) {
                AppNavigation.pushReplacement(const LoginScreen());
              } else {
                ref.read(onboardingProvider.notifier).nextPage();
              }
            },
            backgroundColor: AppColors.orangePrimary,
            text: isLastPage
                ? AppTranslations.of(context, 'onboard_start', langCode)
                : AppTranslations.of(context, 'onboard_next', langCode),
          ),
        ],
      ),
    );
  }
}
