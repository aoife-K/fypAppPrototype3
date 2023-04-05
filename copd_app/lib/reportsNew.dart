//https://pub.dev/packages/fl_chart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'bar_chart.dart';
import 'line_chart.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:convert';
import 'dart:io';

class NewReportsPage extends StatefulWidget {
  const NewReportsPage({super.key});

  @override
  State<NewReportsPage> createState() => _NewReportsPageState();
}

class _NewReportsPageState extends State<NewReportsPage> {
  double _stepsSliderValue = 0;
  double _tempSliderValue = 0;
  double _catSliderValue = 0;
  double _weightSliderValue = 0;
  int stepsRange = 0;
  int tempRange = 0;
  int catRange = 0;
  int weightRange = 0;

  void _onStepsSliderValueChanged(double value) {
    setState(() {
      _stepsSliderValue = value;
      stepsRange = value.toInt();
      //print(stepsRange);
    });
  }

  void _onTempSliderValueChanged(double value) {
    setState(() {
      _tempSliderValue = value;
      tempRange = value.toInt();
      //print(tempRange);
    });
  }

  void _onCatSliderValueChanged(double value) {
    setState(() {
      _catSliderValue = value;
      catRange = value.toInt();
      //print(catRange);
    });
  }

  void _onWeightSliderValueChanged(double value) {
    setState(() {
      _weightSliderValue = value;
      weightRange = value.toInt();
      //print(weightRange);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 60),
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BackButton(),
                Padding(padding: EdgeInsets.only(left: 120)),
                Text("Reports",
                    style: TextStyle(
                      color: Color.fromARGB(255, 91, 90, 90),
                      fontSize: 25.0,
                    )),
              ],
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                ),
                Text("Steps",
                    style: TextStyle(
                      color: Color.fromARGB(255, 91, 90, 90),
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                ),
                Text(
                    "Daily Average: " +
                        getAverageSymptomScore(
                                'symptoms.json', 'steps', stepsRange, 0)
                            .toString(),
                    style: TextStyle(
                      color: Color.fromARGB(255, 91, 90, 90),
                      fontSize: 16.0,
                    )),
              ],
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 200, // provide a specific height
              width: 400,
              child: BarChartWidget(
                chartData: getJsonData('symptoms.json', 'steps', stepsRange),
                color: Color.fromARGB(255, 90, 188, 208),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 10, // provide a specific height
              width: 200,
              child: Slider(
                value: _stepsSliderValue.toDouble(),
                min: 0,
                max: 2,
                divisions: 2,
                onChanged: _onStepsSliderValueChanged,
                label: _stepsSliderValue == 0
                    ? '1 Week'
                    : _stepsSliderValue == 1
                        ? '2 Weeks'
                        : '1 Month',
                activeColor: Color.fromARGB(
                    255, 138, 199, 205), // Sets the active color of the slider
                inactiveColor: Color.fromARGB(255, 222, 221,
                    221), // Sets the inactive color of the slider
              ),
            ),
            Text(
              _stepsSliderValue == 0
                  ? '1 week'
                  : _stepsSliderValue == 1
                      ? '2 weeks'
                      : '1 month',
              style: TextStyle(
                color: Color.fromARGB(255, 91, 90, 90),
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 50),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                ),
                Text("Temperature",
                    style: TextStyle(
                      color: Color.fromARGB(255, 91, 90, 90),
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                ),
                Text(
                    "Daily Average: " +
                        getAverageSymptomScore(
                                'symptoms.json', 'temperature', tempRange, 1)
                            .toString(),
                    style: TextStyle(
                      color: Color.fromARGB(255, 91, 90, 90),
                      fontSize: 16.0,
                    )),
              ],
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 200, // provide a specific height
              width: 400,
              child: BarChartWidget(
                chartData:
                    getJsonData('symptoms.json', 'temperature', tempRange),
                color: Color.fromARGB(255, 245, 150, 143),
              ),
            ),
            //SizedBox(10),
            SizedBox(
              height: 10, // provide a specific height
              width: 200,
              child: Slider(
                value: _tempSliderValue.toDouble(),
                min: 0,
                max: 2,
                divisions: 2,
                onChanged: _onTempSliderValueChanged,
                label: _tempSliderValue == 0
                    ? '1 Week'
                    : _tempSliderValue == 1
                        ? '2 Weeks'
                        : '1 Month',
                activeColor: Color.fromARGB(
                    255, 248, 177, 166), // Sets the active color of the slider
                inactiveColor: Color.fromARGB(255, 222, 221,
                    221), // Sets the inactive color of the slider
              ),
            ),
            Text(
              _tempSliderValue == 0
                  ? '1 week'
                  : _tempSliderValue == 1
                      ? '2 weeks'
                      : '1 month',
              style: TextStyle(
                color: Color.fromARGB(255, 91, 90, 90),
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 50),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                ),
                Text("CAT Score",
                    style: TextStyle(
                      color: Color.fromARGB(255, 91, 90, 90),
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                ),
                Text(
                    "Daily Average: " +
                        getAverageSymptomScore(
                                'symptoms.json', 'cat_score', catRange, 0)
                            .toString(),
                    style: TextStyle(
                      color: Color.fromARGB(255, 91, 90, 90),
                      fontSize: 16.0,
                    )),
              ],
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 200, // provide a specific height
              width: 400,
              child: BarChartWidget(
                chartData: getJsonData('symptoms.json', 'cat_score', catRange),
                color: Color.fromARGB(255, 145, 222, 150),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 10, // provide a specific height
              width: 200,
              child: Slider(
                value: _catSliderValue.toDouble(),
                min: 0,
                max: 2,
                divisions: 2,
                onChanged: _onCatSliderValueChanged,
                label: _catSliderValue == 0
                    ? '1 Week'
                    : _catSliderValue == 1
                        ? '2 Weeks'
                        : '1 Month',
                activeColor: Color.fromARGB(
                    255, 157, 204, 144), // Sets the active color of the slider
                inactiveColor: Color.fromARGB(255, 222, 221, 221),
              ),
            ),
            Text(
              _catSliderValue == 0
                  ? '1 Week'
                  : _catSliderValue == 1
                      ? '2 Weeks'
                      : '1 Month',
              style: TextStyle(
                color: Color.fromARGB(255, 91, 90, 90),
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 50),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                ),
                Text("Weight",
                    style: TextStyle(
                      color: Color.fromARGB(255, 91, 90, 90),
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                ),
                Text(
                    "Daily Average: " +
                        getAverageSymptomScore(
                                'symptoms.json', 'weight', weightRange, 1)
                            .toString(),
                    style: TextStyle(
                      color: Color.fromARGB(255, 91, 90, 90),
                      fontSize: 16.0,
                    )),
              ],
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 200, // provide a specific height
              width: 400,
              child: BarChartWidget(
                chartData: getJsonData('symptoms.json', 'weight', weightRange),
                color: Color.fromARGB(255, 249, 198, 132),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 10, // provide a specific height
              width: 200,
              child: Slider(
                value: _weightSliderValue.toDouble(),
                min: 0,
                max: 2,
                divisions: 2,
                onChanged: _onWeightSliderValueChanged,
                label: _weightSliderValue == 0
                    ? '1 Week'
                    : _weightSliderValue == 1
                        ? '2 Weeks'
                        : '1 Month',
                activeColor: Color.fromARGB(
                    255, 248, 211, 166), // Sets the active color of the slider
                inactiveColor: Color.fromARGB(255, 222, 221, 221),
              ),
            ),
            Text(
              _weightSliderValue == 0
                  ? '1 week'
                  : _weightSliderValue == 1
                      ? '2 weeks'
                      : '1 month',
              style: TextStyle(
                color: Color.fromARGB(255, 91, 90, 90),
                fontSize: 18.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // List<MyData> getJsonData(String dataSource, String symptom) {
  //   String filePath =
  //       '/Users/aoifekhan/Documents/fourthYear/fypApp/copd_app/assets/' +
  //           dataSource;
  //   final File jsonFile = File(filePath);
  //   String jsonString = jsonFile.readAsStringSync();
  //   final List<dynamic> jsonData = jsonDecode(jsonString);

  //   final List<MyData> chartData = jsonData.map((data) {
  //     final double catScore =
  //         data[symptom] != null ? data[symptom].toDouble() : 0.0;
  //     return MyData(DateTime.parse(data['date']), catScore);
  //   }).toList();

  //   return chartData;
  // }

  List<MyData> getJsonData(String dataSource, String symptom, int range) {
    String filePath =
        '/Users/aoifekhan/Documents/fourthYear/fypApp/copd_app/assets/$dataSource';
    final File jsonFile = File(filePath);
    String jsonString = jsonFile.readAsStringSync();
    final List<dynamic> jsonData = jsonDecode(jsonString);

    DateTime startDate;
    if (range == 0) {
      startDate = DateTime.now().subtract(Duration(days: 8));
    } else if (range == 1) {
      startDate = DateTime.now().subtract(Duration(days: 15));
    } else if (range == 2) {
      startDate = DateTime.now().subtract(Duration(days: 31));
    } else {
      throw Exception("Invalid range value");
    }

    final List<MyData> chartData = jsonData.map((data) {
      final DateTime date = DateTime.parse(data['date']);
      final double symptomValue =
          data[symptom] != null ? data[symptom].toDouble() : 0.0;
      return MyData(date, symptomValue);
    }).toList();

    List<MyData> filteredData = chartData.where((data) {
      return data.date.isAfter(startDate);
    }).toList();

    return filteredData;
  }

  double getAverageSymptomScore(
      String dataSource, String symptom, int range, int decimalPlaces) {
    String filePath =
        '/Users/aoifekhan/Documents/fourthYear/fypApp/copd_app/assets/' +
            dataSource;
    final File jsonFile = File(filePath);
    String jsonString = jsonFile.readAsStringSync();
    final List<dynamic> jsonData = jsonDecode(jsonString);

    DateTime startDate;
    if (range == 0) {
      startDate = DateTime.now().subtract(Duration(days: 7));
    } else if (range == 1) {
      startDate = DateTime.now().subtract(Duration(days: 14));
    } else if (range == 2) {
      startDate = DateTime.now().subtract(Duration(days: 30));
    } else {
      throw Exception("Invalid range value");
    }

    double totalScore = 0;
    int count = 0;

    jsonData.forEach((data) {
      final DateTime date = DateTime.parse(data['date']);
      final double catScore =
          data[symptom] != null ? data[symptom].toDouble() : 0.0;

      if (date.isAfter(startDate)) {
        totalScore += catScore;
        count++;
      }
    });

    if (count == 0) {
      return 0;
    }

    double averageScore = totalScore / count;

    return double.parse(averageScore.toStringAsFixed(decimalPlaces));
  }

//   List<MyData?> getJsonData(String dataSource, String symptom, int range) {
//   String filePath =
//       '/Users/aoifekhan/Documents/fourthYear/fypApp/copd_app/assets/' +
//           dataSource;
//   final File jsonFile = File(filePath);
//   String jsonString = jsonFile.readAsStringSync();
//   final List<dynamic> jsonData = jsonDecode(jsonString);
//   //List<MyData> emptyData = List<MyData>.filled(7, ['2023-02-01', 0]);

//   final DateTime now = DateTime.now();
//   DateTime startDate = now;

//   switch (range) {
//     case 0: // last week
//       startDate = now.subtract(Duration(days: 7));
//       break;
//     case 1: // last two weeks
//       startDate = now.subtract(Duration(days: 14));
//       break;
//     case 2: // last month
//       startDate = now.subtract(Duration(days: 30));
//       break;
//     default: // invalid range, return empty list
//       //return emptyData;
//   }

//   final List<MyData?> chartData = jsonData
//       .map((data) {
//         final DateTime date = DateTime.parse(data['date']);
//         if (date.isAfter(startDate)) {
//           final double catScore =
//               data[symptom] != null ? data[symptom].toDouble() : 0.0;
//           return MyData(date, catScore);
//         } else {
//           return null;
//         }
//       })
//       .where((data) => data != null)
//       .toList();

//   return chartData;
// }

}

class MyData {
  final DateTime date;
  final double value;

  MyData(this.date, this.value);
}

class MyLineChart extends StatelessWidget {
  final List<MyData> data;

  MyLineChart(this.data);

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      [
        charts.Series<MyData, DateTime>(
          id: 'MyData',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (MyData data, _) => data.date,
          measureFn: (MyData data, _) => data.value,
          data: data,
        ),
      ],
      animate: true,
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      primaryMeasureAxis: const charts.NumericAxisSpec(
        tickProviderSpec: charts.BasicNumericTickProviderSpec(zeroBound: false),
      ),
    );
  }
}

// class BarChartWidget extends StatelessWidget {
//   final List<MyData> chartData;

//   BarChartWidget({required this.chartData});

//   @override
//   Widget build(BuildContext context) {
//     List<charts.Series<MyData, DateTime>> seriesList = [
//       charts.Series<MyData, DateTime>(
//         id: 'Score',
//         domainFn: (MyData data, _) => data.date,
//         measureFn: (MyData data, _) => data.value,
//         data: chartData,
//       ),
//     ];

//     return charts.TimeSeriesChart(
//       seriesList,
//       animate: true,
//       animationDuration: const Duration(milliseconds: 500),
//       defaultRenderer: charts.BarRendererConfig<DateTime>(),
//     );
//   }
// }

class BarChartWidget extends StatefulWidget {
  final List<MyData> chartData;
  final Color color;

  BarChartWidget({required this.chartData, required this.color});

  @override
  _BarChartWidgetState createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> {
  DateTime? _selectedDate;
  double? _selectedValue;

  @override
  Widget build(BuildContext context) {
    List<charts.Series<MyData, DateTime>> seriesList = [
      charts.Series<MyData, DateTime>(
        id: 'Score',
        domainFn: (MyData data, _) => data.date,
        measureFn: (MyData data, _) => data.value,
        data: widget.chartData,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(widget.color),
      ),
    ];

    return Stack(
      children: [
        GestureDetector(
          onTapUp: _onTapUp,
          child: charts.TimeSeriesChart(
            seriesList,
            animate: true,
            animationDuration: const Duration(milliseconds: 500),
            defaultRenderer: charts.BarRendererConfig<DateTime>(),
            selectionModels: [
              charts.SelectionModelConfig(
                type: charts.SelectionModelType.info,
                changedListener: _onSelectionChanged,
              )
            ],
          ),
        ),
        _buildSelectedValue(),
      ],
    );
  }

  void _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    if (selectedDatum.isNotEmpty) {
      setState(() {
        _selectedDate = selectedDatum.first.datum.date;
        _selectedValue = selectedDatum.first.datum.value;
      });
    } else {
      setState(() {
        _selectedDate = null;
        _selectedValue = null;
      });
    }
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _selectedDate = null;
      _selectedValue = null;
    });
  }

  Widget _buildSelectedValue() {
    if (_selectedValue != null) {
      return Positioned(
        top: 0,
        right: 0,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.9),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '${_selectedValue!.toStringAsFixed(2)}',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
