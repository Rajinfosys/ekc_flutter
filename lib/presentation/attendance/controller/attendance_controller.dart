import 'dart:async';
import 'dart:typed_data';

// import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_scanner/core/utils/app_color.dart';
import 'package:qr_code_scanner/presentation/auth/controller/auth_controller.dart';
import 'package:qr_code_scanner/presentation/home_screen/controller/home_controller.dart';
import 'package:qr_code_scanner/presentation/home_screen/home_page.dart';

import '../../../core/utils/dialogs.dart';
import '../../../core/utils/image_util.dart';
import '../../../core/utils/log_util.dart';
import '../../../main.dart';
import '../models/attendance_model.dart';
import '../repo/attendance_repo.dart';

class AttendanceController extends GetxController
    with GetTickerProviderStateMixin {
  static AttendanceController get instance => Get.find<AttendanceController>();

  // final Rxn<CameraController> cameraController = Rxn<CameraController>();
  final Rxn<Future<void>> initializeControllerFuture = Rxn<Future<void>>();
  final Rx<Uint8List?> selectedImage = Rx<Uint8List?>(null);
  final Rxn<Position?> currentPosition = Rxn<Position>(null);
  var isLoading = false.obs;
  var isLocationFetched = false.obs;
  Rx<TextEditingController> longController = TextEditingController().obs;
  Rx<TextEditingController> latController = TextEditingController().obs;
  Rx<TextEditingController> currentAddress = TextEditingController().obs;
  Rx<TextEditingController> nameController = TextEditingController().obs;
  Rx<TextEditingController> todayDate = TextEditingController().obs;
  var city = ''.obs;
  var areaName = ''.obs;
  DateTime now = DateTime.now();
  String? currTime;
  Rx<String?> imgString = Rx(null);
  Rx<String?> sendImgString = Rx(null);
  Rx<String?> attendId = Rx(null);

  @override
  void onReady() {
    // TODO: implement onReady
    nameController.value.text = AuthController.instance.user!.name!;
    /*cameraController.value = CameraController(
      cameras.first,
      ResolutionPreset.medium,
    );
    initializeControllerFuture.value = cameraController.value!.initialize();*/

    todayDate.value.text = DateFormat('yyyy-MM-dd').format(now);
    currTime = DateFormat('yyyy-MM-dd kk:mm:ss').format(now);
    super.onReady();
  }

  void insertAttendance() async {
    isLoading(true);
    try {
      HomePageController.instance.attendance.value = AttendanceModel(
        tableType: "insertAttendance",
        locationId: AuthController.instance.user!.locationId,
        userName: AuthController.instance.user!.name,
        cityName: city.value,
        areaName: areaName.value,
        unitName: areaName.value,
        attendDate: todayDate.value.text,
        startTime: currTime,
        startPic: sendImgString.value,
        latitude: currentPosition.value!.latitude.toString(),
        longitude: currentPosition.value!.longitude.toString(),
        geolocation: city.value,
        altitude: currentPosition.value!.altitude.toString(),
      );
      HomePageController.instance.attendance.value!.attendedId =
          await AttendanceRepo.insertAttendance(
              HomePageController.instance.attendance.value!);

      isLoading(false);

      HomePageController.instance.switchBool(true);
      Get.offAllNamed(HomePage.routeName);
      Get.snackbar('Excellent!', 'Your attendance is inserted',
          backgroundColor: AppColors.green, colorText: AppColors.white);
    } catch (e) {
      isLoading(false);
      Get.snackbar('Error', "$e");
    }
  }

  void submit() {
    if (selectedImage.value == null) {
      Get.snackbar('Attendance image is empty!', 'Add your image');
    } else {
      if (Get.arguments == "in") {
        updateAttendance();
      } else {
        insertAttendance();
      }
    }
  }

  void updateAttendance() async {
    isLoading(true);
    try {
      LogUtil.debug(HomePageController.instance.attendance.value!.attendedId!);
      HomePageController.instance.attendance.value!.tableType =
          "updateAttendance";
      HomePageController.instance.attendance.value!.areaName = areaName.value;
      HomePageController.instance.attendance.value!.unitName = areaName.value;
      HomePageController.instance.attendance.value!.endTime = currTime;
      HomePageController.instance.attendance.value!.endPic =
          sendImgString.value;
      HomePageController.instance.attendance.value!.endLatitude =
          currentPosition.value!.latitude.toString();
      HomePageController.instance.attendance.value!.endLongitude =
          currentPosition.value!.longitude.toString();
      HomePageController.instance.attendance.value!.geolocation = city.value;
      /*AttendanceModel(
        tableType: "updateAttendance",
        attendedId: HomePageController.instance.attendance.value!.attendedId,
        locationId: AuthController.instance.user!.locationId,
        userName: AuthController.instance.user!.name,
        areaName: areaName.value,
        unitName: areaName.value,
        endTime: currTime,
        endPic: sendImgString.value,
        endLatitude: currentPosition.value!.latitude.toString(),
        endLongitude: currentPosition.value!.longitude.toString(),
        endGeolocation: city.value,
        endAltitude: currentPosition.value!.altitude.toString(),
      );*/
      await AttendanceRepo.updateAttendance(
          HomePageController.instance.attendance.value!);

      isLoading(false);
      HomePageController.instance.switchBool(false);
      Get.offNamed(HomePage.routeName);

      Get.snackbar('Excellent!', 'Your attendance is updated',
          backgroundColor: AppColors.green, colorText: AppColors.white);
    } catch (e) {
      isLoading(false);
      Get.snackbar('Error', "$e");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    longController.value.dispose();
    latController.value.dispose();
    currentAddress.value.dispose();
    // cameraController.value!.dispose();
    nameController.value.dispose();
    todayDate.value.dispose();
    super.dispose();
  }

  Future<void> pickPic() async {
    ImagePicker()
        .pickImage(
      source: ImageSource.camera,
      imageQuality: 20,
      preferredCameraDevice: CameraDevice.front,
    )
        .then((imgFile) async {
      if (imgFile != null) {
        imgString.value = Utility.base64String(await imgFile.readAsBytes());
        selectedImage.value = Utility.dataFromBase64String(imgString.value!);
        sendImgString.value = await AttendanceRepo.uploadImage(
            imgString.value!,
            'attendancepic',
            AuthController.instance.user!,
            HomePageController.instance.attendance.value?.attendedId == null
                ? 0
                : HomePageController.instance.attendance.value!.attendedId!);
      }
    });
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Dialogs.showSnackBar(Get.context,
          'Location services are disabled. Please enable the services');
      isLoading(false);
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Dialogs.showSnackBar(Get.context, 'Location permissions are denied');
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Dialogs.showSnackBar(Get.context,
          'Location permissions are permanently denied, we cannot request permissions.');
      isLoading(false);
      return false;
    }
    return true;
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            currentPosition.value!.latitude, currentPosition.value!.longitude)
        .then((List<Placemark> placeMark) {
      Placemark place = placeMark[0];
      currentAddress.value.text =
          '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      city.value = place.locality!;
      areaName.value = place.subLocality!;
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> getCurrentPosition() async {
    isLoading(true);
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      currentPosition.value = position;
      latController.value.text = position.latitude.toString();
      longController.value.text = position.longitude.toString();
      _getAddressFromLatLng(currentPosition.value!);
      isLocationFetched(true);
    }).catchError((e) {
      debugPrint(e);
      isLocationFetched(false);
      isLoading(false);
    });
    isLoading(false);
  }

// Future<File> getTemporaryFile() async {
//   final directory = await getTemporaryDirectory();
//   final path = '${directory.path}/example.txt';
//   return File(path);
// }
// cropImage(File imgFile) async {
//   final croppedFile = await ImageCropper().cropImage(
//       sourcePath: imgFile.path,
//       aspectRatioPresets: Platform.isAndroid
//           ? [
//               CropAspectRatioPreset.square,
//               CropAspectRatioPreset.ratio3x2,
//               CropAspectRatioPreset.original,
//               CropAspectRatioPreset.ratio4x3,
//               CropAspectRatioPreset.ratio16x9
//             ]
//           : [
//               CropAspectRatioPreset.original,
//               CropAspectRatioPreset.square,
//               CropAspectRatioPreset.ratio3x2,
//               CropAspectRatioPreset.ratio4x3,
//               CropAspectRatioPreset.ratio5x3,
//               CropAspectRatioPreset.ratio5x4,
//               CropAspectRatioPreset.ratio7x5,
//               CropAspectRatioPreset.ratio16x9
//             ],
//       uiSettings: [
//         AndroidUiSettings(
//             toolbarTitle: "Image Cropper",
//             toolbarColor: Colors.black,
//             toolbarWidgetColor: Colors.white,
//             initAspectRatio: CropAspectRatioPreset.original,
//             lockAspectRatio: false),
//         IOSUiSettings(
//           title: "Image Cropper",
//         )
//       ]);
//   if (croppedFile != null) {
//     imageCache.clear();
//
//     Get.off(const HomePage());
//   }
// }
}
