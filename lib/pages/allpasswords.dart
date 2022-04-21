import 'dart:developer';

import 'package:autofill_password/constants/constants.dart';
import 'package:autofill_password/pages/fingerprintauth.dart';
import 'package:autofill_password/pages/themes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

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

class AllPassword extends ConsumerStatefulWidget {
  const AllPassword({Key? key}) : super(key: key);

  @override
  ConsumerState<AllPassword> createState() => _AllPasswordState();
}

class _AllPasswordState extends ConsumerState<AllPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: ref.watch(changeTheme).darkMode ? Colors.grey : Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // body: Center(
        //   child: Container(
        //     child:
        //         IconButton(onPressed: () async {}, icon: const Icon(Icons.add)),
        //   ),
      ),
      body:
          // SingleChildScrollView(
          //   physics: BouncingScrollPhysics(),
          //   scrollDirection: Axis.vertical,
          // ),

          const SafeArea(child: GetPasswords()),
    );
  }
}

class GetPasswords extends ConsumerStatefulWidget {
  const GetPasswords({Key? key}) : super(key: key);

  @override
  ConsumerState<GetPasswords> createState() => _GetPasswordsState();
}

class _GetPasswordsState extends ConsumerState<GetPasswords> {
  final LocalAuthentication auth = LocalAuthentication();
  bool? _canCheckBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  Future<void> _authenticate(int index) async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
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
      setState(() {
        showDialog(
          context: context,
          builder: (BuildContext context) => _buildPopupDialog(context, index),
        );
        selectedIndex = index;
      });
    }
  }

  late String? userId;
  bool isLoading = true;
  List<DocumentSnapshot> allDocs = [];
  // final  val;
  void password() async {
    final qDocs = (await FirebaseFirestore.instance
        .collection("websites")
        .where("uid", isEqualTo: userId)
        .get());
    for (final data in qDocs.docs) {
      allDocs.add(data);
    }

    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  Future<void> getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    userId = user?.uid;
    password();
  }

  // void updatefingerprint(String id) async {
  //   log("Website ID: $id");
  //   await FirebaseFirestore.instance
  //       .collection('websites')
  //       .doc(id)
  //       .update({"fingerprint": true});
  // }

  int selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        itemCount: allDocs.length,
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) => showpassword(index, ref),
      ),
    );
  }

  Widget showpassword(int index, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        _authenticate(index);
      },
      child: Container(
          child: isLoading
              ? const CustomCircularLoader()
              : Container(
                  margin: EdgeInsets.only(
                      top: 20, left: MediaQuery.of(context).size.width * 0.012),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(10),
                    color: selectedIndex == selectedIndex
                        ? ref.watch(changeTheme).darkMode
                            ? Colors.grey.shade700
                            : Colors.green
                        : Colors.transparent,
                  ),

                  // for (var i = 0; i < allDocs.length; i++) {

                  // }
                  child: Row(children: [
                    Icon(
                      Icons.account_circle,
                      color: ref.watch(changeTheme).darkMode
                          ? Colors.green
                          : Colors.grey.shade900,
                      size: 50,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      (allDocs[index].data()
                              as Map<String, dynamic>)["website_name"]
                          .toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        // color: selectedIndex == selectedIndex
                        //     ? Colors.grey[850]
                        //     : Colors.yellow,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ]),
                )),
      // : Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     child: Wrap(
      //       direction: Axis.horizontal,
      //       children: allDocs
      //           .map((e) => Padding(
      //                 padding: const EdgeInsets.all(8.0),
      //                 child: Text("${e['website_name ']}"),
      //               ))
      //           .toList(),
      //     )),
    );
  }

  Widget _buildPopupDialog(BuildContext context, int index) {
    final data =
        (allDocs[selectedIndex].data() as Map<String, dynamic>)["password"]
            .toString();
    final decrypt = Encryption.decrypt(data);
    //updatefingerprint(allDocs[index].id);

    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: const Text('Saved Password'),
      content: SizedBox(
        width: 150,
        height: 150,
        child: Column(
          children: [
            Text(
              "Website Name : " +
                  (allDocs[selectedIndex].data()
                          as Map<String, dynamic>)["website_name"]
                      .toString(),
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  // color: selectedIndex == selectedIndex
                  //     ? Colors.grey[850]
                  //     : Colors.yellow,
                  fontSize: 20),
            ),
            Text(
              "Username : " +
                  (allDocs[selectedIndex].data()
                          as Map<String, dynamic>)["username"]
                      .toString(),
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  // color: selectedIndex == selectedIndex
                  //     ? Colors.grey[850]
                  //     : Colors.yellow,
                  fontSize: 20),
            ),
            Text(
              "Password : " + decrypt,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  // color: selectedIndex == selectedIndex
                  //     ? Colors.grey[850]
                  //     : Colors.yellow,
                  fontSize: 20),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class CustomCircularLoader extends StatelessWidget {
  final double? size;
  const CustomCircularLoader({
    Key? key,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size ?? 50,
      height: size ?? 50,
      child: const CircularProgressIndicator(),
    );
  }
}
