import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mycalender/controller/calender_controller.dart';
import 'package:mycalender/view/base/custom_button.dart';
import 'package:mycalender/view/base/custom_text_field.dart';

import '../helper/route_helper.dart';
import '../utils/app_dimensions.dart';
import '../utils/app_images.dart';
import '../utils/app_style.dart';

class EventCreationScreen extends StatefulWidget {
  final DateTime? selectedDate;

  const EventCreationScreen({this.selectedDate});

  @override
  _EventCreationScreenState createState() => _EventCreationScreenState();
}

class _EventCreationScreenState extends State<EventCreationScreen> {
  final CalController controller = Get.put(CalController());

  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _startDate = TextEditingController();
  final TextEditingController _endDate = TextEditingController();
  final TextEditingController _startTime = TextEditingController();
  final TextEditingController _endTime = TextEditingController();
  final List<int> reminderOptions = [15, 30, 60, 120];
  int? selectedReminder = 15;
  @override
  void initState() {
    super.initState();
    _startDate.text =
        DateFormat("yyyy-MM-dd").format(widget.selectedDate ?? DateTime.now());
    _endDate.text = DateFormat("yyyy-MM-dd").format(
        widget.selectedDate?.add(const Duration(hours: 1)) ??
            DateTime.now().add(const Duration(hours: 1)));
    _startTime.text = "00:00";
    _endTime.text = "00:00";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Create Event"),
        titleTextStyle: textMdBl.copyWith(fontWeight: FontWeight.w700),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
            thickness: 1,
            height: 1,
            color: Colors.black.withOpacity(0.2),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
                controller: _title,
                hintText: "Enter title",
                labelText: "Title"),
            CustomTextField(
                controller: _description,
                hintText: "Enter Description",
                labelText: "Description"),
            CustomTextField(
              controller: _startDate,
              hintText: "Select Start Date",
              labelText: "Start Date",
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: widget.selectedDate,
                  firstDate: DateTime(2022),
                  lastDate: DateTime(2100),
                );
                if (picked != null && picked != widget.selectedDate) {
                  setState(() {
                    _startDate.text =
                        DateFormat("yyyy-MM-dd").format(picked);
                  });
                }
              },
            ),
            CustomTextField(
              controller: _endDate,
              hintText: "Select end date",
              labelText: "End Date",
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate:
                  widget.selectedDate?.add(const Duration(hours: 1)) ??
                      DateTime.now().add(const Duration(hours: 1)),
                  firstDate: DateTime(2022),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    _endDate.text =
                        DateFormat("yyyy-MM-dd").format(picked);
                  });
                }
              },
            ),
            CustomTextField(
              controller: _startTime,
              hintText: "Select start time",
              labelText: "Start Time",
              onTap: () async {
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  setState(() {
                    _startTime.text = "${pickedTime.hour}:${pickedTime.minute}";
                  });
                  if(pickedTime.hour < 9 || pickedTime.minute < 9){
                    _startTime.text = "0${pickedTime.hour}:${pickedTime.minute}";
                  }
                }

              },
            ),
            CustomTextField(
                controller: _endTime,
                hintText: "Select end time",
                labelText: "End Time",
                onTap: () async {
                  final TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      _endTime.text = "${pickedTime.hour}:${pickedTime.minute}";
                    });
                    if(pickedTime.hour < 9 || pickedTime.minute < 9){
                      _endTime.text = "0${pickedTime.hour}:${pickedTime.minute}";
                    }
                  }
                }),
            Container(
              height: 55,
              padding:
              EdgeInsets.symmetric(horizontal: Dimensions.paddingSmall),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
              child: DropdownButton<int>(
                menuWidth: double.infinity,
                isExpanded: true,
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                underline: const SizedBox(),
                value: selectedReminder,
                onChanged: (int? newValue) {
                  setState(() {
                    selectedReminder = newValue;
                  });
                },
                items: reminderOptions.map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text('$value minutes'),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            CustomButton(
              title: "Save Event",
              onTap: () async {
                if (_title.text.trim().isEmpty) {
                  Get.snackbar('Error', 'Title is required',colorText: Colors.black);
                  return;
                }
                log("message${_startDate.text} ${_startTime.text}");
                log("message${_endDate.text} ${_endTime.text}");

                // final start = DateTime.parse("${_startDate.text} ${_startTime.text}");
                // final end = DateTime.parse("${_endDate.text} ${_endTime.text}");
                // log("message${DateFormat("yyyy-MM-dd HH:mm").format(start)}");
                final _startDateTime = DateFormat("yyyy-MM-dd HH:mm").parse("${_startDate.text} ${_startTime.text}");
                final _endDateTime = DateFormat("yyyy-MM-dd HH:mm").parse("${_endDate.text} ${_endTime.text}");
                final reminderTime =_startDateTime.subtract(Duration(minutes: selectedReminder!));
                final _reminderDateTime = DateFormat("yyyy-MM-dd HH:mm").format(reminderTime);

                await controller.createEvent(
                  _title.text,
                  _description.text,
                  _startDateTime,
                  _endDateTime,
                );
                Get.back();
              },
            )

          ],
        ),
      ),
    );
  }
}
