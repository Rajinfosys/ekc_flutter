import 'dart:async';

import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerController extends GetxController{
  static QRScannerController get instance => Get.find<QRScannerController>();
  final MobileScannerController scannerController = MobileScannerController();
  var isFlashOn = false.obs;
  RxDouble linePosition = 0.0.obs;
  var scannedResult = ''.obs;



  void toggleFlashlight() {
    isFlashOn.value = !isFlashOn.value;
    scannerController.toggleTorch();
  }

  void switchCamera() {
    scannerController.switchCamera();
  }

  void animateLine(double boxSize) {
    // Animate line movement within the box size
    linePosition.value = 0;
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 10));
      linePosition.value += 2;
      if (linePosition.value > boxSize) linePosition.value = 0;
      return true;
    });
  }

  @override
  void onClose() {
    scannerController.dispose();
    super.onClose();
  }
}

