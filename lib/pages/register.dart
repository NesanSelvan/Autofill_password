// ignore_for_file: camel_case_types, unused_import

import 'package:autofill_password/constants/constants.dart';
import 'package:autofill_password/db/user.dart';
import 'package:autofill_password/pages/themes.dart';
import 'package:autofill_password/utils/myroutes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/sizeconfig.dart';
import 'Login_page.dart';

class register extends ConsumerWidget {
  final auth =
      FirebaseAuth.instance; // const name({Key? key}) : super(key: key);
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _buildContainer(BuildContext context, WidgetRef ref) {
    SizeConfig().init(context);
    return Column(
      children: <Widget>[
        Container(
          child: Text(
            'Create Account',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: kPrimaryColor),
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        SizedBox(
          width: SizeConfig.screenwidth! * 0.75,
          child: TextFormField(
            style: TextStyle(
                color: ref.watch(changeTheme).darkMode
                    ? Colors.white
                    : Colors.black),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.text_format_rounded),
              filled: true,
              fillColor: ref.watch(changeTheme).darkMode
                  ? Colors.grey.shade800
                  : Colors.grey.shade300,
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: kPrimaryColor, width: 2.0)),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: ref.watch(changeTheme).darkMode
                          ? Colors.grey.shade800
                          : Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(3)),
              labelText: 'Name',
              labelStyle: TextStyle(
                  color: ref.watch(changeTheme).darkMode
                      ? Colors.white
                      : Colors.black),
              hintText: 'Enter Name',
              hintStyle: TextStyle(
                  color: ref.watch(changeTheme).darkMode
                      ? Colors.white60
                      : Colors.black),
            ),
            controller: nameController,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: SizeConfig.screenwidth! * 0.75,
          child: TextFormField(
            style: TextStyle(
                color: ref.watch(changeTheme).darkMode
                    ? Colors.white
                    : Colors.black),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email),
              filled: true,
              fillColor: ref.watch(changeTheme).darkMode
                  ? Colors.grey.shade800
                  : Colors.grey.shade300,
              focusColor: kPrimaryColor,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor, width: 2.0),
                borderRadius: BorderRadius.circular(3),
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: ref.watch(changeTheme).darkMode
                          ? Colors.grey.shade800
                          : Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(3)),
              border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(18)),
              labelText: 'Email Address',
              labelStyle: TextStyle(
                  color: ref.watch(changeTheme).darkMode
                      ? Colors.white
                      : Colors.black),
              hintText: 'Enter Email Address',
              hintStyle: TextStyle(
                  color: ref.watch(changeTheme).darkMode
                      ? Colors.white60
                      : Colors.black),
            ),
            controller: emailController,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: SizeConfig.screenwidth! * 0.75,
          child: TextFormField(
            style: TextStyle(
                color: ref.watch(changeTheme).darkMode
                    ? Colors.white
                    : Colors.black),
            obscureText: true,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock),
              filled: true,
              fillColor: ref.watch(changeTheme).darkMode
                  ? Colors.grey.shade800
                  : Colors.grey.shade300,
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(3),
                  borderSide: BorderSide(color: kPrimaryColor, width: 2.0)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: ref.watch(changeTheme).darkMode
                          ? Colors.grey.shade800
                          : Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(3)),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(3)),
              labelText: ' Password',
              labelStyle: TextStyle(
                  color: ref.watch(changeTheme).darkMode
                      ? Colors.white
                      : Colors.black),
              hintText: 'Enter Password',
              hintStyle: TextStyle(
                  color: ref.watch(changeTheme).darkMode
                      ? Colors.white60
                      : Colors.black),
            ),
            controller: passwordController,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        ElevatedButton(
          style: TextButton.styleFrom(
              minimumSize: const Size(100, 40), backgroundColor: kPrimaryColor),
          onPressed: () async {
            debugPrint(nameController.text);
            try {
              final userCred = await auth.createUserWithEmailAndPassword(
                  email: emailController.text,
                  password: passwordController.text);
              if (userCred.user == null) {
                _scaffoldKey.currentState!.showSnackBar(const SnackBar(
                    content: Text(
                  "Error : in login",
                )));
              } else {
                await Userfirestore().createUserData(userCred.user!.uid,
                    nameController.text, emailController.text, [], "");
                Navigator.pushReplacementNamed(context, MyRoutes.homeRoute);
              }
            } on FirebaseAuthException catch (e) {
              _scaffoldKey.currentState!.showSnackBar(SnackBar(
                  content: Text(
                "Error : ${e.message}",
              )));
            }
          },
          child: const Text(
            'Register',
            style: TextStyle(
              color: Colors.black87,
            ),
          ),
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Already have an account?',
                style: TextStyle(
                    color: ref.watch(changeTheme).darkMode
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, MyRoutes.loginRoute);
                },
                child: Text('Sign in',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: kPrimaryColor)),
              ),
            ])
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: Container(
          width: SizeConfig.screenwidth,
          height: SizeConfig.screenheight,
          decoration: BoxDecoration(
              color: ref.watch(changeTheme).darkMode
                  ? Colors.black
                  : Colors.black),
          child: Stack(
            children: <Widget>[
              Container(
                  width: SizeConfig.screenwidth!,
                  height: SizeConfig.screenheight! * 0.57,
                  decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(70),
                          bottomRight: Radius.circular(70)))),
              Center(
                child: Container(
                  alignment: Alignment.center,
                  height: SizeConfig.screenheight! * 0.7,
                  width: SizeConfig.screenwidth! * 0.85,
                  decoration: BoxDecoration(
                      color: ref.watch(changeTheme).darkMode
                          ? Colors.grey.shade900
                          : Colors.white,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50))),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _buildContainer(context, ref),
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
