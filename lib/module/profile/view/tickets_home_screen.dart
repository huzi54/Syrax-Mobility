import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imo_mobility/core/extensions/app_extensions.dart';
import 'package:imo_mobility/routes/route.dart';
import 'package:imo_mobility/shared/widgets/buttons/app_button.dart';
import 'package:imo_mobility/shared/widgets/my_app_bar.dart';
import 'package:imo_mobility/shared/widgets/text_fields/app_txtfield.dart';

import '../../../core/constants/constants.dart';
import '../../../core/extensions/context_extension.dart';
import '../model/ticket_model.dart';
import '../provider/ticket_provider.dart';
import 'package:imo_mobility/core/localization/locale_provider.dart';
import 'package:imo_mobility/core/localization/app_translations.dart';

class TicketMainScreen extends ConsumerWidget {
  const TicketMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final langCode = ref.watch(localeProvider).languageCode;
    final tickets = ref.watch(supportTicketProvider);
    final langCod = ref.watch(localeProvider).languageCode;

    return Scaffold(
      backgroundColor: AppColors.grayLight,
      appBar: MyAppBar(
        title: AppTranslations.of(context, 'help_support', langCode),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 50.0, left: 20, right: 20),
        child: AppButtons.elevated(
          size: const Size(200, 55),
          text: AppTranslations.of(context, 'generate_ticket', langCode),
          backgroundColor: AppColors.orangePrimary,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const GenerateSupportScreen(),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: tickets.isEmpty
            ? Center(
                child: Text(
                  AppTranslations.of(context, 'no_support_tickets', langCode),
                  style: context.bodyMedium,
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: tickets.length,
                itemBuilder: (context, index) {
                  final t = tickets[index];
                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: AppColors.grayBorder),
                    ),
                    child: ListTile(
                      title: Text(
                        t.category == 'Parcel Tracking Issue'
                            ? AppTranslations.of(
                                context,
                                'parcelTrackingIssue',
                                langCode,
                              )
                            : t.category == 'Payment Failure'
                            ? AppTranslations.of(
                                context,
                                'paymentFailure',
                                langCode,
                              )
                            : '',
                        style: context.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "ID: ${t.ticketId} • ${t.date}",
                        style: context.bodySmall,
                      ),
                      trailing: Text(
                        t.status.name.toUpperCase() == 'PENDING'
                            ? AppTranslations.of(context, 'pending', langCode)
                            : t.status.name.toUpperCase() == 'RESOLVED'
                            ? AppTranslations.of(context, 'resolved', langCode)
                            : '',
                        style: context.bodySmall?.copyWith(
                          color: t.status == TicketStatus.resolved
                              ? Colors.green
                              : AppColors.orangePrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                SupportTicketDetailScreen(ticket: t),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class GenerateSupportScreen extends ConsumerStatefulWidget {
  const GenerateSupportScreen({super.key});
  @override
  ConsumerState<GenerateSupportScreen> createState() =>
      _GenerateSupportScreenState();
}

class _GenerateSupportScreenState extends ConsumerState<GenerateSupportScreen> {
  String? selectedCategory;
  final TextEditingController _messageController = TextEditingController();

  final Map<String, String> categoryKeys = {
    "Parcel Issue": "parcel_issue",
    "Bus Route": "bus_route",
    "Payment": "payment",
    "Other": "other",
  };

  @override
  Widget build(BuildContext context) {
    final langCode = ref.watch(localeProvider).languageCode;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar(
        title: AppTranslations.of(context, 'new_support_request', langCode),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppTranslations.of(context, 'whats_the_issue', langCode),
                style: context.bodyLarge,
              ),
              10.verticalSpace,
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  fillColor: AppColors.grayLight,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: categoryKeys.keys
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          AppTranslations.of(
                            context,
                            categoryKeys[e]!,
                            langCode,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (v) => selectedCategory = v,
                hint: Text(
                  AppTranslations.of(context, 'select_issue', langCode),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                AppTranslations.of(context, 'describe', langCode),
                style: context.bodyLarge,
              ),
              10.verticalSpace,
              Consumer(
                builder: (context, ref, child) {
                  final length = ref.watch(messageLengthProvider);
                  final remaining = ref
                      .read(messageLengthProvider.notifier)
                      .remaining;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 250,
                        child: TextField(
                          controller: _messageController,
                          maxLines: 30,
                          style: context.bodyLarge,
                          maxLength: 250,
                          decoration: InputDecoration(
                            hintText: AppTranslations.of(
                              context,
                              'enter_message',
                              langCode,
                            ),
                            filled: true,
                            fillColor: AppColors.grayLight,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            counterText: "",
                          ),
                          onChanged: (value) {
                            ref
                                .read(messageLengthProvider.notifier)
                                .updateLength(value);
                          },
                        ),
                      ),
                      5.verticalSpace,
                      Text(
                        "$remaining ${AppTranslations.of(context, 'characters_remaining', langCode)}",
                        style: context.bodySmall?.copyWith(
                          color: AppColors.greyColor,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const Spacer(),
              AppButtons.elevated(
                onPressed: () {
                  if (_messageController.text.isEmpty) return;
                  ref
                      .read(supportTicketProvider.notifier)
                      .addTicket(
                        SupportTicketModel(
                          ticketId:
                              "TK-${DateTime.now().millisecondsSinceEpoch}",
                          category:
                              selectedCategory ??
                              AppTranslations.of(context, 'other', langCode),
                          message: _messageController.text,
                          date: "Today",
                          status: TicketStatus.open,
                        ),
                      );
                  Navigator.pop(context);
                },
                text: AppTranslations.of(context, 'submit_ticket', langCode),
                backgroundColor: AppColors.orangePrimary,
                foregroundColor: AppColors.white,
                size: Size(double.infinity, 50),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SupportTicketDetailScreen extends ConsumerWidget {
  final SupportTicketModel ticket;

  const SupportTicketDetailScreen({super.key, required this.ticket});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final langCode = ref.watch(localeProvider).languageCode;
    final isResolved = ticket.status == TicketStatus.resolved;

    return Scaffold(
      backgroundColor: AppColors.grayLight,
      appBar: MyAppBar(
        title: AppTranslations.of(context, 'ticket_details', langCode),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Ticket Info Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.grayBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ID + STATUS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "ID: ${ticket.ticketId}",
                        style: context.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isResolved
                              ? Colors.green.withOpacity(.1)
                              : AppColors.orangePrimary.withOpacity(.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          ticket.status.name.toUpperCase(),
                          style: context.bodySmall?.copyWith(
                            color: isResolved
                                ? Colors.green
                                : AppColors.orangePrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  /// CATEGORY
                  Text(
                    ticket.category,
                    style: context.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),

                  /// DATE
                  Text(ticket.date, style: context.bodySmall),
                ],
              ),
            ),
            const SizedBox(height: 25),

            /// MESSAGE
            Text(
              AppTranslations.of(context, 'your_message', langCode),
              style: context.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.grayBorder),
              ),
              child: Text(ticket.message, style: context.bodyMedium),
            ),
            const SizedBox(height: 25),

            /// SUPPORT RESPONSE (optional)
            if (isResolved) ...[
              Text(
                AppTranslations.of(context, 'support_reply', langCode),
                style: context.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.withOpacity(.2)),
                ),
                child: Text(
                  AppTranslations.of(
                    context,
                    'support_resolved_message',
                    langCode,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
