import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../utils/app_dimensions.dart';
import '../../utils/app_images.dart';

class CustomIconBtn extends StatelessWidget {
  String title;
  String? imagePath;
  final Function() onTap;

   CustomIconBtn({required this.title,this.imagePath,required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 45,
        // padding: EdgeInsets.symmetric(
        //   horizontal: Dimensions.paddingSmall,
        //   vertical: Dimensions.paddingSmall,
        // ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: imagePath != null,
              child: SvgPicture.asset(
                imagePath ?? Images.googleCalenderLogo,
                width: 22,
                height: 22,
              ).paddingOnly(right: Dimensions.paddingSmall),
            ),
            Text(title,
              style: TextStyle(
                fontSize: Dimensions.fontDefault,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.secondary,
              ),),
          ],
        ),
      ),
    );
  }
}
