import 'package:get/get.dart';
import 'package:qr_code_scanner/presentation/auth/auth_screen.dart';
import 'package:qr_code_scanner/presentation/auth/splash_screen.dart';
import 'package:qr_code_scanner/presentation/home_screen/home_page.dart';
import 'package:qr_code_scanner/presentation/packing_list/binding/packlist_bindings.dart';
import 'package:qr_code_scanner/presentation/scan_serial/binding/serial_bindings.dart';
import '../presentation/home_screen/binding/homepage_bindings.dart';

import '../presentation/scan_serial/scan_serial.dart';
import '../presentation/packing_list/packing_list.dart';

class AppRoutes {
  static List<GetPage> pages = [
    GetPage(name: SplashScreen.routeName, page: () => const SplashScreen()),
    GetPage(name: LoginView.routeName, page: () => LoginView()),
    GetPage(
        name: ScanSerialView.routeName,
        page: () => ScanSerialView(),
        binding: ScanSerialBinding()),
    GetPage(
        name: PackListView.routeName,
        page: () => PackListView(),
        binding: PacklistBinding()),
    GetPage(
        name: HomePage.routeName,
        page: () => const HomePage(),
        binding: HomePageBinding()),
  ];
}
