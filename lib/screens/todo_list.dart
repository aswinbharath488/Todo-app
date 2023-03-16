import 'package:flutter/material.dart';
import 'package:todo_app/screens/add_page.dart';
import 'package:todo_app/services/todo_service.dart';
import 'package:todo_app/utils/snackbar_helper.dart';
import 'package:todo_app/widgets/todo_card.dart';

class todolist extends StatefulWidget {
  const todolist({super.key});

  @override
  State<todolist> createState() => _todolistState();
}

class _todolistState extends State<todolist> {
  bool isloading = true;
  List items = [];
  @override
  void initState() {
    super.initState();
    fetchtodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Todo List"),
          centerTitle: true,
        ),
        body: Visibility(
          visible: isloading,
          child: Center(
            child: CircularProgressIndicator(
              color: Colors.grey,
            ),
          ),
          replacement: RefreshIndicator(
            onRefresh: fetchtodo,
            child: Visibility(
              visible: items.isNotEmpty,
              replacement: Center(
                child: Text(
                  ' no todo item',
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              child: ListView.builder(
                itemCount: items.length,
                padding: EdgeInsets.all(12),
                itemBuilder: ((context, index) {
                  final item = items[index] as Map;

                  final id = item['_id'] as String;
                  return todocard(
                    index: index,
                    item: item,
                    navigateedit: navigateToeditPage,
                    deleteById: deleteById,
                  );
                }),
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: ElevatedButton(
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(10),
              shape: CircleBorder(),
              backgroundColor: Colors.white),
          onPressed: navigateToAddPage,
          child: Icon(
            Icons.add,
            size: 25,
            color: Colors.black,
          ),
        ));
  }

  Future<void> navigateToeditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(todo: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isloading = true;
    });
    fetchtodo();
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(),
    );
    await Navigator.push(context, route);
    setState(() {
      isloading = true;
    });
    fetchtodo();
  }

  Future<void> deleteById(String id) async {
    //delete the item

    final isSuccess = await todoservice.deleteById(id);
    if (isSuccess) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      showserrormessage(context, message: 'deletion failed');
    }
  }

  Future<void> fetchtodo() async {
    final response = await todoservice.fetchtodos();
    if (response != null) {
      setState(() {
        items = response;
      });
    } else {
      showserrormessage(context, message: 'somthing went wrong');
    }
    setState(() {
      isloading = false;
    });
  }
}
