import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../controllers/auth_controller.dart';
import 'login_screen.dart';
import '../widget/body_background.dart';

import 'main_bottom_nav_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    gotoLogin();
    super.initState();
  }

  void gotoLogin() async {
    final status = await AuthController.checkAuthState();
    if (!status) {
      Future.delayed(const Duration(seconds: 3)).then((value) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false);
      });
    } else {
      Future.delayed(const Duration(seconds: 3)).then((value) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const MainBottomNavScreen()),
            (route) => false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyBackground(
        child: Center(
          child: SvgPicture.asset(
            'assets/images/logo.svg',
            width: 120,
          ),
        ),
      ),
    );
  }
}
