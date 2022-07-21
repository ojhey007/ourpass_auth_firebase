import 'package:flutter/material.dart';
import 'package:ourpass/global/utils/app_modal.dart';
import 'package:ourpass/models/user_model.dart';
import 'package:ourpass/repository/auth_repository.dart';
import 'package:ourpass/screens/login/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ourpass/screens/verify_email/verify_email.dart';
import 'package:provider/provider.dart';
import 'screens/home_page/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthRepository>(
            create: (_) => AuthRepository(),
          ),
        ],
        child: MaterialApp(
            title: 'Ourpass Demo',
            theme: ThemeData(
              primarySwatch: Colors.cyan,
            ),
            home: const AuthWrapper()));
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthRepository>(context);
    return Scaffold(
        body: StreamBuilder(
            stream: authService.user,
            builder: (
              _,
              AsyncSnapshot<User?> snapshot,
            ) {
              if (snapshot.connectionState == ConnectionState.active) {
                final User? user = snapshot.data;
                return user == null ? LoginPage() : VerifyEmail();
              }
              return const Center(child: CircularProgressIndicator());
            }));
  }
}
