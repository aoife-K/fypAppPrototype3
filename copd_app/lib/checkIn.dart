import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:survey_kit/survey_kit.dart';
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';

class CheckInPage extends StatefulWidget {
  @override
  State<CheckInPage> createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: Colors.white,
          child: Align(
            alignment: Alignment.center,
            child: FutureBuilder<Task>(
              future: getSampleTask(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData &&
                    snapshot.data != null) {
                  final task = snapshot.data!;
                  return SurveyKit(
                    onResult: (SurveyResult result) {
                      print(result.finishReason);
                      final jsonResult = surveyResultsToJson(result);
                      // print the json-formatted results
                      //debugPrint(jsonEncode(jsonResult));
                      //print(jsonResult.length);
                      Map<String, dynamic> resultMap = jsonToMap(jsonResult);
                      print(resultMap);
                      writeJsonFile(resultMap);
                      Navigator.pushNamed(context, '/');
                    },
                    task: task,
                    showProgress: true,
                    localizations: {
                      'cancel': 'Cancel',
                      'next': 'Next',
                    },
                    themeData: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.fromSwatch(
                        primarySwatch: Colors.cyan,
                      ).copyWith(
                        onPrimary: Colors.white,
                      ),
                      primaryColor: Colors.cyan,
                      backgroundColor: Colors.white,
                      appBarTheme: const AppBarTheme(
                        color: Colors.white,
                        iconTheme: IconThemeData(
                          color: Colors.cyan,
                        ),
                        titleTextStyle: TextStyle(
                          color: Colors.cyan,
                        ),
                      ),
                      iconTheme: const IconThemeData(
                        color: Colors.cyan,
                      ),
                      textSelectionTheme: TextSelectionThemeData(
                        cursorColor: Colors.cyan,
                        selectionColor: Colors.cyan,
                        selectionHandleColor: Colors.cyan,
                      ),
                      // cupertinoOverrideTheme: CupertinoThemeData(
                      //   primaryColor: Colors.cyan,
                      // ),
                      outlinedButtonTheme: OutlinedButtonThemeData(
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(
                            Size(150.0, 60.0),
                          ),
                          side: MaterialStateProperty.resolveWith(
                            (Set<MaterialState> state) {
                              if (state.contains(MaterialState.disabled)) {
                                return BorderSide(
                                  color: Colors.grey,
                                );
                              }
                              return BorderSide(
                                color: Colors.cyan,
                              );
                            },
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          textStyle: MaterialStateProperty.resolveWith(
                            (Set<MaterialState> state) {
                              if (state.contains(MaterialState.disabled)) {
                                return Theme.of(context)
                                    .textTheme
                                    .button
                                    ?.copyWith(
                                      color: Colors.grey,
                                    );
                              }
                              return Theme.of(context)
                                  .textTheme
                                  .button
                                  ?.copyWith(
                                    color: Colors.cyan,
                                  );
                            },
                          ),
                        ),
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: ButtonStyle(
                          textStyle: MaterialStateProperty.all(
                            Theme.of(context).textTheme.button?.copyWith(
                                  color: Colors.cyan,
                                ),
                          ),
                        ),
                      ),
                      textTheme: TextTheme(
                        headline2: TextStyle(
                          fontSize: 28.0,
                          color: Colors.black,
                        ),
                        headline5: TextStyle(
                          fontSize: 24.0,
                          color: Colors.black,
                        ),
                        bodyText2: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                        ),
                        subtitle1: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                        ),
                      ),
                      inputDecorationTheme: InputDecorationTheme(
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    surveyProgressbarConfiguration: SurveyProgressConfiguration(
                      backgroundColor: Colors.white,
                    ),
                  );
                }
                return CircularProgressIndicator.adaptive();
              },
            ),
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> surveyResultsToJson(SurveyResult result) {
    List<Map<String, dynamic>> resultList = [];
    int index = 1;
    for (var step in result.results) {
      for (var r in step.results) {
        var resultObject = <String, dynamic>{
          "finishReason": result.finishReason.name,
          "date": r.endDate.toString().substring(0, 10),
          "id": "result$index",
          "result": r.result is BooleanResult
              ? ((r.result as BooleanResult) == BooleanResult.POSITIVE
                  ? true
                  : (r.result as BooleanResult) == BooleanResult.NEGATIVE
                      ? false
                      : null)
              : r.result is TimeOfDay
                  ? '${(r.result as TimeOfDay).hour}:${(r.result as TimeOfDay).minute}'
                  : r.result is DateTime
                      ? (r.result as DateTime).toIso8601String()
                      : r.result,
          //"valueIdentifier": r.valueIdentifier,
        };
        resultList.add(resultObject);
        index++;
      }
    }
    return resultList;
  }

  // Map<String, dynamic> jsonToMap(List<Map<String, dynamic>> jsonList) {
  //   DateTime firstDate = DateTime.parse(jsonList.first['date']);
  //   print(firstDate);
  //   Map<String, dynamic> resultMap = {};
  //   for (var json in jsonList) {
  //     String id = json['id'];
  //     dynamic result = json['result'];
  //     resultMap[id] = result;
  //   }
  //   return resultMap;
  // }

  Map<String, dynamic> jsonToMap(List<Map<String, dynamic>> jsonList) {
    DateTime firstDate = DateTime.parse(jsonList.first['date']);
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(firstDate);
    Map<String, dynamic> resultMap = {};
    double total = 0;
    resultMap['date'] = formatted;
    for (var json in jsonList) {
      String id = json['id'];
      if (id == 'result1' || id == 'result10') {
        continue;
      }
      dynamic result = json['result'];
      switch (id) {
        case 'result2':
          id = 'cough';
          break;
        case 'result3':
          id = 'phlegm';
          break;
        case 'result4':
          id = 'tightness';
          break;
        case 'result5':
          id = 'breathlessness';
          break;
        case 'result6':
          id = 'activities';
          break;
        case 'result7':
          id = 'confidence';
          break;
        case 'result8':
          id = 'sleep';
          break;
        case 'result9':
          id = 'energy';
          break;
        default:
          continue;
      }
      if (result is double) {
        //resultMap[id] = result;
        total += result;
      }

      resultMap[id] = result;
    }
    resultMap['total'] = total;
    return resultMap;
  }

  void writeJsonFile(Map<String, dynamic> data) {
    final String date = data['date'];
    final double total = data['total'];
    final File jsonFile = File(
        '/Users/aoifekhan/Documents/fourthYear/fypApp/copd_app/assets/cat.json');
    final File symptomsFile = File(
        '/Users/aoifekhan/Documents/fourthYear/fypApp/copd_app/assets/symptoms.json');

    // Read the existing data from the file
    final String jsonString =
        jsonFile.existsSync() ? jsonFile.readAsStringSync() : '';
    final List<dynamic> jsonData =
        jsonString.isNotEmpty ? jsonDecode(jsonString) : [];

    // Check if an object with the same date already exists in the data
    final int existingIndex = jsonData.indexWhere((obj) => obj['date'] == date);

    if (existingIndex >= 0) {
      // Replace the existing object with the new data
      jsonData[existingIndex] = data;
    } else {
      // Add the new data as a new object
      jsonData.add(data);
    }

    // Write the updated data to the file
    jsonFile.writeAsStringSync(jsonEncode(jsonData));

    final String symptomsString =
        symptomsFile.existsSync() ? symptomsFile.readAsStringSync() : '';
    final List<dynamic> symptomsJson =
        symptomsString.isNotEmpty ? jsonDecode(symptomsString) : [];

    // Check if an object with the same date already exists in the symptoms data
    final int symptomsIndex =
        symptomsJson.indexWhere((obj) => obj['date'] == date);

    if (symptomsIndex >= 0) {
      // Replace the cat_score value in the existing object with the total value from the new data
      symptomsJson[symptomsIndex]['cat_score'] = total;
    }
    // else {
    //   // Add a new object with the date and total values
    //   symptomsJson.add({'date': date, 'cat_score': total});
    // }

    // Write the updated data to the symptoms file
    symptomsFile.writeAsStringSync(jsonEncode(symptomsJson));
  }

  Future<Task> getSampleTask() {
    var task = NavigableTask(
      id: TaskIdentifier(),
      steps: [
        InstructionStep(
          title: 'Daily Check-in',
          text: 'COPD Assessment Test (CAT)',
          buttonText: 'Begin',
        ),
        QuestionStep(
          title: 'Cough',
          text: '1 - I never cough\n 5 - I cough all the time',
          answerFormat: ScaleAnswerFormat(
            step: 1,
            minimumValue: 1,
            maximumValue: 5,
            defaultValue: 1,
            minimumValueDescription: '1',
            maximumValueDescription: '5',
          ),
        ),
        QuestionStep(
          title: 'Phlegm',
          text:
              '1 - I have no phelgm in my chest at all\n 5 - My chest is completely full of phlegm',
          answerFormat: ScaleAnswerFormat(
            step: 1,
            minimumValue: 1,
            maximumValue: 5,
            defaultValue: 1,
            minimumValueDescription: '1',
            maximumValueDescription: '5',
          ),
        ),
        QuestionStep(
          title: 'Chest tightness',
          text:
              '1 - My chest does not feel tight at all\n 5 - My chest feels very tight',
          answerFormat: ScaleAnswerFormat(
            step: 1,
            minimumValue: 1,
            maximumValue: 5,
            defaultValue: 1,
            minimumValueDescription: '1',
            maximumValueDescription: '5',
          ),
        ),
        QuestionStep(
          title: 'Breathlessness',
          text:
              '1 - When I walk up a hill or one flight of stairs I am not breathless\n 5 - When I walk up a hill or one flight of stairs I am very breathless',
          answerFormat: ScaleAnswerFormat(
            step: 1,
            minimumValue: 1,
            maximumValue: 5,
            defaultValue: 1,
            minimumValueDescription: '1',
            maximumValueDescription: '5',
          ),
        ),
        QuestionStep(
          title: 'Activities',
          text:
              '1 - I am not limited doing any activities at home\n 5 - I am very limited doing any activities at home',
          answerFormat: ScaleAnswerFormat(
            step: 1,
            minimumValue: 1,
            maximumValue: 5,
            defaultValue: 1,
            minimumValueDescription: '1',
            maximumValueDescription: '5',
          ),
        ),
        QuestionStep(
          title: 'Confidence',
          text:
              '1 - I am confident leaving my home despite my lung condition\n 5 - I am not at all confident leaving my home because of my lung condition',
          answerFormat: ScaleAnswerFormat(
            step: 1,
            minimumValue: 1,
            maximumValue: 5,
            defaultValue: 1,
            minimumValueDescription: '1',
            maximumValueDescription: '5',
          ),
        ),
        QuestionStep(
          title: 'Sleep',
          text:
              '1 - I sleep soundly\n 5 - I don\'t sleep soundly because of my lung condition',
          answerFormat: ScaleAnswerFormat(
            step: 1,
            minimumValue: 1,
            maximumValue: 5,
            defaultValue: 1,
            minimumValueDescription: '1',
            maximumValueDescription: '5',
          ),
        ),
        QuestionStep(
          title: 'Energy levels',
          text: '1 - I have lots of energy\n 5 - I have no energy at all',
          answerFormat: ScaleAnswerFormat(
            step: 1,
            minimumValue: 1,
            maximumValue: 5,
            defaultValue: 1,
            minimumValueDescription: '1',
            maximumValueDescription: '5',
          ),
        ),
        CompletionStep(
          stepIdentifier: StepIdentifier(id: '321'),
          text: 'Thanks for completing your daily check-in!',
          title: 'Done!',
          buttonText: 'Submit',
        ),
      ],
    );
    task.addNavigationRule(
      forTriggerStepIdentifier: task.steps[6].stepIdentifier,
      navigationRule: ConditionalNavigationRule(
        resultToStepIdentifierMapper: (input) {
          switch (input) {
            case "Yes":
              return task.steps[0].stepIdentifier;
            case "No":
              return task.steps[7].stepIdentifier;
            default:
              return null;
          }
        },
      ),
    );
    return Future.value(task);
  }
}
