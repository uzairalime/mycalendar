import 'package:flutter/material.dart';
import 'dart:async';

import 'package:get/get.dart';
import 'package:mycalender/helper/route_helper.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {

      Get.offAllNamed(AppRoutes.getLoginRoute());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/logo.png', // Add your logo here in assets
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}

