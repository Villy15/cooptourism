import 'package:cooptourism/core/util/animations/slide_transition.dart';
import 'package:cooptourism/data/models/listing.dart';
import 'package:cooptourism/data/models/task.dart';
import 'package:cooptourism/data/repositories/task_repository.dart';
import 'package:cooptourism/pages/tasks/add_proof.dart';
import 'package:cooptourism/widgets/display_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListingTasks extends StatefulWidget {
  final ListingModel listing;
  const ListingTasks({super.key, required this.listing});

  @override
  State<ListingTasks> createState() => _ListingTasksState();
}

class _ListingTasksState extends State<ListingTasks> {
  @override
  Widget build(BuildContext context) {
    debugPrint("HELLOOO");
    TaskRepository taskRepository = TaskRepository();
    final listingTasks =
        taskRepository.getAllTasksByReferenceId(widget.listing.id);
    return StreamBuilder(
        stream: listingTasks,
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}  ');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final listingTasks = snapshot.data!;
          return ListView.builder(
              itemCount: listingTasks.length,
              itemBuilder: (context, taskIndex) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 20.0),
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
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(listingTasks[taskIndex].title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                              ),

                              // Add an icon button to push to the selected task page
                              IconButton(
                                icon: const Icon(Icons.arrow_forward_ios),
                                iconSize: 20,
                                color: Theme.of(context).colorScheme.primary,
                                onPressed: () {
                                  showModalBottomSheet(
                                    backgroundColor: Colors.white,
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return _ListingToDo(
                                          task: listingTasks[taskIndex]);
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            // Add a text of Progress 50%
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 4.0),
                              child: Row(
                                children: [
                                  const Text('Progress ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12)),
                                  Text(
                                      '${(calculateProgress(listingTasks[taskIndex]) * 100).toStringAsFixed(0)}%',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12)),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 4.0),
                              child: LinearProgressIndicator(
                                value:
                                    calculateProgress(listingTasks[taskIndex]),
                                backgroundColor: Colors.white,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).colorScheme.primary),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              });
        }));
  }

  double calculateProgress(TaskModel task) {
    double progress = 0.0;
    int? totalTasks = task.toDoList.length;
    int completedTasks = 0;

    if (totalTasks > 0) {
      for (ToDoItem item in task.toDoList) {
        if (item.isChecked) {
          completedTasks++;
        }
      }
      progress = completedTasks / totalTasks;
      return progress;
    } else {
      return 1;
    }
  }
}

class _ListingToDo extends StatefulWidget {
  final TaskModel task;
  const _ListingToDo({required this.task});

  @override
  State<_ListingToDo> createState() => __ListingToDoState();
}

class __ListingToDoState extends State<_ListingToDo> {
  @override
  Widget build(BuildContext context) {
    TaskRepository taskRepository = TaskRepository();
    if (widget.task.toDoList.isNotEmpty) {
      return SizedBox(
        height: 400,
        child: ListView.builder(
            itemCount: widget.task.toDoList.length,
            itemBuilder: (context, toDoIndex) {
              ListTile(
                leading: Checkbox(
                  value: widget.task.toDoList[toDoIndex].isChecked,
                  activeColor: Theme.of(context).colorScheme.primary,
                  onChanged: (value) {
                    widget.task.toDoList[toDoIndex].isChecked = value!;
                    widget.task.progress = calculateProgress(widget.task);
                    taskRepository.updateTask(widget.task.uid, widget.task);
                  },
                ),
                title: Text(widget.task.toDoList[toDoIndex].title,
                    style: const TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 12)),
                subtitle: Text(
                    'Date: ${DateFormat('dd/MM/yyyy HH:mm').format(widget.task.toDoList[toDoIndex].date!.toDate())}',
                    style: const TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 12)),
                trailing: widget.task.toDoList[toDoIndex].proof != "" &&
                        widget.task.toDoList[toDoIndex].proof != null
                    ? InkWell(
                        onTap: () {
                          showAddProofPage(
                              context,
                              widget.task.toDoList[toDoIndex],
                              widget.task,
                              toDoIndex);
                        },
                        child: DisplayImage(
                            path:
                                "tasks/${widget.task.toDoList[toDoIndex].proof!}",
                            width: 50,
                            height: 50,
                            radius: BorderRadius.circular(10)),
                      )
                    : IconButton(
                        icon: const Icon(Icons.add),
                        iconSize: 20,
                        color: Theme.of(context).colorScheme.primary,
                        onPressed: () {
                          showAddProofPage(
                              context,
                              widget.task.toDoList[toDoIndex],
                              widget.task,
                              toDoIndex);
                        },
                      ),
              );
              return null;
            }),
      );
    } else {
      return SizedBox(
        height: 400,
        width: double.infinity,
        child: Center(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  "No ToDo",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: FilledButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      onPressed: () {
                        taskRepository
                            .addToDoItem(ToDoItem(title: "", isChecked: false));
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.add),
                          SizedBox(width: 20),
                          Text("New ToDo")
                        ],
                      )))
            ],
          ),
        ),
      );
    }
  }

  double calculateProgress(TaskModel task) {
    double progress = 0.0;
    int? totalTasks = task.toDoList.length;
    int completedTasks = 0;

    if (totalTasks > 0) {
      for (ToDoItem item in task.toDoList) {
        if (item.isChecked) {
          completedTasks++;
        }
      }
      progress = completedTasks / totalTasks;
      return progress;
    } else {
      return 1;
    }
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
}
