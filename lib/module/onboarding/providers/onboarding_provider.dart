// Location: lib/features/onboarding/presentation/providers/onboarding_provider.dart

import 'package:flutter_riverpod/legacy.dart';

import '../data/onboarding_data.dart';

// StateNotifier manages an integer (the current page index)
class OnboardingNotifier extends StateNotifier<int> {
  // Legacy constructor syntax: pass the initial state (0)
  OnboardingNotifier() : super(0);

  // Update the state when a user swipes or taps a navigation button
  void setPage(int index) {
    if (index >= 0 && index < onboardingData.length) {
      state = index;
    }
  }

  // Convenience methods for linear flow control
  void nextPage() => setPage(state + 1);
  void previousPage() => setPage(state - 1);
}

// Global legacy provider definition
final onboardingProvider = StateNotifierProvider<OnboardingNotifier, int>((
  ref,
) {
  return OnboardingNotifier();
});
