import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/presentation/pages/Home%20Page/HomePage.dart';
import 'package:to_do_app/presentation/pages/Login%20SignUp%20Page/login_bloc.dart';
import 'package:to_do_app/presentation/pages/splash%20page/splashpage.dart';

import 'common/theme/app_theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(BlocProvider(
    create: (context) => AuthBloc(FirebaseAuth.instance),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.bgcolor,
      routes: {
        '/home': (context) => HomePage(),
      },
      // Wrap the MaterialApp widget with BlocProvider for AuthBloc
      home: BlocProvider<AuthBloc>(
        create: (_) => AuthBloc(FirebaseAuth.instance),
        child: Splashpage(),
      ),
    );
  }
}
