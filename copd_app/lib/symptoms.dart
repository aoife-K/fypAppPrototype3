// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';

// class DiaryPage extends StatefulWidget {
//   @override
//   State<DiaryPage> createState() => _DiaryPageState();
// }

// class _DiaryPageState extends State<DiaryPage> {
//   late final ValueNotifier<Map<String, double>> _selectedEvents;
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
//       .toggledOff; // Can be toggled on/off by longpressing a date
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;
//   DateTime? _rangeStart;
//   DateTime? _rangeEnd;
//   late final TextEditingController _symptomsController;

//   @override
//   void initState() {
//     super.initState();

//     _selectedDay = _focusedDay;
//     _selectedEvents = ValueNotifier(_getValuesForDay(_selectedDay!));
//     _symptomsController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     _selectedEvents.dispose();
//     _symptomsController.dispose();
//     super.dispose();
//   }

//   Map<String, double> _getValuesForDay(DateTime day) {
//     // Implementation example
//     var hashMap = Map<String, double>();
//     hashMap['CAT Score'] = 0;
//     hashMap['Weight (kg)'] = 30;
//     hashMap['Steps'] = 4048;
//     hashMap['SpO2 (%)'] = 98;
//     hashMap['Temperature (°C)'] = 37.5;
//     hashMap['FEV1 (%)'] = 80;
//     return hashMap;
//   }

//   Future<void> _saveSymptoms(Map<String, dynamic> symptoms) async {
//     final file = File('${(await getApplicationDocumentsDirectory()).path}/symptoms.json');
//     await file.writeAsString(jsonEncode(symptoms));
//   }

//   Future<Map<String, dynamic>> _loadSymptoms() async {
//     final file = File('${(await getApplicationDocumentsDirectory()).path}/symptoms.json');
//     if (file.existsSync()) {
//       final contents = await file.readAsString();
//       return jsonDecode(contents);
//     }
//     return {};
//   }

//   void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
//     if (!isSameDay(_selectedDay, selectedDay)) {
//       setState(() {
//         _selectedDay = selectedDay;
//         _focusedDay = focusedDay;
//         _rangeStart = null; // Important to clean those
//         _rangeEnd = null;
//         _rangeSelectionMode = RangeSelectionMode.toggledOff;
//       });

//       _loadSymptoms().then((symptoms) {
//         final values = _getValuesForDay(selectedDay);
//         for (final key in values.keys) {
//           values[key] = symptoms[key] ?? 0;
//         }
//         _selectedEvents.value = values;
//       });
//     }
//   }

//   void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
//     setState(() {
//       _selectedDay = null;
//       _focusedDay = focusedDay;
//       _rangeStart = start;
//       _rangeEnd = end;
//       _rangeSelectionMode = RangeSelectionMode.toggledOn;
//     });

//     // `start` or `end` could be null
//     if (start != null && end != null) {
//       // TODO: _selectedEvents.value = _getEventsForRange(start, end);
//     } else if (start != null) {
//       _loadSymptoms().then((symptoms) {
//         final values = _getValuesForDay(start
