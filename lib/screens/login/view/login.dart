import 'package:flutter/material.dart';
import 'package:ourpass/screens/login/controller/login_controller.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String _email;
  late String _password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                    key: loginFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          key: const Key('email'),
                          decoration: const InputDecoration(labelText: 'Email'),
                          validator: (val) =>
                              val!.isEmpty ? 'Email can\'t be empty.' : null,
                          onSaved: (val) => _email = val!,
                        ),
                        TextFormField(
                          key: const Key('password'),
                          decoration:
                              const InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          validator: (val) =>
                              val!.isEmpty ? 'Password can\'t be empty.' : null,
                          onSaved: (val) => _password = val!,
                        ),
                        const ElevatedButton(
                            key: Key('login'),
                            onPressed: validateAndSaveForm,
                            child: Text('Login',
                                style: TextStyle(fontSize: 20.0))),
                      ],
                    )),
              ],
            )));
  }
}
