import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../data/models/user_model.dart';
import '../data/network_caller/network_caller.dart';
import '../data/utility/urls.dart';
import 'forgot_password_screen.dart';
import 'main_bottom_nav_screen.dart';
import 'sign_up_screen.dart';
import '../widget/body_background.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final networkCaller = NetworkCaller();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //TODO : #1 create a sign in function
  Future<void> _signIn() async {
    final response = await networkCaller.postRequest(
      Urls.login,
      body: {
        "email": _emailTEController.text.trim(),
        "password": _passwordTEController.text.trim(),
      },
      isLogin: true,
    );
    if (response.statusCode == 200) {
      await AuthController.saveUserInformation(
        response.jsonResponse['token'],
        UserModel.fromJson(response.jsonResponse['data']),
      );
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MainBottomNavScreen()),
      );
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 80),
                    Text("Get started with",
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 24),
                    //TextField For Email
                    TextFormField(
                      controller: _emailTEController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: "Email",
                      ),
                      validator: (String? value) {
                        if (value?.isEmpty ?? true) {
                          return "enter a email";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    //TextField For Password
                    TextFormField(
                      controller: _passwordTEController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: "Password",
                      ),
                      validator: (String? value) {
                        if (value?.isEmpty ?? true) {
                          return "enter a password";
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
                            if (_formKey.currentState!.validate()) {
                              await _signIn();
                            }

                            if (_formKey.currentState!.validate()) {}
                          },
                          child: const Icon(Icons.arrow_circle_right_outlined)),
                    ),
                    const SizedBox(height: 48),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordScreen(),
                              ));
                        },
                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Don\'t have an account?',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SignUpScreen()));
                          },
                          child: const Text(
                            'Sign Up',
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
      ),
    );
  }

  //dispose method for memory reduce - D I S P O S E  M E T H O D
  @override
  void dispose() {
    _emailTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
