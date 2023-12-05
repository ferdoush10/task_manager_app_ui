import 'package:flutter/material.dart';
import 'package:task_manager_app/ui/screens/edit_profile_screen.dart';
import 'package:task_manager_app/ui/screens/login_screen.dart';

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
      title: const Text(
        "Md Ferdoush Wahid ",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      ),
      subtitle: const Text("ferdoush@gmail.com"),
      trailing: IconButton(
          onPressed: ()  {
            if (mounted) {
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
