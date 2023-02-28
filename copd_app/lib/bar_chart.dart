// import 'package:fl_chart_app/presentation/resources/app_resources.dart';
// import 'package:fl_chart_app/presentation/widgets/legend_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartSample6 extends StatelessWidget {
  BarChartSample6({super.key});

  final pilateColor = Colors.green;
  final cyclingColor = Colors.cyan;
  final quickWorkoutColor = Colors.orange;
  final betweenSpace = 0.2;

  BarChartGroupData generateGroupData(
    int x,
    double pilates,
    double quickWorkout,
    double cycling,
  ) {
    return BarChartGroupData(
      x: x,
      groupVertically: true,
      barRods: [
        BarChartRodData(
          fromY: 0,
          toY: pilates,
          color: pilateColor,
          width: 5,
        ),
        BarChartRodData(
          fromY: pilates + betweenSpace,
          toY: pilates + betweenSpace + quickWorkout,
          color: quickWorkoutColor,
          width: 5,
        ),
        BarChartRodData(
          fromY: pilates + betweenSpace + quickWorkout + betweenSpace,
          toY: pilates + betweenSpace + quickWorkout + betweenSpace + cycling,
          color: cyclingColor,
          width: 5,
        ),
      ],
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'MON';
        break;
      case 1:
        text = 'TUE';
        break;
      case 2:
        text = 'WED';
        break;
      case 3:
        text = 'THU';
        break;
      case 4:
        text = 'FRI';
        break;
      case 5:
        text = 'SAT';
        break;
      case 6:
        text = 'SUN';
        break;
      // case 7:
      //   text = 'AUG';
      //   break;
      // case 8:
      //   text = 'SEP';
      //   break;
      // case 9:
      //   text = 'OCT';
      //   break;
      // case 10:
      //   text = 'NOV';
      //   break;
      // case 11:
      //   text = 'DEC';
      //   break;
      default:
        text = '';
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      //padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daily CAT Scores',
            style: TextStyle(
              color: Color.fromARGB(255, 91, 90, 90),
              fontSize: 18.0,
              //fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          // LegendsListWidget(
          //   legends: [
          //     Legend('Pilates', pilateColor),
          //     Legend('Quick workouts', quickWorkoutColor),
          //     Legend('Cycling', cyclingColor),
          //   ],
          // ),
          const SizedBox(height: 14),
          AspectRatio(
            aspectRatio: 2,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceBetween,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(),
                  rightTitles: AxisTitles(),
                  topTitles: AxisTitles(),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: bottomTitles,
                      reservedSize: 20,
                    ),
                  ),
                ),
                barTouchData: BarTouchData(enabled: false),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: false),
                barGroups: [
                  generateGroupData(0, 7, 0, 0),
                  generateGroupData(1, 8, 0, 0),
                  generateGroupData(2, 10, 0, 0),
                  generateGroupData(3, 9, 0, 0),
                  generateGroupData(4, 9, 0, 0),
                  generateGroupData(5, 8, 0, 0),
                  generateGroupData(6, 8, 0, 0),
                  // generateGroupData(7, 2.3, 3.2, 3),
                  // generateGroupData(8, 2, 4.8, 2.5),
                  // generateGroupData(9, 1.2, 3.2, 2.5),
                  // generateGroupData(10, 1, 4.8, 3),
                  // generateGroupData(11, 2, 4.4, 2.8),
                ],
                maxY: 11 + (betweenSpace * 3),
                // extraLinesData: ExtraLinesData(
                //   horizontalLines: [
                //     HorizontalLine(
                //       y: 3.3,
                //       color: pilateColor,
                //       strokeWidth: 1,
                //       dashArray: [20, 4],
                //     ),
                //     HorizontalLine(
                //       y: 8,
                //       color: quickWorkoutColor,
                //       strokeWidth: 1,
                //       dashArray: [20, 4],
                //     ),
                //     HorizontalLine(
                //       y: 11,
                //       color: cyclingColor,
                //       strokeWidth: 1,
                //       dashArray: [20, 4],
                //     ),
                //   ],
                // ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
