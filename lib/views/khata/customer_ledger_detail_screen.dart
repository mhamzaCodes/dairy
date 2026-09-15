import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/khata_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/custom_primary_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../data/models/customer_ledger_model.dart';

/// Detailed Ledger View for a selected customer.
/// Displays running balance metrics, history timeline, Milk Sale & Payment triggers,
/// and WhatsApp statement generator.
class CustomerLedgerDetailScreen extends StatelessWidget {
  final CustomerModel customer;

  const CustomerLedgerDetailScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    final khataController = Get.find<KhataController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          customer.name,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded, color: AppColors.primary),
            tooltip: 'Share WhatsApp Statement',
            onPressed: () => _shareWhatsAppStatement(context, khataController),
          ),
        ],
      ),
      body: Column(
        children: [
          // Running Balance Header Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: AppColors.surface,
            child: Obx(() {
              final activeCust = khataController.customers.firstWhere(
                (c) => c.id == customer.id,
                orElse: () => customer,
              );

              final bool isDue = activeCust.currentBalance > 0;
              final Color balanceColor = isDue ? AppColors.error : AppColors.success;

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activeCust.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            activeCust.phone,
                            style: const TextStyle(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: balanceColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          isDue ? 'Remaining Balance' : 'Account Cleared',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: balanceColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: AppColors.divider),
                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildHeaderMetric(
                        label: AppStrings.totalBought,
                        value: '${AppStrings.currencySymbol} ${activeCust.totalBought.toStringAsFixed(0)}',
                        color: AppColors.textPrimary,
                      ),
                      _buildHeaderMetric(
                        label: AppStrings.totalPaid,
                        value: '${AppStrings.currencySymbol} ${activeCust.totalPaid.toStringAsFixed(0)}',
                        color: AppColors.success,
                      ),
                      _buildHeaderMetric(
                        label: AppStrings.remainingBalance,
                        value: '${AppStrings.currencySymbol} ${activeCust.currentBalance.toStringAsFixed(0)}',
                        color: balanceColor,
                        isBold: true,
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
          const SizedBox(height: 12),

          // Transactions Timeline Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Transaction History',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _shareWhatsAppStatement(context, khataController),
                  icon: const Icon(Icons.send_rounded, size: 16, color: AppColors.primary),
                  label: const Text(
                    'WhatsApp',
                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          // Transactions History Stream List
          Expanded(
            child: Obx(() {
              final history = khataController.selectedCustomerHistory;

              if (history.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.receipt_long_outlined, size: 48, color: AppColors.textMuted),
                      const SizedBox(height: 8),
                      Text(
                        AppStrings.noDataYet,
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: history.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = history[index];
                  final isSale = item.isSale;
                  final Color iconBg = isSale ? AppColors.warningBg : AppColors.successBg;
                  final Color iconColor = isSale ? AppColors.warning : AppColors.success;

                  final dateStr = DateFormat('dd MMM yyyy, h:mm a').format(item.date);

                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: iconBg,
                              child: Icon(
                                isSale ? Icons.local_shipping_rounded : Icons.payments_rounded,
                                color: iconColor,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isSale
                                        ? '${AppStrings.transactionTypeSale} (${item.milkQuantityLiters} L @ Rs. ${item.ratePerLiter.toStringAsFixed(0)})'
                                        : AppStrings.transactionTypePayment,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    dateStr,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${isSale ? "+" : "-"} ${AppStrings.currencySymbol} ${item.amount.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isSale ? AppColors.error : AppColors.success,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Prev: Rs. ${item.previousBalance.toStringAsFixed(0)}',
                              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                            ),
                            Text(
                              'New Balance: Rs. ${item.newBalance.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        if (item.notes != null && item.notes!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Note: ${item.notes}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              );
            }),
          ),

          // Bottom Action Bar ("Record Milk Sale" & "Receive Cash Payment")
          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showRecordMilkSaleModal(context, khataController),
                      icon: const Icon(Icons.add_shopping_cart_rounded),
                      label: const Text(AppStrings.recordMilkSale),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.warning,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showReceivePaymentModal(context, khataController),
                      icon: const Icon(Icons.payments_rounded),
                      label: const Text(AppStrings.recordPaymentReceived),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderMetric({
    required String label,
    required String value,
    required Color color,
    bool isBold = false,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 17 : 15,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  /// Modal to Record Milk Sale to Customer
  void _showRecordMilkSaleModal(BuildContext context, KhataController controller) {
    final formKey = GlobalKey<FormState>();
    final litersCtrl = TextEditingController();
    final rateCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    String selectedShift = 'Morning';
    double totalAmount = 0.0;

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setModalState) {
          void calculate() {
            final l = double.tryParse(litersCtrl.text) ?? 0.0;
            final r = double.tryParse(rateCtrl.text) ?? 0.0;
            setModalState(() {
              totalAmount = l * r;
            });
          }

          return Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '${AppStrings.recordMilkSale} - ${customer.name}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setModalState(() {
                                selectedShift = 'Morning';
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: selectedShift == 'Morning' ? AppColors.warning.withValues(alpha: 0.15) : AppColors.surface,
                                border: Border.all(color: selectedShift == 'Morning' ? AppColors.warning : AppColors.border),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text('Morning ☀️', style: TextStyle(fontWeight: selectedShift == 'Morning' ? FontWeight.bold : FontWeight.normal, color: selectedShift == 'Morning' ? AppColors.warning : AppColors.textPrimary)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setModalState(() {
                                selectedShift = 'Evening';
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: selectedShift == 'Evening' ? AppColors.info.withValues(alpha: 0.15) : AppColors.surface,
                                border: Border.all(color: selectedShift == 'Evening' ? AppColors.info : AppColors.border),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text('Evening 🌙', style: TextStyle(fontWeight: selectedShift == 'Evening' ? FontWeight.bold : FontWeight.normal, color: selectedShift == 'Evening' ? AppColors.info : AppColors.textPrimary)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomTextField.numeric(
                      label: AppStrings.milkQuantity,
                      hint: 'e.g. 10.5',
                      controller: litersCtrl,
                      onChanged: (_) => calculate(),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return AppStrings.fieldRequired;
                        if ((double.tryParse(v) ?? 0) <= 0) return AppStrings.invalidNumber;
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    CustomTextField.numeric(
                      label: AppStrings.ratePerLiter,
                      hint: 'e.g. 180',
                      controller: rateCtrl,
                      onChanged: (_) => calculate(),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return AppStrings.fieldRequired;
                        if ((double.tryParse(v) ?? 0) <= 0) return AppStrings.invalidNumber;
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      label: AppStrings.notesLabel,
                      hint: 'e.g. Evening delivery',
                      controller: notesCtrl,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.warningBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Sale Value:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.warning,
                            ),
                          ),
                          Text(
                            'Rs. ${totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.warning,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Obx(() => CustomPrimaryButton(
                          text: AppStrings.save,
                          backgroundColor: AppColors.warning,
                          isLoading: controller.isLoading.value,
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              final l = double.tryParse(litersCtrl.text) ?? 0.0;
                              final r = double.tryParse(rateCtrl.text) ?? 0.0;
                              final success = await controller.addLedgerTransaction(
                                customerId: customer.id,
                                transactionType: 'sale',
                                amount: totalAmount,
                                milkQuantityLiters: l,
                                ratePerLiter: r,
                                shift: selectedShift,
                                notes: notesCtrl.text,
                              );
                              if (success) {
                                Get.back();
                              }
                            }
                          },
                        )),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }

  /// Modal to Receive Payment from Customer
  void _showReceivePaymentModal(BuildContext context, KhataController controller) {
    final formKey = GlobalKey<FormState>();
    final amountCtrl = TextEditingController();
    final notesCtrl = TextEditingController();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '${AppStrings.recordPaymentReceived} - ${customer.name}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextField.numeric(
                  label: 'Payment Amount (${AppStrings.currencySymbol})',
                  hint: 'e.g. 5000',
                  controller: amountCtrl,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return AppStrings.fieldRequired;
                    if ((double.tryParse(v) ?? 0) <= 0) return AppStrings.invalidNumber;
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  label: AppStrings.notesLabel,
                  hint: 'e.g. Cash received via JazzCash / Hand',
                  controller: notesCtrl,
                ),
                const SizedBox(height: 20),
                Obx(() => CustomPrimaryButton(
                      text: AppStrings.save,
                      backgroundColor: AppColors.success,
                      isLoading: controller.isLoading.value,
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          final amt = double.tryParse(amountCtrl.text) ?? 0.0;
                          final success = await controller.addLedgerTransaction(
                            customerId: customer.id,
                            transactionType: 'payment',
                            amount: amt,
                            notes: notesCtrl.text,
                          );
                          if (success) {
                            Get.back();
                          }
                        }
                      },
                    )),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  /// Formats ledger statement text for WhatsApp sharing
  void _shareWhatsAppStatement(BuildContext context, KhataController controller) {
    final activeCust = controller.customers.firstWhere(
      (c) => c.id == customer.id,
      orElse: () => customer,
    );

    final history = controller.selectedCustomerHistory.take(5).toList();

    StringBuffer sb = StringBuffer();
    sb.writeln('📋 *DAIRY KHATA ACCOUNT STATEMENT*');
    sb.writeln('👤 *Customer:* ${activeCust.name}');
    sb.writeln('📞 *Phone:* ${activeCust.phone}');
    sb.writeln('-----------------------------------');
    sb.writeln('🛒 *Total Milk Bought:* Rs. ${activeCust.totalBought.toStringAsFixed(0)}');
    sb.writeln('💵 *Total Paid Received:* Rs. ${activeCust.totalPaid.toStringAsFixed(0)}');
    sb.writeln('⚠️ *REMAINING DUE BALANCE:* Rs. ${activeCust.currentBalance.toStringAsFixed(0)}');
    sb.writeln('-----------------------------------');
    sb.writeln('📜 *Recent Transactions:*');

    for (var item in history) {
      final dateStr = DateFormat('dd/MM/yyyy').format(item.date);
      if (item.isSale) {
        sb.writeln('• $dateStr: Milk Sale ${item.milkQuantityLiters}L = +Rs. ${item.amount.toStringAsFixed(0)}');
      } else {
        sb.writeln('• $dateStr: Cash Payment = -Rs. ${item.amount.toStringAsFixed(0)}');
      }
    }

    sb.writeln('-----------------------------------');
    sb.writeln('Thank you for your business! 🙏');

    final String statementText = sb.toString();

    Get.defaultDialog(
      title: 'Share Account Statement',
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                statementText,
                style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: statementText));
                      Get.back();
                      Get.snackbar(
                        'Copied to Clipboard',
                        'Statement copied! You can paste it into WhatsApp or SMS.',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppColors.successBg,
                        colorText: AppColors.success,
                      );
                    },
                    icon: const Icon(Icons.copy_rounded),
                    label: const Text('Copy Statement'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
