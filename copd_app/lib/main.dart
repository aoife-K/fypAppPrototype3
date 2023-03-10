//import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:survey_kit/survey_kit.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:copd_app/custom_expansion_tile.dart';

import 'contacts.dart';
import 'info.dart';
import 'medication.dart';
import 'reports.dart';
import 'diary.dart';
import 'checkIn.dart';
import 'reportsNew.dart';
//import 'login.dart';
import 'signup.dart';
import 'auth_service.dart';

Future main() async {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeModeNotifier(),
      child: MyApp(),
    ),
  );
  //WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isIOS) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    await Firebase.initializeApp();
  }
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
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: Provider.of<ThemeModeNotifier>(context).isDarkMode
            ? ThemeMode.dark
            : ThemeMode.light,
        // ThemeData(
        //   useMaterial3: true,
        //   colorScheme: ColorScheme.fromSeed(
        //     seedColor: Colors.white,
        //   ),
        //   //backgroundColor: Colors.white,
        // ),
        home: Login(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //final AuthService _auth = AuthService();
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Text("Login Page"),
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 130.0),
              child: Center(
                child: Container(
                  height: MediaQuery.of(context).size.height / 9,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/home.png'))),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Center(
                child: Container(
                  width: 200,
                  height: 150,
                  /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                  child: Text('COPD Symptom Tracker',
                      style: TextStyle(fontSize: 35),
                      textAlign: TextAlign.center),
                  //color: Colors.blue,
                ),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _email = value.trim();
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your email',
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _password = value.trim();
                          });
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      // TextButton(
                      //   onPressed: () async {
                      //     if (_formKey.currentState!.validate()) {
                      //       dynamic result = await _auth
                      //           .signInWithEmailAndPassword(_email, _password);
                      //       if (result == null) {
                      //         print('Invalid login credentials');
                      //       } else {
                      //         Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //                 builder: (_) => MyHomePage()));
                      //         print('Login successful');
                      //       }
                      //     }
                      //   },
                      //   child: Text(
                      //     'Login',
                      //     style: TextStyle(color: Colors.white, fontSize: 18),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),

            // TextButton(
            //   onPressed: () {
            //     //TODO FORGOT PASSWORD SCREEN GOES HERE
            //   },
            //   child: Text(
            //     'Forgot Password?',
            //     style: TextStyle(color: Colors.blue, fontSize: 15),
            //   ),
            // ),
            SizedBox(height: 30),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 29, 181, 215),
                  borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () async {
                  //if (_formKey.currentState!.validate()) {
                  // dynamic result = await _auth.signInWithEmailAndPassword(
                  //     _email, _password);
                  // if (result == null) {
                  //   print('Invalid login credentials');
                  // } else
                  {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => MyHomePage()));
                    print('Login successful');
                  }
                  //}
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            SizedBox(
              height: 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignupPage()));
                  },
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color.fromARGB(255, 26, 187, 195)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// class Login extends StatefulWidget {
//   @override
//   _LoginState createState() => _LoginState();
// }

// class _LoginState extends State<Login> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final AuthService _auth = AuthService();
//   String _email = '';
//   String _password = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Login'),
//       ),
//       body: Container(
//         padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               TextFormField(
//                 validator: (String? value) {
//                   if (value!.isEmpty) {
//                     return 'Please enter your email';
//                   }
//                   return null;
//                 },
//                 onChanged: (value) {
//                   setState(() {
//                     _email = value.trim();
//                   });
//                 },
//                 decoration: InputDecoration(
//                   labelText: 'Email',
//                   hintText: 'Enter your email',
//                 ),
//               ),
//               SizedBox(
//                 height: 20.0,
//               ),
//               TextFormField(
//                 validator: (String? value) {
//                   if (value!.isEmpty) {
//                     return 'Please enter your password';
//                   }
//                   return null;
//                 },
//                 onChanged: (value) {
//                   setState(() {
//                     _password = value.trim();
//                   });
//                 },
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   labelText: 'Password',
//                   hintText: 'Enter your password',
//                 ),
//               ),
//               SizedBox(
//                 height: 20.0,
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   if (_formKey.currentState!.validate()) {
//                     dynamic result = await _auth.signInWithEmailAndPassword(
//                         _email, _password);
//                     if (result == null) {
//                       print('Invalid login credentials');
//                     } else {
//                       print('Login successful');
//                     }
//                   }
//                 },
//                 child: Text('Login'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

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
          Consumer<ThemeModeNotifier>(
            builder: (context, notifier, child) => Switch(
              value: notifier.isDarkMode,
              onChanged: (value) {
                notifier.toggleThemeMode();
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text("Welcome, Aoife!",
              style: TextStyle(
                color: Color.fromARGB(255, 91, 90, 90),
                fontSize: 25.0,
              )),
          SizedBox(height: 40),
          // Container(
          //   child: isTodayInJsonFile()
          //       ? Text('This text is displayed when isTrue is true')
          //       : Text('This text is displayed when isTrue is false'),
          // ),
          Card(
            //elevation: 3,
            color: Color.fromARGB(255, 249, 251, 251),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Container(
              width: 400,
              height: 100,
              color: isTodayInJsonFile()
                  ? Color.fromARGB(255, 199, 233, 235)
                  : Color.fromARGB(255, 240, 210, 198),
              child: Center(
                  // onDoubleTap: () {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => CheckInPage(),
                  //     ),
                  //   );
                  // },
                  child: GestureDetector(
                onTap: () {
                  if (!isTodayInJsonFile()) {
                    // Replace with your navigation code
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckInPage(),
                      ),
                    );
                  }
                },
                child: isTodayInJsonFile()
                    ? Text(
                        "Your daily check-in is complete!",
                        style: TextStyle(
                          color: Color.fromARGB(255, 30, 148, 168),
                          fontSize: 18.0,
                        ),
                      )
                    : Text(
                        "Your daily check-in is incomplete! Tap here to complete it.",
                        style: TextStyle(
                          color: Color.fromARGB(255, 234, 105, 96),
                          fontSize: 18.0,
                        ),
                      ),
              )
                  // child: isTodayInJsonFile()
                  //     ? Text(
                  //         "Your daily check-in is complete!",
                  //         style: TextStyle(
                  //           color: Color.fromARGB(255, 30, 148, 168),
                  //           fontSize: 18.0,
                  //         ),
                  //       )
                  //     : Text(
                  //         "Your daily check-in is incomplete! Tap here to complete it.",
                  //         style: TextStyle(
                  //           color: Color.fromARGB(255, 234, 105, 96),
                  //           fontSize: 18.0,
                  //         ),
                  //       ),
                  // child: Text(
                  //   "Your daily check-in is complete!",
                  //   style: TextStyle(
                  //     color: Color.fromARGB(255, 30, 148, 168),
                  //     fontSize: 18.0,
                  //   ),
                  // ),
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
                  builder: (context) => NewReportsPage(),
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

  bool isTodayInJsonFile() {
    // Read the contents of the JSON file
    const String filePath =
        '/Users/aoifekhan/Documents/fourthYear/fypApp/copd_app/assets/cat.json';
    final fileContents = File(filePath).readAsStringSync();

    // Parse the JSON contents into a List of maps
    final data = jsonDecode(fileContents).cast<Map<String, dynamic>>();

    // Get today's date in the format "YYYY-MM-DD"
    final today = DateTime.now().toIso8601String().substring(0, 10);

    // Check if today's date is present in any of the objects
    for (final obj in data) {
      if (obj['date'] == today) {
        return true;
      }
    }

    return false;
  }
}

class ThemeModeNotifier with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleThemeMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
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
