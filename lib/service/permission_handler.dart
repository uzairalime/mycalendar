import 'package:permission_handler/permission_handler.dart';

Future<void> requestExactAlarmPermission() async {
  final status = await Permission.notification.request();
  if (status.isGranted) {
    // Permission granted
  } else {
    // Handle permission denial
  }
}
