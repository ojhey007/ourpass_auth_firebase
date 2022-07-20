import 'package:flutter/material.dart';
import 'package:ourpass/global/widgets/custom_elevated_button.dart';
import 'package:ourpass/repository/auth_repository.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: const Text("Welcome Home"),
          ),
          OurpassElevatedButton(
            color: Colors.blue,
            buttonIdentifier: '',
            isIconButton: false,
            buttonLabel: "Logout",
            onPressed: () => context
                .read<AuthRepository>()
                .signOut()
                .then((value) => Navigator.of(context).pop()),
          )
        ],
      )),
    );
  }
}
