import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mycalender/helper/route_helper.dart';
import 'package:mycalender/utils/app_dimensions.dart';
import 'package:mycalender/utils/app_images.dart';
import '../../controller/auth_controller.dart';
import '../base/custom_icon_btn.dart';

class LoginScreen extends StatelessWidget {
  AuthController controller = Get.put(AuthController());
  // final AuthController controller = Get.find<AuthController>();
   LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text("Welcome to",style: Theme.of(context).textTheme.headlineMedium,).paddingOnly(
                bottom: Dimensions.paddingExtraSmall
              ),
              Text("My Calender",style: Theme.of(context).textTheme.headlineLarge,),
            ],
          ),
          Column(
            children: [
              CustomIconBtn(
                title: "Continue with Google Calendar",
                imagePath: Images.googleCalenderLogo,
                onTap: () {
                  controller.signInWithGoogle();
                },
              ).paddingOnly(
                bottom: Dimensions.paddingDefault,
              ),
              CustomIconBtn(
                title: "Continue with Microsoft",
                imagePath: Images.outlookCalenderLogo,
                onTap: () =>controller.signInWithMicrosoft(),
                // onTap: ()=> log("Microsoft Sign In");
              ),
            ],
          ),

        ],
      ).paddingSymmetric(
        horizontal: Dimensions.paddingDefault,
        vertical: Dimensions.paddingDefault,
      ),
    );
  }
}
