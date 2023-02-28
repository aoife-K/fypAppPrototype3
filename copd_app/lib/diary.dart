import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class DiaryPage extends StatefulWidget {
  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  late final ValueNotifier<List<String>> _selectedEvents;
  //late final ValueNotifier<List<String>> _dailyEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    //_dailyEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    //_dailyEvents.dispose();
    super.dispose();
  }

  List<String> _getEventsForDay(DateTime day) {
    // Implementation example
    List<String> symptoms = [
      "CAT Score: 20",
      "Weight (kg): 75",
      "Steps: 4826",
      "SpO2 (%): 98",
      "Temperature (°C): 37.5",
      "FEV1 (%): 68"
    ];
    var hashMap = Map<String, dynamic>();
    hashMap['CAT'] = [];
    hashMap['Weight (kg)'] = 30;
    hashMap['Steps'] = 4048;
    hashMap['SpO2 (%)'] = 98;
    hashMap['Temperature (°C)'] = 37.5;
    hashMap['FEV1 (%)'] = 80;
    return symptoms;
  }

  List<String> _getValuesForDay(DateTime day) {
    // Implementation example
    List<String> symptoms = ["", "75", "4826", "98", "37.5", "68"];
    return symptoms;
  }

  // List<Event> _getEventsForRange(DateTime start, DateTime end) {
  //   // Implementation example
  //   final days = daysInRange(start, end);

  //   return [
  //     for (final d in days) ..._getEventsForDay(d),
  //   ];
  // }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
      //_dailyValues.value = _getValuesForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      //_selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Symptom Diary'),
      ),
      body: Column(
        children: [
          TableCalendar<String>(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            //eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              // Use `CalendarStyle` to customize the UI
              outsideDaysVisible: false,
            ),
            onDaySelected: _onDaySelected,
            onRangeSelected: _onRangeSelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<String>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      // children: ExpansionTile(
                      //   title: const Text('Jane Doe'),
                      //   subtitle: const Text('Physician'),
                      //   leading: Icon(Icons.person),
                      //   trailing: Icon(
                      //     _customTileExpanded ? Icons.more_vert : Icons.more_vert,
                      //   ),
                      //   children: const <Widget>[
                      //     ListTile(
                      //         title:
                      //             Text('Phone: 123-456-7890 \nEmail: janedoe@gmail.com')),
                      //   ],
                      //   onExpansionChanged: (bool expanded) {
                      //     setState(() => _customTileExpanded = expanded);
                      //   },
                      // ),
                      child: EditableListTile(
                        title: ('${value[index]}'),
                        //subtitle: (''),
                      ),
                      // ListTile(
                      //   onTap: () => print('${value[index]}'),
                      //   title: Text('${value[index]}'),
                      //   trailing: Icon(Icons.edit),
                      // ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class EditableListTile extends StatefulWidget {
  String title;
  //String subtitle;

  EditableListTile({required this.title});

  @override
  _EditableListTileState createState() => _EditableListTileState();
}

class _EditableListTileState extends State<EditableListTile> {
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: isEditing
          ? TextField(
              decoration: InputDecoration(
                hintText: widget.title,
              ),
              onChanged: (value) {
                setState(() {
                  widget.title = value;
                });
              },
            )
          : Text(widget.title),
      // subtitle: isEditing
      //     ? TextField(
      //         decoration: InputDecoration(
      //           hintText: widget.subtitle,
      //         ),
      //         onChanged: (value) {
      //           setState(() {
      //             widget.subtitle = value;
      //           });
      //         },
      //       )
      //     : Text(widget.subtitle),
      trailing: IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          setState(() {
            isEditing = !isEditing;
          });
        },
      ),
    );
  }
}
