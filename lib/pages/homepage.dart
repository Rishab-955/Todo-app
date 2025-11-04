import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todoapp/data/database.dart';
import 'package:todoapp/util/dialog_box.dart';
import 'package:todoapp/util/todo_tile.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  //reference the hive box
  final _myBox = Hive.box('mybox');

  //text controller
  final _controller = TextEditingController();
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    //if this is the first time ever opening the app
    if(_myBox.get("TODOLIST")== null) {
      db.createInitialData();
    }else{
      db.loadData();
    }
    super.initState();
  }


  //list of things to do
  // List toDoList = [
  //   ["Make jokes", false],
  //   ["Do something", false]
  // ];

  void checkBoxChanged(bool? value, int index){
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }
// save a new task 
  void saveNewTask(){
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }
  void createNewTask(){
    showDialog(
        context: context,
        builder: (context){
          return DialogBox(
            controller: _controller,
            onSave: saveNewTask,
            onCancel: () => Navigator.of(context).pop(),
          );
        },
    );
  }

  //deletes the container
  void deleteTask(int index){
    setState(() {
      db.toDoList.removeAt(index);
      db.updateDataBase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        title: Text("TO DO"),
        centerTitle: true,
        backgroundColor: Colors.yellow[300],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow[400],
        onPressed: createNewTask,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder:(context, index){
          return TodoTile(
              taskName: db.toDoList[index][0],
              taskCompleted: db.toDoList[index][1],
              onChanged: (value) => checkBoxChanged(value, index),
              deleteFunction: (context) => deleteTask(index),
          );
        },
      ),
      // body: ListView(
      //   children: [
      //     TodoTile(
      //       taskName: "make joke",
      //       taskCompleted: true,
      //       onChanged: (p0) {},
      //     ),
      //     TodoTile(
      //       taskName: "make examples",
      //       taskCompleted: false,
      //       onChanged: (p0) {},
      //     ),
      //   ],
      // ),
    );
  }
}
