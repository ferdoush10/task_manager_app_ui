import 'package:flutter/material.dart';
import '../data/models/network_response.dart';
import '../data/network_caller/network_caller.dart';
import '../data/utility/urls.dart';
import '../widget/body_background.dart';
import '../widget/profile_summary_card.dart';
import '../widget/snack_message.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  bool _createTaskInProgress = false;
  final TextEditingController _subjetTEController = TextEditingController();
  final TextEditingController _descriptionTEController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final networkCaller = NetworkCaller();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummaryCard(),
            Expanded(
                child: BodyBackground(
              child: SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32),
                      Text("Add New Task",
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 16),
                      //Subjet text Fields
                      TextFormField(
                        controller: _subjetTEController,
                        decoration: const InputDecoration(hintText: "Subject"),
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return "Enter a subject";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      //Description text Field
                      TextFormField(
                        controller: _descriptionTEController,
                        maxLines: 8,
                        decoration:
                            const InputDecoration(hintText: "Description"),
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return "Write a description";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: _createTaskInProgress
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : ElevatedButton(
                                onPressed: _createTask,
                                child: const Icon(
                                    Icons.arrow_circle_right_outlined),
                              ),
                      ),
                    ],
                  ),
                ),
              )),
            ))
          ],
        ),
      ),
    );
  }

  Future<void> _createTask() async {
    if (_formKey.currentState!.validate()) {
      _createTaskInProgress = true;
      if (mounted) {
        setState(() {});
      }
      final NetworkResponse response =
          await NetworkCaller().postRequest(Urls.createTask, body: {
        "title": _subjetTEController.text.trim(),
        "description": _descriptionTEController.text.trim(),
        "status": "Cancelled"
      });
      _createTaskInProgress = false;
      if (mounted) {
        setState(() {});
      }
      if (response.isSuccess) {
        _subjetTEController.clear();
        _descriptionTEController.clear();
        if (mounted) {
          showSnackMessage(context, "New task added!");
        }
      } else {
        if (mounted) {
          showSnackMessage(
              context, "Failed to creat new task, try again!", true);
        }
      }
    }
  }

  @override
  void dispose() {
    _subjetTEController.dispose();
    _descriptionTEController.dispose();
    super.dispose();
  }
}
