import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class GlobalSectionHeader extends StatelessWidget {
  final String title;
  final EdgeInsets? margin, padding;
  const GlobalSectionHeader({
    super.key,
    required this.title,
    this.margin,
    this.padding
  });

  Color get sideColor => Get.isDarkMode ? Colors.grey.shade800 : const Color(0xFFF9F9FB);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, 
      padding: padding,
      margin: margin,
      child: Row(
        children: [
          Flexible(
            child: Container(
              height: 3.h,
              color: sideColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SvgPicture.asset(
              "assets/images/logo.svg",
              fit: BoxFit.fitWidth,
              width: 40.w,
            ),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Get.isDarkMode ? Colors.white : Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: 16.sp
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SvgPicture.asset(
              "assets/images/logo.svg",
              fit: BoxFit.fitWidth,
              width: 40.w,
            ),
          ),
          Flexible(
            child: Container(
              width: double.infinity,
              height: 3.h,
              color: sideColor,
            ),
          )
        ],
      ),
    );
  }
}