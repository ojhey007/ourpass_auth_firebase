import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ourpass/global/utils/app_modal.dart';
import 'package:ourpass/global/utils/navigation_fn.dart';
import 'package:ourpass/global/widgets/custom_elevated_button.dart';
import 'package:ourpass/global/widgets/form_spacer.dart';
import 'package:ourpass/repository/auth_repository.dart';
import 'package:ourpass/screens/login/login.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  final String title = " Ourpass Firebase Auth";

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final signupFormKey = GlobalKey<FormState>();

  String? emailError;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  bool validateAndSaveForm() {
    final form = signupFormKey.currentState;
    if (!RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
        .hasMatch(_emailController.text)) {
      setState(() {
        emailError = "Enter a Valid email";
      });
      return false;
    } else if (form!.validate()) {
      setState(() {
        emailError = null;
      });
      form.save();
      return true;
    }
    return false;
  }

  registerUser() async {
    if (validateAndSaveForm()) {
      showLoadingDialog(context);
      context
          .read<AuthRepository>()
          .signUp(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          )
          .then((value) {
        Navigator.of(context).pop();
        showErrorMessage(context, value);
      });
    }
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

  signIn() {
    pushUntil(context: context, page: LoginPage());
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
          title: const Text("Sign Up"),
        ),
        body: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                    key: signupFormKey,
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
                        registerButton(),
                        loginRoute()
                      ],
                    )),
              ],
            )));
  }

  Padding loginRoute() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Already registered? "),
          GestureDetector(
            onTap: signIn,
            child: const Text(
              "Login",
              style: TextStyle(
                decoration: TextDecoration.underline,
              ),
            ),
          )
        ],
      ),
    );
  }

  Row registerButton() {
    return Row(
      children: [
        Expanded(
          child: OurpassElevatedButton(
            buttonIdentifier: 'registerButton',
            onPressed: registerUser,
            isIconButton: false,
            buttonLabel: 'Register',
            color: Colors.amber,
          ),
        ),
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
