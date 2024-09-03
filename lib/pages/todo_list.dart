import 'dart:async';
import 'package:flutter/material.dart';
import 'package:todoapp/pages/add_page.dart';
import 'package:todoapp/services/todo_service.dart';
import 'package:todoapp/utils/snackbar_helper.dart';
import 'package:todoapp/widgets/todo_card.dart';


class TodoListPage extends StatefulWidget {

  const TodoListPage({super.key,});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = true;
  List items = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTodo();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       backgroundColor: Colors.black26,
        title: Center(
            child: Text('Todo List',
              style:
              TextStyle(
                  fontWeight: FontWeight.bold),
            ),
        ),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
          onRefresh:fetchTodo ,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(child: Text('NO TODO ITEM',
            style:Theme.of(context).textTheme.displaySmall,
            ),),

            child: ListView.builder(
              itemCount: items.length,
                padding: EdgeInsets.all(8),
                itemBuilder: (context, index){
                final item = items[index] as Map;
                final id = item['_id'] as String;
                  return TodoCard(
                      item: item,
                      index: index,
                      navigateEdit: navigateToEditePage,
                      deleteById: deleteById
                  );
                }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: navigateToAddPage,
          label: Text('Add Todo'),

      ),
    );
  }

  Future <void> navigateToEditePage(Map item) async{
    final  route = MaterialPageRoute(builder: (context) => AddTodoPage(todo: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future <void> navigateToAddPage() async{
    final  route = MaterialPageRoute(builder: (context) => AddTodoPage(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> deleteById(String id) async{
    final isSuccess = await TodoService.deleteById(id);
    if(isSuccess){
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    }else{
      //Show error
      ShowErrorMessage(context,message: 'Deletion Field');
    }
  }


  Future <void> fetchTodo()async{

    final response = await TodoService.fetchTodo();
if(response != null){

  setState(() {
    items = response;
  });
}else{
  ShowErrorMessage(context,message: 'Somthing went wrong');
}
setState(() {
  isLoading = false;
});
  }



}