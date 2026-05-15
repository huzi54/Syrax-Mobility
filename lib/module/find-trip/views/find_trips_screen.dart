import 'package:flutter/material.dart';
import 'package:imo_mobility/shared/widgets/my_app_bar.dart';

import '../../../shared/widgets/search_trips_card.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:imo_mobility/core/localization/app_translations.dart';
import 'package:imo_mobility/core/localization/locale_provider.dart';

class FindTripsScreen extends ConsumerWidget {
  const FindTripsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final langCode = ref.watch(localeProvider).languageCode;

    return Scaffold(
      appBar: MyAppBar(
        title: AppTranslations.of(context, 'find_trip', langCode),
      ),
      body: Column(children: const [SearchTripsCard()]),
    );
  }
}
