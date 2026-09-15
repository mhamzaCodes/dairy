import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/custom_primary_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../routes/app_routes.dart';

/// Registration Screen for Dairy Farmers
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _farmNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _farmNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

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
          AppStrings.registerTitle,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  AppStrings.registerSubtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),

                // Full Name Input
                CustomTextField(
                  label: AppStrings.fullNameLabel,
                  hint: AppStrings.fullNameHint,
                  controller: _nameController,
                  prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.primary),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return AppStrings.fieldRequired;
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Farm Name Input
                CustomTextField(
                  label: AppStrings.farmNameLabel,
                  hint: AppStrings.farmNameHint,
                  controller: _farmNameController,
                  prefixIcon: const Icon(Icons.agriculture_rounded, color: AppColors.primary),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return AppStrings.fieldRequired;
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Phone Number Input
                CustomTextField.numeric(
                  label: AppStrings.phoneLabel,
                  hint: AppStrings.phoneHint,
                  controller: _phoneController,
                  allowDecimal: false,
                  prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.primary),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return AppStrings.fieldRequired;
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Email Input
                CustomTextField(
                  label: AppStrings.emailLabel,
                  hint: AppStrings.emailHint,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined, color: AppColors.primary),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return AppStrings.fieldRequired;
                    if (!GetUtils.isEmail(val.trim())) return AppStrings.invalidEmail;
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password Input
                CustomTextField(
                  label: AppStrings.passwordLabel,
                  hint: AppStrings.passwordHint,
                  controller: _passwordController,
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.primary),
                  validator: (val) {
                    if (val == null || val.isEmpty) return AppStrings.fieldRequired;
                    if (val.length < 6) return AppStrings.passwordTooShort;
                    return null;
                  },
                ),
                const SizedBox(height: 28),

                // Register Submit Primary Button
                Obx(() => CustomPrimaryButton(
                      text: AppStrings.registerButton,
                      icon: Icons.how_to_reg_rounded,
                      isLoading: authController.isLoading.value,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final success = await authController.register(
                            email: _emailController.text,
                            password: _passwordController.text,
                            name: _nameController.text,
                            farmName: _farmNameController.text,
                            phoneNumber: _phoneController.text,
                          );
                          if (success) {
                            _nameController.clear();
                            _farmNameController.clear();
                            _phoneController.clear();
                            _emailController.clear();
                            _passwordController.clear();
                            Get.offAllNamed(AppRoutes.MAIN);
                          }
                        }
                      },
                    )),
                const SizedBox(height: 20),

                // Back to Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.alreadyHaveAccount,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
