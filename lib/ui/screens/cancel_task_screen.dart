import 'package:flutter/material.dart';
import '../data/network_caller/network_caller.dart';
import '../data/utility/urls.dart';
import '../widget/profile_summary_card.dart';
import '../widget/task_item_card.dart';

import '../data/models/task.dart';

class CancelTaskScreen extends StatefulWidget {
  const CancelTaskScreen({super.key});

  @override
  State<CancelTaskScreen> createState() => _CancelTaskScreenState();
}

class _CancelTaskScreenState extends State<CancelTaskScreen> {
  bool isLoading = false;
  final networkCaller = NetworkCaller();
  List<Task> tasks = [];

  Future fetchData() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });

      final response = await networkCaller
          .getRequest('${Urls.listTaskByStatus}/${TaskStatus.Cancelled.name}');

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

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummaryCard(),
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
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
