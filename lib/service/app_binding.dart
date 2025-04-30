import 'package:get/get.dart';
import 'package:mycalender/controller/calender_controller.dart';
import '../controller/auth_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies()  {
    // TODO: implement dependencies
    Get.put(() => AuthController());
    Get.put(() => CalController());
  }
}