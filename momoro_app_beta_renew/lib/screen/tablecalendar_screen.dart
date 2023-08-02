import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:momoro_app_beta/data_manage_component/db_helper.dart';
import 'package:momoro_app_beta/screen/input_list_first.dart';
//import 'input_list_later.dart';

class TableCalendarScreen extends StatefulWidget {
  const TableCalendarScreen({super.key});

  @override
  State<TableCalendarScreen> createState() => _TableCalendarScreenState();
}

class _TableCalendarScreenState extends State<TableCalendarScreen> {
  DateTime? selectedDay;

  List<Map<String, dynamic>> _dayData = [];
  bool _isLoading = true;

  //
  void _refreshData() async {
    final data = await SQLHelper.getDayData(selectedDay!);
    setState(() {
      _dayData = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedDay = DateTime.now();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: TableCalendar(
        locale: 'ko_KR',
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2029, 12, 31),
        focusedDay: DateTime.now(),
        onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
          setState(() {
            this.selectedDay = selectedDay;
          });

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => InputListFirstScreen(
                      selectedDate: selectedDay,
                    )),
          );

          // showCupertinoDialog(
          //   context: context,
          //   builder: (BuildContext context) {
          //     if (_dayData == null) {
          //       return InputListFirstScreen(
          //         selectedDate: DateTime(
          //           selectedDay.year,
          //           selectedDay.month,
          //           selectedDay.day,
          //         ),
          //       );
          //     } else {
          //       return InputListFirstScreen(
          //         selectedDate: DateTime(
          //           selectedDay.year,
          //           selectedDay.month,
          //           selectedDay.day,
          //         ),
          //       );
          //     }
          //   },
          // );
        },
        selectedDayPredicate: (DateTime date) {
          if (selectedDay == null) {
            return false;
          }

          return date.year == selectedDay!.year &&
              date.month == selectedDay!.month &&
              date.day == selectedDay!.day;
        },
        headerStyle: const HeaderStyle(
          titleCentered: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          formatButtonVisible: false,
        ),
        calendarStyle: const CalendarStyle(
          defaultTextStyle: TextStyle(
            color: Colors.black,
          ),
          weekendTextStyle: TextStyle(
            color: Colors.grey,
          ),
          outsideDaysVisible: false,
          isTodayHighlighted: false,
          todayDecoration: BoxDecoration(
            color: Color(0xFF9FA8DA),
            shape: BoxShape.circle,
          ),
          selectedTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          selectedDecoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
