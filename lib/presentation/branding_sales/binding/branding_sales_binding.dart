import 'package:get/get.dart';

import '../controller/branding_sales_controller.dart';

class BrandingSalesBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(BrandingSalesController());
  }
}
