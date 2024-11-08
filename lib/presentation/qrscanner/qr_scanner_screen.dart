import 'package:ekc_scan/presentation/qrscanner/controller/qr_scanner_controller.dart';
import 'package:ekc_scan/presentation/scan_serial/controller/serial_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../core/utils/log_util.dart';

class QrScannerScreen extends GetView<QRScannerController> {
  static const routeName = '/qr-code-scanner';

  const QrScannerScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // QR Scanner behind the overlay
          MobileScanner(
            controller: controller.scannerController,
            onDetect: (BarcodeCapture barcodeCapture) {
              final List<Barcode> barcodes = barcodeCapture.barcodes;
              for (final Barcode barcode in barcodes) {
                final String? code = barcode.rawValue;
                if (code != null) {
                  controller.scannedResult.value = code;
                  if(Get.arguments == 'scan'){
                    ScanSerialController.instance.code.value.text = controller.scannedResult.value;
                    ScanSerialController.instance.code.refresh();
                  }else{
                    // Packing list screen logic
                  }
                  LogUtil.debug(controller.scannedResult.value);
                  Get.back(); // Return result on QR detection
                }
              }
            },
            onDetectError: (Object error, StackTrace stackTrace) {
              LogUtil.debug('Error detecting barcode: $error');
            },
          ),

          // Overlay with a transparent scanning area
          LayoutBuilder(
            builder: (context, constraints) {
              final double boxSize = constraints.maxWidth * 0.6; // Size of the scanning box
              final double boxOffset = (constraints.maxHeight - boxSize) / 2;

              // Start line animation when the box size is known
              controller.animateLine(boxSize);

              return Stack(
                children: [
                  // Top black overlay
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: boxOffset,
                    child: Container(color: Colors.black.withOpacity(0.6)),
                  ),
                  // Bottom black overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: boxOffset,
                    child: Container(color: Colors.black.withOpacity(0.6)),
                  ),
                  // Left black overlay
                  Positioned(
                    top: boxOffset,
                    bottom: boxOffset,
                    left: 0,
                    width: (constraints.maxWidth - boxSize) / 2,
                    child: Container(color: Colors.black.withOpacity(0.6)),
                  ),
                  // Right black overlay
                  Positioned(
                    top: boxOffset,
                    bottom: boxOffset,
                    right: 0,
                    width: (constraints.maxWidth - boxSize) / 2,
                    child: Container(color: Colors.black.withOpacity(0.6)),
                  ),
                  // Center green-bordered box
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
                  // Scanning Line in Center Box
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

          // Bottom Buttons: Flashlight, Camera Switch, and Cancel
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Flashlight Button
                Obx(() => IconButton(
                  icon: Icon(
                    controller.isFlashOn.value ? Icons.flash_on : Icons.flash_off,
                    color: Colors.white,
                  ),
                  onPressed: controller.toggleFlashlight,
                )),
                // Camera Switch Button
                IconButton(
                  icon: const Icon(Icons.cameraswitch, color: Colors.white),
                  onPressed: controller.switchCamera,
                ),
                // Cancel Button
                ElevatedButton(
                  onPressed: () {
                    Get.back(); // Exit the scanner screen
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
