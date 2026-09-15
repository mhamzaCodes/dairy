import 'package:get/get.dart';
import '../bindings/initial_binding.dart';
import '../views/auth/login_screen.dart';
import '../views/auth/register_screen.dart';
import '../views/dashboard/dashboard_screen.dart';
import '../views/encyclopedia/breed_encyclopedia_screen.dart';
import '../views/herd/add_cattle_screen.dart';
import '../views/herd/my_herd_screen.dart';
import '../views/khata/customer_khata_screen.dart';
import '../views/main_navigation_screen.dart';
import '../views/milk/add_milk_entry_screen.dart';
import 'app_routes.dart';

/// GetX Route Definitions mapping routes to views and bindings
class AppPages {
  AppPages._();

  static const INITIAL = AppRoutes.MAIN;

  static final routes = [
    GetPage(
      name: AppRoutes.MAIN,
      page: () => const MainNavigationScreen(),
      binding: InitialBinding(),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.REGISTER,
      page: () => const RegisterScreen(),
    ),
    GetPage(
      name: AppRoutes.DASHBOARD,
      page: () => const DashboardScreen(),
    ),
    GetPage(
      name: AppRoutes.KHATA,
      page: () => const CustomerKhataScreen(),
    ),
    GetPage(
      name: AppRoutes.HERD,
      page: () => const MyHerdScreen(),
    ),
    GetPage(
      name: AppRoutes.ADD_CATTLE,
      page: () => const AddCattleScreen(),
    ),
    GetPage(
      name: AppRoutes.ADD_MILK,
      page: () => const AddMilkEntryScreen(),
    ),
    GetPage(
      name: AppRoutes.ENCYCLOPEDIA,
      page: () => const BreedEncyclopediaScreen(),
    ),
  ];
}
