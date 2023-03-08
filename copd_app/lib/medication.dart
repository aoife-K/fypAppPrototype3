import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class MedicationsPage extends StatefulWidget {
  @override
  State<MedicationsPage> createState() => _MedicationsPageState();
}

class _MedicationsPageState extends State<MedicationsPage> {
  bool _isEnabled = false;

  //var _listSection = List<Widget>();
  List<Widget> _listOfWidgets = [];
  Map<String, dynamic> _medicationMap = {
    "Symbicort Inhaler": "2 puffs twice daily"
  };

  @override
  void initState() {
    super.initState();
    // Here initialize the list in case it is required
    _listOfWidgets = [];
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Medication",
              style: TextStyle(
                color: Color.fromARGB(255, 91, 90, 90),
                fontSize: 25.0,
              )),
          SizedBox(height: 60),
          // ListTile(
          //   title: Text("Symbicort Inhaler"),
          //   subtitle: Text('Dosage: 2 puffs twice daily'),
          //   trailing: Icon(Icons.edit),
          // ),
          // Wrap(children: [
          //   ListView.builder(
          //     itemCount: _medicationMap.length,
          //     itemBuilder: (context, index) {
          //       return EditableListTile(
          //         title: _medicationMap.keys.elementAt(index),
          //         subtitle: _medicationMap.values.elementAt(index),
          //       );
          //     },
          //   ),
          // ]),
          //ListWidget(),
          EditableListTile(
              title: "Symbicort Inhaler", subtitle: "2 puffs twice daily"),
          for (var item in _listOfWidgets) item,
          ListTile(
            title: Text('New Medication...'),
            trailing: Icon(Icons.add),
            onTap: () {
              setState(() {
                print("fab clicked");
                _addItemToList(); // new method
                //_getJsonData();
              });
            },
          ),
        ],
      ),
    );
  }

  _addItemToList() {
    //<Widget> _listOfWidgets = [];
    List<Widget> tempList =
        _listOfWidgets; // defining a new temporary list which will be equal to our other list
    tempList.add(EditableListTile(
        title: "Medication...",
        subtitle: "Dosage...")); // adding a new item to the list
    setState(() {
      _listOfWidgets =
          tempList; // this will trigger a rebuild of the ENTIRE widget, therefore adding our new item to the list!
    });
  }

  Map<String, String> _getJsonData() {
    Map<String, String> emptyData = {};
    File jsonFile = File(
        '/Users/aoifekhan/Documents/fourthYear/fypApp/copd_app/assets/medications.json');
    jsonFile.existsSync();
    String jsonString = jsonFile.readAsStringSync();

    List<dynamic> jsonData = jsonDecode(jsonString);
    //Map<String, String> map = jsonData.asMap();
    Map<String, String> map = Map.fromIterable(jsonData,
        key: (item) => item['Medication'], value: (item) => item['Dosage']);
    //print(map);
    return map;
  }
}

class EditableListTile extends StatefulWidget {
  String title;
  String subtitle;

  EditableListTile({required this.title, required this.subtitle});

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
      subtitle: isEditing
          ? TextField(
              decoration: InputDecoration(
                hintText: widget.subtitle,
              ),
              onChanged: (value) {
                setState(() {
                  widget.subtitle = value;
                });
              },
            )
          : Text(widget.subtitle),
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

class ListWidget extends StatefulWidget {
  @override
  _ListWidgetState createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  List<Map<String, String>> items = [
    {'title': 'Item 1', 'subtitle': 'Subtitle for item 1'},
    {'title': 'Item 2', 'subtitle': 'Subtitle for item 2'},
    {'title': 'Item 3', 'subtitle': 'Subtitle for item 3'}
  ];
  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();

  void addItem() {
    setState(() {
      items.add(
          {'title': titleController.text, 'subtitle': subtitleController.text});
      titleController.clear();
      subtitleController.clear();
    });
  }

  void editItem(int index) {
    titleController.text = items[index]['title']!;
    subtitleController.text = items[index]['subtitle']!;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Edit Item'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(hintText: 'Title'),
                ),
                TextField(
                  controller: subtitleController,
                  decoration: InputDecoration(hintText: 'Subtitle'),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      items[index]['title'] = titleController.text;
                      items[index]['subtitle'] = subtitleController.text;
                      titleController.clear();
                      subtitleController.clear();
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Save')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
            ],
          );
        });
  }

  void deleteItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('List Widget')),
      body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(items[index]['title']!),
              subtitle: Text(items[index]['subtitle']!),
              trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    editItem(index);
                  }),
              onTap: () {
                deleteItem(index);
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Add Item'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: InputDecoration(hintText: 'Title'),
                      ),
                      TextField(
                        controller: subtitleController,
                        decoration: InputDecoration(hintText: 'Subtitle'),
                      ),
                    ],
                  ),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          addItem();
                          Navigator.pop(context);
                        },
                        child: Text('Add')),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel')),
                  ],
                );
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
