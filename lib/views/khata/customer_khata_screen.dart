import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/khata_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/custom_primary_button.dart';
import '../../core/widgets/custom_text_field.dart';
import 'customer_ledger_detail_screen.dart';

/// Customer Khata Ledger View displaying customers list, balances, and addition modal
class CustomerKhataScreen extends StatefulWidget {
  const CustomerKhataScreen({super.key});

  @override
  State<CustomerKhataScreen> createState() => _CustomerKhataScreenState();
}

class _CustomerKhataScreenState extends State<CustomerKhataScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final khataController = Get.find<KhataController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          AppStrings.khataHeader,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Total Outstanding Balance Summary Banner
            Obx(() {
              final totalOutstanding = khataController.totalOutstandingBalance;
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Total Amount to Receive',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${AppStrings.currencySymbol} ${totalOutstanding.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.error,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '(Total owed by all buyers)',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 16),

            // Customer Search Input Field
            TextField(
              controller: _searchController,
              onChanged: (val) {
                khataController.searchQuery.value = val;
              },
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search customer name or phone...',
                hintStyle: const TextStyle(color: AppColors.textMuted),
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
                suffixIcon: Obx(() => khataController.searchQuery.value.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, color: AppColors.textMuted),
                        onPressed: () {
                          _searchController.clear();
                          khataController.searchQuery.value = '';
                        },
                      )
                    : const SizedBox.shrink()),
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Customers Stream List
            Expanded(
              child: Obx(() {
                final customerList = khataController.filteredCustomers;

                if (customerList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.menu_book_rounded, size: 54, color: AppColors.textMuted),
                        const SizedBox(height: 12),
                        const Text(
                          'No customer ledger entries found.',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => _showAddCustomerModal(context, khataController),
                          icon: const Icon(Icons.person_add_rounded),
                          label: const Text(AppStrings.addCustomer),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: customerList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final customer = customerList[index];
                    final bool hasOutstanding = customer.currentBalance > 0;
                    final Color statusColor =
                        hasOutstanding ? AppColors.error : AppColors.success;

                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.shadow,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        onTap: () {
                          khataController.activeCustomer.value = customer;
                          khataController.bindCustomerHistory(customer.id);
                          Get.to(() => CustomerLedgerDetailScreen(customer: customer));
                        },
                        leading: CircleAvatar(
                          radius: 24,
                          backgroundColor: statusColor.withValues(alpha: 0.15),
                          child: Text(
                            customer.name.isNotEmpty ? customer.name[0].toUpperCase() : 'C',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: statusColor,
                            ),
                          ),
                        ),
                        title: Text(
                          customer.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        subtitle: Text(
                          customer.phone,
                          style: const TextStyle(color: AppColors.textSecondary),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${AppStrings.currencySymbol} ${customer.currentBalance.abs().toStringAsFixed(0)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: statusColor,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                hasOutstanding ? 'Due' : 'Cleared',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: statusColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      )
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'khata_fab',
        onPressed: () => _showAddCustomerModal(context, khataController),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add_rounded),
        label: const Text(AppStrings.addCustomer, style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  /// Modal Bottom Sheet to add a new customer
  void _showAddCustomerModal(BuildContext context, KhataController controller) {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final addressCtrl = TextEditingController();
    final initialBalanceCtrl = TextEditingController();

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
                const Text(
                  AppStrings.addCustomer,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: AppStrings.customerName,
                  hint: 'e.g. Malik Usman',
                  controller: nameCtrl,
                  validator: (v) => v == null || v.trim().isEmpty ? AppStrings.fieldRequired : null,
                ),
                const SizedBox(height: 12),
                CustomTextField.numeric(
                  label: AppStrings.customerPhone,
                  hint: 'e.g. 03001234567',
                  controller: phoneCtrl,
                  allowDecimal: false,
                  validator: (v) => v == null || v.trim().isEmpty ? AppStrings.fieldRequired : null,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  label: AppStrings.customerAddress,
                  hint: 'e.g. Village Chak 42',
                  controller: addressCtrl,
                ),
                const SizedBox(height: 12),
                CustomTextField.numeric(
                  label: 'Initial Previous Balance (${AppStrings.currencySymbol}) ${AppStrings.optional}',
                  hint: 'e.g. 0',
                  controller: initialBalanceCtrl,
                ),
                const SizedBox(height: 20),
                Obx(() => CustomPrimaryButton(
                      text: AppStrings.save,
                      isLoading: controller.isLoading.value,
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          final initialBal = double.tryParse(initialBalanceCtrl.text) ?? 0.0;
                          final success = await controller.addCustomer(
                            name: nameCtrl.text,
                            phone: phoneCtrl.text,
                            address: addressCtrl.text,
                            initialBalance: initialBal,
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
}
