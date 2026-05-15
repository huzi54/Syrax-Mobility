import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // Add this
import 'package:imo_mobility/module/home/view/home_screen.dart';
import 'package:imo_mobility/module/splash/ui/splash_screen.dart';
import 'package:imo_mobility/routes/route.dart';
import 'core/constants/app_theme.dart';
import 'shared/utils/app_snackbar.dart';
// Apne banaye huye paths import karein
import 'core/localization/locale_provider.dart';

class ImoMobilityApp extends StatefulWidget {
  static void run() {
    WidgetsFlutterBinding.ensureInitialized();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    runApp(const ProviderScope(child: ImoMobilityApp()));
  }

  const ImoMobilityApp({super.key});

  @override
  State<ImoMobilityApp> createState() => _ImoMobilityAppState();
}

// ConsumerState use karein taake ref ko access kar saken
class _ImoMobilityAppState extends State<ImoMobilityApp> {
  @override
  Widget build(BuildContext context) {
    // Wrap with Consumer to watch the locale
    return Consumer(
      builder: (context, ref, child) {
        final locale = ref.watch(localeProvider); // Watch the language state

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: AppSnackBar.scaffoldMessengerKey,
          navigatorKey: AppNavigation.navigatorKey,
          theme: AppTheme.lightTheme,

          // --- LOCALIZATION SETTINGS ---
          locale: locale,
          supportedLocales: const [Locale('en'), Locale('fr')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          // -----------------------------
          home: const SplashScreen(),
        );
      },
    );
  }
}
