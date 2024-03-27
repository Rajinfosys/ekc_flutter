import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_scanner/core/utils/log_util.dart';
import 'package:qr_code_scanner/presentation/home_screen/repo/homepage_repo.dart';

import '../../../core/utils/storage_util.dart';
import '../../attendance/models/attendance_model.dart';
import '../../auth/controller/auth_controller.dart';
import '../../customer_screen/models/customer_model.dart';
import '../../outlet_screen/models/shop_model.dart';

class HomePageController extends GetxController {
  static HomePageController get instance => Get.find<HomePageController>();
  Rx<bool> switchBool = Rx(false);
  RxInt lengthOfListOfOutlets = RxInt(0);
  RxInt lengthOfListOfCustomer = RxInt(0);
  final List<OutletModel> _allOutlets = [];
  final List<CustomerModel> _allCustomers = [];
  RxList<OutletModel> listOfOutlets = RxList.empty();
  RxList<CustomerModel> listOfCustomers = RxList.empty();
  var isLoading = false.obs;

  Rx<AttendanceModel?> attendance = Rx(null);

  void showOtherUserContextMenu() {
    showMenu(
      context: Get.context!,
      position: const RelativeRect.fromLTRB(10.0, 0.0, 0.0, 0.0),
      items: [
        const PopupMenuItem(
          value: 1,
          child: Text('Logout User'),
        ),
      ],
      elevation: 0.0,
    ).then((value) {
      // Handle the selected menu item here
      if (value != null) {
        switch (value) {
          case 1:
            showDialog(
              context: Get.context!,
              builder: (context) => SimpleDialog(
                backgroundColor: Colors.white,
                title: const Text("You want to logout?"),
                children: [
                  SimpleDialogOption(
                    child: const Text("Yes"),
                    onPressed: () {
                      AuthController.instance.logout();
                    },
                  ),
                  SimpleDialogOption(
                    child: const Text("No"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            );
            break;
        }
      }
    });
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // getList();
    // fetchAttendanceDetails();
  }

  DateTime now = DateTime.now();

  void getAttendance(int attendId) async {
    LogUtil.debug(attendId);
    attendance.value = await HomePageRepo.getAttendance(attendId);
    String currDate = DateFormat('yyyy-MM-dd').format(now);
    if (currDate != attendance.value!.attendDate) {
      attendance.value = null;
      StorageUtil.deleteAttendanceId();
    } else if (attendance.value?.startTime != null &&
        attendance.value?.endTime == null) {
      switchBool(true);
    }
  }

  fetchAttendanceDetails() async {
    try {
      if (StorageUtil.getAttendanceId() != null) {
        String? attendId = StorageUtil.getAttendanceId();
        getAttendance(int.parse(attendId!));
      }
    } catch (e) {
      Get.snackbar('Error', "$e");
    }
  }

  getList() async {
    isLoading(true);
    try {
      _allOutlets.clear();
      _allOutlets.addAll(await HomePageRepo.getListOfOutlets());
      listOfOutlets.clear();
      listOfOutlets.addAll(_allOutlets);
      _allCustomers.clear();
      _allCustomers.addAll(await HomePageRepo.getListOfCustomers());
      listOfCustomers.addAll(_allCustomers);
      lengthOfListOfCustomer.value = listOfCustomers.length;
      lengthOfListOfOutlets.value = listOfOutlets.length;
    } catch (e) {
      AuthController.instance.user?.token = await HomePageRepo.refreshToken(
          AuthController.instance.user!.refreshToken!);
      update();
    }
    isLoading(false);
  }

  searchOutlets(String query) {
    if (query == '') {
      listOfOutlets.clear();
      listOfOutlets.addAll(_allOutlets);
    } else {
      listOfOutlets.clear();
      listOfOutlets.addAll(_allOutlets.where((element) =>
          element.outletName?.toLowerCase().startsWith(query.toLowerCase()) ??
          false));
    }
  }
}
