import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ourpass/global/widgets/custom_elevated_button.dart';
import 'package:ourpass/repository/auth_repository.dart';
import 'package:ourpass/screens/home_page/home_page.dart';
import 'package:provider/provider.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool isEmailVerified = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    // check user's email verification status;
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      context.read<AuthRepository>().verifyEmail();
      timer = Timer.periodic(
          const Duration(seconds: 3), (_) => checkEmailVerified());
    }
  }

  cancel() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    // cancel timer when no longer in use to avoid memory leak
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return isEmailVerified
        ? const HomePage()
        : Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                    child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                      "A verification link has been to your registered email please Verify your email, check your inbox or spam folder."),
                )),
                OurpassElevatedButton(
                  buttonIdentifier: "cancel",
                  color: Colors.cyan,
                  isIconButton: false,
                  buttonLabel: "Cancel",
                  onPressed: () => cancel(),
                )
              ],
            ),
          );
  }
}
