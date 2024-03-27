import 'package:qr_code_scanner/presentation/outlet_screen/controller/outlet_controller.dart';
import 'package:get/get.dart';

class OutletBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OutletController());
  }
}
