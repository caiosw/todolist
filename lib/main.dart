import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(
    home: Home()
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _todoList = [];
  final _newTaskInput = TextEditingController();

  @override
  void initState() {
    super.initState();

    _readData().then((data) => {
      setState(() {
        _todoList = json.decode(data);
      })
    });
  }

  void _addTask() {
    setState(() {
      Map<String, dynamic> newTask = {"title": _newTaskInput.text, "done": false};
      _todoList.add(newTask);
      _newTaskInput.text = "";
      _saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter's TODO List"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "New Task",
                      labelStyle: TextStyle(color: Colors.blueAccent),
                    ),
                    controller: _newTaskInput,
                  ),
                ),
                RaisedButton(
                  color: Colors.blueAccent,
                  child: Text("ADD"),
                  textColor: Colors.white,
                  onPressed: _addTask,
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 10.0),
              itemCount: _todoList.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text(_todoList[index]["title"]),
                  value: _todoList[index]["done"],
                  secondary: CircleAvatar(
                    child: Icon(
                      _todoList[index]["done"] ? Icons.check : Icons.error
                    )
                  ),
                  onChanged: (checked) {
                    setState(() {
                      _todoList[index]["done"] = checked;
                      _saveData();
                    });
                  },
                );
              }
            )
          )
        ],
      ),
    );
  }


  Future<File> _getFile() async {
    // path_provider brings path
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_todoList);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
}

