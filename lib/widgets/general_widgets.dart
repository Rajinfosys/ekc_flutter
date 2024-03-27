import 'package:qr_code_scanner/presentation/customer_screen/add_customer_screen.dart';
import 'package:qr_code_scanner/presentation/customer_screen/list_of_customer_screen.dart';
import 'package:qr_code_scanner/presentation/customer_screen/models/customer_model.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/utils/app_color.dart';
import '../core/utils/styles.dart';
import '../presentation/auth/controller/auth_controller.dart';
import '../presentation/branding_sales/add_branding_screen.dart';
import '../presentation/branding_sales/add_product_screen.dart';
import '../presentation/branding_sales/branding_screen.dart';
import '../presentation/branding_sales/models/branding_model.dart';
import '../presentation/branding_sales/models/product_model.dart';
import '../presentation/branding_sales/product_screen.dart';
import '../presentation/outlet_screen/add_outlet_screen.dart';
import '../presentation/outlet_screen/models/shop_model.dart';

Widget myText({text, style, textAlign, maxLines}) {
  return Text(
    text,
    style: style,
    textAlign: textAlign,
    overflow: TextOverflow.ellipsis,
    maxLines: maxLines,
    softWrap: false,
  );
}

Widget myTextField(
    {text,
    String? prefixIcon,
    int maxLines = 1,
    int? maxLength,
    TextEditingController? controller,
    TextInputType textInputType = TextInputType.text,
    bool readOnly = false,
    Function? validator}) {
  return Container(
    // height: 45,
    margin: EdgeInsets.only(bottom: Get.height * 0.02),
    child: TextFormField(
      maxLength: maxLength,
      readOnly: readOnly,
      keyboardType: textInputType,
      validator: (input) => validator!(input),
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: text,
        contentPadding: const EdgeInsets.only(top: 5, left: 20),
        errorStyle: const TextStyle(fontSize: 0),
        hintStyle: TextStyle(
          color: AppColors.genderTextColor,
        ),
        hintText: text,
        prefixIcon: prefixIcon == null
            ? null
            : Image.asset(
                prefixIcon,
                cacheHeight: 20,
              ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
  );
}

Widget cardOutletWidget(OutletModel outlet) {
  return Padding(
    padding: const EdgeInsets.all(18.0),
    child: InkWell(
      onTap: () {
        Get.toNamed(ListOfCustomersScreen.routeName, arguments: outlet);
      },
      child: Container(
        width: (Get.width),
        decoration: BoxDecoration(boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            spreadRadius: 0.1,
            offset: Offset(0, 10),
          )
        ], color: AppColors.white, borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.only(bottom: 25, right: 20, left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                  child: Text(
                    outlet.outletName!,
                    overflow: TextOverflow.clip,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () {
                      Get.toNamed(
                        AddOutletScreen.routeName,
                        arguments: outlet,
                      );
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.blue,
                      // size: 35,
                    ),
                  ),
                ),
                // Container(
                //   alignment: Alignment.topRight,
                //   child: OutletController.instance.isEditLoading.value
                //       ? const CircularProgressIndicator()
                //       : IconButton(
                //           onPressed: () {
                //             OutletController.instance.deleteOutlet(outlet);
                //           },
                //           icon: const Icon(
                //             Icons.delete,
                //             color: Colors.blue,
                //             // size: 35,
                //           ),
                //         ),
                // ),
              ],
            ),
            Text(
              "Owner name:- ${outlet.ownerName}",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            Text(
              "Owner city name:- ${outlet.cityName}",
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            Text(
              'Owner area name:- ${outlet.areaName}',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            Text(
              'Owner email:- ${outlet.ownerEmail}',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            Text(
              'Owner number:- ${outlet.ownerNumber}',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            Text(
              'Owner address:- ${outlet.address}',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            elevatedButton(
                text: 'Branding',
                onPress: () {
                  Get.toNamed(ListOfBrandingScreen.routeName,
                      arguments: outlet);
                },
                fontSize: 14),
          ],
        ),
      ),
    ),
  );
}

Widget cardBrandingWidget(BrandingModel branding) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 16),
    child: Container(
      width: Get.width,
      decoration: BoxDecoration(boxShadow: const [
        BoxShadow(
          color: AppColors.shadow,
          blurRadius: 10,
          spreadRadius: 0.1,
          offset: Offset(0, 10),
        )
      ], color: AppColors.white, borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.only(bottom: 25, top: 10, right: 20, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                branding.productName!.toUpperCase(),
                overflow: TextOverflow.clip,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    Get.toNamed(AddBrandingScreen.routeName,
                        arguments: branding);
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.blue,
                    // size: 35,
                  ),
                ),
              ),
              // Obx(
              //       () => Container(
              //     alignment: Alignment.topRight,
              //     child: CustomerController.instance.isEditLoading.value
              //         ? const CircularProgressIndicator()
              //         : IconButton(
              //       onPressed: () {
              //         CustomerController.instance
              //             .deleteCustomer(customer);
              //       },
              //       icon: const Icon(
              //         Icons.delete,
              //         color: Colors.blue,
              //         // size: 35,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: ('Branding:- '),
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: (branding.productName),
                  style: TextStyle(
                    overflow: TextOverflow.fade,
                    color: AppColors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: ('Number of quantity:- '),
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: (branding.quantity.toString()),
                  style: TextStyle(
                    overflow: TextOverflow.fade,
                    color: AppColors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget cardProductWidget(ProductModel product) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 16),
    child: Container(
      width: Get.width,
      decoration: BoxDecoration(boxShadow: const [
        BoxShadow(
          color: AppColors.shadow,
          blurRadius: 10,
          spreadRadius: 0.1,
          offset: Offset(0, 10),
        )
      ], color: AppColors.white, borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.only(bottom: 25, top: 10, right: 20, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  product.productName!,
                  overflow: TextOverflow.clip,
                  softWrap: true,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    Get.toNamed(AddProductScreen.routeName, arguments: product);
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.blue,
                    // size: 35,
                  ),
                ),
              ),
              // Obx(
              //       () => Container(
              //     alignment: Alignment.topRight,
              //     child: CustomerController.instance.isEditLoading.value
              //         ? const CircularProgressIndicator()
              //         : IconButton(
              //       onPressed: () {
              //         CustomerController.instance
              //             .deleteCustomer(customer);
              //       },
              //       icon: const Icon(
              //         Icons.delete,
              //         color: Colors.blue,
              //         // size: 35,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: ('Product:- '),
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: (product.productName),
                  style: TextStyle(
                    overflow: TextOverflow.fade,
                    color: AppColors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: ('Number of quantity:- '),
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: (product.quantity.toString()),
                  style: TextStyle(
                    overflow: TextOverflow.fade,
                    color: AppColors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget cardCustomerWidget(CustomerModel customer) {
  return Padding(
    padding: const EdgeInsets.all(18.0),
    child: Container(
      width: Get.width,
      decoration: BoxDecoration(boxShadow: const [
        BoxShadow(
          color: AppColors.shadow,
          blurRadius: 10,
          spreadRadius: 0.1,
          offset: Offset(0, 10),
        )
      ], color: AppColors.white, borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.only(bottom: 25, top: 10, right: 20, left: 20),
      child: Wrap(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    customer.customerName!,
                    overflow: TextOverflow.clip,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () {
                        Get.toNamed(
                          AddCustomerScreen.routeName,
                          arguments: customer,
                        );
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.blue,
                        // size: 35,
                      ),
                    ),
                  ),
                  // Obx(
                  //   () => Container(
                  //     alignment: Alignment.topRight,
                  //     child: CustomerController.instance.isEditLoading.value
                  //         ? const CircularProgressIndicator()
                  //         : IconButton(
                  //             onPressed: () {
                  //               CustomerController.instance
                  //                   .deleteCustomer(customer);
                  //             },
                  //             icon: const Icon(
                  //               Icons.delete,
                  //               color: Colors.blue,
                  //               // size: 35,
                  //             ),
                  //           ),
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: ('Address:- '), style: subtitleStyle),
                    TextSpan(text: customer.address, style: subtitleStyle2),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: ('Landmark:- '), style: subtitleStyle),
                    TextSpan(text: customer.cityName, style: subtitleStyle2),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: ('Pin-code:- '), style: subtitleStyle),
                    TextSpan(text: customer.pinCode, style: subtitleStyle2),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: ('Email:- '), style: subtitleStyle),
                    TextSpan(
                        text: (customer.customerEmail), style: subtitleStyle2),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: ('Is Enquired:- '), style: subtitleStyle),
                    TextSpan(
                        text: (customer.isEnquired == 0 ? 'No' : 'Yes'),
                        style: subtitleStyle2),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: ('Branding Done? :- '), style: subtitleStyle),
                    TextSpan(
                        text: (customer.brandingDone == 0 ? 'No' : 'Yes'),
                        style: subtitleStyle2),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: ('Order done? :- '), style: subtitleStyle),
                    TextSpan(
                        text: (customer.salesDone == 0 ? 'No' : 'Yes'),
                        style: subtitleStyle2),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  elevatedButton(
                      text: 'Branding',
                      onPress: () {
                        Get.toNamed(ListOfBrandingScreen.routeName,
                            arguments: customer);
                      },
                      fontSize: 14),
                  elevatedButton(
                      text: 'Product',
                      onPress: () {
                        Get.toNamed(ListOfProductScreen.routeName,
                            arguments: customer);
                      },
                      fontSize: 14),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

PreferredSizeWidget appBarWidget({String? title, actions, Icon? leading}) {
  return AppBar(
    actions: actions,
    backgroundColor: AppColors.white,
    title: title == null
        ? null
        : Text(
            title,
            style: const TextStyle(color: Colors.black),
          ),
    leading: leading == null
        ? null
        : IconButton(
            icon: leading,
            onPressed: () => Get.back(),
            color: Colors.black,
          ),
  );
}

Widget myPasswordTextField(
    {text,
    String? prefixIcon,
    bool suffixIcon = false,
    obscure,
    TextEditingController? controller,
    Function? validator}) {
  AuthController.instance.isObscure.value = obscure;
  return Obx(
    () => SizedBox(
      height: 45,
      child: TextFormField(
        validator: (input) => validator!(input),
        obscureText: AuthController.instance.isObscure.value,
        controller: controller,
        decoration: InputDecoration(
            suffixIcon: suffixIcon
                ? IconButton(
                    onPressed: () {
                      AuthController.instance.toggle();
                    },
                    icon: Icon(
                      AuthController.instance.isObscure.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.black,
                    ))
                : null,
            contentPadding: const EdgeInsets.only(top: 5),
            errorStyle: const TextStyle(fontSize: 0),
            hintStyle: TextStyle(
              color: AppColors.genderTextColor,
            ),
            hintText: text,
            prefixIcon: Image.asset(
              prefixIcon!,
              cacheHeight: 20,
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(8.0))),
      ),
    ),
  );
}

Widget elevatedButton(
    {required String text, Function? onPress, double fontSize = 18}) {
  return ElevatedButton(
    style: ButtonStyle(
      // give color '#247159'
      backgroundColor: MaterialStateProperty.all<Color>(AppColors.green),
    ),
    onPressed: () {
      onPress!();
    },
    child: Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

Widget dropDownWidget(
    {required String valueString,
    required ValueChanged<String?> onChanged,
    listOfEle,
    required String? Function(String?)? validator}) {
  return DropdownButtonFormField<String>(
    isExpanded: true,
    validator: validator,
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
    //borderRadius: BorderRadius.circular(10),
    elevation: 16,
    style: TextStyle(
      fontWeight: FontWeight.w400,
      color: AppColors.black,
    ),
    value: valueString,
    onChanged: onChanged,
    items: listOfEle.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xffA6A6A6),
          ),
        ),
      );
    }).toList(),
  );
}
