import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//import 'package:copd_app/custom_expansion_tile.dart';
enum SampleItem { itemOne, itemTwo, itemThree }

class ContactPage extends StatefulWidget {
  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  bool _customTileExpanded = false;
  SampleItem? selectedMenu;

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
          Text("Contacts",
              style: TextStyle(
                color: Color.fromARGB(255, 91, 90, 90),
                fontSize: 25.0,
              )),
          // FloatingActionButton(
          //   onPressed: () {
          //     setState(() {
          //       print("fab clicked");
          //       _addItemToList(); // new method
          //     });
          //   },
          //   child: Text("+"),
          //   backgroundColor: Colors.blue,
          // ),
          SizedBox(height: 60),
          // ListTile(
          //   title: Text('John Doe'),
          //   subtitle: Text('Carer'),
          //   leading: Icon(Icons.person),
          //   trailing: Icon(Icons.more_vert),
          // ),
          ExpansionTile(
            title: const Text('Jane Doe'),
            subtitle: const Text('Physician'),
            trailing: PopupMenuButton<SampleItem>(
              initialValue: selectedMenu,
              // Callback that sets the selected popup menu item.
              onSelected: (SampleItem item) {
                setState(() {
                  selectedMenu = item;
                });
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<SampleItem>>[
                const PopupMenuItem<SampleItem>(
                  value: SampleItem.itemOne,
                  child: Text('Edit'),
                ),
                const PopupMenuItem<SampleItem>(
                  value: SampleItem.itemTwo,
                  child: Text('Delete'),
                ),
                // const PopupMenuItem<SampleItem>(
                //   value: SampleItem.itemThree,
                //   child: Text('Item 3'),
                // ),
              ],
            ),
            leading: Icon(
              _customTileExpanded ? Icons.person : Icons.person,
            ),
            children: const <Widget>[
              ListTile(
                  title:
                      Text('Phone: 123-456-7890 \nEmail: janedoe@gmail.com')),
            ],
            // onExpansionChanged: (bool expanded) {
            //   setState(() => _customTileExpanded = expanded);
            // },
          ),
          ExpansionTile(
            title: const Text('John Doe'),
            subtitle: const Text('Carer'),
            trailing: PopupMenuButton<SampleItem>(
              initialValue: selectedMenu,
              // Callback that sets the selected popup menu item.
              onSelected: (SampleItem item) {
                setState(() {
                  selectedMenu = item;
                });
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<SampleItem>>[
                const PopupMenuItem<SampleItem>(
                  value: SampleItem.itemOne,
                  child: Text('Edit'),
                ),
                const PopupMenuItem<SampleItem>(
                  value: SampleItem.itemTwo,
                  child: Text('Delete'),
                ),
                // const PopupMenuItem<SampleItem>(
                //   value: SampleItem.itemThree,
                //   child: Text('Item 3'),
                // ),
              ],
            ),
            leading: Icon(
              _customTileExpanded ? Icons.person : Icons.person,
            ),
            children: const <Widget>[
              ListTile(
                  title:
                      Text('Phone: 123-456-7890 \nEmail: johndoe@gmail.com')),
            ],
            onExpansionChanged: (bool expanded) {
              setState(() => _customTileExpanded = expanded);
            },
            // onLongPress: () {
            //   setState(() {
            //     print("fab clicked");
            //     _addItemToList(); // new method
            //   });
            // },
          ),
          for (var item in _listOfWidgets) item,
          // ListTile(
          //   title: Text('Add New Contact...'),
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
    );
  }

  _addItemToList() {
    //<Widget> _listOfWidgets = [];
    List<Widget> tempList =
        _listOfWidgets; // defining a new temporary list which will be equal to our other list
    tempList.add(ExpansionTile(
      title: const Text('New Contact'),
      subtitle: const Text('Occupation'),
      leading: Icon(Icons.person),
      trailing: Icon(
        _customTileExpanded ? Icons.more_vert : Icons.more_vert,
      ),
      children: const <Widget>[
        ListTile(title: Text('Phone:\nEmail:')),
      ],
      onExpansionChanged: (bool expanded) {
        setState(() => _customTileExpanded = expanded);
      },
    )); // adding a new item to the list
    setState(() {
      _listOfWidgets =
          tempList; // this will trigger a rebuild of the ENTIRE widget, therefore adding our new item to the list!
    });
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_contacts/flutter_contacts.dart';

// void main() => runApp(FlutterContactsExample());

// class FlutterContactsExample extends StatefulWidget {
//   @override
//   _FlutterContactsExampleState createState() => _FlutterContactsExampleState();
// }

// class _FlutterContactsExampleState extends State<FlutterContactsExample> {
//   List<Contact>? _contacts;
//   bool _permissionDenied = false;

//   @override
//   void initState() {
//     super.initState();
//     _fetchContacts();
//   }

//   Future _fetchContacts() async {
//     if (!await FlutterContacts.requestPermission(readonly: true)) {
//       setState(() => _permissionDenied = true);
//     } else {
//       final contacts = await FlutterContacts.getContacts();
//       setState(() => _contacts = contacts);
//     }
//   }

//   @override
//   Widget build(BuildContext context) => MaterialApp(
//       home: Scaffold(
//           appBar: AppBar(title: Text('flutter_contacts_example')),
//           body: _body()));

//   Widget _body() {
//     if (_permissionDenied) return Center(child: Text('Permission denied'));
//     if (_contacts == null) return Center(child: CircularProgressIndicator());
//     return ListView.builder(
//         itemCount: _contacts!.length,
//         itemBuilder: (context, i) => ListTile(
//             title: Text(_contacts![i].displayName),
//             onTap: () async {
//               final fullContact =
//                   await FlutterContacts.getContact(_contacts![i].id);
//               await Navigator.of(context).push(
//                   MaterialPageRoute(builder: (_) => ContactPage(fullContact!)));
//             }));
//   }
// }

// class ContactPage extends StatelessWidget {
//   final Contact contact;
//   ContactPage(this.contact);

//   @override
//   Widget build(BuildContext context) => Scaffold(
//       appBar: AppBar(title: Text(contact.displayName)),
//       body: Column(children: [
//         Text('First name: ${contact.name.first}'),
//         Text('Last name: ${contact.name.last}'),
//         Text(
//             'Phone number: ${contact.phones.isNotEmpty ? contact.phones.first.number : '(none)'}'),
//         Text(
//             'Email address: ${contact.emails.isNotEmpty ? contact.emails.first.address : '(none)'}'),
//       ]));
// }
