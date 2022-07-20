import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ourpass/global/utils/app_material_page_route.dart';
import 'package:ourpass/global/utils/app_modal.dart';
import 'package:ourpass/global/utils/navigation_fn.dart';
import 'package:ourpass/global/widgets/custom_elevated_button.dart';
import 'package:ourpass/global/widgets/form_spacer.dart';
import 'package:ourpass/repository/auth_repository.dart';
import 'package:ourpass/screens/home_page/home_page.dart';
import 'package:ourpass/screens/sign_up/sign_up.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  String title = "Ourpass Firebase Auth";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final loginFormKey = GlobalKey<FormState>();

  String? emailError;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  validateAndSaveForm() {
    final form = loginFormKey.currentState;
    if (!RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
        .hasMatch(_emailController.text)) {
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
    push(context: context, page: SignUp());
  }

  signIn() {
    if (validateAndSaveForm()) {
      showLoadingDialog(context);
      context
          .read<AuthRepository>()
          .signIn(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim())
          .then((value) => checkForDialog())
          .onError((error, stackTrace) =>
              showErrorMessage(context, error.toString()));
    }
  }

  checkForDialog() async {
    Navigator.pop(context);
    push(context: context, page: HomePage());
  }

  @override
  void initState() {
    initControllers();
    super.initState();
  }

  initControllers() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                        emailField(),
                        const FormSpacer(
                          isVertical: true,
                        ),
                        passwordField(),
                        const FormSpacer(
                          isVertical: true,
                        ),
                        loginButton(),
                        registerRoute()
                      ],
                    )),
              ],
            )));
  }

  Padding registerRoute() {
    return Padding(
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
    );
  }

  Row loginButton() {
    return Row(
      children: [
        Expanded(
            child: OurpassElevatedButton(
          buttonIdentifier: 'registerButton',
          buttonLabel: "Login",
          color: Colors.cyan,
          isIconButton: false,
          onPressed: signIn,
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
    );
  }

  TextFormField passwordField() {
    return TextFormField(
      key: const Key('password'),
      decoration: const InputDecoration(labelText: 'Password'),
      obscureText: true,
      controller: _passwordController,
      validator: (val) => val!.isEmpty ? 'Password can\'t be empty.' : null,
    );
  }

  TextFormField emailField() {
    return TextFormField(
      key: const Key('email'),
      decoration: InputDecoration(labelText: 'Email', errorText: emailError),
      controller: _emailController,
      validator: (val) => val!.isEmpty ? 'Email can\'t be empty.' : null,
    );
  }
}
