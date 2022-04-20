//import 'package:basics/utils/routes.dart';
import 'package:autofill_password/constants/constants.dart';
import 'package:autofill_password/pages/addingpassword.dart';
import 'package:autofill_password/pages/allpasswords.dart';
import 'package:autofill_password/pages/homepage.dart';
import 'package:autofill_password/pages/login_page.dart';
import 'package:autofill_password/pages/register.dart';
import 'package:autofill_password/pages/themes.dart';
import 'package:autofill_password/utils/myroutes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

//import 'dart:ui';
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class AppTheme {
  static final lighttheme = ThemeData(
      scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      primaryColor: Colors.green,
      appBarTheme: AppBarTheme(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      textTheme: const TextTheme(
        headline6: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
      ));
  static final darktheme = ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: Color.fromARGB(255, 32, 32, 32),
      ),
      scaffoldBackgroundColor: Color.fromARGB(255, 32, 32, 32),
      backgroundColor: const Color(0xFF57859D),
      primaryColor: Colors.green,
      textTheme: const TextTheme(headline6: TextStyle(color: Colors.white)));
}

class MyApp extends ConsumerWidget {
  //var GoogleFonts;

  //const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(changeTheme);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: AppTheme.lighttheme,
      // darkTheme: AppTheme.darktheme,
      theme: currentTheme.darkMode ? AppTheme.darktheme : AppTheme.lighttheme,
      themeMode: currentTheme.darkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: "/login",
      routes: {
        "/login": (context) => LoginPage(),
        MyRoutes.registerRoute: (context) => register(),
        MyRoutes.homeRoute: (context) => HomePage(),
        MyRoutes.addingpassroute: (context) => Addingpass(),
        MyRoutes.allpasswordsroute: (context) => AllPassword(),

        //      MyRoutes.loginRoute: (context) => LoginPage(),
      },
    );
  }
}
