//import 'dart:html';

import 'dart:async';

import 'package:autofill_password/constants/constants.dart';
import 'package:autofill_password/db/user.dart';
import 'package:autofill_password/pages/themes.dart';
import 'package:autofill_password/utils/myroutes.dart';
//import 'package:basics/utils/routes.dart';
// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
//import 'package:basics/pages/home_page.dart';
//import 'dart:ui';
//import 'package:flutter/material.dart';

class LoginPage extends ConsumerStatefulWidget {
  //const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final LocalAuthentication fingerprintauth = LocalAuthentication();
  bool? _canCheckBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await fingerprintauth.authenticate(
        localizedReason: 'Let OS determine authentication method',
        //  useErrorDialogs: true,
        //   stickyAuth: true
      );
      setState(() {
        _isAuthenticating = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = "Error - $e";
      });
      return;
    }
    if (!mounted) return;

    setState(
        () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
    if (authenticated) {
      Navigator.pushReplacementNamed(context, MyRoutes.homeRoute);
    }
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  FirebaseAuth get auth => FirebaseAuth.instance;

  Future<void> checkLoginIn() async {
    debugPrint("${await GoogleSignIn().isSignedIn()}");
    if (await GoogleSignIn().isSignedIn()) {
      _authenticate();
    }
    debugPrint("${FirebaseAuth.instance.currentUser}");
  }

  @override
  void initState() {
    super.initState();
    checkLoginIn();
  }

  Future<void> performGoogleLogin() async {
    try {
      final result = await GoogleSignIn().signIn();
      debugPrint("Result : $result");
      if (result != null) {
        GoogleSignInAuthentication _googleAuth = await result.authentication;
        if (_googleAuth.idToken != null && _googleAuth.accessToken != null) {
          final sonuc = await FirebaseAuth.instance.signInWithCredential(
              GoogleAuthProvider.credential(
                  idToken: _googleAuth.idToken,
                  accessToken: _googleAuth.accessToken));
          User? _user = sonuc.user;

          if (_user != null) {
            await Userfirestore().createUserData(
                _user.uid,
                _user.displayName ?? "",
                _user.email ?? "",
                [],
                _user.photoURL ?? "");
            Navigator.pushReplacementNamed(context, MyRoutes.loginRoute);
          }
        }
      }
    } catch (e) {
      debugPrint("Error : ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          e.toString(),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                // image: DecorationImage(
                //     image: AssetImage(
                //       'assets/login-bg.jpg',
                //     ),
                //     colorFilter: ColorFilter.mode(
                //         Colors.grey[700]!.withOpacity(0.5), BlendMode.colorBurn),
                //     fit: BoxFit.cover),
                ),
            child: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/shield.png",
                      fit: BoxFit.cover,
                      height: 75,
                    ),
                    //   SvgPicture.asset(
                    //     "assets/svg/login-svg.svg",
                    //     height: MediaQuery.of(context).size.height* 0.25,
                    //     width: MediaQuery.of(context).size.width
                    //   ),

                    Text(
                      'PASSWORDZ',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 18.0, horizontal: 32.0),
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email),

                              filled: true,
                              fillColor: ref.watch(changeTheme).darkMode
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade300,
                              focusColor: kPrimaryColor,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                    color: kPrimaryColor, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ref.watch(changeTheme).darkMode
                                          ? Colors.grey.shade900
                                          : Colors.white)),

                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              hintText: "Enter Email",
                              hintStyle: TextStyle(
                                  color: ref.watch(changeTheme).darkMode
                                      ? Colors.white
                                      : Colors.black),
                              //  hintStyle: TextStyle(color: Colors.white),
                              labelText: "Email",
                              labelStyle: TextStyle(
                                  color: ref.watch(changeTheme).darkMode
                                      ? Colors.white
                                      : Colors.black),
                            ),
                            controller: emailController,
                            style: TextStyle(
                                color: ref.watch(changeTheme).darkMode
                                    ? Colors.white
                                    : Colors.black),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              filled: true,
                              fillColor: ref.watch(changeTheme).darkMode
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade300,
                              focusColor: kPrimaryColor,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      color: kPrimaryColor, width: 2.0)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ref.watch(changeTheme).darkMode
                                          ? Colors.grey.shade900
                                          : Colors.white)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              hintText: "Enter Password",
                              hintStyle: TextStyle(
                                  color: ref.watch(changeTheme).darkMode
                                      ? Colors.white
                                      : Colors.black),
                              labelText: "Password",
                              labelStyle: TextStyle(
                                  color: ref.watch(changeTheme).darkMode
                                      ? Colors.white
                                      : Colors.black),
                            ),
                            controller: passwordController,
                            style: TextStyle(
                                color: ref.watch(changeTheme).darkMode
                                    ? Colors.white
                                    : Colors.black),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          ElevatedButton(
                            child: const Text(
                              "Login",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: TextButton.styleFrom(
                                minimumSize: const Size(75, 36),
                                backgroundColor: kPrimaryColor),
                            onPressed: () async {
                              try {
                                final userData =
                                    await auth.signInWithEmailAndPassword(
                                        email: emailController.text,
                                        password: passwordController.text);

                                // final UserCredential =
                                if (userData.user != null) {
                                  Navigator.pushReplacementNamed(
                                      context, MyRoutes.homeRoute);
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      "Something went wrong",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ));
                                }
                              } on FirebaseAuthException catch (e) {
                                debugPrint("Error:${(e.toString())}");
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                    e.toString(),
                                  ),
                                ));
                              }
                            },
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    child: const Divider()),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Or',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: ref.watch(changeTheme).darkMode
                                          ? Colors.white
                                          : Colors.black),
                                  // style: (fon),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    child: const Divider()),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Image.asset('assets/google.png'),
                                iconSize: 10,
                                onPressed: performGoogleLogin,
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'New to this app?',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: ref.watch(changeTheme).darkMode
                                        ? Colors.white
                                        : Colors.black),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, MyRoutes.registerRoute);
                                },
                                child: Text(
                                  'Register',
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
