import 'package:cooptourism/core/util/animations/slide_transition.dart';
import 'package:cooptourism/data/models/task.dart';
import 'package:cooptourism/data/repositories/task_repository.dart';
import 'package:cooptourism/pages/tasks/add_proof.dart';
import 'package:flutter/material.dart';

final TaskRepository taskRepository = TaskRepository();

class SelectedTaskPage extends StatefulWidget {
  final String taskId;
  const SelectedTaskPage({super.key, required this.taskId});

  @override
  State<SelectedTaskPage> createState() => _SelectedTaskPageState();
}

class _SelectedTaskPageState extends State<SelectedTaskPage> {
  @override
  Widget build(BuildContext context) {
    final String taskId = widget.taskId;

    return Scaffold(
        appBar: _appBar(context, "Task Details"),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder(
                stream: taskRepository.streamSpecificTask(taskId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // show a loader while waiting for data
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return const Text('No Tasks available');
                  } else {
                    TaskModel task = snapshot.data as TaskModel;

                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          taskTitle(task),
                          taskDescription(task),
                          taskProgress(context, task),
                          divider(),
                          tasksText(),
                          ...buildToDoList(task),
                        ],
                      ),
                    );
                  }
                },
              )
            ],
          ),
        ));
  }

  List<Widget> buildToDoList(TaskModel task) {
    List<Widget> toDoList = [];

    for (ToDoItem item in task.toDoList) {
      toDoList.add(
        Row(
          children: [
            Checkbox(
              value: item.isChecked,
              activeColor: Theme.of(context).colorScheme.primary,
              onChanged: (value) {
                item.isChecked = value!;
                task.progress = calculateProgress(task);
                taskRepository.updateTask(task.uid, task);
              },
            ),
            Expanded (
              child: Text(item.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.normal, fontSize: 12)),
            ),

            // Add an circular container to push to the selected task page that says "Add proof" then push this to the most left
            IconButton(
              icon: const Icon(Icons.add),
              iconSize: 20,
              color: Theme.of(context).colorScheme.primary,
              onPressed: () {
                showAddProofPage(context, item, task);             
              },
            ),
          ],
        ),
      );
    }

    return toDoList;
  }

  double calculateProgress(TaskModel task) {
    double progress = 0.0;
    int totalTasks = task.toDoList.length;
    int completedTasks = 0;

    for (ToDoItem item in task.toDoList) {
      if (item.isChecked) {
        completedTasks++;
      }
    }

    progress = completedTasks / totalTasks;

    return progress;
  }

  Padding tasksText() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text('Tasks',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }

  Padding divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Divider(
        color: Colors.grey,
        thickness: 1,
      ),
    );
  }

  Column taskProgress(BuildContext context, TaskModel task) {
    return Column(
      children: [
        // Add a text of Progress 50%
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Row(
            children: [
              const Text('Progress ',
                  style:
                      TextStyle(fontWeight: FontWeight.normal, fontSize: 12)),
              Text('${(calculateProgress(task) * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: LinearProgressIndicator(
            value: calculateProgress(task),
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary),
          ),
        ),
      ],
    );
  }

  Padding taskDescription(TaskModel task) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(task.description,
          style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 12)),
    );
  }

  Padding taskTitle(TaskModel task) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Text(task.title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          ),

          // Add an icon button to push to the selected task page
          // IconButton(
          //   icon: const Icon(Icons.arrow_forward_ios),
          //   iconSize: 20,
          //   color: Theme.of(context).colorScheme.primary,
          //   onPressed: () {
          //     showAddProofPage(context);
          //   },
          // ),
        ],
      ),
    );
  }

  void showAddProofPage(BuildContext context, ToDoItem item, TaskModel task) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return AddTaskProofPage(item: item, task: task);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransitionAnimation(
            animation: animation,
            child: child,
          );
        },
      ),
    );
  }

  AppBar _appBar(BuildContext context, String title) {
    return AppBar(
      toolbarHeight: 70,
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
      title: Text(title,
          style: TextStyle(
              fontSize: 28, color: Theme.of(context).colorScheme.primary)),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            child: IconButton(
              onPressed: () {
                // showAddPostPage(context);
              },
              icon: const Icon(Icons.settings, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
