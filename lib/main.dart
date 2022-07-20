import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ourpass/repository/auth_repository.dart';
import 'package:ourpass/screens/login/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ourpass/screens/sign_up/sign_up.dart';
import 'package:ourpass/screens/verify_email/verify_email.dart';
import 'package:provider/provider.dart';

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
          create: (_) => AuthRepository(FirebaseAuth.instance),
        ),
        StreamProvider(
            create: (context) =>
                context.watch<AuthRepository>().authStateChanges,
            initialData: null)
      ],
      child: MaterialApp(
        title: 'Ourpass Demo',
        theme: ThemeData(
          primarySwatch: Colors.cyan,
        ),
        home: context.read<User?>() == null ? LoginPage() : const VerifyEmail(),
      ),
    );
  }
}
