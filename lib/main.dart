import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mycalender/helper/route_helper.dart';
import 'package:mycalender/service/notifiaction_service.dart';
import 'package:mycalender/utils/app_constant.dart';
import 'package:mycalender/utils/light_theme.dart';

import 'firebase_options.dart';



void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  // NotificationService notificationService = NotificationService();
  // await notificationService.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstant.appName,
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      initialRoute: AppRoutes.getLoginRoute(),
      getPages: AppRoutes.routes,
    );
  }
}