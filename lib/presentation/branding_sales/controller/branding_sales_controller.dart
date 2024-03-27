import 'package:qr_code_scanner/presentation/customer_screen/controller/customer_controller.dart';
import 'package:qr_code_scanner/presentation/customer_screen/models/customer_model.dart';
import 'package:qr_code_scanner/presentation/outlet_screen/models/shop_model.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/app_color.dart';
import '../../../core/utils/dialogs.dart';
import '../../customer_screen/models/customer_type_model.dart';
import '../../customer_screen/repo/customer_repo.dart';
import '../models/branding_model.dart';
import '../models/product_model.dart';
import '../repo/branding_sales_repo.dart';

class BrandingSalesController extends GetxController {
  Rx<TextEditingController> customerProdQuantity = TextEditingController().obs;
  RxList<CustomerTypeModel> productTypes = RxList.empty();
  Rx<CustomerTypeModel?> productModifier = Rx(null);
  Rx<CustomerTypeModel?> brandingModifier = Rx(null);
  RxList<CustomerTypeModel> brandingTypes = RxList.empty();
  RxBool isLoading = RxBool(false);
  RxBool isEditLoading = RxBool(false);
  Rx<CustomerModel?> customer = Rx(null);
  Rx<OutletModel?> outlet = Rx(null);
  late List<BrandingModel> listOfBranding = [];
  List<ProductModel> listOfProducts = [];
  Rx<BrandingModel?> brand = Rx(null);
  ProductModel? product;

  static BrandingSalesController get instance =>
      Get.find<BrandingSalesController>();
  var brandingCheckModifier = 'No'.obs;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    customerProdQuantity.value.dispose();
  }

  void clear() {
    productModifier.value = null;
    customerProdQuantity.value.text = '';
    brandingModifier.value = null;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    try {
      customer.value = Get.arguments;
      fetchingListOfCustomerBranding();
      fetchingListOfProducts();
    } catch (e) {
      outlet.value = Get.arguments;
      fetchingListOfOutletBranding();
    }
    getBrandingType();
    getSalesType();
    super.onInit();
  }

  void updateCustomerBranding() async {
    isLoading(true);
    try {
      brand.value = BrandingModel(
          dbType: 'updateBranding',
          brandingId: brand.value!.brandingId,
          brandingType: brand.value!.brandingType,
          locationId: brand.value!.locationId,
          variableId: brand.value!.variableId,
          productUnit: "Nos",
          productName: brandingModifier.value!.value,
          quantity: int.parse(customerProdQuantity.value.text));
      await BrandingSalesRepo.updateBranding(brand.value!.toJsonCustomer())
          .then((value) {
        listOfBranding.removeWhere(
            (element) => element.brandingId == brand.value!.brandingId);
        listOfBranding.add(brand.value!);
      });
      Get.back();
      isLoading(false);

      Dialogs.showSnackBar(Get.context, "Branding updated");
    } catch (e) {
      isLoading(false);
      Get.snackbar('Error', "$e");
    }
  }

  void updateOutletBranding() async {
    isLoading(true);
    try {
      brand.value = BrandingModel(
          dbType: 'updateBranding',
          brandingId: brand.value!.brandingId,
          brandingType: brand.value!.brandingType,
          locationId: brand.value!.locationId,
          variableId: brand.value!.variableId,
          productUnit: "Nos",
          productName: brandingModifier.value!.value,
          quantity: int.parse(customerProdQuantity.value.text));
      await BrandingSalesRepo.updateBranding(brand.value!.toJsonOutlet())
          .then((value) {
        listOfBranding.removeWhere(
            (element) => element.brandingId == brand.value!.brandingId);
        listOfBranding.add(brand.value!);
      });
      Get.back();
      isLoading(false);

      Dialogs.showSnackBar(Get.context, "Branding updated");
    } catch (e) {
      isLoading(false);
      Get.snackbar('Error', "$e");
    }
  }

  void editBranding() async {
    isEditLoading(true);

    brand.value = Get.arguments;
    try {
      if (brand.value != null) {
        brandingModifier.value = brandingTypes.firstWhereOrNull(
            (element) => element.value == brand.value!.productName);
        customerProdQuantity.value.text = brand.value!.quantity.toString();
        isEditLoading(false);
      }
    } catch (e) {
      isEditLoading(false);
      Get.snackbar('Error', "$e");
    }
  }

  void updateProduct() async {
    isLoading(true);
    try {
      product = ProductModel(
          dbType: 'updateCustOrder',
          productId: product!.productId,
          locationId: product!.locationId,
          customerId: product!.customerId,
          productUnit: "Nos",
          productName: productModifier.value!.value,
          quantity: int.parse(customerProdQuantity.value.text));
      await BrandingSalesRepo.updateProduct(product!);
      listOfProducts
          .removeWhere((element) => element.productId == product!.productId);
      listOfProducts.add(product!);
      isLoading(false);
      Get.back();
      Dialogs.showSnackBar(Get.context, "Product updated");
    } catch (e) {
      isLoading(false);
      Get.snackbar('Error', "$e");
    }
  }

  void editProduct() async {
    product = Get.arguments;
    try {
      if (product != null) {
        productModifier.value = productTypes.firstWhereOrNull(
            (element) => element.value == product!.productName);
        customerProdQuantity.value.text = product!.quantity.toString();
      }
    } catch (e) {
      Get.snackbar('Error', "$e");
    }
  }

  insertCustomerProduct() async {
    isLoading(true);
    try {
      customer.value!.salesDone = 1;
      customer.value!.dbType = "updateCustomer";
      product = ProductModel(
          dbType: 'insertCustOrder',
          locationId: customer.value!.locationId,
          customerId: customer.value!.customerId,
          productName: productModifier.value!.value,
          productUnit: 'Nos',
          quantity: int.parse(customerProdQuantity.value.text));
      product?.productId = await BrandingSalesRepo.insertProduct(product!);

      CustomerController.instance.customer.value = customer.value!;
      await CustomerRepo.updateCustomer(customer.value!);
      listOfProducts.add(product!);
      Get.back();
      isLoading(false);
      Get.back();
      Get.snackbar('Congrats!', 'Product is added.',
          backgroundColor: AppColors.green, colorText: AppColors.white);
    } catch (e) {
      isLoading(false);
      Get.snackbar('Error', "$e");
    }
  }

  insertCustomerBranding() async {
    isLoading(true);
    try {
      customer.value!.brandingDone = 1;
      customer.value!.dbType = "updateCustomer";
      brand.value = BrandingModel(
        dbType: 'insertBranding',
        brandingType: 'Customer',
        locationId: customer.value!.locationId!,
        variableId: customer.value!.customerId!,
        productName: brandingModifier.value!.value!,
        productUnit: 'Nos',
        quantity: int.parse(customerProdQuantity.value.text),
      );
      brand.value?.brandingId =
          await BrandingSalesRepo.insertCustomerBranding(brand.value!);
      listOfBranding.add(brand.value!);
      CustomerController.instance.customer.value = customer.value!;
      await CustomerRepo.updateCustomer(customer.value!);
      Get.back();
      isLoading(false);
      Get.snackbar('Congrats!', 'Customer branding is added.',
          backgroundColor: AppColors.green, colorText: AppColors.white);
    } catch (e) {
      isLoading(false);
      Get.snackbar('Error', "$e");
    }
  }

  insertOutletBranding() async {
    isLoading(true);
    try {
      brand.value = BrandingModel(
        dbType: 'insertBranding',
        brandingType: 'Outlet',
        locationId: outlet.value!.locationId!,
        variableId: outlet.value!.outletId!,
        productName: brandingModifier.value!.value!,
        productUnit: 'Nos',
        quantity: int.parse(customerProdQuantity.value.text),
      );
      brand.value?.brandingId =
          await BrandingSalesRepo.insertOutletBranding(brand.value!);
      listOfBranding.add(brand.value!);
      Get.back();
      isLoading(false);
      Get.snackbar('Congrats!', 'Outlet branding is added.',
          backgroundColor: AppColors.green, colorText: AppColors.white);
    } catch (e) {
      isLoading(false);
      Get.snackbar('Error', "$e");
    }
  }

  void fetchingListOfCustomerBranding() async {
    isLoading(true);
    try {
      listOfBranding.clear();
      listOfBranding.addAll(
          await BrandingSalesRepo.getBranding(customer.value!.customerId!));

      isLoading(false);
    } catch (e) {
      isLoading(false);
      Get.snackbar('Error', "$e");
    }
    isLoading(false);
  }

  void fetchingListOfOutletBranding() async {
    isLoading(true);
    try {
      listOfBranding.clear();
      listOfBranding.addAll(
          await BrandingSalesRepo.getBrandingByOutlet(outlet.value!.outletId!));

      isLoading(false);
    } catch (e) {
      isLoading(false);
      Get.snackbar('Error', "$e");
    }
    isLoading(false);
  }

  void fetchingListOfProducts() async {
    isEditLoading(true);
    try {
      listOfProducts.clear();
      listOfProducts.addAll(
          await BrandingSalesRepo.getProducts(customer.value!.customerId!));

      isEditLoading(false);
    } catch (e) {
      isEditLoading(false);
      Get.snackbar('Error', "$e");
    }
    isEditLoading(false);
  }

  getSalesType() async {
    productTypes.clear();
    productTypes.addAll(await CustomerRepo.getSalesType());
  }

  getBrandingType() async {
    brandingTypes.clear();
    brandingTypes.addAll(await CustomerRepo.getBrandingType());
  }

  void setSalesValue(CustomerTypeModel? value) {
    productModifier.value = value!;
  }

  void setBrandingValue(CustomerTypeModel? value) {
    brandingModifier.value = value;
  }

  void setCheckBrandingStatus(String? value) {
    brandingCheckModifier.value = value!;
  }
}
