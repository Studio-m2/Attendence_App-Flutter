import 'package:flutter/material.dart';
import 'dart:core';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //List list = [];
  String insert = "";
  DateTime date = DateTime.now();
  late List<String> list = [];
  final String _listKey = 'myList';
  //List<MyList> myList = [1, 2, 4];
  //List<MyList> myList =s [];

  @override
  void initState() {
    super.initState();
    _loadList();
  }

  //void _deleteList() async {
  //SharedPreferences prefs = await SharedPreferences.getInstance();
  //await prefs.remove("_listKey");

  //setState(() {
  //insert = "";
  //});
  //}

  void _saveList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_listKey, list);
  }

  void _loadList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      list = (prefs.getStringList(_listKey) ?? []);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text("Attendance_App"),
        centerTitle: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: TextField(
                    onChanged: (String value) {
                      insert = value;
                    },
                  ),
                  title: Text("Do you want to save data"),
                  actions: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        setState(() {
                          list.add(insert);
                          _saveList();
                          Navigator.pop(context);
                        });
                      },
                      icon: Icon(Icons.save),
                      label: Text('save'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          Navigator.pop(context);
                        });
                      },
                      icon: Icon(Icons.cancel),
                      label: Text('cancle'),
                    ),
                  ],
                );
              });
        },
        child: Icon(Icons.add),
      ),
      body: Material(
        color: Colors.blue,
        child: ListView.separated(
          itemCount: list.length,
          separatorBuilder: (BuildContext context, int index) => const Divider(
            height: 1.4,
          ),
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              trailing: Wrap(
                spacing: 12, // space between two icons
                children: <Widget>[
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: TextField(
                                onChanged: (String value) {
                                  insert = value;
                                },
                              ),
                              title: Text("edit your data"),
                              actions: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      list[index] = insert;
                                    });
                                    _saveList();
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.edit),
                                  label: Text('edit'),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.cancel),
                                  label: Text('cancle'),
                                ),
                              ],
                            );
                          });
                    },
                    icon: Icon(Icons.edit),
                    label: Text('Edit'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Are you want to delete"),
                              actions: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      list.removeAt(index);
                                      _saveList();

                                      Navigator.pop(context);
                                    });
                                  },
                                  icon: Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  ),
                                  label: Text('yes'),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      Navigator.pop(context);
                                    });
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ),
                                  label: Text('no'),
                                ),
                              ],
                            );
                          });
                    },
                    icon: Icon(Icons.delete),
                    label: Text('delete'),
                  ),
                ],
              ),
              title: Text(list[index]),
              subtitle: Text(date.toString()),
            );
          },
        ),
      ),
    );
  }
}