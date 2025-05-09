import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mycalender/controller/auth_controller.dart';
import 'package:mycalender/helper/route_helper.dart';
import 'package:mycalender/utils/app_dimensions.dart';
import 'package:mycalender/utils/app_images.dart';
import 'package:mycalender/utils/app_style.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../controller/calender_controller.dart';
import 'app_drawer.dart';
import 'event_creation_screen.dart';

class HomeScreen extends StatelessWidget {
  final CalController controller = Get.put(CalController());
  final AuthController authController = Get.put(AuthController());
  // final CalController controller = Get.find();
  // final AuthController authController = Get.find();

  HomeScreen({super.key}) {
    controller.fetchAllEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title:  Text(authController.getUserName),
        titleTextStyle: textMdBl.copyWith(fontWeight: FontWeight.w700),
        centerTitle: true,
        actions: [
          InkWell(
            // onTap: ()=>Get.toNamed(AppRoutes.getEventCreationRoute()),
            // onTap: ()=>controller.fetchAllEvents(),
            onTap: ()=>controller.fetchAllEventsMicrosoft(),
            child: SvgPicture.asset(
              Images.addIcon,
              width: 25,
            ).paddingOnly(right: Dimensions.paddingDefault),
          ),
          SvgPicture.asset(Images.filterIcon, width: 25)
              .paddingOnly(right: Dimensions.paddingDefault),
          InkWell(
              onTap: () => authController.logoutDialog(context),
              child: Icon(Icons.login_outlined)
                  .paddingOnly(right: Dimensions.paddingDefault)),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
            thickness: 1,
            height: 1,
            color: Colors.black.withOpacity(0.2),
          ),
        ),
      ),
      body: Obx(() => Column(
            children: [
              Visibility(
                visible: controller.appointments.isEmpty,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: LinearProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              Expanded(
                child: Obx(()=> SfCalendar(
                  key: ValueKey(controller.calenderView.value),
                  view: controller.calenderView.value,
                  showTodayButton: true,
                  // timeZone: controller.currentTimeZone.value,
                  initialSelectedDate: DateTime.now(),
                  dataSource: MeetingDataSource(controller.appointments),
                 headerStyle: CalendarHeaderStyle(
                   backgroundColor: Theme.of(context).primaryColor,
                   textStyle: textMd.copyWith(
                     color: Colors.white,
                   ),
                 ),
                  initialDisplayDate: DateTime.now(),
                  showCurrentTimeIndicator: true,
                  monthViewSettings: MonthViewSettings(
                    showTrailingAndLeadingDates: false,
                    appointmentDisplayMode: MonthAppointmentDisplayMode.none,

                  ),
                  onTap: (details) {
                    if (details.targetElement == CalendarElement.calendarCell) {
                      Get.to(() =>
                          EventCreationScreen(selectedDate: details.date!));
                    } else if (details.targetElement ==
                        CalendarElement.appointment) {
                      final Appointment event = details.appointments!.first;
                      controller.showEventDetails(event);
                    }
                  },
                  monthCellBuilder: (context, details) {
                    final dayAppointments = controller.appointments.where((app) {
                      final localStart = app.startTime.toLocal();
                      return localStart.year == details.date.year &&
                          localStart.month == details.date.month &&
                          localStart.day == details.date.day;
                    }).toList();
                    return Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.withOpacity(0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              '${details.date.day}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 2),
                          if (dayAppointments.isNotEmpty)
                            ...dayAppointments
                                .take(2)
                                .map((app) => GestureDetector(
                                      onTap: () => controller
                                          .showEventDetailsDialog(context, app),
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 2),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4, vertical: 2),
                                        decoration: BoxDecoration(
                                          // color: app.color.withOpacity(0.7),
                                          // color: controller.getRandomColor(),
                                          color: Theme.of(context).primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          app.subject,
                                          style: const TextStyle(
                                            fontSize: 8,
                                            color: Colors.white,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          maxLines: 1,
                                        ),
                                      ),
                                    )),
                        ],
                      ),
                    );
                  },
                ),
              ),)
            ],
          )),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
