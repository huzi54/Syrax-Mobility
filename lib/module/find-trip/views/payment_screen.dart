// Location: lib/features/trips/presentation/screens/card_payment_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imo_mobility/core/constants/constants.dart';
import 'package:imo_mobility/core/extensions/context_extension.dart';
import 'package:imo_mobility/routes/route.dart';
import 'package:imo_mobility/shared/widgets/my_app_bar.dart';
import 'package:imo_mobility/shared/widgets/text_fields/app_txtfield.dart';
import '../../../core/localization/app_translations.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../../book ride/widgets/ticket_card.dart';

class CardPaymentScreen extends ConsumerStatefulWidget {
  final String price;
  const CardPaymentScreen({super.key, required this.price});

  @override
  ConsumerState<CardPaymentScreen> createState() => _CardPaymentScreenState();
}

class _CardPaymentScreenState extends ConsumerState<CardPaymentScreen> {
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Real-time update ke liye listeners add karein
    _cardNumberController.addListener(_updateCard);
    _expiryController.addListener(_updateCard);
    _nameController.addListener(_updateCard);
    _cvvController.addListener(_updateCard);
  }

  void _updateCard() {
    setState(() {
      // Empty, setState triggers rebuild
    });
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(localeProvider).languageCode;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(
        title: AppTranslations.of(context, 'payment_details', lang),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildCreditCard(
                    number: _cardNumberController.text,
                    name: _nameController.text,
                    expiry: _expiryController.text,
                    lang: lang,
                  ),
                  const SizedBox(height: 40),
                  Text(
                    AppTranslations.of(context, 'card_information', lang),
                    style: context.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildLabel(
                    AppTranslations.of(context, 'card_holder_name', lang),
                  ),
                  AppTextFields(
                    controller: _nameController,
                    hintText: AppTranslations.of(context, 'full_name', lang),
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  const SizedBox(height: 20),
                  _buildLabel(AppTranslations.of(context, 'card_number', lang)),
                  AppTextFields(
                    controller: _cardNumberController,
                    hintText: AppTranslations.of(
                      context,
                      'xxxx xxxx xxxx xxxx',
                      lang,
                    ),
                    prefixIcon: const Icon(Icons.credit_card),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(16),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      // Expiry
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel(
                              AppTranslations.of(context, 'expiry_date', lang),
                            ),
                            AppTextFields(
                              controller: _expiryController,
                              hintText: AppTranslations.of(
                                context,
                                'mm/yy',
                                lang,
                              ),
                              prefixIcon: const Icon(
                                Icons.calendar_today_outlined,
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                                CardExpiryFormatter(),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      // CVV
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel(
                              AppTranslations.of(context, 'cvv', lang),
                            ),
                            AppTextFields(
                              controller: _cvvController,
                              hintText: AppTranslations.of(
                                context,
                                'xxx',
                                lang,
                              ),
                              prefixIcon: const Icon(Icons.lock_outline),
                              keyboardType: TextInputType.number,
                              maxLength: 3,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(3),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _buildPayButton(context, lang),
        ],
      ),
    );
  }

  // ------------------------- Helpers -------------------------

  Widget _buildCreditCard({
    required String number,
    required String name,
    required String expiry,
    required String lang,
  }) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.bluePrimary, const Color(0xFF1A1A2E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.bluePrimary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.wifi, color: Colors.white54, size: 24),
              Text(
                "VISA",
                style: context.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          Text(
            formattedCardNumber(number),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              letterSpacing: 2,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _cardBottomInfo(
                AppTranslations.of(context, 'card_holder', lang),
                name.isEmpty ? 'FULL NAME' : name,
              ),
              _cardBottomInfo(
                AppTranslations.of(context, 'expires', lang),
                expiry.isEmpty ? 'MM/YY' : expiry,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String formattedCardNumber(String number) {
    if (number.isEmpty) return 'xxxx xxxx xxxx xxxx';
    final digitsOnly = number.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < digitsOnly.length; i++) {
      buffer.write(digitsOnly[i]);
      if ((i + 1) % 4 == 0 && i != digitsOnly.length - 1) buffer.write(' ');
    }
    return buffer.toString();
  }

  Widget _cardBottomInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 10),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildPayButton(BuildContext context, String lang) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppTranslations.of(context, 'total_payable', lang),
                  style: const TextStyle(color: Colors.grey),
                ),
                Text(
                  "€${widget.price}",
                  style: context.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.bluePrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AppButtons.elevated(
              size: Size(double.infinity, 50),
              onPressed: () => _handlePayment(context, lang),
              text: AppTranslations.of(context, 'pay_securely', lang),
              backgroundColor: AppColors.orangePrimary,
            ),
          ],
        ),
      ),
    );
  }

  void _handlePayment(BuildContext context, String lang) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Colors.orange),
            const SizedBox(height: 20),
            Text(
              AppTranslations.of(context, 'securing_seat', lang),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const BusTicketScreen(
            passengerName: "Jasper McAllister",
            bookingReference: "BUS-FRA-99281",
            departureTime: "09:30 AM",
            arrivalTime: "01:45 PM",
            duration: "4h 15m",
            fromCity: "Paris",
            fromStation: "Bercy Seine",
            toCity: "Lyon",
            toStation: "Lyon Perrache",
            busNumber: "FLX-402",
            busPlate: "FR-922-BK",
            seatNumber: "12A",
            isHome: false,
          ),
        ),
      );
    }
  }
}

// ------------------------- Card Expiry Formatter -------------------------
class CardExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (digitsOnly.length > 4) digitsOnly = digitsOnly.substring(0, 4);

    String formatted = '';
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i == 2) formatted += '/';
      formatted += digitsOnly[i];
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
