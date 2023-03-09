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
            SizedBox(height: 10),
            // Text(
            //     "This page will contain reports and trends from your symptom tracking data.\nHere are some samples of what the reports page will look like when detailed data is added in the future.",
            //     style: TextStyle(
            //       color: Color.fromARGB(255, 91, 90, 90),
            //       fontSize: 15.0,
            //     ),
            //     textAlign: TextAlign.center),
            SizedBox(height: 50),
            // SizedBox(
            //   height: 300, // provide a specific height
            //   width: 400,
            //   child:
            //       MyLineChart(getJsonData('reportsData.json', 'temperature')),
            // ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                ),
                Text("Steps",
                    style: TextStyle(
                      color: Color.fromARGB(255, 91, 90, 90),
                      fontSize: 18.0,
                    )),
              ],
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 200, // provide a specific height
              width: 400,
              child: BarChartWidget(
                  chartData: getJsonData('reportsData.json', 'steps')),
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
                    )),
              ],
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 200, // provide a specific height
              width: 400,
              child: BarChartWidget(
                  chartData: getJsonData('reportsData.json', 'temperature')),
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
                    )),
              ],
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 200, // provide a specific height
              width: 400,
              child: BarChartWidget(
                  chartData: getJsonData('reportsData.json', 'cat_score')),
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
                    )),
              ],
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 200, // provide a specific height
              width: 400,
              child: BarChartWidget(
                  chartData: getJsonData('reportsData.json', 'weight')),
            ),
          ],
        ),
      ),
    );
  }

  List<MyData> getJsonData(String dataSource, String symptom) {
    String filePath =
        '/Users/aoifekhan/Documents/fourthYear/fypApp/copd_app/assets/' +
            dataSource;
    final File jsonFile = File(filePath);
    String jsonString = jsonFile.readAsStringSync();
    final List<dynamic> jsonData = jsonDecode(jsonString);

    final List<MyData> chartData = jsonData.map((data) {
      final double catScore =
          data[symptom] != null ? data[symptom].toDouble() : 0.0;
      return MyData(DateTime.parse(data['date']), catScore);
    }).toList();

    return chartData;
  }
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

  BarChartWidget({required this.chartData});

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
