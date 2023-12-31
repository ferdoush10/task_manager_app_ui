import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/auth_controller.dart';
import '../data/models/user_model.dart';
import '../data/network_caller/network_caller.dart';
import '../data/utility/urls.dart';
import 'main_bottom_nav_screen.dart';
import '../widget/body_background.dart';
import '../widget/profile_summary_card.dart';
import '../widget/snack_message.dart';

import '../data/models/network_response.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool updateInProgress = false;

  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String imageString = '';

  @override
  void initState() {
    setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          const ProfileSummaryCard(
            enabledOnTap: false,
          ),
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
                    Text("Update Profile",
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 16),
                    photoPickerField(),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailTEController,
                      decoration: const InputDecoration(hintText: "Email"),
                      validator: (value) {
                        if (value!.isEmpty ||
                            !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,3}')
                                .hasMatch(value)) {
                          return "Enter correct email";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _firstNameTEController,
                      decoration: const InputDecoration(hintText: "First Name"),
                      validator: (String? value) {
                        if (value!.trim().isEmpty) {
                          return "Enter your first name";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _lastNameTEController,
                      decoration: const InputDecoration(hintText: "Last Name"),
                      validator: (String? value) {
                        if (value!.trim().isEmpty) {
                          return "Enter your last name";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _mobileTEController,
                      decoration: const InputDecoration(hintText: "Mobile"),
                      validator: (String? value) {
                        if (value!.trim().isEmpty) {
                          return " enter mobile number";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      obscureText: true,
                      controller: _passwordTEController,
                      decoration: const InputDecoration(hintText: "Password"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "enter a password";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await updateProfile();
                          }
                        },
                        child: const Icon(Icons.arrow_circle_right_outlined),
                      ),
                    ),
                  ],
                ),
              ),
            )),
          )),
        ],
      )),
    );
  }

  Future<void> setData() async {
    _emailTEController.text = AuthController.user?.email ?? '';
    _firstNameTEController.text = AuthController.user?.firstName ?? '';
    _lastNameTEController.text = AuthController.user?.lastName ?? '';
    _mobileTEController.text = AuthController.user?.mobile ?? '';
  }

  Future<void> updateProfile() async {
    if (_formKey.currentState!.validate()) {
      updateInProgress = true;
      if (mounted) {
        setState(() {});
      }
      final NetworkResponse response = await NetworkCaller().postRequest(
        Urls.updateProfile,
        body: {
          "email": _emailTEController.text.trim(),
          "firstName": _firstNameTEController.text.trim(),
          "lastName": _lastNameTEController.text.trim(),
          "mobile": _mobileTEController.text.trim(),
          "password": _passwordTEController.text.trim(),
        },
      );
      updateInProgress = false;
      if (mounted) {
        setState(() {});
      }
      if (response.isSuccess) {
        if (mounted) {
          showSnackMessage(context, "Profile updated!");
        }

        await AuthController.updateUserInformation(
          UserModel.fromJson({
            "email": _emailTEController.text.trim(),
            "firstName": _firstNameTEController.text.trim(),
            "lastName": _lastNameTEController.text.trim(),
            "mobile": _mobileTEController.text.trim(),
            "photo": '',
          }),
        );
        _emailTEController.clear();
        _firstNameTEController.clear();
        _lastNameTEController.clear();
        _mobileTEController.clear();
        _passwordTEController.clear();

        // ignore: use_build_context_synchronously
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute<void>(
                builder: (BuildContext context) => const MainBottomNavScreen()),
            (Route<dynamic> route) => false);
      } else {
        if (mounted) {
          showSnackMessage(
              context, "Failed to update profile, try again!", true);
        }
      }
    }
  }

  Container photoPickerField() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(children: [
        Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () async {
                final ImagePicker picker = ImagePicker();
                final img = await picker.pickImage(source: ImageSource.gallery);
                if (img != null) {
                  final bytes = await File(img.path).readAsBytes();
                  imageString = base64.encode(bytes);
                }
              },
              child: Container(
                alignment: Alignment.center,
                height: 50,
                decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    )),
                child: const Text(
                  'Photo',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )),
        const Expanded(
          flex: 3,
          child: Text('Select a photo'),
        ),
      ]),
    );
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();

    super.dispose();
  }
}
