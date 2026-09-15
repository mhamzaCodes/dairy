import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/milk_entry_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/custom_primary_button.dart';
import '../../core/widgets/custom_text_field.dart';

/// Screen for recording daily milk production entries with reactive total calculation.
class AddMilkEntryScreen extends StatefulWidget {
  const AddMilkEntryScreen({super.key});

  @override
  State<AddMilkEntryScreen> createState() => _AddMilkEntryScreenState();
}

class _AddMilkEntryScreenState extends State<AddMilkEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  late final MilkEntryController _controller;

  final TextEditingController _litersController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = Get.find<MilkEntryController>();
    _controller.resetForm();
  }

  @override
  void dispose() {
    _litersController.dispose();
    _rateController.dispose();
    _fatController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          AppStrings.addMilkEntry,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shift Selection Header
              const Text(
                'Shift Selection',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),

              // Segmented Shift Toggle Buttons (Morning vs. Evening)
              Obx(() => Row(
                    children: [
                      Expanded(
                        child: _buildShiftOption(
                          label: 'Morning Shift',
                          value: 'Morning',
                          icon: Icons.wb_sunny_rounded,
                          activeColor: AppColors.warning,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildShiftOption(
                          label: 'Evening Shift',
                          value: 'Evening',
                          icon: Icons.nightlight_round,
                          activeColor: AppColors.info,
                        ),
                      ),
                    ],
                  )),
              const SizedBox(height: 20),

              // Date Selector Button
              const Text(
                'Collection Date',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Obx(() => InkWell(
                    onTap: () => _selectDate(context),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.border, width: 1.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('EEEE, d MMMM yyyy').format(_controller.entryDate.value),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const Icon(Icons.calendar_today_rounded, color: AppColors.primary),
                        ],
                      ),
                    ),
                  )),
              const SizedBox(height: 20),

              // Liters Input Field
              CustomTextField.numeric(
                label: 'Milk Quantity (${AppStrings.unitLiters})',
                hint: 'e.g. 50.0',
                controller: _litersController,
                prefixIcon: const Icon(Icons.water_drop_outlined, color: AppColors.primary),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return AppStrings.fieldRequired;
                  final num = double.tryParse(val);
                  if (num == null || num <= 0) return AppStrings.invalidNumber;
                  return null;
                },
                onChanged: (val) {
                  _controller.quantityLiters.value = double.tryParse(val) ?? 0.0;
                },
              ),
              const SizedBox(height: 16),

              // Rate per Liter Input Field
              CustomTextField.numeric(
                label: 'Price / Rate per Liter (${AppStrings.currencySymbol})',
                hint: 'e.g. 180',
                controller: _rateController,
                prefixIcon: const Icon(Icons.payments_outlined, color: AppColors.primary),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return AppStrings.fieldRequired;
                  final num = double.tryParse(val);
                  if (num == null || num <= 0) return AppStrings.invalidNumber;
                  return null;
                },
                onChanged: (val) {
                  _controller.pricePerLiter.value = double.tryParse(val) ?? 0.0;
                },
              ),
              const SizedBox(height: 16),

              // FAT Percentage (Optional) Input Field
              CustomTextField.numeric(
                label: 'FAT Content (%) ${AppStrings.optional}',
                hint: 'e.g. 5.5',
                controller: _fatController,
                prefixIcon: const Icon(Icons.percent_rounded, color: AppColors.textSecondary),
                onChanged: (val) {
                  _controller.fatPercentage.value = double.tryParse(val) ?? 0.0;
                },
              ),
              const SizedBox(height: 16),

              // Notes Input Field
              CustomTextField(
                label: '${AppStrings.notesLabel} ${AppStrings.optional}',
                hint: 'Add any notes...',
                controller: _notesController,
                prefixIcon: const Icon(Icons.notes_rounded, color: AppColors.textSecondary),
                maxLines: 2,
              ),
              const SizedBox(height: 24),

              // Reactive Summary Card displaying total price using Obx
              Obx(() => Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.primaryAccent),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Estimated Revenue:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryDark,
                          ),
                        ),
                        Text(
                          '${AppStrings.currencySymbol} ${_controller.totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 24),

              // Large Submit Primary Button
              Obx(() => CustomPrimaryButton(
                    text: AppStrings.save,
                    icon: Icons.check_circle_rounded,
                    isLoading: _controller.isLoading.value,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final success = await _controller.addMilkEntry(
                          notes: _notesController.text,
                        );
                        if (success) {
                          _litersController.clear();
                          _rateController.clear();
                          _fatController.clear();
                          _notesController.clear();
                          Get.back();
                        }
                      }
                    },
                  )),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// Shift toggle option builder
  Widget _buildShiftOption({
    required String label,
    required String value,
    required IconData icon,
    required Color activeColor,
  }) {
    final isSelected = _controller.selectedShift.value == value;

    return Material(
      color: isSelected ? activeColor.withValues(alpha: 0.15) : AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          _controller.selectedShift.value = value;
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? activeColor : AppColors.border,
              width: isSelected ? 2.0 : 1.0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? activeColor : AppColors.textSecondary,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? activeColor : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _controller.entryDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      _controller.entryDate.value = picked;
    }
  }
}
