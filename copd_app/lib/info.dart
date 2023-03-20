import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'infoSub1.dart';
// import 'medication.dart';

class InfoPage extends StatefulWidget {
  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    //return Scaffold(,)
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Information",
              style: TextStyle(
                color: Color.fromARGB(255, 91, 90, 90),
                fontSize: 25.0,
              )),
          SizedBox(height: 60),
          ListTile(
            title: Text('What is COPD?'),
            leading: Icon(Icons.arrow_forward_ios_rounded),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WhatIsCOPDPage(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Pulmonary Rehabilitation'),
            leading: Icon(Icons.arrow_forward_ios_rounded),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PRPage(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('COPD and COVID-19'),
            leading: Icon(Icons.arrow_forward_ios_rounded),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CovidPage(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Smoking Advice'),
            leading: Icon(Icons.arrow_forward_ios_rounded),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SmokingPage(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Vaccination Advice'),
            leading: Icon(Icons.arrow_forward_ios_rounded),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VaccinationPage(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('COPD Support'),
            leading: Icon(Icons.arrow_forward_ios_rounded),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SupportPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class WhatIsCOPDPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 350),
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BackButton(),
                Padding(padding: EdgeInsets.only(left: 80)),
                Text("What is COPD?",
                    style: TextStyle(
                      color: Color.fromARGB(255, 91, 90, 90),
                      fontSize: 25.0,
                    )),
              ],
            ),
            SizedBox(height: 60),
            Text(
                "This page will contain information about COPD, including symptoms, causes, and treatments.",
                style: TextStyle(
                  color: Color.fromARGB(255, 91, 90, 90),
                  fontSize: 15.0,
                )),
          ],
        ),
      ),
    );
  }
}

class PRPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BackButton(),
              Padding(padding: EdgeInsets.only(left: 30)),
              Text("Pulmonary Rehabilitation",
                  style: TextStyle(
                    color: Color.fromARGB(255, 91, 90, 90),
                    fontSize: 25.0,
                  )),
            ],
          ),
          SizedBox(height: 60),
          Text(
              "This page will contain pulmonary rehabilitation information and exercises to follow along with.",
              style: TextStyle(
                color: Color.fromARGB(255, 91, 90, 90),
                fontSize: 15.0,
              )),
        ],
      ),
    );
  }
}

class CovidPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BackButton(),
              Padding(padding: EdgeInsets.only(left: 30)),
              Text("COPD and COVID-19",
                  style: TextStyle(
                    color: Color.fromARGB(255, 91, 90, 90),
                    fontSize: 25.0,
                  )),
            ],
          ),
          Text(
              "This page will contain information about the risks of COVID-19 for people with COPD, and how to protect yourself.",
              style: TextStyle(
                color: Color.fromARGB(255, 91, 90, 90),
                fontSize: 15.0,
              )),
        ],
      ),
    );
  }
}

class SmokingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BackButton(),
              Padding(padding: EdgeInsets.only(left: 30)),
              Text("Smoking Advice",
                  style: TextStyle(
                    color: Color.fromARGB(255, 91, 90, 90),
                    fontSize: 25.0,
                  )),
            ],
          ),
          Text(
              "This page will contain information about the risks of smoking for people with COPD, and advice on how to quit.",
              style: TextStyle(
                color: Color.fromARGB(255, 91, 90, 90),
                fontSize: 15.0,
              )),
        ],
      ),
    );
  }
}

class VaccinationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BackButton(),
              Padding(padding: EdgeInsets.only(left: 30)),
              Text("Vaccination Advice",
                  style: TextStyle(
                    color: Color.fromARGB(255, 91, 90, 90),
                    fontSize: 25.0,
                  )),
            ],
          ),
          Text(
              "This page will contain information about the benefits of vaccination for people with COPD.",
              style: TextStyle(
                color: Color.fromARGB(255, 91, 90, 90),
                fontSize: 15.0,
              )),
        ],
      ),
    );
  }
}

class SupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BackButton(),
              Padding(padding: EdgeInsets.only(left: 30)),
              Text("COPD Support",
                  style: TextStyle(
                    color: Color.fromARGB(255, 91, 90, 90),
                    fontSize: 25.0,
                  )),
            ],
          ),
          Text(
              "This page will contain information about support groups and helplines for people with COPD.",
              style: TextStyle(
                color: Color.fromARGB(255, 91, 90, 90),
                fontSize: 15.0,
              )),
        ],
      ),
    );
  }
}
