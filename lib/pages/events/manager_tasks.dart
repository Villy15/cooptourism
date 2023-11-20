import 'package:cooptourism/data/models/events.dart';
import 'package:cooptourism/data/models/task.dart';
import 'package:cooptourism/data/models/user.dart';
import 'package:cooptourism/data/repositories/task_repository.dart';
import 'package:cooptourism/data/repositories/user_repository.dart';
import 'package:cooptourism/pages/events/manager_task_selected.dart';
import 'package:cooptourism/pages/events/manager_tasks_create.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final TaskRepository taskRepository = TaskRepository();
final UserRepository userRepository = UserRepository();

class ManagerTasksPage extends ConsumerStatefulWidget {
  final EventsModel event;
  const ManagerTasksPage({super.key, required this.event});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ManagerTasksPageState();
}

class _ManagerTasksPageState extends ConsumerState<ManagerTasksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context, 'Event Details'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream: taskRepository.getAllTasksByReferenceId(widget.event.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // show a loader while waiting for data
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No Tasks available');
                } else {
                  List<TaskModel> taskList = snapshot.data!;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: taskList.length,
                    itemBuilder: (context, index) {
                      return taskCard(context, taskList[index]);
                    },
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Padding taskCard(BuildContext context, TaskModel task) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      child: Container(
        width: 400,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(20.0),
        ),
        // Circular border
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            taskTitle(task),
            taskDescription(task),
            taskProgress(context, task),

            divider(),

            // Assigned member
            assignedMember(task),

            // tasksText(),
            // ...buildToDoList(task),
          ],
        ),
      ),
    );
  }

  Padding assignedMember(TaskModel task) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        children: [
          const Text('Assigned Member: ',
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12)),
          FutureBuilder<UserModel>(
            future: userRepository.getUser(task.assignedMember!),
            builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Text(
                    "${snapshot.data!.firstName!} ${snapshot.data!.lastName!}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 12));
              }
            },
          ),
        ],
      ),
    );
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
            Text(item.title,
                style: const TextStyle(
                    fontWeight: FontWeight.normal, fontSize: 12)),
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
      padding: const EdgeInsets.only(top: 16.0, left: 16.0),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ManagerSelectedTask(taskId: task.uid!)));
              },
              child: Text(task.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
            ),
          ),

          // Add an icon button to push to the selected task page
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            iconSize: 20,
            color: Theme.of(context).colorScheme.primary,
            onPressed: () {
              // context.push('/tasks_page/${task.uid}');
            },
          ),
        ],
      ),
    );
  }

  AppBar _appBar(BuildContext context, String title) {
    return AppBar(
      iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      toolbarHeight: 70,
      title: Text(title,
          style: TextStyle(
              fontSize: 28, color: Theme.of(context).colorScheme.primary)),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            child: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ManagerTasksCreate(event: widget.event)));
              },
              icon: const Icon(Icons.add),
            ),
          ),
        ),
      ],
    );
  }
}
