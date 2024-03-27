import 'package:qr_code_scanner/core/utils/app_color.dart';
import 'package:qr_code_scanner/presentation/customer_screen/controller/customer_controller.dart';
import 'package:qr_code_scanner/presentation/customer_screen/models/customer_type_model.dart';
import 'package:qr_code_scanner/widgets/general_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/global_variables.dart';
import '../outlet_screen/models/areas_model.dart';
import '../outlet_screen/models/city_model.dart';

class AddCustomerScreen extends GetView<CustomerController> {
  AddCustomerScreen({Key? key}) : super(key: key);
  static const routeName = '/add-customer';
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Get.arguments != null ? controller.editCustomer() : controller.clear();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBarWidget(
        title: controller.customer.value == null
            ? 'Add Customer'
            : 'Edit Customer',
        leading: const Icon(CupertinoIcons.arrow_left),
      ),
      body: !controller.isLoading.value && !controller.isEditLoading.value
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
                        myText(
                            text: "Select customer type",
                            style: const TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 18)),
                        SizedBox(
                          height: Get.height * dropSize,
                        ),
                        DropdownButtonFormField<CustomerTypeModel>(
                          isExpanded: true,
                          menuMaxHeight: 500,
                          elevation: 16,
                          validator: (CustomerTypeModel? input) {
                            if (input?.value == null) {
                              Get.snackbar('Warning', 'Select customer type.',
                                  colorText: Colors.white,
                                  backgroundColor: Colors.blue);
                              return '';
                            }
                            return null;
                          },
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
                          value: controller.customerModifier.value,
                          onChanged: controller.setCustomerValue,
                          items: controller.customerTypes
                              .map<DropdownMenuItem<CustomerTypeModel>>(
                                  (CustomerTypeModel value) {
                            return DropdownMenuItem<CustomerTypeModel>(
                              value: value,
                              child: Text(
                                value.value ?? '-',
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
                          text: "Customer Name",
                          controller: controller.customerName.value,
                          validator: (String input) {
                            if (input.isEmpty) {
                              Get.snackbar('Warning', 'Name is required.',
                                  colorText: Colors.white,
                                  backgroundColor: Colors.blue);
                              return '';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: Get.height * 0.005,
                        ),
                        myTextField(
                          text: "Customer Number",
                          controller: controller.customerNum.value,
                          textInputType: TextInputType.number,
                          maxLength: 10,
                          validator: (String input) {
                            if (input.length < 10 || input.length > 10) {
                              Get.snackbar(
                                  'Warning', 'Phone number should be 10 digit.',
                                  colorText: Colors.white,
                                  backgroundColor: Colors.blue);
                              return '';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: Get.height * 0.005,
                        ),
                        myTextField(
                          text: "Customer Age",
                          controller: controller.customerAge.value,
                          textInputType: TextInputType.number,
                          validator: (String input) {
                            /*if (input.isEmpty) {
                              Get.snackbar('Warning', 'Age is required.',
                                  colorText: Colors.white,
                                  backgroundColor: Colors.blue);
                              return '';
                            }*/
                            return null;
                          },
                        ),
                        SizedBox(
                          height: Get.height * 0.005,
                        ),
                        myTextField(
                          text: "Customer Email",
                          controller: controller.customerEmail.value,
                          textInputType: TextInputType.emailAddress,
                          validator: (String input) {
                            /*if (input.isEmpty) {
                              Get.snackbar('Warning', 'Email is required.',
                                  colorText: Colors.white,
                                  backgroundColor: Colors.blue);
                              return '';
                            }

                            if (!input.contains('@')) {
                              Get.snackbar('Warning', 'Email is invalid.',
                                  colorText: Colors.white,
                                  backgroundColor: Colors.blue);
                              return '';
                            }*/
                            return null;
                          },
                        ),
                        myText(
                            text: "Select Marital Status",
                            style: const TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 18)),
                        SizedBox(
                          height: Get.height * dropSize,
                        ),
                        dropDownWidget(
                          valueString: controller.maritalModifier.value,
                          onChanged: controller.setMartialValue,
                          listOfEle: controller.maritalStatusList,
                          validator: (String? input) {
                            // if (input!.isEmpty) {
                            //   Get.snackbar(
                            //       'Warning', 'Martial status is required.',
                            //       colorText: Colors.white,
                            //       backgroundColor: Colors.blue);
                            //   return '';
                            // }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: Get.height * size,
                        ),
                        myTextField(
                          text: "Customer no. of kids",
                          textInputType: TextInputType.number,
                          controller: controller.noOfKids.value,
                          validator: (String input) {
                            // if (input.isEmpty) {
                            //   Get.snackbar('Warning', 'No. of kid is required.',
                            //       colorText: Colors.white,
                            //       backgroundColor: Colors.blue);
                            //   return '';
                            // }
                            return null;
                          },
                        ),
                        myTextField(
                          text: "Customer address",
                          controller: controller.customerAddress.value,
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
                            text: "Select city",
                            style: const TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 18)),
                        SizedBox(
                          height: Get.height * dropSize,
                        ),
                        DropdownButtonFormField<CityModel>(
                          isExpanded: true,
                          menuMaxHeight: 500,
                          elevation: 16,
                          validator: (CityModel? input) {
                            if (input?.name == null) {
                              Get.snackbar('Warning', 'Select your city.',
                                  colorText: Colors.white,
                                  backgroundColor: Colors.blue);
                              return '';
                            }
                            return null;
                          },
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
                        Obx(
                          () => DropdownButtonFormField<AreaModel>(
                            isExpanded: true,
                            menuMaxHeight: 500,
                            elevation: 16,
                            validator: (AreaModel? input) {
                              /*if (input?.areaName == null) {
                                Get.snackbar('Warning', 'Select your area.',
                                    colorText: Colors.white,
                                    backgroundColor: Colors.blue);
                                return '';
                              }*/
                              return null;
                            },
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
                        ),
                        SizedBox(
                          height: Get.height * size,
                        ),
                        myTextField(
                          text: "Pin-code",
                          controller: controller.customerPinCode.value,
                          textInputType: TextInputType.number,
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
                        myText(
                            text: "Is Customer Enquired? ",
                            style: const TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 18)),
                        SizedBox(
                          height: Get.height * dropSize,
                        ),
                        dropDownWidget(
                          valueString: controller.requiredCheckModifier.value,
                          onChanged: controller.setRequiredValue,
                          listOfEle: controller.decisionList,
                          validator: (String? input) {
                            if (input!.isEmpty) {
                              Get.snackbar('Warning', 'Required field.',
                                  colorText: Colors.white,
                                  backgroundColor: Colors.blue);
                              return '';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: Get.height * size,
                        ),
                        Center(
                          child: SizedBox(
                            height: 50,
                            // margin: EdgeInsets.symmetric(vertical: Get.height * 0.04),
                            width: Get.width * 0.5,
                            child: Obx(
                              () => controller.isLoading.value
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : elevatedButton(
                                      text: 'Add Customer',
                                      onPress: () {
                                        if (!formKey.currentState!.validate()) {
                                          return;
                                        }
                                        controller.customer.value != null
                                            ? controller.updateCustomer()
                                            : controller.insertCustomer();
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
    );
  }
}
// myTextField(
// text: "Site Address",
// controller: controller.siteAddress.value,
// ),
// myTextField(
// text: "Site City",
// controller: siteCity,
// ),
// myTextField(
// text: "Gift given",
// controller: giftGiven,
// ),
