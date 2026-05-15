import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imo_mobility/core/extensions/context_extension.dart';

import '../../../core/constants/constants.dart';

import '../../onboarding/views/onboarding_screen.dart'; // adjust path

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 3),

            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 280,
                    width: 280,
                    child: Hero(
                      tag: 'app-logo',
                      child: Image.asset('assets/images/app-logo.png'),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(flex: 3),

            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Text(
                'V.1.0.1',
                style: context.bodySmall?.copyWith(
                  color: AppColors.blueSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
