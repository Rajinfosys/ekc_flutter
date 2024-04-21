import 'package:get/get.dart';
import 'package:ekc_scan/presentation/packing_list/controller/packlist_controller.dart';
import 'package:ekc_scan/presentation/scan_serial/controller/serial_controller.dart';

class PacklistBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PacklistController());
  }
}
