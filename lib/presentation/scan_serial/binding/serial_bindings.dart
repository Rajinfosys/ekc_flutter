import 'package:get/get.dart';
import 'package:qr_code_scanner/presentation/scan_serial/controller/serial_controller.dart';

class ScanSerialBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ScanSerialController());
  }
}
