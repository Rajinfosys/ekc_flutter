import 'package:ekc_scan/presentation/packing_list/partial_packing_list.dart';
import 'package:ekc_scan/presentation/qrscanner/binding/qr_scanner_bindings.dart';
import 'package:get/get.dart';
import 'package:ekc_scan/presentation/auth/auth_screen.dart';
import 'package:ekc_scan/presentation/auth/splash_screen.dart';
import 'package:ekc_scan/presentation/home_screen/home_page.dart';
import 'package:ekc_scan/presentation/packing_list/binding/packlist_bindings.dart';
import 'package:ekc_scan/presentation/scan_serial/binding/serial_bindings.dart';
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
        bindings: [
          ScanSerialBinding(),
          QRScannerBindings()
        ]),
    GetPage(
        name: PackListView.routeName,
        page: () => PackListView(),
        bindings: [PacklistBinding(),QRScannerBindings()]),
    GetPage(
        name: HomePage.routeName,
        page: () => const HomePage(),
        binding: HomePageBinding()),
    GetPage(
        name: PartialPackListView.routeName,
        page: () => PartialPackListView(),
        binding: PacklistBinding()),
    // GetPage(
    //     name: QrScannerScreen.routeName,
    //     page: () => QrScannerScreen(),
    //     binding: QRScannerBindings()),
  ];
}
