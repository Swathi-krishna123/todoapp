import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/taskmodel.dart';
import 'package:todo_app/screens/task_page.dart';
import 'package:todo_app/services/task_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TaskServices _taskServices = TaskServices();
  
  @override
  Widget build(BuildContext context) {
    String? _uid=FirebaseAuth.instance.currentUser!.uid;
    final ThemeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {print('-------------------------$_uid');
          Navigator.pushNamed(context, '/taskpage');
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Text("Hi", style: ThemeData.textTheme.displayMedium),
                        const SizedBox(
                          width: 10,
                        ),
                        Text("swathi",
                            style: ThemeData.textTheme.displayMedium),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    child: IconButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut().then((value) =>
                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/', (route) => false));
                        },
                        icon: const Icon(Icons.logout_outlined)),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "Your fields",
                style: ThemeData.textTheme.displayMedium,
              ),
              const SizedBox(
                height: 15,
              ),
              StreamBuilder<List<Taskmodel>>(
                  stream: _taskServices.getallTasks(_uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "Some errors are occured!!!",
                          style: ThemeData.textTheme.displaySmall,
                        ),
                      );
                    }
                    if (snapshot.hasData && snapshot.data!.length == 0) {
                      return Center(
                        child: Text(
                          "No Task added",
                          style: ThemeData.textTheme.displaySmall,
                        ),
                      );
                    }
                    if (snapshot.hasData && snapshot.data!.length != 0) {
                      List<Taskmodel> tasks = snapshot.data ?? [];
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final _task = tasks[index];
                            print(_task);
                            return Card(
                              color: ThemeData.scaffoldBackgroundColor,
                              elevation: 5.0,
                              child: ListTile(
                                leading: const Icon(
                                  Icons.circle_outlined,
                                  color: Colors.white,
                                ),
                                title: Text(
                                  "${_task.title}",
                                  style: ThemeData.textTheme.displaySmall,
                                ),
                                subtitle: Text(
                                  "${_task.body}",
                                  style: ThemeData.textTheme.displaySmall,
                                ),
                                trailing: Container(
                                    width: 100,
                                    child: Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              
                                              Navigator.push(context,MaterialPageRoute(builder: (context)=>TaskPage(task: _task,userid:_uid)));
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Colors.teal,
                                            )),
                                        IconButton(
                                            onPressed: () {
                                              _taskServices.deleteTask(_task.id);
                                            },
                                            icon: const Icon(Icons.delete,
                                                color: Colors.red))
                                      ],
                                    )),
                              ),
                            );
                          });
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
