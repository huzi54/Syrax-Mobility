// Location: lib/features/onboarding/data/onboarding_data.dart

// --- DATA SOURCE WITH CORRECT SPELLING ---
// All text here is derived directly from the supplied images.
import '../model/onboarding_model.dart';

const List<OnboardingPage> onboardingData = [
  // Page 0: The Splash Screen (from image 0)
  OnboardingPage(
    title: "imo mobility",
    description: "Your seamless mobility partner",
    imagePath: "assets/images/app-logo.png", // Simplified logo-only image
  ),
  // Page 1: Route Planning (from image 1)
  OnboardingPage(
    title: "Find your route",
    description:
        "Seamlessly plan your journey with our vast network of routes and times.",
    imagePath: "assets/images/onboard-1.png",
  ),
  // Page 2: Booking and Tracking (from image 3)
  OnboardingPage(
    title: "Book your exact seat & track arrival",
    description:
        "Choose your preferred seat from the bus plan and see the exact shuttle location in real-time.",
    imagePath: "assets/images/onboard-2.png",
  ),
  // Page 3: Customer Support (from image 3)
  OnboardingPage(
    title: "24/7 Support & seamless help",
    description:
        "Access our round-the-clock help center, report issues, and manage all your ride details in one place.",
    imagePath: "assets/images/onboard-3.png",
  ),
];
