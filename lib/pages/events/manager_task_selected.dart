import 'package:cooptourism/core/util/animations/slide_transition.dart';
import 'package:cooptourism/data/models/task.dart';
import 'package:cooptourism/data/repositories/task_repository.dart';
import 'package:cooptourism/pages/tasks/add_proof.dart';
import 'package:cooptourism/widgets/display_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final TaskRepository taskRepository = TaskRepository();

class ManagerSelectedTask extends StatefulWidget {
  final String taskId;
  const ManagerSelectedTask({super.key, required this.taskId});

  @override
  State<ManagerSelectedTask> createState() => _ManagerSelectedTaskState();
}

class _ManagerSelectedTaskState extends State<ManagerSelectedTask> {
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
                    return const Center(child: Text('No Tasks available'));
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
        Column(
          children: [
            ListTile(
              leading: Checkbox(
                value: item.isChecked,
                activeColor: Theme.of(context).colorScheme.primary,
                onChanged: null,
              ),
              title: Text(item.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.normal, fontSize: 12)),
              subtitle: Text(
                  'Date: ${DateFormat('dd/MM/yyyy HH:mm').format(item.date!.toDate())}',
                  style: const TextStyle(
                      fontWeight: FontWeight.normal, fontSize: 12)),
              trailing: item.proof != "" && item.proof != null
                  ? DisplayImage(
                      path: "tasks/${item.proof!}",
                      width: 50,
                      height: 50,
                      radius: BorderRadius.circular(10))
                  : const Text(
                      'No Proof',
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 12),
                    ),
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
              Expanded(
                // This will take up all available space and push the button to the right
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // context.push('/events_page/${task.referenceId}');
                    },
                    child: const Text('Approve Task'),
                  ),
                ),
              ),
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

  void showAddProofPage(
      BuildContext context, ToDoItem item, TaskModel task, int index) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return AddTaskProofPage(item: item, task: task, index: index);
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
          style: TextStyle(color: Theme.of(context).colorScheme.primary)),
    );
  }
}
