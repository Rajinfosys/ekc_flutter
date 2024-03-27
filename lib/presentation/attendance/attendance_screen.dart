import 'package:qr_code_scanner/widgets/general_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/attendance_controller.dart';

class AttendanceScreen extends GetView<AttendanceController> {
  AttendanceScreen({Key? key}) : super(key: key);
  static const routeName = '/attendance-screen';

  final formKey = GlobalKey<FormState>();

  void _submit() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    if (controller.selectedImage.value == null) {
      Get.snackbar('Attendance image is empty!', 'Add your image');
    } else {
      if (Get.arguments == "in") {
        controller.updateAttendance();
      } else {
        controller.insertAttendance();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 40.0),
          child: Text('Attendance Screen'),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(
              () => GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: ((builder) => bottomSheet()),
                  );
                },
                child: CircleAvatar(
                  radius: 80.0,
                  backgroundImage: const AssetImage('assets/images/img.png'),
                  backgroundColor: Colors.grey.shade900,
                  foregroundImage: controller.selectedImage.value != null
                      ? MemoryImage(controller.selectedImage.value!)
                      : null,
                ),
              ),
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            Container(
              width: Get.width,
              margin: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
              child: Obx(
                () => Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      myTextField(
                          text: "Name",
                          controller: controller.nameController.value,
                          readOnly: true,
                          validator: (String input) {}),
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                      myTextField(
                          text: "Date",
                          controller: controller.todayDate.value,
                          validator: (String input) {}),
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                      myTextField(
                          text: "Latitude",
                          validator: (String input) {},
                          controller: controller.latController.value,
                          readOnly: true),
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                      myTextField(
                          text: "Longitude",
                          validator: (String input) {},
                          controller: controller.longController.value,
                          readOnly: true),
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                      myTextField(
                          text: "Address",
                          validator: (String input) {},
                          maxLines: 2,
                          controller: controller.currentAddress.value,
                          readOnly: true),
                      controller.isLoading.value
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : SizedBox(
                              height: 50,
                              // margin: EdgeInsets.symmetric(vertical: Get.height * 0.04),
                              width: Get.width * 0.5,
                              child: controller.isLocationFetched.value
                                  ? elevatedButton(
                                      text: 'Submit', onPress: _submit)
                                  : elevatedButton(
                                      text: 'Get Address',
                                      onPress: () {
                                        controller.getCurrentPosition();
                                      },
                                    ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: Get.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            "Capture Image",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextButton.icon(
            onPressed: () async {
              Get.back();
              controller.pickPic();
            },
            icon: const Icon(
              Icons.image,
            ),
            label: const Text(
              "Camera",
            ),
          ),
        ],
      ),
    );
  }
}
