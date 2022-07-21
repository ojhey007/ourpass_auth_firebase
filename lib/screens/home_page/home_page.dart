import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ourpass/global/utils/navigation_fn.dart';
import 'package:ourpass/global/widgets/custom_elevated_button.dart';
import 'package:ourpass/repository/auth_repository.dart';
import 'package:ourpass/screens/login/login.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Welcome Home",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          Text("Email : ${user!.email}"),
          Text("UID : ${user.uid}"),
          OurpassElevatedButton(
            color: Colors.blue,
            buttonIdentifier: '',
            isIconButton: false,
            buttonLabel: "Logout",
            onPressed: () => context.read<AuthRepository>().signOut().then(
                (value) => pushUntil(context: context, page: LoginPage())),
          )
        ],
      )),
    );
  }
}
