import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mycalender/controller/calender_controller.dart';
import 'package:mycalender/utils/app_dimensions.dart';
import 'package:mycalender/utils/app_images.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'base/custom_drawer_item.dart';

class AppDrawer extends StatelessWidget {
  // CalController controller = Get.put(CalController());
  final CalController controller = Get.find<CalController>();

  AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).drawerTheme.backgroundColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            CustomDrawerItem(
                title: "Month",
                imagePath: Images.listIcon,
                onTap: () {
                  controller.changeCalenderView(
                    CalendarView.month,
                  );
                  Get.back();
                  // log("Calender View ${controller.calenderView}");
                }),
            CustomDrawerItem(
                title: "List",
                imagePath: Images.monthIcon,
                onTap: () {
                  controller.changeCalenderView(
                    CalendarView.workWeek,
                  );
                  Get.back();
                }),
            CustomDrawerItem(
                title: "Month",
                imagePath: Images.weekIcon,
                onTap: () {
                  controller.changeCalenderView(
                    CalendarView.month,
                  );
                  Get.back();
                }),
            CustomDrawerItem(
              title: "Week",
              imagePath: Images.dayIcon,
              onTap: () {
                controller.changeCalenderView(
                  CalendarView.week,
                );
                Get.back();
              },
            ),
            CustomDrawerItem(
              title: "Day",
              imagePath: Images.yearIcon,
              onTap: () {
                controller.changeCalenderView(
                  CalendarView.day,
                );
                Get.back();
              },
            ),
            CustomDrawerItem(
              title: "Search",
              imagePath: Images.searchIcon,
              onTap: () => log("dddd"),
            ),
          ],
        ).paddingSymmetric(
          horizontal: Dimensions.paddingExtraLarge,
          vertical: Dimensions.paddingExtraOverLarge,
        ),
      ),
    );
  }
}
