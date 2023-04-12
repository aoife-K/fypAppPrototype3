//https://pub.dev/packages/table_calendar

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class DiaryPage extends StatefulWidget {
  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  late final ValueNotifier<Map<String, double>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  List _items = [];

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getValuesForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    //_dailyEvents.dispose();
    super.dispose();
  }

  Future<Map<String, double>> _getJsonData(DateTime date) async {
    Map<String, double> emptyData = {
      'CAT Score': 0,
      'Weight (kg)': 0,
      'Steps': 0,
      'SpO2 (%)': 0,
      'Temperature (°C)': 0,
      'FEV1 (%)': 0
    };
    // Read JSON data from file
    var dir = getApplicationDocumentsDirectory();
    File jsonFile = File(
        '/Users/aoifekhan/Documents/fourthYear/fypApp/copd_app/assets/symptoms.json');
    jsonFile.readAsString().then((String contents) {});
    jsonFile.existsSync();
    String jsonString = jsonFile.readAsStringSync();

    // Parse JSON data into a List of maps
    List<dynamic> jsonData = jsonDecode(jsonString);
    print(jsonData.length);

    // Filter maps to find the one with matching date
    Map<String, dynamic> matchingMap = jsonData.firstWhere(
      (map) => DateTime.parse(map['date']).isAtSameMomentAs(date),
      orElse: () => emptyData,
    );

    // If matching map was found, return values
    if (matchingMap != null) {
      Map<String, double> values = {};
      for (var entry in matchingMap.entries) {
        // if (entry.key == 'cat_score') {
        //   values[entry.key] = 0;
        // }
        if (entry.key != 'date') {
          values[entry.key] = entry.value.toDouble();
        }
      }
      return values;
    }

    // If no matching map was found, return empty list
    return emptyData;
  }

  Map<String, double> _getValuesForDay(DateTime day) {
    var hashMap = Map<String, double>();
    hashMap['CAT Score'] = 0;
    hashMap['Weight (kg)'] = 0;
    hashMap['Steps'] = 0;
    hashMap['SpO2 (%)'] = 0;
    hashMap['Temperature (°C)'] = 0;
    hashMap['FEV1 (%)'] = 0;

    //if day is after today, return empty map
    if (day.isAfter(DateTime.now())) {
      return {};
    } else
      return hashMap;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) async {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = await _getJsonData(selectedDay);
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
      _selectedEvents.value = _getValuesForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getValuesForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 70),
          Text('Symptom Diary',
              style: TextStyle(
                  //color: Color.fromARGB(255, 28, 28, 28),
                  fontSize: 20)),
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
              isTodayHighlighted: true,
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
            child: ValueListenableBuilder<Map<String, double>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                if (_focusedDay.isAfter(DateTime.now())) {
                  return Center(
                    child: Text(
                      'No data available! Future data cannot be added.',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  );
                }
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
                      child: EditableListTile(
                        title: (value.keys.elementAt(index)),
                        subtitle:
                            double.parse('${value.values.elementAt(index)}'),
                        onSubtitleChanged: (newSubtitleValue) {
                          setState(() {
                            value[value.keys.elementAt(index)] =
                                newSubtitleValue;
                          });
                          onSubtitleChanged(
                              (value.keys.elementAt(index)), newSubtitleValue);
                        },
                        date: _focusedDay,
                      ),
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

  void onSubtitleChanged(String title, double newSubtitleValue) {
    Map<String, double> events = _selectedEvents.value;
    events[title] = newSubtitleValue;
    _selectedEvents.value = events;
  }
}

//******************** */
class EditableListTile extends StatefulWidget {
  final String title;
  final double subtitle;
  final ValueChanged<double> onSubtitleChanged;
  final DateTime date;

  const EditableListTile({
    required this.title,
    required this.subtitle,
    required this.onSubtitleChanged,
    required this.date,
  });

  @override
  _EditableListTileState createState() => _EditableListTileState();
}

class _EditableListTileState extends State<EditableListTile> {
  bool isEditing = false;
  late TextEditingController _textEditingController;
  Map<String, double> catData = {};

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    String title;

    if (widget.title == 'cat_score') {
      title = 'CAT Score';
    } else if (widget.title == 'weight') {
      title = 'Weight (kg)';
    } else if (widget.title == 'steps') {
      title = 'Steps';
    } else if (widget.title == 'spo2') {
      title = 'SpO2 (%)';
    } else if (widget.title == 'temperature') {
      title = 'Temperature (°C)';
    } else if (widget.title == 'fev1') {
      title = 'FEV1 (%)';
    } else {
      title = widget.title;
    }
    return ListTile(
      title: Text(
        title,
      ),
      subtitle: isEditing
          ? TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                hintText: widget.subtitle.toString(),
              ),
              onChanged: (value) {
                widget.onSubtitleChanged(
                    double.tryParse(value) ?? widget.subtitle);
              },
              style: TextStyle(
                  //color: Color.fromARGB(255, 140, 142, 140),
                  ))
          : Text(widget.subtitle.toString(),
              style: TextStyle(
                //color: Color.fromARGB(255, 49, 50, 49),
                fontSize: 18,
              )),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  String title;
                  String content =
                      'Information about this symptom will appear here, along with acceptable ranges for this symptom.' +
                          '\n';
                  Map<String, double> myMap = _getCatData(widget.date);

                  if (widget.title == 'cat_score') {
                    title = 'CAT Score';
                    content += '\n' + 'Detailed CAT score information: ' + '\n';
                    String tempTitle = '';
                    for (String key in myMap.keys) {
                      final value = myMap[key];
                      if (key == 'date') {
                        tempTitle = 'Date Completed:';
                      } else if (key == 'cough') {
                        tempTitle = 'Cough:';
                      } else if (key == 'phlegm') {
                        tempTitle = 'Phlegm:';
                      } else if (key == 'breathlessness') {
                        tempTitle = 'Breathlessness:';
                      } else if (key == 'tightness') {
                        tempTitle = 'Chest Tightness:';
                      } else if (key == 'activities') {
                        tempTitle = 'Activities:';
                      } else if (key == 'confidence') {
                        tempTitle = 'Confidence:';
                      } else if (key == 'sleep') {
                        tempTitle = 'Sleep:';
                      } else if (key == 'energy') {
                        tempTitle = 'Energy:';
                      } else if (key == 'total') {
                        tempTitle = 'Total:';
                      }
                      if (value != null) {
                        content +=
                            (tempTitle + ' ${value.toStringAsFixed(2)}' + '\n');
                      } else {
                        content += ('${key}: null' + '\n');
                      }
                    }
                  } else if (widget.title == 'weight') {
                    title = 'Weight';
                  } else if (widget.title == 'steps') {
                    title = 'Steps';
                  } else if (widget.title == 'spo2') {
                    title = 'SpO2';
                  } else if (widget.title == 'temperature') {
                    title = 'Temperature';
                  } else if (widget.title == 'fev1') {
                    title = 'FEV1';
                  } else {
                    title = widget.title;
                  }

                  return AlertDialog(
                    title: Text(title),
                    content: Text(content),
                    actions: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          IconButton(
            icon: Icon(isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
              });
              if (!isEditing) {
                final newSubtitle =
                    double.tryParse(_textEditingController.text) ??
                        widget.subtitle;
                print("test" + newSubtitle.toString());
                widget.onSubtitleChanged(newSubtitle);
                _updateJsonFile(widget.title, newSubtitle, widget.date);
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _updateJsonFile(
      String title, double newSubtitle, DateTime date) async {
    Map<String, dynamic> emptyData = {
      'date': "",
      'cat_score': 0,
      'weight': 0,
      'steps': 0,
      'spo2': 0,
      'temperature': 0,
      'fev1': 0
    };

    if (emptyData.containsKey(title)) {
      emptyData[title] = newSubtitle;
      emptyData['date'] = date;
    }

    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String dateEntered = formatter.format(date);
    final file = File(
        '/Users/aoifekhan/Documents/fourthYear/fypApp/copd_app/assets/symptoms.json');
    if (await file.exists()) {
      final jsonContent = await file.readAsString();
      final List<dynamic> data = jsonDecode(jsonContent);
      for (var i = 0; i < data.length; i++) {
        final item = data[i];
        final itemDate = DateTime.parse(item['date']);
        if (itemDate.isAtSameMomentAs(date)) {
          data[i][title] = newSubtitle;
          data[i]['date'] = DateFormat('yyyy-MM-dd').format(date);
          await file.writeAsString(jsonEncode(data));
          return;
        }
      }
    }
  }

  Map<String, double> _getCatData(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String dateEntered = formatter.format(date);
    Map<String, double> emptyData = {
      "cough": 0,
      "phlegm": 0,
      "tightness": 0,
      "breathlessness": 0,
      "activities": 0,
      "confidence": 0,
      "sleep": 0,
      "energy": 0,
      "total": 0
    };

    File jsonFile = File(
        '/Users/aoifekhan/Documents/fourthYear/fypApp/copd_app/assets/cat.json');
    jsonFile.existsSync();
    String jsonString = jsonFile.readAsStringSync();

    // Parse JSON data into a List of maps
    List<dynamic> jsonData = jsonDecode(jsonString);
    print(jsonData.length);

    // Filter maps to find the one with matching date
    Map<String, dynamic> matchingMap = jsonData.firstWhere(
      (map) => DateTime.parse(map['date']).isAtSameMomentAs(date),
      orElse: () => emptyData,
    );

    // If matching map was found, return values
    if (matchingMap != null) {
      Map<String, double> values = {};
      for (var entry in matchingMap.entries) {
        if (entry.key != 'date') {
          values[entry.key] = entry.value.toDouble();
        }
      }
      return values;
    }

    // If no matching map was found, return empty list
    return emptyData;
  }
}
