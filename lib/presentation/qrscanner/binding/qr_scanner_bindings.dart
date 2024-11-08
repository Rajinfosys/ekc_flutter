import 'package:get/get.dart';

import '../controller/qr_scanner_controller.dart';

class QRScannerBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => QRScannerController());
  }
}