import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class MedicationsPage extends StatefulWidget {
  @override
  State<MedicationsPage> createState() => _MedicationsPageState();
}

class _MedicationsPageState extends State<MedicationsPage> {
  bool _isEnabled = false;
  bool _customTileExpanded = false;
  SampleItem? selectedMenu;

  List<Widget> _listOfWidgets = [];
  final List<Medication> _medications = [
    Medication(name: 'Symbicort Inhaler', dosage: '2 puffs daily'),
    Medication(name: 'Albuterol', dosage: '250mg'),
    Medication(name: 'Theophylline', dosage: '400mg'),
  ];

  @override
  void initState() {
    super.initState();
    // Here initialize the list in case it is required
    _listOfWidgets = [];
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 150),
            Text("Medications",
                style: TextStyle(
                  //color: Color.fromARGB(255, 91, 90, 90),
                  fontSize: 25.0,
                )),
            IconButton(
              onPressed: _addMedication,
              icon: Icon(Icons.add),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                itemCount: _medications.length,
                itemBuilder: (BuildContext context, int index) {
                  final contact = _medications[index];

                  return Container(
                    height: 80.0,
                    child: GestureDetector(
                      onTap: () => _showOptionsDialog(context, index),
                      child: ListTile(
                        leading: Icon(Icons.medication,
                            color: Colors.green, size: 25.0),
                        title: Text(contact.name,
                            style: TextStyle(fontSize: 18.0)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(contact.dosage,
                                style: TextStyle(fontSize: 15.0)),
                          ],
                        ),
                        trailing: PopupMenuButton(
                          itemBuilder: (BuildContext context) => [
                            PopupMenuItem(
                              child: Text('Edit'),
                              value: 'edit',
                            ),
                            PopupMenuItem(
                              child: Text('Delete'),
                              value: 'delete',
                            ),
                          ],
                          onSelected: (String value) {
                            if (value == 'edit') {
                              _editMedication(index);
                            } else if (value == 'delete') {
                              _deleteMedication(index);
                            }
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // SizedBox(height: 60),
            // for (var item in _listOfWidgets) item,
            // ListTile(
            //   title: Text('Add New Medication...'),
            //   trailing: Icon(Icons.add),
            //   onTap: () {
            //     setState(() {
            //       print("fab clicked");
            //       _addItemToList(); // new method
            //     });
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  // _addItemToList() {
  //   //<Widget> _listOfWidgets = [];
  //   List<Widget> tempList =
  //       _listOfWidgets; // defining a new temporary list which will be equal to our other list
  //   tempList.add(EditableListTile(
  //     title: "Medication...",
  //     subtitle: "Dosage...",
  //     onDelete: deleteItem(0),
  //   )); // adding a new item to the list

  //   setState(() {
  //     _listOfWidgets =
  //         tempList; // this will trigger a rebuild of the ENTIRE widget, therefore adding our new item to the list!
  //   });
  // }

  // VoidCallback deleteItem(int index) {
  //   // setState(() {
  //   //   _ListOfWidgets.removeAt(index);
  //   // });
  //   print("delete item called");
  //   return () {
  //     setState(() {
  //       _listOfWidgets.removeAt(index);
  //     });
  //   };
  // }

  void _showOptionsDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Medication Options'),
          actions: [
            TextButton(
              child: Text('Edit'),
              onPressed: () {
                Navigator.pop(context);
                _editMedication(index);
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                setState(() {
                  _medications.removeAt(index);
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _addMedication() async {
    final result = await showDialog<Medication>(
      context: context,
      builder: (BuildContext context) => _buildAddMedicationDialog(),
    );

    if (result != null) {
      setState(() {
        _medications.add(result);
      });
    }
  }

  Widget _buildAddMedicationDialog() {
    final nameController = TextEditingController();
    final dosageController = TextEditingController();

    return AlertDialog(
      title: Text('Add Medication'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Name',
            ),
          ),
          TextField(
            controller: dosageController,
            decoration: InputDecoration(
              labelText: 'Dosage',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: Text('Save'),
          onPressed: () {
            final name = nameController.text.trim();
            final dosage = dosageController.text.trim();

            if (name.isNotEmpty && dosage.isNotEmpty) {
              Navigator.of(context).pop(Medication(name: name, dosage: dosage));
            }
          },
        ),
      ],
    );
  }

  void _deleteMedication(int index) {
    setState(() {
      _medications.removeAt(index);
    });
  }

  void _editMedication(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final nameController =
            TextEditingController(text: _medications[index].name);
        final dosageController =
            TextEditingController(text: _medications[index].dosage);

        return AlertDialog(
          title: Text('Edit Medication'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
              ),
              TextField(
                controller: dosageController,
                decoration: InputDecoration(
                  labelText: 'Dosage',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                final name = nameController.text;
                final dosage = dosageController.text;
                final newContact = Medication(name: name, dosage: dosage);

                setState(() {
                  _medications[index] = newContact;
                });

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

class EditableListTile extends StatefulWidget {
  String title;
  String subtitle;
  final VoidCallback onDelete;

  EditableListTile(
      {required this.title, required this.subtitle, required this.onDelete});

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
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              widget.onDelete();
            },
          ),
        ],
      ),
    );
  }
}

class Medication {
  final String name;
  final String dosage;

  Medication({
    required this.name,
    required this.dosage,
  });
}

class MedicationWidget extends StatelessWidget {
  final String name;
  final String dosage;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  MedicationWidget({
    required this.name,
    required this.dosage,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Text(name[0])),
      title: Text(name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(dosage),
        ],
      ),
      trailing: PopupMenuButton(
        itemBuilder: (BuildContext context) => [
          PopupMenuItem(
            child: Text('Edit'),
            onTap: onEdit,
          ),
          PopupMenuItem(
            child: Text('Delete'),
            onTap: onDelete,
          ),
        ],
        icon: Icon(Icons.more_vert),
      ),
    );
  }
}
