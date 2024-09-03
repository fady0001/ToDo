import 'package:flutter/material.dart';
import 'package:todoapp/services/todo_service.dart';
import 'package:todoapp/utils/snackbar_helper.dart';


class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({super.key, this.todo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final todo = widget.todo;
    if(todo != null){
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text=title;
      descriptionController.text=description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black26,
        title: Center(
          child: Text(
            isEdit ? 'Edit Todo' : 'Add Todo',
            style:
            TextStyle(
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Title'
              ),
            ),
            SizedBox(height: 20,),
            TextField(
              controller: descriptionController,
                decoration: InputDecoration(
                    hintText: 'Description',
                ),
              keyboardType: TextInputType.multiline,
              minLines: 5,
              maxLines: 8,
            ),
            SizedBox(height: 20,),
            ElevatedButton(
                onPressed: isEdit ? UpdateData : submitData,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                      isEdit ? 'UPDATE' : 'SUBMIT'),
                ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> UpdateData() async{
    //Get the data from form
    final todo = widget.todo;
    if(todo == null){
      print('you can not call update whithout todo data');
      return;
    }
    final id = todo['_id'];
    // final isCompleted = todo['is_completed'];

    //Submit  update data to the server

    final isSuccess = await TodoService.updateTodo(id, body);

    //Show success or fail message based on status
    if(isSuccess){

      ShowSuccessMessage(context,message: 'Updation Success');
    }else{
      ShowErrorMessage(context,message: 'Updation   Field');
    }
  }

  Future<void> submitData() async{
    //Get the data from form
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };
    //Submit data to the server

     final isSuccess = await TodoService.addTodo(body);

    //Show success or fail message based on status
if(isSuccess){
  titleController.text= '';
  descriptionController.text= '';
  ShowSuccessMessage(context,message: 'Creation Success');
}else{
  ShowErrorMessage(context,message: 'Creation Field');
}
  }

  Map get body{
    //Get the data from form
    final title = titleController.text;
    final description = descriptionController.text;
    return {
      "title": title,
      "description": description,
      "is_completed": false
    };
  }
}
