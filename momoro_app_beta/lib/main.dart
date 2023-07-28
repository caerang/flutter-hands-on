import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:momoro_app_beta/screen/tablecalendar_screen.dart';

void main() async {
  await initializeDateFormatting();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const TableCalendarScreen(),
    );
  }
}