import 'package:autofill_password/constants/constants.dart';
import 'package:autofill_password/pages/fingerprintauth.dart';
import 'package:autofill_password/pages/themes.dart';
import 'package:autofill_password/utils/myroutes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Encryption {
  static const encryptionKey = 'UNIQUE';

  static String encrypt(String data) {
    var charCount = data.length;
    var encrypted = [];
    var kp = 0;
    var kl = encryptionKey.length - 1;

    for (var i = 0; i < charCount; i++) {
      var other = data[i].codeUnits[0] ^ encryptionKey[kp].codeUnits[0];
      encrypted.insert(i, other);
      kp = (kp < kl) ? (++kp) : (0);
    }
    return dataToString(encrypted);
  }

  static String decrypt(data) {
    return encrypt(data);
  }

  static String dataToString(data) {
    var s = "";
    for (var i = 0; i < data.length; i++) {
      s += String.fromCharCode(data[i]);
    }
    return s;
  }
}

class Addingpass extends ConsumerStatefulWidget {
  @override
  ConsumerState<Addingpass> createState() => _AddingpassState();
}

class _AddingpassState extends ConsumerState<Addingpass> {
  final websitelinkcontroller = TextEditingController();
  final namecontroller = TextEditingController();
  final passwordController = TextEditingController();
  Future<String> getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    return uid ?? "";
  }

  late String _password;
  double _strength = 0;

  RegExp numReg = RegExp(r".*[0-9].*");
  RegExp letterReg = RegExp(r".*[A-Za-z].*");

  String _displayText = 'Password Strength checker';

  void _checkPassword(String value) {
    _password = value.trim();

    if (_password.isEmpty) {
      setState(() {
        _strength = 0;
        _displayText = 'Please enter you password';
      });
    } else if (_password.length < 6) {
      setState(() {
        _strength = 1 / 4;
        _displayText = 'Your password is too short';
      });
    } else if (_password.length < 8) {
      setState(() {
        _strength = 2 / 4;
        _displayText = 'Your password is acceptable but not strong';
      });
    } else {
      if (!letterReg.hasMatch(_password) || !numReg.hasMatch(_password)) {
        setState(() {
          // Password length >= 8
          // But doesn't contain both letter and digit characters
          _strength = 3 / 4;
          _displayText = 'Your password is strong';
        });
      } else {
        // Password length >= 8
        // Password contains both letter and digit characters
        setState(() {
          _strength = 1;
          _displayText = 'Your password is great';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        child: Padding(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 30,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Website Link",
                      style: TextStyle(
                          height: 1,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade400),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: TextField(
                      style: TextStyle(
                          color: ref.watch(changeTheme).darkMode
                              ? Colors.white
                              : Colors.black),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.power_input_sharp,
                        ),

                        fillColor: ref.watch(changeTheme).darkMode
                            ? Colors.grey.shade800
                            : Colors.grey.shade200,
                        filled: true,
                        focusColor: Colors.grey,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide:
                                BorderSide(color: kPrimaryColor, width: 2.0)),
                        //labelText: 'website link ',
                        labelText: 'Website',
                        hintText: 'Enter the website link',
                        hintStyle: TextStyle(
                            color: ref.watch(changeTheme).darkMode
                                ? Colors.grey.shade200
                                : Colors.grey.shade900),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: ref.watch(changeTheme).darkMode
                                    ? Colors.grey.shade900
                                    : Colors.grey.shade200)),
                      ),
                      controller: websitelinkcontroller,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Username ",
                      style: TextStyle(
                          height: 1,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextField(
                      style: TextStyle(
                          color: ref.watch(changeTheme).darkMode
                              ? Colors.white
                              : Colors.black),
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          fillColor: ref.watch(changeTheme).darkMode
                              ? Colors.grey.shade800
                              : Colors.grey.shade200,
                          filled: true,
                          focusColor: kPrimaryColor,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide:
                                  BorderSide(color: kPrimaryColor, width: 3.0)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: kPrimaryColor, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: ref.watch(changeTheme).darkMode
                                      ? Colors.grey.shade900
                                      : Colors.grey.shade200)),
                          labelText: 'Name',
                          // labelText: 'User Name',
                          hintText: 'Enter Your Name',
                          hintStyle: TextStyle(
                              color: ref.watch(changeTheme).darkMode
                                  ? Colors.grey.shade200
                                  : Colors.grey.shade900)),
                      controller: namecontroller,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Password",
                      style: TextStyle(
                          height: 1,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextField(
                      style: TextStyle(
                          color: ref.watch(changeTheme).darkMode
                              ? Colors.white
                              : Colors.black),
                      obscureText: true,
                      onChanged: (value) => _checkPassword(value),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        fillColor: ref.watch(changeTheme).darkMode
                            ? Colors.grey.shade800
                            : Colors.grey.shade200,
                        filled: true,
                        focusColor: kPrimaryColor,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide:
                                BorderSide(color: kPrimaryColor, width: 3.0)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: ref.watch(changeTheme).darkMode
                                    ? Colors.grey.shade900
                                    : Colors.grey.shade200)),
                        labelText: 'Password',
                        hintText: 'Enter Password',
                        hintStyle: TextStyle(
                            color: ref.watch(changeTheme).darkMode
                                ? Colors.grey.shade200
                                : Colors.grey.shade900),
                      ),
                      controller: passwordController,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  // The strength indicator bar
                  LinearProgressIndicator(
                    value: _strength,
                    backgroundColor: Colors.grey[300],
                    color: _strength <= 1 / 4
                        ? Colors.red
                        : _strength == 2 / 4
                            ? Colors.yellow
                            : _strength == 3 / 4
                                ? Colors.blue
                                : Colors.green,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    _displayText,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    textColor: Colors.white,
                    color: kPrimaryColor,
                    child: const Text('Save Account '),
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text("Successfull"),
                          content: const Text("Password successfully added"),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                                Navigator.pushNamed(
                                    context, MyRoutes.homeRoute);
                              },
                              child: const Text("okay"),
                            ),
                          ],
                        ),
                      );
                      final encrypt =
                          Encryption.encrypt(passwordController.text);
                      //   debugPrint(encypt);
                      //   final dep = Encryption.decrypt(encypt);
                      //   debugPrint(dep);
                      final userId = await getCurrentUser();
                      final firestore = FirebaseFirestore.instance;
                      firestore.collection("websites").add({
                        "website_name": websitelinkcontroller.text,
                        "username": namecontroller.text,
                        "password": encrypt,
                        "uid": userId,
                      });
                    },
                  )
                ],
              ),
            )),
      ),
    ));
  }
}
