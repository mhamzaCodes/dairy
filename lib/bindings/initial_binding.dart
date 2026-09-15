import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/herd_controller.dart';
import '../controllers/khata_controller.dart';
import '../controllers/milk_entry_controller.dart';

/// Initial Global Bindings injecting core controllers
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<MilkEntryController>(MilkEntryController(), permanent: true);
    Get.put<KhataController>(KhataController(), permanent: true);
    Get.put<HerdController>(HerdController(), permanent: true);
  }
}
