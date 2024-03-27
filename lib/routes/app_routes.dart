import 'package:get/get.dart';
import 'package:qr_code_scanner/presentation/attendance/attendance_screen.dart';
import 'package:qr_code_scanner/presentation/attendance/binding/attendance_bindings.dart';
import 'package:qr_code_scanner/presentation/auth/auth_screen.dart';
import 'package:qr_code_scanner/presentation/auth/binding/login_bindings.dart';
import 'package:qr_code_scanner/presentation/auth/splash_screen.dart';
import 'package:qr_code_scanner/presentation/customer_screen/add_customer_screen.dart';
import 'package:qr_code_scanner/presentation/customer_screen/binding/customer_bindings.dart';
import 'package:qr_code_scanner/presentation/customer_screen/list_of_customer_screen.dart';
import 'package:qr_code_scanner/presentation/home_screen/home_page.dart';
import 'package:qr_code_scanner/presentation/outlet_screen/add_outlet_screen.dart';
import 'package:qr_code_scanner/presentation/outlet_screen/binding/outlets_bindings.dart';
import 'package:qr_code_scanner/presentation/outlet_screen/list_of_outlet_screen.dart';
import 'package:qr_code_scanner/presentation/scan_serial/binding/serial_bindings.dart';

import '../presentation/branding_sales/add_branding_screen.dart';
import '../presentation/branding_sales/add_product_screen.dart';
import '../presentation/branding_sales/binding/branding_sales_binding.dart';
import '../presentation/branding_sales/branding_screen.dart';
import '../presentation/branding_sales/product_screen.dart';
import '../presentation/home_screen/binding/homepage_bindings.dart';

import '../presentation/scan_serial/scan_serial.dart';

class AppRoutes {
  static List<GetPage> pages = [
    GetPage(name: SplashScreen.routeName, page: () => const SplashScreen()),
    GetPage(name: LoginView.routeName, page: () => LoginView()),
    GetPage(
        name: ScanSerialView.routeName,
        page: () => ScanSerialView(),
        binding: ScanSerialBinding()),
    GetPage(
        name: AttendanceScreen.routeName,
        page: () => AttendanceScreen(),
        binding: AttendanceBinding()),
    GetPage(
        name: AddCustomerScreen.routeName,
        page: () => AddCustomerScreen(),
        binding: CustomerBinding()),
    GetPage(
        name: ListOfCustomersScreen.routeName,
        page: () => const ListOfCustomersScreen(),
        binding: CustomerBinding()),
    GetPage(
        name: AddOutletScreen.routeName,
        page: () => AddOutletScreen(),
        binding: OutletBinding()),
    GetPage(
        name: ListOfOutletsScreen.routeName,
        page: () => const ListOfOutletsScreen(),
        binding: OutletBinding()),
    GetPage(
        name: HomePage.routeName,
        page: () => const HomePage(),
        binding: HomePageBinding()),
    GetPage(
        name: AddBrandingScreen.routeName,
        page: () => AddBrandingScreen(),
        binding: BrandingSalesBinding()),
    GetPage(
        name: ListOfBrandingScreen.routeName,
        page: () => const ListOfBrandingScreen(),
        binding: BrandingSalesBinding()),
    GetPage(
        name: AddProductScreen.routeName,
        page: () => AddProductScreen(),
        binding: BrandingSalesBinding()),
    GetPage(
        name: ListOfProductScreen.routeName,
        page: () => const ListOfProductScreen(),
        binding: BrandingSalesBinding()),
  ];
}
