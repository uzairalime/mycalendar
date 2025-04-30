import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mycalender/utils/app_dimensions.dart';

class CustomTextField extends StatelessWidget {
  TextEditingController controller;
  String labelText;
  String hintText;
  Widget? prefixIcon;
  Widget? suffixIcon;
  Function()? onTap;

   CustomTextField({required this.controller, required this.hintText, required this.labelText,this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onTap: onTap,
      readOnly: onTap != null,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            )
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
                width: 2
            )
        ),
        errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.red,
                width: 2
            )
        ),
      ),

    ).paddingOnly(
      bottom: Dimensions.paddingDefault
    );
  }
}
