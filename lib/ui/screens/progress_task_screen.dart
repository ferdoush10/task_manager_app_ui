import 'package:flutter/material.dart';
import 'package:task_manager_app/ui/widget/profile_summary_card.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(children: [
          ProfileSummaryCard(),
          Expanded(
            child: Text("Hello"),
          ),
        ]),
      ),
    );
  }
}
