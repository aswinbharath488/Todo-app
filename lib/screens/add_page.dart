import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/services/todo_service.dart';
import 'package:todo_app/utils/snackbar_helper.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({
    super.key,
    this.todo,
  });

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController Descriptioncontroller = TextEditingController();
  bool isedit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isedit = true;
      final title = todo['title'];
      final description = todo['description'];
      titlecontroller.text = title;
      Descriptioncontroller.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new_rounded)),
        title: Text(
          isedit ? 'Edit Todo' : "Add Todo",
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: titlecontroller,
            cursorColor: Colors.grey,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2)),
                labelText: "Title",
                labelStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey))),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: Descriptioncontroller,
            cursorColor: Colors.grey,
            decoration: InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
                labelStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey))),
            keyboardType: TextInputType.multiline,
            maxLines: 8,
            minLines: 5,
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              if (isedit) {
                updatedata(context);
              } else {
                submitdata(context);
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8))),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                isedit ? 'update' : "Submit",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    letterSpacing: .6,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> updatedata(BuildContext context) async {
    final todo = widget.todo;
    if (todo == null) {
      print("you can nott call updated without todo data");
      return;
    }
    final id = todo['_id'];

    final title = titlecontroller.text;
    final Description = Descriptioncontroller.text;
    final body = {
      "title": title,
      "description": Description,
      "is_completed": false,
    };

    //submit updated data to the surver
    final isSuccess = await todoservice.updatetodo(id, body);

    //show success or fail message based on status

    if (isSuccess) {
      Navigator.pop(context);
      showserrormessage(context, message: 'updation Success');
    } else {
      showserrormessage(context, message: 'updation Failed');
    }
  }

  Future<void> submitdata(BuildContext context) async {
    //get the data from form
    final title = titlecontroller.text;
    final Description = Descriptioncontroller.text;
    final body = {
      "title": title,
      "description": Description,
      "is_completed": false,
    };

    //submit data to the surver

    final isSuccess = await todoservice.addtodo(body);

    //Show success or fail message based on status
    if (isSuccess) {
      titlecontroller.text = '';
      Descriptioncontroller.text = '';
      showserrormessage(context, message: 'Creation Success');
      Navigator.pop(context);
    } else {
      showserrormessage(context, message: 'Creation Failed');
    }
  }
}
