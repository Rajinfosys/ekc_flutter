import 'package:get/get.dart';
import 'package:qr_code_scanner/presentation/packing_list/controller/packlist_controller.dart';
import 'package:qr_code_scanner/presentation/scan_serial/controller/serial_controller.dart';

class PacklistBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PacklistController());
  }
}
