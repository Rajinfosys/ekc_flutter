import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/presentation/home_screen/controller/home_controller.dart';
import 'package:qr_code_scanner/presentation/scan_serial/scan_serial.dart';
import 'package:qr_code_scanner/presentation/widgets/home_screen_dart.dart';
import 'package:qr_code_scanner/widgets/general_widgets.dart';

import '../outlet_screen/list_of_outlet_screen.dart';

class HomePage extends GetView<HomePageController> {
  const HomePage({super.key});

  static const routeName = '/home-page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        title: 'Dashboard',
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                controller.showOtherUserContextMenu();
              },
              icon: const Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HomeScreenCard(
                      color: Colors.orange,
                      imageFile: 'assets/images/scan.png',
                      label: "Scan Serials",
                      onTap: () {
                        Get.toNamed(ScanSerialView.routeName);
                      },
                    ),
                    HomeScreenCard(
                      color: Colors.lightGreen,
                      imageFile: 'assets/images/pack_list.png',
                      label: "Scan Packing List",
                      onTap: () {
                        controller.searchOutlets('');
                        Get.toNamed(ListOfOutletsScreen.routeName);
                      },
                    ),
                  ],
                ),
              ],
            ),
            // DropdownSearch<CountriesModel>(
            //   items: countries,
            //   itemAsString: (CountriesModel? u) => u!.name,
            //   onChanged: (CountriesModel? data) {
            //     print(data);
            //   },
            //   compareFn: (CountriesModel? item1, CountriesModel? item2) => true,
            //   popupProps: PopupProps.menu(
            //       isFilterOnline: true,
            //       showSearchBox: true,
            //       showSelectedItems: true),
            //   // selectedItem: countries[0],
            // ),
          ],
        ),
      ),
      bottomSheet: Container(
        margin: const EdgeInsets.all(12.0),
        child: myText(text: 'App Version - 1.0'),
      ),
    );
  }
}

// class CountriesModel {
//   final int id;
//   final String name;

//   const CountriesModel({
//     required this.id,
//     required this.name,
//   });

//   factory CountriesModel.fromJson(Map<String, dynamic> fromJson) {
//     return CountriesModel(
//       id: fromJson['id'],
//       name: fromJson['name'],
//     );
//   }
// }

// define dummy country list
// final List<CountriesModel> countries = [
//   CountriesModel(id: 1, name: 'India'),
//   CountriesModel(id: 2, name: 'USA'),
//   CountriesModel(id: 3, name: 'UK'),
//   CountriesModel(id: 4, name: 'Canada'),
//   CountriesModel(id: 5, name: 'Australia'),
//   CountriesModel(id: 6, name: 'Japan'),
//   CountriesModel(id: 7, name: 'China'),
//   CountriesModel(id: 8, name: 'Russia'),
//   CountriesModel(id: 9, name: 'Brazil'),
//   CountriesModel(id: 10, name: 'Germany'),
//   CountriesModel(id: 11, name: 'France'),
//   CountriesModel(id: 12, name: 'Italy'),
//   CountriesModel(id: 13, name: 'Spain'),
//   CountriesModel(id: 14, name: 'Mexico'),
//   CountriesModel(id: 15, name: 'South Africa'),
//   CountriesModel(id: 16, name: 'Nigeria'),
//   CountriesModel(id: 17, name: 'Egypt'),
//   CountriesModel(id: 18, name: 'Argentina'),
//   CountriesModel(id: 19, name: 'Colombia'),
//   CountriesModel(id: 20, name: 'Chile'),
//   CountriesModel(id: 21, name: 'Peru'),
//   CountriesModel(id: 22, name: 'Venezuela'),
//   CountriesModel(id: 23, name: 'Ecuador'),
//   CountriesModel(id: 24, name: 'Bolivia'),
//   CountriesModel(id: 25, name: 'Paraguay'),
//   CountriesModel(id: 26, name: 'Uruguay'),
//   CountriesModel(id: 27, name: 'Panama'),
//   CountriesModel(id: 28, name: 'Costa Rica'),
//   CountriesModel(id: 29, name: 'Honduras'),
//   CountriesModel(id: 30, name: 'El Salvador'),
//   CountriesModel(id: 31, name: 'Nicaragua'),
//   CountriesModel(id: 32, name: 'Guatemala'),
//   CountriesModel(id: 33, name: 'Belize'),
//   CountriesModel(id: 34, name: 'Cuba'),
//   CountriesModel(id: 35, name: 'Jamaica'),
//   CountriesModel(id: 36, name: 'Haiti'),
// ];
