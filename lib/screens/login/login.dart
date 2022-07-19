import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ourpass/globals/app_material_page_route.dart';
import 'package:ourpass/globals/navigation_fn.dart';
import 'package:ourpass/globals/widgets/custom_elevated_button.dart';
import 'package:ourpass/globals/widgets/form_spacer.dart';
import 'package:ourpass/screens/sign_up/sign_up.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String _email = "";
  late String _password;

  final loginFormKey = GlobalKey<FormState>();

  String? emailError;
  late TextEditingController loginEmailController;
  late TextEditingController loginPasswordController;

  validateAndSaveForm() {
    final form = loginFormKey.currentState;
    if (!RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
        .hasMatch(loginEmailController.text)) {
      setState(() {
        emailError = "Enter a Valid email";
      });
    } else if (form!.validate()) {
      setState(() {
        emailError = null;
      });
      form.save();
      return true;
    }
    return false;
  }

  gotoRegister() {
    push(context: context, page: SignUp(title: 'Sign Up'));
  }

  @override
  void initState() {
    initControllers();
    super.initState();
  }

  initControllers() {
    loginEmailController = TextEditingController();
    loginPasswordController = TextEditingController();
  }

  @override
  dispose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();
    super.dispose();
  }

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
                          decoration: InputDecoration(
                              labelText: 'Email', errorText: emailError),
                          controller: loginEmailController,
                          validator: (val) =>
                              val!.isEmpty ? 'Email can\'t be empty.' : null,
                          onSaved: (val) => _email = val!,
                        ),
                        const FormSpacer(
                          isVertical: true,
                        ),
                        TextFormField(
                          key: const Key('password'),
                          decoration:
                              const InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          controller: loginPasswordController,
                          validator: (val) =>
                              val!.isEmpty ? 'Password can\'t be empty.' : null,
                          onSaved: (val) => _password = val!,
                        ),
                        const FormSpacer(
                          isVertical: true,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: OurpassElevatedButton(
                              buttonIdentifier: 'registerButton',
                              buttonLabel: "Login",
                              color: Colors.cyan,
                              isIconButton: false,
                              onPressed: validateAndSaveForm,
                            )),
                            const FormSpacer(isVertical: false),
                            const OurpassElevatedButton(
                              color: Colors.amber,
                              isIconButton: true,
                              onPressed: null,
                              iconData: Icons.fingerprint,
                              buttonIdentifier: 'FingerPrintButton',
                            )
                          ],
                        )
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("New user? "),
                      GestureDetector(
                        onTap: gotoRegister,
                        child: const Text(
                          "Register",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            )));
  }
}
