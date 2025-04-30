import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_dimensions.dart';
import '../../utils/app_style.dart';

class CustomButton extends StatelessWidget {
  String title;
  Function()? onTap;
  CustomButton({required this.title, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),

          ),
          alignment: Alignment.center,
          child: Text(title,
              style: textMd.copyWith(
                color: Colors.white,))
              .paddingSymmetric(
            horizontal: Dimensions.paddingSmall,
            vertical: Dimensions.paddingSmall,
          )

      ),
    );
  }
}
