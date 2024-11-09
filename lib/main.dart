import 'package:ctree/pages/auth/CYO/presenter/page/CYO.dart';
import 'package:ctree/pages/auth/data/auth_repository.dart';
import 'package:ctree/pages/auth/signin/presenter/pages/signin_page.dart';
import 'package:ctree/pages/auth/signin/presenter/state/auth_sigin_state.dart';
import 'package:ctree/pages/auth/signup/presenter/pages/signup_page.dart';
import 'package:ctree/pages/auth/signup/presenter/state/auth_signup_state.dart';
import 'package:ctree/core/styles/theme/theme.dart';
import 'package:ctree/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthSignupState(AuthRepository(FirebaseAuth.instance)),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthSiginState(AuthRepository(FirebaseAuth.instance)),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CTREE',
      theme: AppTheme.lightTheme,
      routes: {
        '/': (context) => const CYOPage(),
        '/signin': (context) => const SignInPage(),
        '/signup': (context) => const SignUpPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
