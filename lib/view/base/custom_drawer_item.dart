import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_dimensions.dart';
import '../../utils/app_style.dart';

class CustomDrawerItem extends StatelessWidget {
  String title;
  String imagePath;
  Function() onTap;
  CustomDrawerItem(
      {required this.title,
      required this.imagePath,
      required this.onTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          SizedBox(
              width: 40,
              height: 40,
              child: SvgPicture.asset(
                imagePath,
              ).paddingOnly(right: Dimensions.paddingDefault)),
          Text(
            title,
            style: textMdBl.copyWith(color: AppColors.secondaryColor),
          )
        ],
      ).paddingOnly(
        bottom: Dimensions.paddingLarge,
      ),
    );
  }
}
