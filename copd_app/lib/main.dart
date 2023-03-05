//import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:survey_kit/survey_kit.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:copd_app/custom_expansion_tile.dart';

import 'contacts.dart';
import 'info.dart';
import 'medication.dart';
import 'reports.dart';
import 'diary.dart';
import 'checkIn.dart';

void main() async {
  runApp(MyApp());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore db = FirebaseFirestore.instance;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.white,
          ),
          //backgroundColor: Colors.white,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  var _selectedPageIndex;
  List<Widget> _pages = [
    GeneratorPage(),
    CheckInPage(),
    //ReportsPage(),
    DiaryPage(),
    ContactPage(),
    MedicationsPage(),
    InfoPage()
  ];
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();

    _selectedPageIndex = 0;
    _pages = [
      GeneratorPage(),
      CheckInPage(),
      //ReportsPage(),
      DiaryPage(),
      ContactPage(),
      MedicationsPage(),
      InfoPage()
      //The individual tabs.
    ];

    _pageController = PageController(initialPage: _selectedPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = CheckInPage();
        break;
      // case 2:
      //   page = ReportsPage();
      //   break;
      case 2:
        page = DiaryPage();
        break;
      case 3:
        page = ContactPage();
        break;
      case 4:
        page = MedicationsPage();
        break;
      case 5:
        page = InfoPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        // body: Container(
        //   color: Theme.of(context).colorScheme.primaryContainer,
        //   child: page,
        // ),
        body: IndexedStack(
          index: selectedIndex,
          children: _pages,
        ),
        // body: PageView(
        //   controller: _pageController,
        //   //color: Theme.of(context).colorScheme.primaryContainer,
        //   physics: NeverScrollableScrollPhysics(),
        //   children: _pages,
        // ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Color.fromARGB(255, 146, 145, 145)),
              activeIcon: Icon(
                Icons.home,
                color: Color.fromARGB(255, 58, 189, 198),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon:
                  Icon(Icons.check, color: Color.fromARGB(255, 146, 145, 145)),
              activeIcon: Icon(
                Icons.check,
                color: Color.fromARGB(255, 58, 189, 198),
              ),
              label: 'Check-In',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.summarize_outlined,
            //       color: Color.fromARGB(255, 146, 145, 145)),
            //   activeIcon: Icon(
            //     Icons.summarize_outlined,
            //     color: Color.fromARGB(255, 58, 189, 198),
            //   ),
            //   label: 'Reports',
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month,
                  color: Color.fromARGB(255, 146, 145, 145)),
              activeIcon: Icon(
                Icons.calendar_month,
                color: Color.fromARGB(255, 58, 189, 198),
              ),
              label: 'Diary',
            ),
            BottomNavigationBarItem(
              icon:
                  Icon(Icons.person, color: Color.fromARGB(255, 146, 145, 145)),
              activeIcon: Icon(
                Icons.person,
                color: Color.fromARGB(255, 58, 189, 198),
              ),
              label: 'Contacts',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.medication,
                  color: Color.fromARGB(255, 146, 145, 145)),
              activeIcon: Icon(
                Icons.medication,
                color: Color.fromARGB(255, 58, 189, 198),
              ),
              label: 'Medication',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info, color: Color.fromARGB(255, 146, 145, 145)),
              activeIcon: Icon(
                Icons.info,
                color: Color.fromARGB(255, 58, 189, 198),
              ),
              label: 'Information',
            ),
          ],
          currentIndex: selectedIndex,
          onTap: (value) {
            setState(() {
              selectedIndex = value;
            });
          },
          // currentIndex: _selectedPageIndex,
          // onTap: (selectedPageIndex) {
          //   setState(() {
          //     _selectedPageIndex = selectedPageIndex;
          //     _pageController.jumpToPage(selectedPageIndex);
          //   });
          // },
          fixedColor: Color.fromARGB(255, 121, 119, 119),
        ),
      );
    });
  }
}

class GeneratorPage extends StatefulWidget {
  @override
  State<GeneratorPage> createState() => _GeneratorPageState();
}

class _GeneratorPageState extends State<GeneratorPage> {
  @override
  Widget build(BuildContext context) {
    //return Scaffold(,)
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),
          Text("Welcome, Aoife!",
              style: TextStyle(
                color: Color.fromARGB(255, 91, 90, 90),
                fontSize: 25.0,
              )),
          SizedBox(height: 40),
          Card(
            //elevation: 3,
            color: Color.fromARGB(255, 249, 251, 251),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Container(
              width: 400,
              height: 100,
              child: Center(
                // onDoubleTap: () {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => CheckInPage(),
                //     ),
                //   );
                // },
                child: Text(
                  "Your daily check-in is complete!",
                  style: TextStyle(
                    color: Color.fromARGB(255, 30, 148, 168),
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 60),
          Text("Here's this week's summary:",
              style: TextStyle(
                color: Color.fromARGB(255, 91, 90, 90),
                fontSize: 20.0,
              )),
          SizedBox(height: 20),
          ListTile(
            title: Text('On average, you\'re taking more steps than last week.',
                style: TextStyle(color: Color.fromARGB(255, 130, 131, 130))),
            leading: Icon(Icons.directions_walk, color: Colors.green),
            // trailing: Icon(Icons.arrow_forward),
            // onTap: () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => ReportsPage(),
            //     ),
            //   );
            // },
          ),
          SizedBox(height: 20),
          ListTile(
            title: Text('Your average weight is 0.5kg lower than last week.',
                style: TextStyle(color: Color.fromARGB(255, 130, 131, 130))),
            //subtitle: Text('See your sleep trends...'),
            leading: Icon(Icons.scale_sharp, color: Colors.orange),
            // trailing: Icon(Icons.arrow_forward),
            // onTap: () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => GraphsPage(),
            //     ),
            //   );
            // },
          ),
          SizedBox(height: 20),
          ListTile(
            title: Text(
                'Your SPO2 levels have been in a healthy range this week.',
                style: TextStyle(color: Color.fromARGB(255, 130, 131, 130))),
            leading: Icon(Icons.favorite, color: Colors.green),
            // trailing: Icon(Icons.arrow_forward),
            // onTap: () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => GraphsPage(),
            //     ),
            //   );
            // },
          ),
          SizedBox(height: 20),
          ListTile(
            title: Text('Your average CAT score is higher than last week.',
                style: TextStyle(color: Color.fromARGB(255, 130, 131, 130))),
            leading: Icon(Icons.emoji_emotions, color: Colors.red),
            // trailing: Icon(Icons.arrow_forward),
            // onTap: () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => GraphsPage(),
            //     ),
            //   );
            // },
          ),
          SizedBox(height: 60),
          ListTile(
            title: Text('See all of your trends',
                style: TextStyle(color: Colors.blue, fontSize: 18)),
            leading: Icon(Icons.health_and_safety, color: Colors.blue),
            trailing: Icon(Icons.arrow_forward, color: Colors.blue),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReportsPage(),
                ),
              );
            },
          ),
          //SizedBox(height: 150),
          // ListTile(
          //   title: Text('Settings'),
          //   leading: Icon(Icons.settings),
          //   trailing: Icon(Icons.more_horiz),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => SettingsPage(),
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}


// class GraphsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           BackButton(),
//           Text("Reports",
//               style: TextStyle(
//                 color: Color.fromARGB(255, 91, 90, 90),
//                 fontSize: 25.0,
//               )),
//           Text(
//               "See your sleep trends, steps taken, and more over the past weeks and months.",
//               style: TextStyle(
//                 color: Color.fromARGB(255, 91, 90, 90),
//                 fontSize: 15.0,
//               )),
//         ],
//       ),
//     );
//   }
// }






// class BigCard extends StatelessWidget {
//   const BigCard({
//     Key? key,
//     required this.pair,
//   }) : super(key: key);

//   //final WordPair pair;

//   @override
//   Widget build(BuildContext context) {
//     var theme = Theme.of(context);
//     var style = theme.textTheme.displayMedium!.copyWith(
//       color: theme.colorScheme.onPrimary,
//     );

//     return Card(
//       color: theme.colorScheme.primary,
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Text(
//           pair.asLowerCase,
//           style: style,
//           semanticsLabel: pair.asPascalCase,
//         ),
//       ),
//     );
//   }
// }
