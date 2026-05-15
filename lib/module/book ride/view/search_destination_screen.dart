import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/constants.dart';
import '../../../core/extensions/context_extension.dart';
import '../../../core/localization/app_translations.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../shared/widgets/text_fields/app_txtfield.dart';
import '../provider/book_ride_provider.dart';

class SearchDestinationSheet extends ConsumerStatefulWidget {
  final String route;
  const SearchDestinationSheet({super.key, required this.route});

  @override
  ConsumerState<SearchDestinationSheet> createState() =>
      _SearchDestinationSheetState();
}

class _SearchDestinationSheetState
    extends ConsumerState<SearchDestinationSheet> {
  late TextEditingController searchCityController;

  bool hasText = false;

  @override
  void initState() {
    super.initState();
    searchCityController = TextEditingController();

    /// Listener for showing cancel button
    searchCityController.addListener(() {
      setState(() {
        hasText = searchCityController.text.isNotEmpty;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchCityController.clear();
      ref.read(citySearchProvider.notifier).reset();
    });
  }

  @override
  void dispose() {
    searchCityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cities = ref.watch(citySearchProvider);
    final langCode = ref.watch(localeProvider).languageCode;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),

          child: Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: .5),
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              border: Border(top: BorderSide(color: AppColors.primaryColor)),
            ),
            child: Column(
              children: [
                /// Drag Handle
                const SizedBox(height: 10),
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 15),

                /// Title
                /// final langCode = ref.watch(localeProvider).languageCode;
                Text(
                  widget.route == 'arrival'
                      ? AppTranslations.of(
                          context,
                          'arrival_destination',
                          langCode,
                        )
                      : AppTranslations.of(
                          context,
                          'departure_destination',
                          langCode,
                        ),
                  style: context.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.bluePrimary,
                  ),
                ),

                // Text(
                //   widget.route,
                // style: context.titleMedium?.copyWith(
                //   fontWeight: FontWeight.bold,
                //   color: AppColors.primaryColor,
                // ),
                // ),
                const SizedBox(height: 20),

                /// Search Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AppTextFields(
                    controller: searchCityController,
                    hintText: AppTranslations.of(
                      context,
                      "searchDestination",
                      langCode,
                    ),

                    /// Search icon
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Icon(Icons.search, color: AppColors.greyColor),
                    ),

                    /// Cancel button
                    suffixIcon: hasText
                        ? GestureDetector(
                            onTap: () {
                              searchCityController.clear();
                              ref.read(citySearchProvider.notifier).reset();
                            },
                            child: const Icon(
                              CupertinoIcons.xmark,
                              color: Colors.grey,
                              size: 15,
                            ),
                          )
                        : null,

                    onChanged: (value) {
                      ref.read(citySearchProvider.notifier).search(value);
                    },
                  ),
                ),

                const SizedBox(height: 10),

                /// Cities List
                Expanded(
                  child: ListView.separated(
                    itemCount: cities.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.orangePrimary.withValues(alpha: .2),
                    ),
                    itemBuilder: (context, index) {
                      final selectedCity = ref.watch(citySelectionProvider);

                      // final isSelected = widget.route == 'Arrival Destination'
                      //     ? selectedCity.fromCity == cities[index]
                      //     : selectedCity.toCity == cities[index];
                      final isSelected = widget.route == 'arrival'
                          ? selectedCity.toCity == cities[index]
                          : selectedCity.fromCity == cities[index];

                      return Container(
                        color: isSelected
                            ? AppColors.primaryColor.withValues(alpha: .2)
                            : AppColors.white.withValues(alpha: .5),
                        child: ListTile(
                          focusColor: AppColors.black,
                          selectedColor: AppColors.white,
                          leading: Icon(
                            Icons.location_on_outlined,
                            color: isSelected
                                ? AppColors.primaryColor
                                : AppColors.bluePrimary,
                          ),
                          title: Text(
                            cities[index],
                            style: context.bodyLarge?.copyWith(
                              fontWeight: isSelected
                                  ? FontWeight.w800
                                  : FontWeight.w500,
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : AppColors.bluePrimary,
                              fontSize: 20,
                            ),
                          ),
                          trailing: isSelected
                              ? Icon(
                                  Icons.check_circle,
                                  color: AppColors.primaryColor,
                                )
                              : null,
                          tileColor: isSelected ? AppColors.white : null,
                          onTap: () {
                            if (widget.route == 'arrival') {
                              ref
                                  .read(citySelectionProvider.notifier)
                                  .setToCity(cities[index]);
                            } else {
                              ref
                                  .read(citySelectionProvider.notifier)
                                  .setFromCity(cities[index]);
                            }

                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
