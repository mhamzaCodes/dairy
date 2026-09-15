import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/herd_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/custom_primary_button.dart';
import '../../core/widgets/custom_text_field.dart';

/// Form screen for registering a new animal (Cow or Buffalo) into Herd Management
class AddCattleScreen extends StatefulWidget {
  const AddCattleScreen({super.key});

  @override
  State<AddCattleScreen> createState() => _AddCattleScreenState();
}

class _AddCattleScreenState extends State<AddCattleScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _tagIdController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _yieldController = TextEditingController();
  final TextEditingController _motherTagController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String _selectedType = 'Cow'; // 'Cow' or 'Buffalo'
  DateTime? _purchaseDate;

  @override
  void dispose() {
    _tagIdController.dispose();
    _breedController.dispose();
    _yieldController.dispose();
    _motherTagController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final herdController = Get.find<HerdController>();

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
          AppStrings.addAnimal,
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
              // Species Type Selection Toggle (Cow vs Buffalo)
              const Text(
                AppStrings.animalType,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: _buildTypeOption(
                      label: '${AppStrings.cow} 🐄',
                      value: 'Cow',
                      activeColor: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTypeOption(
                      label: '${AppStrings.buffalo} 🐃',
                      value: 'Buffalo',
                      activeColor: AppColors.secondaryDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Ear Tag ID Input
              CustomTextField(
                label: AppStrings.tagIdLabel,
                hint: AppStrings.tagIdHint,
                controller: _tagIdController,
                prefixIcon: const Icon(Icons.qr_code_rounded, color: AppColors.primary),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return AppStrings.fieldRequired;
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Breed Input
              CustomTextField(
                label: AppStrings.animalBreed,
                hint: 'e.g. Sahiwal / Nili-Ravi / Holstein',
                controller: _breedController,
                prefixIcon: const Icon(Icons.category_rounded, color: AppColors.primary),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return AppStrings.fieldRequired;
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Average Daily Yield Input
              CustomTextField.numeric(
                label: AppStrings.averageYield,
                hint: 'e.g. 15.0',
                controller: _yieldController,
                prefixIcon: const Icon(Icons.water_drop_rounded, color: AppColors.primary),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return AppStrings.fieldRequired;
                  final num = double.tryParse(val);
                  if (num == null || num < 0) return AppStrings.invalidNumber;
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Mother's Tag ID Input (Lineage tracking)
              CustomTextField(
                label: "Mother's Tag ID ${AppStrings.optional}",
                hint: 'e.g. COW-005 (For lineage tracking)',
                controller: _motherTagController,
                prefixIcon: const Icon(Icons.family_restroom_rounded, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),

              // Purchase Date Selector
              const Text(
                AppStrings.purchaseDate,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              InkWell(
                onTap: () => _selectPurchaseDate(context),
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
                        _purchaseDate != null
                            ? DateFormat('dd MMMM yyyy').format(_purchaseDate!)
                            : 'Select Purchase Date (Optional)',
                        style: TextStyle(
                          fontSize: 15,
                          color: _purchaseDate != null
                              ? AppColors.textPrimary
                              : AppColors.textMuted,
                        ),
                      ),
                      const Icon(Icons.calendar_month_rounded, color: AppColors.primary),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Notes Input Field
              CustomTextField(
                label: '${AppStrings.notesLabel} ${AppStrings.optional}',
                hint: 'Vaccination history, health status, or lineage notes...',
                controller: _notesController,
                maxLines: 2,
              ),
              const SizedBox(height: 28),

              // Submit Primary Button
              Obx(() => CustomPrimaryButton(
                    text: AppStrings.save,
                    icon: Icons.check_circle_rounded,
                    isLoading: herdController.isLoading.value,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final y = double.tryParse(_yieldController.text) ?? 0.0;
                        final success = await herdController.registerCattle(
                          tagId: _tagIdController.text,
                          type: _selectedType,
                          breed: _breedController.text,
                          averageYield: y,
                          motherTagId: _motherTagController.text,
                          purchaseDate: _purchaseDate,
                          notes: _notesController.text,
                        );
                        if (success) {
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

  Widget _buildTypeOption({
    required String label,
    required String value,
    required Color activeColor,
  }) {
    final isSelected = _selectedType == value;

    return Material(
      color: isSelected ? activeColor.withValues(alpha: 0.15) : AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedType = value;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? activeColor : AppColors.border,
              width: isSelected ? 2.0 : 1.0,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? activeColor : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectPurchaseDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _purchaseDate = picked;
      });
    }
  }
}
