import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/taskmodel.dart';
import 'package:todo_app/services/task_services.dart';
import 'package:uuid/uuid.dart';

class TaskPage extends StatefulWidget {
  final Taskmodel? task;
  final String? userid;
  const TaskPage({super.key, this.task,this.userid});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final TextEditingController _titlecontroller = TextEditingController();
  final TextEditingController _discriptioncontroller = TextEditingController();
  bool _edit = false;
  TaskServices _taskServices = TaskServices();
                          

  @override
  void dispose() {
    _titlecontroller.dispose();
    _discriptioncontroller.dispose();
    super.dispose();
  }

  loadData() {
    if (widget.task != null) {
      setState(() {
        _titlecontroller.text = widget.task!.title!;
        _discriptioncontroller.text = widget.task!.body!;
        _edit = true;
      });
    }
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  final _taskkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final ThemeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(30),
        child: Form(
          key: _taskkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _edit == true
                  ? Text(
                      "Update Task",
                      style: ThemeData.textTheme.displayMedium,
                    )
                  : Text(
                      "Add Task",
                      style: ThemeData.textTheme.displayMedium,
                    ),
              const SizedBox(
                height: 5,
              ),
              const Divider(
                height: 3,
                color: Colors.teal,
                endIndent: 50,
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                style: ThemeData.textTheme.displaySmall,
                controller: _titlecontroller,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "title is mandatory";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white70),
                        borderRadius: BorderRadius.circular(20)),
                    hintText: "enter task title",
                    hintStyle: ThemeData.textTheme.displaySmall),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                style: ThemeData.textTheme.displaySmall,
                controller: _discriptioncontroller,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "description is also mandatory";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white70),
                        borderRadius: BorderRadius.circular(20)),
                    hintText: "enter the description",
                    hintStyle: ThemeData.textTheme.displaySmall),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    if (_taskkey.currentState!.validate()) {
                      print('--------------------${widget.userid}');
                      if (_edit) {
                        Taskmodel taskmodel = Taskmodel(
                            id: widget.task!.id,
                            userid:widget.userid ,
                            title: _titlecontroller.text,
                            body: _discriptioncontroller.text,
                            status: widget.task!.status,
                            createdAt: widget.task!.createdAt);

                        _taskServices
                            .updateTask(taskmodel)
                            .then((value) => Navigator.pop(context));
                      } else {
                        _addtask();
                      }
                    }
                  },
                  child: Container(
                    height: 48,
                    width: 250,
                    decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                      child: _edit == true
                          ? Text(
                              "Update",
                              style: ThemeData.textTheme.displayMedium,
                            )
                          : Text(
                              "Add",
                              style: ThemeData.textTheme.displayMedium,
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _addtask() async {
    String? userid = FirebaseAuth.instance.currentUser!.uid;
    var id = Uuid().v1();
    Taskmodel taskmodel = Taskmodel(
        title: _titlecontroller.text,
        body: _discriptioncontroller.text,
        id: id,
        userid: userid,
        status: 1,
        createdAt: DateTime.now());

    TaskServices taskservices = TaskServices();
    final task = await taskservices.createTask(taskmodel);

    if (task != null) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Task created")));
    }
  }
}
