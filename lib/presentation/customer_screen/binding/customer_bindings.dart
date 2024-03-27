import 'package:qr_code_scanner/presentation/customer_screen/controller/customer_controller.dart';
import 'package:get/get.dart';

class CustomerBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(CustomerController());
  }
}
