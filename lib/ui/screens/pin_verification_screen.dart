import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../data/network_caller/network_caller.dart';
import '../data/utility/urls.dart';
import 'login_screen.dart';
import 'reset_password_screen.dart';
import '../widget/body_background.dart';

class PinVerificationScreen extends StatefulWidget {
  const PinVerificationScreen({
    super.key,
    required this.email,
  });

  final String email;

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  final networkCaller = NetworkCaller();

  String otp = '';

  recoverVerifyOTP() async {
    final response = await networkCaller.getRequest(
      '${Urls.recoverVerifyOTP}/${widget.email}/$otp',
    );
    if (response.statusCode == 200) {
      print(response.jsonResponse);
      if (response.jsonResponse['status'] != 'fail') {
        // ignore: use_build_context_synchronously
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResetPasswordScreen(
                email: widget.email,
                otp: otp,
              ),
            ));
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
                  Text("Pin Verification",
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  const Text(
                    "A 6 digit OTP will be sent to your email address",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),

                  PinCodeTextField(
                    appContext: context,
                    length: 6,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,
                      activeColor: Colors.green,
                      selectedFillColor: Colors.white,
                      inactiveFillColor: Colors.white,
                    ),
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    onCompleted: (v) {
                      //  print('completed');
                      otp = v;
                    },
                    onChanged: (value) {
                      otp = value;
                    },
                    beforeTextPaste: (text) {
                      return true;
                    },
                  ),

                  const SizedBox(height: 16),
                  //Elevated Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await recoverVerifyOTP();
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             const ResetPasswordScreen()));
                      },
                      child: const Text("Verify"),
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
}
