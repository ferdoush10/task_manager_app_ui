import 'package:flutter/material.dart';

import '../data/network_caller/network_caller.dart';
import '../data/utility/urls.dart';
import 'login_screen.dart';
import '../widget/body_background.dart';
import '../widget/snack_message.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.otp,
  });

  final String email;
  final String otp;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final networkCaller = NetworkCaller();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cPasswordController = TextEditingController();

  resetPassword() async {
    final response = await networkCaller.postRequest(
      Urls.recoverResetPass,
      body: {
        "email": widget.email,
        "OTP": widget.otp,
        "password": _passwordController.text.trim(),
      },
    );
    if (response.statusCode == 200) {
      print(response.jsonResponse);
      if (response.jsonResponse['status'] == 'success') {
        // ignore: use_build_context_synchronously
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      } else {
        // ignore: use_build_context_synchronously
        showSnackMessage(
            context, 'Error occured when changing password, try again!');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  Text("Set Password",
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  const Text(
                    "Minimum length password 8 character with Latter and number combination",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  //TextField For Email
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "Password",
                    ),
                  ),
                  const SizedBox(height: 16),
                  //TextField For Email
                  TextFormField(
                    controller: _cPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "Confirm password",
                    ),
                    validator: (v) {
                      if (v != _passwordController.text) {
                        return 'Confirm password';
                      } else {
                        return null;
                      }
                    },
                  ),

                  const SizedBox(height: 16),
                  //Elevated Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await resetPassword();
                      },
                      child: const Text('Confirm'),
                    ),
                  ),
                  const SizedBox(height: 48),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Have an account?',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                              (route) => false);
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _cPasswordController.dispose();
    super.dispose();
  }
}
