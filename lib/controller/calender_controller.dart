import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:mycalender/controller/auth_controller.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalController extends GetxController {

  RxBool isFetchingEvents = false.obs;
  RxString currentTimeZone = ''.obs;
  var appointments = <Appointment>[].obs;
  Rx<CalendarView> calenderView = CalendarView.month.obs;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void onInit() async{
    super.onInit();
  }
  /// Event Details
  void showEventDetailsDialog(BuildContext context, Appointment event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(event.subject),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Description: ${event.notes ?? 'No description'}"),
            Text("Start: ${event.startTime}"),
            Text("End: ${event.endTime}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
          TextButton(
            onPressed: () {
              final userEmail = Get.find<AuthController>().getUserEmail;
              print("object${userEmail}");
              print("object${event.location}");
              if(userEmail == event.location){
                deleteEvent(event.location.toString(), event.id.toString());
                checkEventExistence(event.location.toString(), event.id.toString());
                print("event id ${event.id.toString()}${event.location.toString()}");
                Navigator.pop(context);
              }else{
                print("You are not authorized to delete this event");
                Navigator.pop(context);
              }

            },
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }
  /// Fetch all events from the calendar
  Future<void> fetchAllEvents() async {
    try {
      isFetchingEvents.value = true;
      appointments.clear();

      final now = DateTime.now();
      final start = DateTime(now.year - 1, now.month, now.day);
      final end = DateTime(now.year + 1, now.month, now.day);
      // Get all calendars
      final calendarList = await Get.find<AuthController>().calendarApi.calendarList.list();
      for (var cal in calendarList.items!) {
        final events = await Get.find<AuthController>().calendarApi.events.list(
          cal.id!,
          timeMin: start.toUtc(),
          timeMax: end.toUtc(),
          singleEvents: true,
          orderBy: 'startTime',
        );
        if (events.items == null) continue;

        appointments.addAll(events.items!.map((event) {
          final startTime = event.start?.dateTime ?? DateTime.parse(event.start!.date!.toString());
          final endTime = event.end?.dateTime ?? DateTime.parse(event.end!.date!.toString());

          return Appointment(
            id: event.id,
            location: cal.id,
            recurrenceId: event.creator?.email??'',
            startTime: startTime,
            endTime: endTime,
            subject: event.summary ?? 'No Title',
            notes: event.description ?? '',
            color: getRandomColor(),
          );
        }).toList());
      }
      print('Total Events Loaded: ${appointments.length}');
    } catch (e) {
      isFetchingEvents.value = true;
      print('Error fetching events: $e');
    }
  }
  /// Create an event
  Future<void> createEvent(String title, String description, DateTime startTime, DateTime endTime) async {
    try {
      final event = calendar.Event(
        summary: title,
        description: description,
        start: calendar.EventDateTime(
          dateTime: startTime,
          // timeZone: startTime.timeZoneName, // You can change timezone
        ),
        end: calendar.EventDateTime(
          dateTime: endTime,
          // timeZone: endTime.timeZoneName,
        ),
      );

      await Get.find<AuthController>().calendarApi.events.insert(event, 'primary');
      print("Event created: ${event.id}");
      print("Event created: ${event.summary}");
      await fetchAllEvents(); // Refresh after create
    } catch (e) {
      print('Error creating event: $e');
    }
  }
  /// Delete an event by ID
  Future<void> deleteEvent(calendarId, eventId) async {
    try {

      await Get.find<AuthController>().calendarApi.events.delete(calendarId, eventId);
      await fetchAllEvents(); // Refresh after delete
    } catch (e) {
      print('Failed to Delete event: $e');
    }
  }
  /// Check if an event exists by ID
  Future<void> checkEventExistence(calendarId, eventId) async {
    try {
      // Fetch the event by ID to check if it exists
      final event = await Get.find<AuthController>().calendarApi.events.get(calendarId, eventId,alwaysIncludeEmail: true,);
      // final event = await Get.find<AuthController>().calendarApi.events.get(, eventId);
      print('Event found: ${event.summary}');
      // print("d${event.items?[0].status}");
    } catch (e) {
      print('Event not found: $e');
    }
  }
  /// event Details
  void showEventDetails(Appointment appointment) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${appointment.subject}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Start: ${appointment.startTime}'),
            Text('End: ${appointment.endTime}'),
            SizedBox(height: 10),
            Text('Description: ${appointment.notes ?? "No description"}'),
          ],
        ),
      ),
    );
  }
  /// Calender view
  void changeCalenderView(CalendarView view) {
    calenderView.value = view;
  }
  /// Color
  Color getRandomColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(255),
      random.nextInt(255),
      random.nextInt(255),
    );
  }
  /// Date formatter


}
