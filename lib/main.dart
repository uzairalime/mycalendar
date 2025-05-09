import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mycalender/helper/route_helper.dart';
import 'package:mycalender/utils/app_constant.dart';
import 'package:mycalender/utils/light_theme.dart';
import 'package:mycalender/view/auth/login_screen.dart';
import 'package:mycalender/view/home_screen.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
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
    // return MaterialApp(
    //   title: AppConstant.appName,
    //   debugShowCheckedModeBanner: false,
    //   theme: lightTheme,
    //   home: StreamBuilder<User?>(stream: FirebaseAuth.instance.authStateChanges(), builder: (context, snapshot) {
    //     if(snapshot.hasData == true){
    //       // final user = snapshot.data;
    //       return HomeScreen();
    //     }
    //     return  LoginScreen();
    //   },),
    // );
  }
}