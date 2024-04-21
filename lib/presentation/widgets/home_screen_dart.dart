import 'package:ekc_scan/core/utils/app_color.dart';
import 'package:ekc_scan/widgets/general_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreenCard extends StatelessWidget {
  final Color color;
  final String imageFile;
  final String label;
  final VoidCallback onTap;

  const HomeScreenCard(
      {required this.color,
      required this.imageFile,
      required this.label,
      required this.onTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Stack(
        children: [
          Container(
            height: Get.height * 0.2,
            width: Get.width * 0.436,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  blurRadius: 5.0,
                  spreadRadius: 1.0,
                  color: const Color(0xff393939).withOpacity(0.15),
                ),
              ],
            ),
            child: InkWell(
              onTap: onTap,
              child: Column(
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  Image(
                    image: AssetImage(imageFile),
                    color: AppColors.green,
                    // height: 72,
                    height: Get.height * 0.1,
                    width: Get.height * 0.1,
                    fit: BoxFit.fill,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  myText(
                    text: label,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
