import 'package:qr_code_scanner/core/utils/global_variables.dart';
import 'package:qr_code_scanner/core/utils/log_util.dart';
import 'package:qr_code_scanner/widgets/general_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/app_color.dart';
import 'controller/outlet_controller.dart';
import 'models/areas_model.dart';
import 'models/city_model.dart';

class AddOutletScreen extends GetView<OutletController> {
  AddOutletScreen({Key? key}) : super(key: key);
  static const routeName = '/add-outlets';
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Get.arguments != null ? controller.editOutlet() : controller.clear();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBarWidget(
        title: Get.arguments != null ? "Edit Outlet" : "Add Outlet",
        leading: const Icon(CupertinoIcons.arrow_left),
      ),
      body: Obx(
        () => !controller.isLoading.value || !controller.isEditLoading.value
            ? SingleChildScrollView(
                child: SizedBox(
                  width: Get.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 16),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          myTextField(
                            text: "Outlet Name",
                            controller: controller.outletName.value,
                            validator: (String input) {
                              if (input.isEmpty) {
                                Get.snackbar(
                                    'Warning', 'Outlet name is required.',
                                    colorText: Colors.white,
                                    backgroundColor: Colors.blue);
                                return '';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: Get.height * textMidSize,
                          ),
                          myTextField(
                            text: "Owner Name",
                            controller: controller.ownerName.value,
                            validator: (String input) {
                              if (input.isEmpty) {
                                Get.snackbar(
                                    'Warning', 'Owner name is required.',
                                    colorText: Colors.white,
                                    backgroundColor: Colors.blue);
                                return '';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: Get.height * textMidSize,
                          ),
                          myTextField(
                            text: "Owner Email",
                            textInputType: TextInputType.emailAddress,
                            controller: controller.ownerEmail.value,
                            validator: (String input) {
                              return null;
                            },
                          ),
                          SizedBox(
                            height: Get.height * textMidSize,
                          ),
                          myTextField(
                            text: "Owner Number",
                            maxLength: 10,
                            textInputType: TextInputType.number,
                            controller: controller.ownerNum.value,
                            validator: (String input) {
                              if (input.length < 10 || input.length > 10) {
                                Get.snackbar('Warning',
                                    'Phone number should be 10 digit.',
                                    colorText: Colors.white,
                                    backgroundColor: Colors.blue);
                                return '';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: Get.height * textMidSize,
                          ),
                          myTextField(
                            text: "Age",
                            textInputType: TextInputType.number,
                            controller: controller.ownerAge.value,
                            validator: (String input) {
                              return null;
                            },
                          ),
                          SizedBox(
                            height: Get.height * textMidSize,
                          ),
                          myTextField(
                            text: "Outlet Address",
                            controller: controller.ownerAddress.value,
                            validator: (String input) {
                              if (input.isEmpty) {
                                Get.snackbar('Warning', 'Address is required.',
                                    colorText: Colors.white,
                                    backgroundColor: Colors.blue);
                                return '';
                              }
                              return null;
                            },
                          ),
                          myText(
                              text: "Select your city",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 18)),
                          SizedBox(
                            height: Get.height * dropSize,
                          ),
                          DropdownButtonFormField<CityModel>(
                            validator: (CityModel? input) {
                              if (input?.name == null) {
                                Get.snackbar('Warning', 'Select your city.',
                                    colorText: Colors.white,
                                    backgroundColor: Colors.blue);
                                return '';
                              }
                              return null;
                            },
                            isExpanded: true,
                            menuMaxHeight: 500,
                            elevation: 16,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColors.black,
                            ),
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.only(top: 5, left: 20),
                              errorStyle: const TextStyle(fontSize: 0),
                              hintStyle: TextStyle(
                                color: AppColors.genderTextColor,
                              ),
                              hintText: ' -select- ',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            value: controller.cityModifier.value,
                            onChanged: controller.setCityValue,
                            items: controller.citiesList
                                .map<DropdownMenuItem<CityModel>>(
                                    (CityModel value) {
                              return DropdownMenuItem<CityModel>(
                                value: value,
                                child: Text(
                                  value.name ?? '-',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xffA6A6A6),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          SizedBox(
                            height: Get.height * dropSize,
                          ),
                          myText(
                              text: "Select your area",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 18)),
                          SizedBox(
                            height: Get.height * dropSize,
                          ),
                          DropdownButtonFormField<AreaModel>(
                            validator: (AreaModel? input) {
                              return null;
                            },
                            isExpanded: true,
                            menuMaxHeight: 500,
                            elevation: 16,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColors.black,
                            ),
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.only(top: 5, left: 20),
                              errorStyle: const TextStyle(fontSize: 0),
                              hintStyle: TextStyle(
                                color: AppColors.genderTextColor,
                              ),
                              hintText: ' -select- ',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            // validator: (value) {
                            //   if (controller.areasModifier.value ==
                            //       null) {
                            //     return "This field can't be empty.";
                            //   }
                            //   return null;
                            // },
                            value: controller.areasModifier.value,
                            onChanged: controller.setAreaValue,
                            items: controller.selectedAreasList
                                .map<DropdownMenuItem<AreaModel>>(
                                    (AreaModel value) {
                              return DropdownMenuItem<AreaModel>(
                                value: value,
                                child: Text(
                                  value.areaName ?? '-',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xffA6A6A6),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          SizedBox(
                            height: Get.height * size,
                          ),
                          myTextField(
                            text: "Pin-code",
                            controller: controller.ownerPinCode.value,
                            textInputType: TextInputType.number,
                            // readOnly: true,
                            validator: (String input) {
                              if (input.isEmpty) {
                                Get.snackbar('Warning', 'Pin code is required.',
                                    colorText: Colors.white,
                                    backgroundColor: Colors.blue);
                                return '';
                              }
                              return null;
                            },
                          ),
                          Obx(
                            () => controller.isLoading.value
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Center(
                                    child: SizedBox(
                                      height: 50,
                                      width: Get.width * 0.5,
                                      child: elevatedButton(
                                        text: Get.arguments != null
                                            ? "Edit Outlet"
                                            : "Add Outlet",
                                        onPress: () {
                                          if (!formKey.currentState!
                                              .validate()) {
                                            LogUtil.warning(
                                                'error in inserting or updating outlet');
                                            return;
                                          }
                                          Get.arguments != null
                                              ? controller.updateOutlet()
                                              : controller.insertOutlet();
                                        },
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
