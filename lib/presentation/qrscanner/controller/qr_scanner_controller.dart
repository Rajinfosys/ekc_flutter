import 'dart:async';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../core/utils/log_util.dart';
import '../../../service/http_service.dart';
import '../../home_screen/controller/home_controller.dart';
import '../../packing_list/controller/packlist_controller.dart';
import '../../scan_serial/controller/serial_controller.dart';

class QRScannerController extends GetxController {
  static QRScannerController get instance => Get.find<QRScannerController>();
  final MobileScannerController scannerController = MobileScannerController();
  var isFlashOn = false.obs;
  RxDouble linePosition = 0.0.obs;
  var scannedResult = ''.obs;

  static const String _getCommonPath = '/scriptcase/app/ekc_qc/api_qrcode/index.php';

  // New variables to prevent repeated processing
  String lastScannedCode = '';
  DateTime lastScanTime = DateTime.now();

  void toggleFlashlight() {
    isFlashOn.value = !isFlashOn.value;
    scannerController.toggleTorch();
  }

  void switchCamera() {
    scannerController.switchCamera();
  }
  void checkSerialNo(String code) async {
    try {
      // Construct the request body
      Map<String, dynamic> requestBody = {
        "dbtype": "checkSerialno",
        "code": code,
      };

      // Make the POST API call
      final result = await HttpService.post(_getCommonPath, requestBody);

      LogUtil.debug(result.toString());

      // Handle the response
      if (result["status"] != 200) {
        // Show an error dialog using GetX
        Get.defaultDialog(
          title: "Error",
          titleStyle: TextStyle(color: Colors.red),
          content: Text(
            result["message"] ?? "An unknown error occurred.",
            textAlign: TextAlign.center,
          ),
          confirm: ElevatedButton(
            onPressed: () => Get.back(),
            child: Text("OK"),
          ),
        );
      } else {
        // Show a success dialog using GetX
        Get.defaultDialog(
          title: "Success",
          titleStyle: TextStyle(color: Colors.green),
          content: Text(
            result["message"] ?? "Operation successful.",
            textAlign: TextAlign.center,
          ),
          confirm: ElevatedButton(
            onPressed: () => Get.back(),
            child: Text("OK"),
          ),
        );
      }
    } catch (e) {
      LogUtil.error(e);

      // Show an error dialog for exceptions using GetX
      Get.defaultDialog(
        title: "Error",
        titleStyle: TextStyle(color: Colors.red),
        content: Text(
          "An error occurred: $e",
          textAlign: TextAlign.center,
        ),
        confirm: ElevatedButton(
          onPressed: () => Get.back(),
          child: Text("OK"),
        ),
      );
    }
  }

  void animateLine(double boxSize) {
    linePosition.value = 0;
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 10));
      linePosition.value += 2;
      if (linePosition.value > boxSize) linePosition.value = 0;
      return true;
    });
  }

  void openQrScannerScreen(String argument) {
    Get.dialog(
      QrScannerContent(argument: argument),
      barrierDismissible: false, // Prevents closing by tapping outside the dialog
    );
  }

  @override
  void onClose() {
    scannerController.dispose();
    super.onClose();
  }
}



class QrScannerContent extends StatelessWidget {
  final String argument;

  QrScannerContent({super.key, required this.argument});

  final AudioPlayer audioPlayer = AudioPlayer();

  Future<void> _playBeep() async {
    await audioPlayer.play(AssetSource('beep.mp3')); // Ensure you have a beep sound in assets
  }

  // Future<void> _vibrate() async {
  //   // Check if the device has a vibrator and the result is not null
  //   final hasVibrator = await Vibration.hasVibrator();
  //   if (hasVibrator != null && hasVibrator) {
  //     Vibration.vibrate();
  //   }
  // }


  Future<void> _handleScanResult(QRScannerController controller, String code) async {

    final DateTime now = DateTime.now();

    // Prevent repeated handling of the same code within a short interval
    if (controller.lastScannedCode == code && now.difference(controller.lastScanTime) < Duration(seconds: 2)) {
      return; // Exit early if the same code was scanned within 2 seconds
    }

    controller.lastScannedCode = code;
    controller.lastScanTime = now;
    controller.scannedResult.value = code;

    // Play beep sound
    await _playBeep();

    if (argument == 'scan') {
      ScanSerialController.instance.code.value.text = code;
      controller.checkSerialNo(code);
      ScanSerialController.instance.code.refresh();

    } else if (argument == 'packlist') {
      var serial = HomePageController.instance.serialList.firstWhereOrNull(
              (element) => element.serialno == code || element.client_serialno == code);

      if (serial == null || PacklistController.instance.selectedProduct.value?.productId != serial.productid ||
          PacklistController.instance.selectedGas.value?.gasName != serial.gas_type) {
        controller.checkSerialNo(code);
        return;
      }

      if (PacklistController.instance.packSerialList.any((element) => element.serialno == code || element.client_serialno == code)) {
        Get.snackbar('Warning', 'Serial No. already added.', colorText: Colors.white, backgroundColor: Colors.blue);
        return;
      }


      serial.packlistdtlid = null;
      PacklistController.instance.packSerialList.add(serial);

      PacklistController.instance.code.value.text = code;
      // PacklistController.instance.packSerialList.refresh();
    }

    // Close the scanner dialog after processing the scan result
    Get.back();
  }



  @override
  Widget build(BuildContext context) {
    final QRScannerController controller = QRScannerController.instance;

    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            controller: controller.scannerController,
            onDetect: (BarcodeCapture barcodeCapture) {
              final List<Barcode> barcodes = barcodeCapture.barcodes;
              for (final Barcode barcode in barcodes) {
                final String? code = barcode.rawValue;
                if (code != null) {
                  _handleScanResult(controller, code);
                  break;
                }
              }
            },
            onDetectError: (Object error, StackTrace stackTrace) {
              print('Error detecting barcode: $error');
            },
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final double boxSize = constraints.maxWidth * 0.6;
              final double boxOffset = (constraints.maxHeight - boxSize) / 2;

              controller.animateLine(boxSize);

              return Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: boxOffset,
                    child: Container(color: Colors.black.withOpacity(0.6)),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: boxOffset,
                    child: Container(color: Colors.black.withOpacity(0.6)),
                  ),
                  Positioned(
                    top: boxOffset,
                    bottom: boxOffset,
                    left: 0,
                    width: (constraints.maxWidth - boxSize) / 2,
                    child: Container(color: Colors.black.withOpacity(0.6)),
                  ),
                  Positioned(
                    top: boxOffset,
                    bottom: boxOffset,
                    right: 0,
                    width: (constraints.maxWidth - boxSize) / 2,
                    child: Container(color: Colors.black.withOpacity(0.6)),
                  ),
                  Positioned(
                    top: boxOffset,
                    left: (constraints.maxWidth - boxSize) / 2,
                    child: Container(
                      width: boxSize,
                      height: boxSize,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green, width: 4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Obx(() => Positioned(
                    top: boxOffset + controller.linePosition.value,
                    left: (constraints.maxWidth - boxSize) / 2,
                    child: Container(
                      width: boxSize,
                      height: 2,
                      color: Colors.redAccent,
                    ),
                  )),
                ],
              );
            },
          ),
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Obx(() => IconButton(
                  icon: Icon(
                    controller.isFlashOn.value
                        ? Icons.flash_on
                        : Icons.flash_off,
                    color: Colors.white,
                  ),
                  onPressed: controller.toggleFlashlight,
                )),
                IconButton(
                  icon: const Icon(Icons.cameraswitch, color: Colors.white),
                  onPressed: controller.switchCamera,
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


