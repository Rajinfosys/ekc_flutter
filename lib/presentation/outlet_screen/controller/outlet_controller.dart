import 'package:qr_code_scanner/presentation/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_color.dart';
import '../../../core/utils/dialogs.dart';
import '../../home_screen/controller/home_controller.dart';
import '../models/areas_model.dart';
import '../models/city_model.dart';
import '../models/shop_model.dart';
import '../repo/shop_repo.dart';

class OutletController extends GetxController {
  Rx<TextEditingController> outletName = TextEditingController().obs;
  Rx<TextEditingController> ownerName = TextEditingController().obs;
  Rx<TextEditingController> ownerEmail = TextEditingController().obs;
  Rx<TextEditingController> ownerNum = TextEditingController().obs;
  Rx<TextEditingController> ownerAge = TextEditingController().obs;
  Rx<TextEditingController> ownerAddress = TextEditingController().obs;
  Rx<TextEditingController> ownerPinCode = TextEditingController().obs;
  RxList<CityModel> citiesList = RxList.empty();
  RxList<AreaModel> areasList = RxList.empty();
  OutletModel? outlet;
  var isLoading = false.obs;
  var isEditLoading = false.obs;
  Rx<CityModel?> cityModifier = Rx(null);
  Rx<AreaModel?> areasModifier = Rx(null);
  RxList<AreaModel> selectedAreasList = RxList.empty();

  static OutletController get instance => Get.find<OutletController>();

  void updateOutlet() async {
    isLoading(true);
    try {
      outlet = OutletModel(
        locationId: AuthController.instance.user!.locationId,
        outletName: outletName.value.text,
        outletId: outlet!.outletId,
        ownerName: ownerName.value.text,
        ownerEmail: ownerEmail.value.text,
        ownerNumber: ownerNum.value.text,
        ownerAge: int.parse(ownerAge.value.text),
        address: ownerAddress.value.text,
        cityName: cityModifier.value!.name,
        areaName: areasModifier.value!.areaName,
        pinCode: ownerPinCode.value.text,
      );
      await ShopRepo.updateOutlet(outlet!).then((value) {
        HomePageController.instance.listOfOutlets
            .removeWhere((shop) => shop.outletId == outlet!.outletId);
        HomePageController.instance.listOfOutlets.add(outlet!);
      });
      Get.back();
      isLoading(false);
      Dialogs.showSnackBar(Get.context, "Outlet updated");
    } catch (e) {
      isLoading(false);
      Get.snackbar('Error', "$e");
    }
  }

  void fetchingListOfOutlets() async {
    isLoading(true);
    try {
      /*listOfOutlets.clear();
      listOfOutlets.addAll(await ShopRepo.getOutlets());*/
      isLoading(false);
    } catch (e) {
      isLoading(false);
      Get.snackbar('Error', "$e");
    }
    isLoading(false);
  }

  void editOutlet() async {
    isEditLoading(true);

    outlet = Get.arguments;
    try {
      if (outlet != null) {
        outletName.value.text = outlet!.outletName ?? '';
        ownerName.value.text = outlet!.ownerName ?? '';
        ownerEmail.value.text = outlet!.ownerEmail ?? '';
        ownerNum.value.text = outlet!.ownerNumber ?? '';
        ownerAddress.value.text = outlet!.address ?? '';
        cityModifier.value = citiesList
            .firstWhereOrNull((element) => element.name == outlet!.cityName);
        setCityValue(cityModifier.value);
        areasModifier.value = selectedAreasList.firstWhereOrNull(
            (element) => element.areaName == outlet!.areaName);
        ownerPinCode.value.text = outlet!.pinCode ?? '';
        String age = outlet!.ownerAge.toString();
        ownerAge.value.text = age;

        isEditLoading(false);
      }
    } catch (e) {
      isEditLoading(false);
      Get.snackbar('Error', "$e");
    }
  }

  void deleteOutlet(OutletModel outlet) async {
    isEditLoading(true);

    try {
      ShopRepo.deleteOutlet(outlet);
      HomePageController.instance.listOfOutlets
          .removeWhere((element) => element.outletId == outlet.outletId);
      isEditLoading(false);
      HomePageController.instance.lengthOfListOfOutlets.value =
          HomePageController.instance.lengthOfListOfOutlets.value - 1;
      Dialogs.showSnackBar(Get.context, "Outlet deleted");
    } catch (e) {
      isEditLoading(false);
      Get.snackbar('Error', "$e");
    }
  }

  void insertOutlet() async {
    isLoading(true);
    try {
      int age = ownerAge.value.text == '' ? 0 : int.parse(ownerAge.value.text);
      outlet = OutletModel(
        locationId: AuthController.instance.user!.locationId,
        outletName: outletName.value.text,
        ownerName: ownerName.value.text,
        ownerEmail: ownerEmail.value.text == '' ? '' : ownerEmail.value.text,
        ownerNumber: ownerNum.value.text,
        ownerAge: age,
        address: ownerAddress.value.text,
        cityName: cityModifier.value!.name,
        areaName: areasModifier.value?.areaName == null
            ? ''
            : areasModifier.value!.areaName,
        pinCode: ownerPinCode.value.text,
      );
      outlet?.outletId = await ShopRepo.insertOutlet(outlet!);
      HomePageController.instance.listOfOutlets.add(outlet!);
      isLoading(false);
      Get.back();
      HomePageController.instance.lengthOfListOfOutlets.value =
          HomePageController.instance.lengthOfListOfOutlets.value + 1;
      Get.snackbar('Congrats!', 'Outlet is inserted.',
          backgroundColor: AppColors.green, colorText: AppColors.white);
    } catch (e) {
      isLoading(false);
      Get.snackbar('Error', "$e");
    }
  }

  getCities() async {
    citiesList.clear();
    citiesList.addAll(await ShopRepo.getCitesData());
  }

  getAreas() async {
    areasList.clear();
    areasList.addAll(await ShopRepo.getAreasData());
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
    ownerPinCode.value.text = selectedArea.pinCode ?? '';
  }

  @override
  void onInit() {
    // TODO: implement onInit
    getAreas();
    getCities();
    fetchingListOfOutlets();

    super.onInit();
  }

  void clear() {
    outletName.value.text = '';
    ownerName.value.text = '';
    ownerEmail.value.text = '';
    ownerAge.value.text = '';
    ownerPinCode.value.text = '';
    ownerAddress.value.text = '';
    ownerNum.value.text = '';
    cityModifier.value = null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    outletName.value.dispose();
    ownerName.value.dispose();
    ownerEmail.value.dispose();
    ownerAge.value.dispose();
    ownerPinCode.value.dispose();
    ownerAddress.value.dispose();
    ownerNum.value.dispose();
  }
}
