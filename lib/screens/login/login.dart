import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ourpass/global/utility_function.dart';
import 'package:ourpass/global/utils/app_constant.dart';
import 'package:ourpass/global/utils/app_material_page_route.dart';
import 'package:ourpass/global/utils/app_modal.dart';
import 'package:ourpass/global/utils/navigation_fn.dart';
import 'package:ourpass/global/widgets/custom_elevated_button.dart';
import 'package:ourpass/global/widgets/form_spacer.dart';
import 'package:ourpass/repository/auth_repository.dart';
import 'package:ourpass/repository/storage_repository.dart';
import 'package:ourpass/screens/home_page/home_page.dart';
import 'package:ourpass/screens/sign_up/sign_up.dart';
import 'package:ourpass/screens/verify_email/verify_email.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  String title = "Ourpass Firebase Auth";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final loginFormKey = GlobalKey<FormState>();
  final secureStorageRepository = SecureStorageRepository();

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

  signIn() async {
    if (validateAndSaveForm()) {
      showLoadingDialog(context);
      await context
          .read<AuthRepository>()
          .signIn(
              context: context,
              email: _emailController.text.trim(),
              password: _passwordController.text.trim())
          .then((value) => checkForDialog(value));
    }
  }

  Future openBiometricAuthDialog() async {
    List isAuthenticated = await initBiometricAuthentication();
    initBiometricLogin(isAuthenticated);
  }

  void initBiometricLogin(List isAuthenticated) async {
    if (isAuthenticated[0] == true) {
      String? email = await secureStorageRepository.getValue(secureEmail);
      String? password = await secureStorageRepository.getValue(securePassword);

      if (email != null && password != null) {
        _emailController.text = email;
        _passwordController.text = password;

        signIn();
        return;
      } else {
        // ignore: use_build_context_synchronously
        showErrorMessage(
            context, "Please signin with email & password at least once");
      }
    } else {
      showErrorMessage(context, isAuthenticated[1] ?? "");
    }
  }

  checkForDialog(value) async {
    Navigator.pop(context);
    if (value.runtimeType == String) {
      showErrorMessage(context, value);
    }
    bool isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (isEmailVerified) {
      push(context: context, page: const VerifyEmail());
      saveCredentials();
    }
  }

  saveCredentials() {
    secureStorageRepository.saveValue(secureEmail, _emailController.text);
    secureStorageRepository.saveValue(securePassword, _passwordController.text);
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
        OurpassElevatedButton(
          color: Colors.amber,
          isIconButton: true,
          onPressed: openBiometricAuthDialog,
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
