import 'package:hive/hive.dart';

class ToDoDataBase{

  List toDoList = [];


  //reference the box

  final _mybox = Hive.box('mybox');

  //run this method if this is the 1st time ever opening the app
  void createInitialData(){
    toDoList = [
      ["Make jokes", false],
      ["Do something", false]
    ];
  }

  //load the data from database
  void loadData(){
    toDoList = _mybox.get("TODOLIST");
  }

  // update the database
  void updateDataBase(){
    _mybox.put("TODOLIST", toDoList);
  }
}