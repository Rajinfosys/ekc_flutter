
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/app_color.dart';
import '../../core/utils/global_variables.dart';
import '../../widgets/general_widgets.dart';
import '../customer_screen/models/customer_type_model.dart';
import 'controller/branding_sales_controller.dart';

class AddProductScreen extends GetView<BrandingSalesController> {
  AddProductScreen({super.key});

  static const routeName = '/add-sales';
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Get.arguments != null ? controller.editProduct() : controller.clear();
    return Scaffold(
      appBar: appBarWidget(title: "Add Product"),
      body: SingleChildScrollView(
        child: SizedBox(
          width: Get.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  myText(
                      text: "Select product",
                      style: const TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 18)),
                  SizedBox(
                    height: Get.height * dropSize,
                  ),
                  Obx(
                    () => DropdownButtonFormField<CustomerTypeModel>(
                      isExpanded: true,
                      elevation: 16,
                      menuMaxHeight: 500,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(top: 5, left: 20),
                        errorStyle: const TextStyle(fontSize: 0),
                        hintStyle: TextStyle(
                          color: AppColors.genderTextColor,
                        ),
                        hintText: ' -select- ',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: AppColors.black,
                      ),
                      value: controller.productModifier.value,
                      onChanged: controller.setSalesValue,
                      items: controller.productTypes
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
                  ),
                  SizedBox(
                    height: Get.height * size,
                  ),
                  myTextField(
                    text: "Quantity",
                    controller: controller.customerProdQuantity.value,
                    textInputType: TextInputType.number,
                    validator: (String input) {
                      if (input.isEmpty) {
                        Get.snackbar('Warning', 'Quantity is required.',
                            colorText: Colors.white,
                            backgroundColor: Colors.blue);
                        return '';
                      }
                      return null;
                    },
                  ),
                  Center(
                    child: Container(
                      height: 50,
                      margin: EdgeInsets.symmetric(vertical: Get.height * 0.04),
                      width: Get.width * 0.5,
                      child: Obx(
                        () => controller.isLoading.value
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : elevatedButton(
                                text: 'Add Product',
                                onPress: () {
                                  if (!formKey.currentState!.validate()) {
                                    return;
                                  }
                                  Get.arguments != null
                                      ? controller.updateProduct()
                                      : controller.insertCustomerProduct();
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
      ),
    );
  }
}
