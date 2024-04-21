import 'package:get/get.dart';
import 'package:ekc_scan/presentation/scan_serial/controller/serial_controller.dart';

class ScanSerialBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ScanSerialController());
  }
}
