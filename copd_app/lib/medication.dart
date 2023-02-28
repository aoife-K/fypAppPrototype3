import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MedicationsPage extends StatefulWidget {
  @override
  State<MedicationsPage> createState() => _MedicationsPageState();
}

class _MedicationsPageState extends State<MedicationsPage> {
  bool _isEnabled = false;

  //var _listSection = List<Widget>();
  List<Widget> _listOfWidgets = [];

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
