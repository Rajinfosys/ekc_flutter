import 'package:get/get.dart';
import 'package:qr_code_scanner/presentation/attendance/controller/attendance_controller.dart';

class AttendanceBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(AttendanceController());
  }
}
