import 'package:ekc_scan/presentation/packing_list/controller/packlist_controller.dart';
import 'package:ekc_scan/widgets/general_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/app_color.dart';

class PartialPackListView extends GetView<PacklistController> {
  PartialPackListView({Key? key}) : super(key: key);
  static const routeName = '/partial-packing-list';
  final formKey = GlobalKey<FormState>();

  ScrollController scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBarWidget(
        title: "Partial Packing Lists",
        leading: const Icon(CupertinoIcons.arrow_left),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.only(bottom: 50.0, right: 16),
      //   child: FloatingActionButton(
      //     onPressed: () async {
      //       scrollController?.animateTo(
      //         1500.0,
      //         duration: const Duration(milliseconds: 500),
      //         curve: Curves.easeOut,
      //       );
      //     },
      //     backgroundColor: AppColors.white2,
      //     child: const Icon(CupertinoIcons.arrow_down, color: AppColors.green),
      //   ),
      // ),
      body: Obx(() => !controller.isInitialized.value
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.green,
              ),
            )
          : SingleChildScrollView(
              controller: scrollController,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 32,
                    right: 32,
                    top: 16,
                    bottom: 16,
                  ),
                  child: Column(
                    children: [
                      if (PacklistController.instance.partialPackLists.isEmpty)
                        const Expanded(
                          child: Center(
                            child: Text(
                              'No Packing List Found',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 25),
                            ),
                          ),
                        )
                      else
                        Expanded(
                          child: ListView.builder(
                            itemBuilder: (ctx, i) {
                              return cardPacklistWidget(
                                PacklistController.instance.partialPackLists[i],
                              );
                            },
                            itemCount: PacklistController
                                .instance.partialPackLists.length,
                          ),
                        ),
                      SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            )),
    );
  }
}
