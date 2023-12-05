import 'package:flutter/material.dart';
import '../data/models/task.dart';
import '../data/models/task_count.dart';
import '../data/models/task_count_summary_list_model.dart';
import '../data/network_caller/network_caller.dart';
import '../data/utility/urls.dart';
import 'add_new_task_screen.dart';
import '../widget/profile_summary_card.dart';
import '../widget/sumarry_card.dart';
import '../widget/task_item_card.dart';

class NewTasksScreen extends StatefulWidget {
  const NewTasksScreen({super.key});

  @override
  State<NewTasksScreen> createState() => _NewTasksScreenState();
}

class _NewTasksScreenState extends State<NewTasksScreen> {
  bool isLoading = false;
  final networkCaller = NetworkCaller();
  List<Task> tasks = [];
  List<TaskCount> taskCountList = [];

  Future fetchData() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });

      final response = await networkCaller
          .getRequest('${Urls.listTaskByStatus}/${TaskStatus.New.name}');

      setState(() {
        isLoading = false;
      });
      if (response.statusCode == 200) {
        final t = (response.jsonResponse['data'] as Iterable)
            .map((e) => Task.fromJson(e))
            .toList();

        setState(() {
          tasks = t;
        });
      }
    }
  }

  Future fetchSummeryCardData() async {
    final response = await networkCaller.getRequest(Urls.getTaskStatusCount);

    if (response.statusCode == 200) {
      final res = TaskSumaryListCountModel.fromJson(response.jsonResponse);
      if (res.status == 'success') {
        setState(() {
          taskCountList = res.taskCountList ?? [];
        });
      }
    }
  }

  @override
  void initState() {
    fetchData();
    fetchSummeryCardData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummaryCard(),
            SizedBox(
              height: 120,
              child: taskCountList.isEmpty
                  ? const Center(child: Text('Not tasks available'))
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: taskCountList.length,
                      itemBuilder: (context, index) {
                        return SummeryCard(
                          title: taskCountList[index].sId ?? '',
                          count: '${taskCountList[index].sum ?? 0}',
                        );
                      }),
            ),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        return TaskItemCard(
                          task: tasks[index],
                          onStatuschange: () {
                            fetchData();
                            fetchSummeryCardData();
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const AddNewTaskScreen();
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
