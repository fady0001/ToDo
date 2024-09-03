import 'package:flutter/material.dart';
import 'package:todoapp/pages/todo_list.dart';


void main(){
  runApp( const ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const TodoListPage(),
    );
  }
}
