import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imo_mobility/core/constants/constants.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    // loadTranslations();
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.forward();

    // Start authentication check after animation and delay
    // Future.delayed(const Duration(seconds: 3), () {
    //   ref.read(splashProvider.notifier).checkAuthenticationAndCommunity();
    // });
  }

  // Future loadTranslations() async {
  //   final languageId = await AppDataKeys.languageId.getFromSecure<int>();
  //   Future.microtask(() {
  //     ref
  //         .read(translationProvider.notifier)
  //         .loadTranslations(
  //           platform: 'resident_app',
  //           languageId: languageId ?? 1,
  //         );
  //   });
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Centered app icon with fade-in
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: AppAssets.images.applogo.image(height: 65),
            ),
          ),
          // Circular progress indicator at the bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: kBottomNavigationBarHeight / 2,
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
