import 'package:flutter/material.dart';
import '../data/models/task.dart';
import '../data/network_caller/network_caller.dart';
import '../data/utility/urls.dart';
import 'snack_message.dart';

import '../data/models/network_response.dart';

class TaskItemCard extends StatefulWidget {
  const TaskItemCard({
    super.key,
    required this.task,
    required this.onStatuschange,
  });

  final Task task;
  final VoidCallback onStatuschange;

  @override
  State<TaskItemCard> createState() => _TaskItemCardState();
}

class _TaskItemCardState extends State<TaskItemCard> {
  TaskStatus selectedTask = TaskStatus.New;

  Future<void> _updateTask() async {
    Navigator.pop(context);
    final NetworkResponse response = await NetworkCaller().getRequest(
      '${Urls.updateTaskStatus}/${widget.task.sId}/${selectedTask.name}',
    );
    if (response.isSuccess) {
      // ignore: use_build_context_synchronously
      showSnackMessage(context, 'Successfully updated');
      widget.onStatuschange();
    }
  }

  Future<void> _deleteTask() async {
    final NetworkResponse response = await NetworkCaller().getRequest(
      '${Urls.deleteTask}/${widget.task.sId}',
    );
    if (response.isSuccess) {
      // ignore: use_build_context_synchronously
      showSnackMessage(context, 'Successfully deleted');
      widget.onStatuschange();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.task.title ?? '',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Text(
              widget.task.description ?? '',
            ),
            Text(
              widget.task.createdDate ?? '',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(
                    widget.task.status ?? '',
                  ),
                  backgroundColor: Colors.blue,
                ),
                Wrap(
                  children: [
                    IconButton(
                        onPressed: _deleteTask,
                        color: Colors.red,
                        icon: const Icon(Icons.delete_forever_outlined)),
                    IconButton(
                        onPressed: () {
                          showUpdateStatusModal();
                        },
                        icon: const Icon(Icons.edit)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showUpdateStatusModal() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Update Status',
            ),
            content: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: TaskStatus.values
                      .map(
                        (e) => Card(
                          color:
                              selectedTask == e ? Colors.green : Colors.white,
                          child: ListTile(
                            onTap: () {
                              setState(() {
                                selectedTask = e;
                              });
                            },
                            title: Text(
                              e.name,
                              style: TextStyle(
                                color: selectedTask == e
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),
            actions: [
              ButtonBar(
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel')),
                  TextButton(
                    onPressed: _updateTask,
                    child: const Text('Update'),
                  ),
                ],
              ),
            ],
          );
        });
  }
}

// ignore: constant_identifier_names
enum TaskStatus { New, Progress, Completed, Cancelled }
