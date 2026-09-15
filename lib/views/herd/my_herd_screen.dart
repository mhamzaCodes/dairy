import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/herd_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import 'add_cattle_screen.dart';

/// My Herd Asset Tracking View displaying cattle list, breed tags, yield, and lineage
class MyHerdScreen extends StatefulWidget {
  const MyHerdScreen({super.key});

  @override
  State<MyHerdScreen> createState() => _MyHerdScreenState();
}

class _MyHerdScreenState extends State<MyHerdScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
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
        title: const Text(
          AppStrings.herdHeader,
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
            // Total Herd Summary Metric Card
            Obx(() {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMetricCol('Total Animals', '${herdController.totalCattleCount}', AppColors.primary),
                    _buildMetricCol('Cows 🐄', '${herdController.totalCowsCount}', AppColors.primaryDark),
                    _buildMetricCol('Buffaloes 🐃', '${herdController.totalBuffaloesCount}', AppColors.secondaryDark),
                    _buildMetricCol('Daily Yield Cap.', '${herdController.totalDailyCapacity.toStringAsFixed(0)}L', AppColors.warning),
                  ],
                ),
              );
            }),
            const SizedBox(height: 16),

            // Search & Species Filter Chips
            TextField(
              controller: _searchController,
              onChanged: (val) {
                herdController.searchQuery.value = val;
              },
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search Tag ID or Breed...',
                hintStyle: const TextStyle(color: AppColors.textMuted),
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
                suffixIcon: Obx(() => herdController.searchQuery.value.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, color: AppColors.textMuted),
                        onPressed: () {
                          _searchController.clear();
                          herdController.searchQuery.value = '';
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
            const SizedBox(height: 12),

            // Filter Chips
            Obx(() => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildChip(herdController, 'All Animals', 'All'),
                      const SizedBox(width: 8),
                      _buildChip(herdController, 'Cows 🐄', 'Cow'),
                      const SizedBox(width: 8),
                      _buildChip(herdController, 'Buffaloes 🐃', 'Buffalo'),
                    ],
                  ),
                )),
            const SizedBox(height: 16),

            // Cattle List
            Expanded(
              child: Obx(() {
                final cattleList = herdController.filteredCattleList;

                if (cattleList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.pets_rounded, size: 54, color: AppColors.textMuted),
                        const SizedBox(height: 12),
                        const Text(
                          'No cattle registered yet.',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => Get.to(() => const AddCattleScreen()),
                          icon: const Icon(Icons.add_rounded),
                          label: const Text(AppStrings.addAnimal),
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
                  itemCount: cattleList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final animal = cattleList[index];
                    final isCow = animal.isCow;
                    final iconBg = isCow ? AppColors.primaryLight : AppColors.secondaryLight;
                    final iconColor = isCow ? AppColors.primary : AppColors.secondaryDark;

                    return Container(
                      padding: const EdgeInsets.all(16),
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
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: iconBg,
                            child: Icon(
                              isCow ? Icons.pets_rounded : Icons.water_drop_rounded,
                              color: iconColor,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      animal.tagId,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: iconBg,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        animal.type,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: iconColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Breed: ${animal.breed}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                if (animal.motherTagId != null && animal.motherTagId!.isNotEmpty) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    'Mother Tag: ${animal.motherTagId}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textMuted,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '~${animal.averageYield.toStringAsFixed(0)} L/day',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 20),
                                onPressed: () {
                                  _confirmDelete(context, herdController, animal.id, animal.tagId);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'herd_fab',
        onPressed: () => Get.to(() => const AddCattleScreen()),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text(AppStrings.addAnimal, style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildMetricCol(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildChip(HerdController controller, String label, String value) {
    final isSelected = controller.selectedTypeFilter.value == value;

    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected ? Colors.white : AppColors.textPrimary,
        ),
      ),
      selected: isSelected,
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.surface,
      side: BorderSide(
        color: isSelected ? AppColors.primary : AppColors.border,
      ),
      onSelected: (selected) {
        if (selected) {
          controller.selectedTypeFilter.value = value;
        }
      },
    );
  }

  void _confirmDelete(BuildContext context, HerdController controller, String id, String tagId) {
    Get.defaultDialog(
      title: 'Delete Animal Record',
      middleText: 'Are you sure you want to remove animal $tagId from your herd inventory?',
      textConfirm: AppStrings.delete,
      textCancel: AppStrings.cancel,
      confirmTextColor: Colors.white,
      buttonColor: AppColors.error,
      onConfirm: () async {
        Get.back();
        await controller.deleteCattle(id);
      },
    );
  }
}
