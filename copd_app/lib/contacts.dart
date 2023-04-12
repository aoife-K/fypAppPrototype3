import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  bool _customTileExpanded = false;

  List<Widget> _listOfWidgets = [];
  final List<Contact> _contacts = [
    Contact(name: 'John Doe', phone: '555-1234', email: 'johndoe@example.com'),
    Contact(
        name: 'Jane Smith', phone: '555-5678', email: 'janesmith@example.com'),
  ];

  @override
  void initState() {
    super.initState();
    _listOfWidgets = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 150),
            Text("Contacts",
                style: TextStyle(
                  //color: Color.fromARGB(255, 91, 90, 90),
                  fontSize: 25.0,
                )),
            IconButton(
              onPressed: _addContact,
              icon: Icon(Icons.add),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                itemCount: _contacts.length,
                itemBuilder: (BuildContext context, int index) {
                  final contact = _contacts[index];

                  return Container(
                    height: 80.0,
                    child: GestureDetector(
                      onTap: () => _showOptionsDialog(context, index),
                      child: ListTile(
                        leading:
                            Icon(Icons.person, size: 40.0, color: Colors.blue),
                        title: Text(contact.name,
                            style: TextStyle(fontSize: 18.0)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(contact.phone,
                                style: TextStyle(fontSize: 15.0)),
                            Text(contact.email,
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
                              _editContact(index);
                            } else if (value == 'delete') {
                              _deleteContact(index);
                            }
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  void _showOptionsDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Contact Options'),
          actions: [
            TextButton(
              child: Text('Edit'),
              onPressed: () {
                Navigator.pop(context);
                _editContact(index);
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                setState(() {
                  _contacts.removeAt(index);
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _addContact() async {
    final result = await showDialog<Contact>(
      context: context,
      builder: (BuildContext context) => _buildAddContactDialog(),
    );

    if (result != null) {
      setState(() {
        _contacts.add(result);
      });
    }
  }

  Widget _buildAddContactDialog() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();

    return AlertDialog(
      title: Text('Add Contact'),
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
            controller: phoneController,
            decoration: InputDecoration(
              labelText: 'Phone',
            ),
          ),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Email',
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
            final phone = phoneController.text.trim();
            final email = emailController.text.trim();

            if (name.isNotEmpty && phone.isNotEmpty) {
              Navigator.of(context)
                  .pop(Contact(name: name, phone: phone, email: email));
            }
          },
        ),
      ],
    );
  }

  void _deleteContact(int index) {
    setState(() {
      _contacts.removeAt(index);
    });
  }

  void _editContact(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final nameController =
            TextEditingController(text: _contacts[index].name);
        final phoneController =
            TextEditingController(text: _contacts[index].phone);
        final emailController =
            TextEditingController(text: _contacts[index].email);

        return AlertDialog(
          title: Text('Edit Contact'),
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
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone',
                ),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
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
                final phone = phoneController.text;
                final email = emailController.text;
                final newContact =
                    Contact(name: name, phone: phone, email: email);

                setState(() {
                  _contacts[index] = newContact;
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

class Contact {
  final String name;
  final String phone;
  final String email;

  Contact({
    required this.name,
    required this.phone,
    required this.email,
  });
}

class ContactWidget extends StatelessWidget {
  final String name;
  final String phone;
  final String email;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  ContactWidget({
    required this.name,
    required this.phone,
    required this.email,
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
          Text(phone),
          Text(email),
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
