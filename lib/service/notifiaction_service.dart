// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_timezone/flutter_timezone.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:intl/intl.dart';  // For formatting if needed
//
// class NotificationService {
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   // Initialize the plugin
//   Future<void> init() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('@mipmap/ic_launcher'); // Your app icon
//
//     const InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//     );
//
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//
//     // Initialize time zone handling
//     final String timeZoneName = await FlutterTimezone.getLocalTimezone();
//     await FlutterTimezone.getLocalTimezone();
//   }
//
//   // Schedule reminder with a properly adjusted time
//   Future<void> scheduleReminderNotification(DateTime eventStartTime, int reminderMinutes) async {
//     // Adjust for the reminder time
//     final reminderTime = eventStartTime.subtract(Duration(minutes: reminderMinutes));
//
//     // Convert the `DateTime` to local time zone
//     final String location = await FlutterTimezone.getLocalTimezone();
//     final tz.TZDateTime tzDateTime = tz.TZDateTime.from(reminderTime, tz.getLocation(location));
//
//     // Debug log for time zone conversion (optional)
//     print('Event reminder time (Local Timezone): $tzDateTime');
//
//     // Android notification details
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'event_reminders', // Channel ID
//       'Event Reminders', // Channel Name
//       channelDescription: 'Channel for event reminders', // Description
//       importance: Importance.high,
//       priority: Priority.high,
//        // Ensure exact scheduling
//     );
//
//     const NotificationDetails platformDetails = NotificationDetails(
//       android: androidDetails,
//
//     );
//
//     // Schedule the notification
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       0, // Notification ID
//       'Event Reminder',
//       'You have an event in $reminderMinutes minutes!',
//       tzDateTime, // Time to show the notification
//       platformDetails,
//       androidScheduleMode: AndroidScheduleMode.exact,
//
//     );
//   }
// }
