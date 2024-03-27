import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/presentation/customer_screen/add_customer_screen.dart';
import 'package:qr_code_scanner/presentation/customer_screen/controller/customer_controller.dart';
import 'package:qr_code_scanner/widgets/general_widgets.dart';

import '../../core/utils/app_color.dart';

class ListOfCustomersScreen extends GetView<CustomerController> {
  const ListOfCustomersScreen({super.key});

  static const routeName = '/list-of-customer';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.outlet.value!.outletName!),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(AddCustomerScreen.routeName,
                  arguments: controller.outlet.value!);
            },
            icon: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(
                CupertinoIcons.add,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 32.0, right: 16),
        child: FloatingActionButton(
          onPressed: () {
            Get.toNamed(AddCustomerScreen.routeName,
                arguments: controller.outlet.value!);
          },
          backgroundColor: AppColors.white2,
          child: const Icon(CupertinoIcons.add),
        ),
      ),
      body: Obx(
        () => Container(
          child: controller.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: SearchBar(
                        elevation: MaterialStateProperty.all(2),
                        backgroundColor:
                            MaterialStateProperty.all(AppColors.white),
                        surfaceTintColor:
                            MaterialStateProperty.all(AppColors.white),
                        // textInputAction: TextInputAction.done,
                        leading: const Icon(Icons.search),
                        hintText: 'Search Customers',
                        onChanged: controller.searchCustomers,
                      ),
                    ),
                    if (controller.listOfOutletCustomer.isEmpty)
                      const Expanded(
                        child: Center(
                          child: Text(
                            'No Customer',
                            style: TextStyle(color: Colors.black, fontSize: 25),
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (ctx, i) {
                            return cardCustomerWidget(
                              controller.listOfOutletCustomer[i],
                            );
                          },
                          itemCount: controller.listOfOutletCustomer.length,
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}
