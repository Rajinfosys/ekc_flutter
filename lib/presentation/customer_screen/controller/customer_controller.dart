import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/presentation/customer_screen/models/customer_model.dart';
import 'package:qr_code_scanner/presentation/customer_screen/models/customer_type_model.dart';
import 'package:qr_code_scanner/presentation/home_screen/controller/home_controller.dart';

import '../../../core/utils/app_color.dart';
import '../../../core/utils/dialogs.dart';
import '../../../core/utils/log_util.dart';
import '../../auth/controller/auth_controller.dart';
import '../../outlet_screen/models/areas_model.dart';
import '../../outlet_screen/models/city_model.dart';
import '../../outlet_screen/models/shop_model.dart';
import '../../outlet_screen/repo/shop_repo.dart';
import '../repo/customer_repo.dart';

class CustomerController extends GetxController {
  RxList<CustomerTypeModel> customerTypes = RxList.empty();

  Rx<CustomerTypeModel?> customerModifier = Rx(null);
  RxList<CityModel> citiesList = RxList.empty();
  Rx<TextEditingController> customerName = TextEditingController().obs;
  Rx<TextEditingController> customerEmail = TextEditingController().obs;
  Rx<TextEditingController> customerNum = TextEditingController().obs;
  Rx<TextEditingController> customerAge = TextEditingController().obs;
  Rx<TextEditingController> customerAddress = TextEditingController().obs;
  Rx<TextEditingController> noOfKids = TextEditingController().obs;
  Rx<TextEditingController> customerPinCode = TextEditingController().obs;
  final List<CustomerModel> _allCustomers = [];
  RxList<CustomerModel> listOfOutletCustomer = RxList.empty();
  var isEditLoading = false.obs;

  static CustomerController get instance => Get.find<CustomerController>();
  Rx<String> maritalModifier = Rx(' -select- ');

  var requiredCheckModifier = 'No'.obs;
  Rx<CityModel?> cityModifier = Rx(null);
  Rx<AreaModel?> areasModifier = Rx(null);
  RxList<AreaModel> areasList = RxList.empty();
  RxList<AreaModel> selectedAreasList = RxList.empty();
  Rx<OutletModel?> outlet = Rx(null);
  Rx<CustomerModel?> customer = Rx(null);

  var isLoading = false.obs;
  List<String> decisionList = [
    'Yes',
    'No',
  ].obs;
  List<String> maritalStatusList = [
    ' -select- ',
    'Married',
    'Unmarried',
  ].obs;

  void updateCustomer() async {
    isLoading(true);
    try {
      customer.value = CustomerModel(
        dbType: "updateCustomer",
        customerId: customer.value!.customerId,
        customerName: customerName.value.text,
        customerType: customerModifier.value!.value!,
        outletId: customer.value!.outletId,
        locationId: customer.value!.locationId,
        customerNumber: customerNum.value.text,
        customerAge: int.parse(customerAge.value.text),
        customerEmail: customerEmail.value.text,
        maritalStatus: maritalModifier.value,
        noOfKids: int.parse(noOfKids.value.text),
        address: customerAddress.value.text,
        cityName: cityModifier.value!.name,
        areaName: areasModifier.value!.areaName,
        pinCode: customerPinCode.value.text,
        isEnquired: requiredCheckModifier.value == 'No' ? 0 : 1,
      );
      await CustomerRepo.updateCustomer(customer.value!);
      HomePageController.instance.listOfCustomers.removeWhere(
          (element) => element.customerId == customer.value!.customerId);
      listOfOutletCustomer.removeWhere(
          (element) => element.customerId == customer.value!.customerId);
      HomePageController.instance.listOfCustomers.add(customer.value!);
      Get.back();
      isLoading(false);
      Dialogs.showSnackBar(Get.context, "Customer detail is updated.");
    } catch (e) {
      isLoading(false);
      LogUtil.error('Error $e');
      Get.snackbar('Error', "$e");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    customerName.value.dispose();
    customerEmail.value.dispose();
    customerNum.value.dispose();
    customerAge.value.dispose();
    customerAddress.value.dispose();
    noOfKids.value.dispose();
    customerPinCode.value.dispose();
    customerModifier.value = null;
    cityModifier.value = null;
    super.dispose();
  }

  void clear() {
    customerName.value.text = '';
    customerEmail.value.text = '';
    customerNum.value.text = '';
    customerAge.value.text = '';
    customerAddress.value.text = '';
    noOfKids.value.text = '';
    customerPinCode.value.text = '';
    cityModifier.value = null;
    areasModifier.value = null;
    customerModifier.value = null;
  }

  void editCustomer() async {
    isEditLoading(true);
    try {
      if (Get.arguments is CustomerModel) {
        customer.value = Get.arguments;
        if (customer.value != null) {
          customerModifier.value = customerTypes.firstWhereOrNull(
              (element) => element.value == customer.value!.customerType);
          customerName.value.text = customer.value!.customerName ?? '';
          customerNum.value.text = customer.value!.customerNumber ?? '';
          String age = customer.value!.customerAge.toString();
          customerAge.value.text = age;
          customerEmail.value.text = customer.value!.customerEmail ?? '';
          maritalModifier.value = maritalStatusList.firstWhereOrNull(
                  (element) => element == customer.value!.maritalStatus) ??
              ' -select- ';
          customerAddress.value.text = customer.value!.address ?? '';
          noOfKids.value.text = customer.value!.noOfKids.toString();
          customerPinCode.value.text = customer.value!.pinCode ?? '';
          cityModifier.value = citiesList.firstWhereOrNull(
              (element) => element.name == customer.value!.cityName);
          setCityValue(cityModifier.value);
          areasModifier.value = selectedAreasList.firstWhereOrNull(
              (element) => element.areaName == customer.value!.areaName);
          requiredCheckModifier.value =
              customer.value!.isEnquired == 0 ? 'No' : 'Yes';

          isEditLoading(false);
        }
      } else if (Get.arguments is OutletModel) {
        outlet.value = Get.arguments;
        clear();
        isEditLoading(false);
      }
    } catch (e) {
      outlet.value = Get.arguments;
      clear();
      isEditLoading(false);
    }
  }

  void deleteCustomer(CustomerModel customer) async {
    isEditLoading(true);

    try {
      CustomerRepo.deleteCustomer(customer);
      HomePageController.instance.listOfCustomers
          .removeWhere((custom) => custom.customerId == customer.customerId);
      listOfOutletCustomer
          .removeWhere((custom) => custom.customerId == customer.customerId);
      HomePageController.instance.lengthOfListOfCustomer.value =
          HomePageController.instance.lengthOfListOfCustomer.value - 1;
      isEditLoading(false);

      Dialogs.showSnackBar(Get.context, "Customer is deleted.");
    } catch (e) {
      isEditLoading(false);
      Get.snackbar('Error', "$e");
    }
  }

  void insertCustomer() async {
    isLoading(true);
    try {
      LogUtil.debug('insertCustomer');
      int age =
          customerAge.value.text == '' ? 0 : int.parse(customerAge.value.text);
      int kids = noOfKids.value.text == '' ? 0 : int.parse(noOfKids.value.text);
      customer.value = CustomerModel(
        dbType: "insertCustomer",
        locationId: AuthController.instance.user!.locationId,
        outletId: outlet.value!.outletId,
        customerType: customerModifier.value!.value!,
        customerName: customerName.value.text,
        customerNumber: customerNum.value.text,
        customerAge: age,
        customerEmail:
            customerEmail.value.text == '' ? '' : customerEmail.value.text,
        maritalStatus:
            maritalModifier.value == ' -select- ' ? '' : maritalModifier.value,
        noOfKids: kids,
        address: customerAddress.value.text,
        cityName: cityModifier.value!.name,
        areaName: areasModifier.value?.areaName == null
            ? ''
            : areasModifier.value!.areaName,
        pinCode: customerPinCode.value.text,
        isEnquired: requiredCheckModifier.value == 'No' ? 0 : 1,
        brandingDone: 0,
        salesDone: 0,
      );
      customer.value?.customerId =
          await CustomerRepo.insertCustomer(customer.value!);
      HomePageController.instance.listOfCustomers.add(customer.value!);
      listOfOutletCustomer.add(customer.value!);
      customer.value = null;
      isLoading(false);
      Get.back();
      HomePageController.instance.lengthOfListOfCustomer.value =
          HomePageController.instance.lengthOfListOfCustomer.value + 1;
      Get.snackbar('Congrats!', 'Customer is added.',
          backgroundColor: AppColors.green, colorText: AppColors.white);
    } catch (e) {
      isLoading(false);
      LogUtil.error('Error $e');
      Get.snackbar('Error', "$e");
    }
  }

  void setCustomerValue(CustomerTypeModel? value) {
    customerModifier.value = value!;
  }

  void setMartialValue(String? value) {
    maritalModifier.value = value!;
  }

  void setRequiredValue(String? value) {
    requiredCheckModifier.value = value!;
  }

  void fetchingListOfCustomer() async {
    isLoading(true);
    try {
      /*listOfCustomers.clear();
      listOfCustomers
          .addAll(await CustomerRepo.getCustomers(outlet.value!.outletId!));*/
      listOfOutletCustomer.clear();
      _allCustomers.clear();
      _allCustomers.addAll(HomePageController.instance.listOfCustomers
          .where((element) => element.outletId == outlet.value!.outletId));
      listOfOutletCustomer.addAll(_allCustomers);
      /*for (var tempList in list) {
        if (tempList.outletId == outlet.value!.outletId) {
          listOfOutletCustomer.add(tempList);
        }
      }*/

      isLoading(false);
    } catch (e) {
      isLoading(false);
      Get.snackbar('Error', "$e");
    }
    isLoading(false);
  }

  searchCustomers(String query) {
    if (query == '') {
      listOfOutletCustomer.clear();
      listOfOutletCustomer.addAll(_allCustomers);
    } else {
      listOfOutletCustomer.clear();
      listOfOutletCustomer.addAll(_allCustomers.where((element) =>
          element.customerName?.toLowerCase().startsWith(query.toLowerCase()) ??
          false));
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    outlet.value = Get.arguments;
    getCities();
    getAreas();
    getCustomerTypes();
    fetchingListOfCustomer();
    super.onInit();
  }

  getCustomerTypes() async {
    customerTypes.clear();
    customerTypes.addAll(await CustomerRepo.getCustomerType());
  }

  getAreas() async {
    areasList.clear();
    areasList.addAll(await ShopRepo.getAreasData());
  }

  getCities() async {
    citiesList.clear();
    citiesList.addAll(await ShopRepo.getCitesData());
  }

  void setCityValue(CityModel? city) {
    areasModifier.value = null;
    selectedAreasList.clear();
    cityModifier.value = city;
    for (var area in areasList) {
      if (area.cityName == cityModifier.value!.name) {
        selectedAreasList.add(area);
      }
    }
  }

  void setAreaValue(AreaModel? selectedArea) {
    areasModifier.value = selectedArea!;
    customerPinCode.value.text = selectedArea.pinCode ?? '';
  }
}
