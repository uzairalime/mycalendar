import 'package:get/get.dart';
import 'package:mycalender/view/event_creation_screen.dart';
import '../service/app_binding.dart';
import '../view/home_screen.dart';
import '../view/auth/login_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String eventCreation = '/eventCreation';

  static String getLoginRoute() => login;
  static String getHomeRoute() => home;
  static String getEventCreationRoute() => eventCreation;

  static List<GetPage> routes = [
    GetPage(
      name: login,
      page: () =>  LoginScreen(),
      // binding: AppBinding(),
    ),
    GetPage(
      name: home,
      page: () =>  HomeScreen(),
      // binding: AppBinding(),
    ),
    GetPage(
      name: eventCreation,
      page: () =>  EventCreationScreen(),
    ),
  ];


}