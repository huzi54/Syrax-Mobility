// Location: lib/features/track-parcel/view/track_parcel_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:imo_mobility/core/constants/constants.dart';
import 'package:imo_mobility/core/extensions/context_extension.dart';
import 'package:imo_mobility/module/track-parcel/view/parcel_detail_screen.dart';
import 'package:imo_mobility/routes/route.dart';
import 'package:imo_mobility/shared/widgets/my_app_bar.dart';
import 'package:imo_mobility/shared/widgets/text_fields/app_txtfield.dart';

import '../../../core/extensions/app_extensions.dart';
import '../../../core/localization/app_translations.dart';
import '../../../core/localization/locale_provider.dart';

/// 🔹 Search text provider
final parcelSearchProvider = StateProvider<String>((ref) => "");

class TrackParcelScreen extends ConsumerStatefulWidget {
  final TextEditingController? controller;

  const TrackParcelScreen({super.key, this.controller});

  @override
  ConsumerState<TrackParcelScreen> createState() => _TrackParcelScreenState();
}

class _TrackParcelScreenState extends ConsumerState<TrackParcelScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _searchController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final parcels = ref.watch(parcelListProvider(context));
    // final parcels = ref.watch(parcelListProvider);
    final searchQuery = ref.watch(parcelSearchProvider).toLowerCase();

    final filteredParcels = parcels.where((parcel) {
      return parcel.trackingId.toLowerCase().contains(searchQuery) ||
          parcel.destination.toLowerCase().contains(searchQuery);
    }).toList();
    final lang = ref.watch(localeProvider).languageCode;

    return Scaffold(
      appBar: MyAppBar(
        title: AppTranslations.of(context, 'my_parcels', lang),
        titleColor: AppColors.white,
        showBackButton: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            /// 🔹 Search Bar
            AppTextFields(
              controller: _searchController,
              hintText: AppTranslations.of(
                context,
                'search_by_id_or_destination',
                lang,
              ),
              onChanged: (val) {
                ref.read(parcelSearchProvider.notifier).state = val;
              },
              prefixIcon: const Icon(Icons.search),
            ),
            16.verticalSpace,

            /// 🔹 Parcel List
            Expanded(
              child: filteredParcels.isEmpty
                  ? Center(
                      child: Text(
                        AppTranslations.of(context, 'no_parcels_found', lang),
                        style: context.bodyMedium,
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredParcels.length,
                      itemBuilder: (context, index) {
                        final parcel = filteredParcels[index];
                        return _buildParcelCard(parcel, context, lang);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParcelCard(
    ParcelModel parcel,
    BuildContext context,
    String lang,
  ) {
    Color topRightColor;
    IconData topRightIcon;
    switch (parcel.status) {
      case ParcelStatus.delivered:
        topRightColor = Colors.green;
        topRightIcon = Icons.check;
        break;
      case ParcelStatus.inTransit:
        topRightColor = Colors.blue;
        topRightIcon = Icons.local_shipping;
        break;
      case ParcelStatus.pending:
        topRightColor = Colors.orange;
        topRightIcon = Icons.access_time;
        break;
      case ParcelStatus.cancelled:
        topRightColor = Colors.red;
        topRightIcon = Icons.cancel;
        break;
    }

    return GestureDetector(
      onTap: () => AppNavigation.push(
        ParcelTrackingScreen(trackingId: parcel.trackingId),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.white.withOpacity(0.5),
                border: Border.all(
                  color: AppColors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔹 Top Row: Tracking ID + Status + View Details
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: topRightColor,
                            ),
                            child: Icon(topRightIcon, color: AppColors.white),
                          ),
                          5.horizontalSpace,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ⭐ Tracking ID, flexible
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  parcel.trackingId,
                                  style: context.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _getStatusText(parcel.status, lang),
                                  style: context.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: topRightColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.orangePrimary,
                            width: .5,
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Row(
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                AppTranslations.of(
                                  context,
                                  'view_details',
                                  lang,
                                ),
                                style: context.bodyExtraSmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.parcelBtnColor,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: AppColors.parcelBtnColor,
                              size: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  5.verticalSpace,

                  /// 🔹 Bottom Row: Date + From → Destination
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.grayBorder.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(Icons.date_range, size: 16),
                              5.horizontalSpace,
                              Text(
                                parcel.date,
                                style: context.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              10.horizontalSpace,
                            ],
                          ),
                        ),

                        // ⭐ Location row
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 16,
                                color: AppColors.orangePrimary,
                              ),
                              5.horizontalSpace,

                              /// FROM
                              Expanded(
                                child: Text(
                                  parcel.from,
                                  style: context.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                              4.horizontalSpace,
                              const Icon(Icons.arrow_forward, size: 15),
                              4.horizontalSpace,

                              const Icon(
                                Icons.location_on_outlined,
                                size: 16,
                                color: AppColors.greenColor,
                              ),
                              5.horizontalSpace,

                              /// DESTINATION
                              Expanded(
                                child: Text(
                                  parcel.destination,
                                  style: context.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getStatusText(ParcelStatus status, String lang) {
    switch (status) {
      case ParcelStatus.delivered:
        return AppTranslations.of(context, 'delivered', lang);
      case ParcelStatus.inTransit:
        return AppTranslations.of(context, 'in_transit', lang);
      case ParcelStatus.pending:
        return AppTranslations.of(context, 'pending', lang);
      case ParcelStatus.cancelled:
        return AppTranslations.of(context, 'cancelled', lang);
    }
  }
}

// Parcel Model & Status
enum ParcelStatus { inTransit, delivered, pending, cancelled }

class ParcelModel {
  final String trackingId;
  final String destination;
  final String from;
  final String date;
  final ParcelStatus status;

  ParcelModel({
    required this.trackingId,
    required this.destination,
    required this.date,
    required this.status,
    required this.from,
  });
}

final parcelListProvider = Provider.family<List<ParcelModel>, BuildContext>((
  ref,
  context,
) {
  final langCode = ref.watch(localeProvider).languageCode;

  return [
    ParcelModel(
      trackingId: "SIRAX-7821-XP",
      destination: "Paris",
      from: 'Lyon',
      date:
          "${AppTranslations.of(context, 'march', langCode).substring(0, 3)} 12, 2023",
      status: ParcelStatus.inTransit,
    ),
    ParcelModel(
      trackingId: "SIRAX-9912-LQ",
      destination: "Lyon",
      from: 'Paris',
      date:
          "${AppTranslations.of(context, 'march', langCode).substring(0, 3)} 10, 2023",
      status: ParcelStatus.delivered,
    ),
    ParcelModel(
      trackingId: "SIRAX-4451-ZW",
      destination: "Nice",
      from: 'Lyon',
      date:
          "${AppTranslations.of(context, 'march', langCode).substring(0, 3)} 08, 2023",
      status: ParcelStatus.pending,
    ),
    ParcelModel(
      trackingId: "SIRAX-1120-BA",
      destination: "Nice",
      from: 'Lyon',
      date:
          "${AppTranslations.of(context, 'march', langCode).substring(0, 3)} 05, 2023",
      status: ParcelStatus.cancelled,
    ),
  ];
});
// ENGLISH
// 'my_parcels': 'My Parcels',
// 'search_by_id_or_destination': 'Search by ID or Destination',
// 'no_parcels_found': 'No parcels found',
// 'view_details': 'View Details',
// 'delivered': 'Delivered',
// 'in_transit': 'In Transit',
// 'pending': 'Pending',
// 'cancelled': 'Cancelled',

// FRENCH
// 'my_parcels': 'Mes Colis',
// 'search_by_id_or_destination': 'Rechercher par ID ou destination',
// 'no_parcels_found': 'Aucun colis trouvé',
// 'view_details': 'Voir les détails',
// 'delivered': 'Livré',
// 'in_transit': 'En transit',
// 'pending': 'En attente',
// 'cancelled': 'Annulé'
