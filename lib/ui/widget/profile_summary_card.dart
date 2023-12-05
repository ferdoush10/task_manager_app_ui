import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../screens/edit_profile_screen.dart';
import '../screens/login_screen.dart';

class ProfileSummaryCard extends StatefulWidget {
  const ProfileSummaryCard({
    Key? key,
    this.enabledOnTap = true,
  }) : super(key: key);

  final bool enabledOnTap;

  @override
  State<ProfileSummaryCard> createState() => _ProfileSummaryCardState();
}

class _ProfileSummaryCardState extends State<ProfileSummaryCard> {
  @override
  Widget build(BuildContext context) {
    // Uint8List imageBytes =
    //     const Base64Decoder().convert(AuthController.user?.photo ?? '');
    return ListTile(
      onTap: () {
        if (widget.enabledOnTap) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const EditProfileScreen()));
        }
      },
      leading: const CircleAvatar(
        // child: AuthController.user?.photo == null
        //     ? const Icon(Icons.person)
        //     : Image.memory(imageBytes),
        child: Icon(Icons.person),
      ),
      title: Text(
        '${AuthController.user?.firstName} ${AuthController.user?.lastName}',
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      ),
      subtitle: Text(AuthController.user?.email ?? ''),
      trailing: IconButton(
          onPressed: () {
            if (mounted) {
              AuthController.clearAuthData();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false);
            }
          },
          icon: const Icon(
            Icons.logout,
            color: Colors.white,
          )),
      tileColor: Colors.green,
    );
  }
}
