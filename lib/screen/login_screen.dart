import 'package:flutter/material.dart';
import 'package:gallery/screen/gallery_screen.dart';
import 'package:gallery/service/user_service.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await context.read<UserService>().signInWithGoogle();
            if (context.read<UserService>().currentUser() != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => GalleryScreem(),
                ),
              );
            }
          },
          child: const Text("google login"),
        ),
      ),
    );
  }
}
