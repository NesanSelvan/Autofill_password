import 'dart:developer';

import 'package:autofill_password/constants/constants.dart';
import 'package:autofill_password/main.dart';
import 'package:autofill_password/pages/addingpassword.dart';
import 'package:autofill_password/pages/themes.dart';
import 'package:autofill_password/utils/myroutes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';

import 'custom_animated_bottombar.dart';

//import 'package:basics/login_page.dart';
//import 'dart:ui';
class HomePage extends ConsumerStatefulWidget {
  //const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _currentIndex = 0;
  final _inactiveColor = Colors.grey;

  final user = FirebaseAuth.instance.currentUser;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int index = 0;
  List<Widget> screens = [
    // body(),
    // MoviePage(),
    // ProfileScreen(),
    //ProfileScreen(),
  ];

  void getInitialData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.pushReplacementNamed(context, MyRoutes.loginRoute);
      return;
    }
    final data = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();
    debugPrint("Data: ${data.data()}");
    final userData = data.data();
    if (userData == null) {
      Navigator.pushReplacementNamed(context, MyRoutes.loginRoute);
      return;
    }
//     else {
//       try {
//         final favourites = userData['favourites'] as List;
//         if (favourites.isEmpty) {
//           Timer(Duration(seconds: 1), () async {
//             await dialog().showMyDialog(context);
//             getInitialData();
//           });
//         }
//       } catch (e) {}
//     }
    ///   await Userfirestore.addIfCustomUserIdNotExists();
  }

  @override
  void initState() {
    super.initState();
    getInitialData();

    // if (FirebaseAuth.instance.currentUser == null) {
    //   Navigator.pushReplacementNamed(context, MyRoutes.loginRoute);
    // }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.read(changeTheme).darkMode;
    final theme = Theme.of(context);
    var customIcon;
    var customSearchbar;
    return Scaffold(
      key: _scaffoldKey,
      //  drawer: MainDrawer(),

      //child: UserAccountsDrawerHeader(
      // //accountName: Text(user!.displayName!),
      //accountEmail: Text(user!.email!)),
      appBar: AppBar(
        elevation: 0,
        backgroundColor:
            ref.watch(changeTheme).darkMode ? Colors.black : Colors.white60,
        leading: IconButton(
          icon: Image.asset(
            "assets/Drawer.png",
            height: 70,
            width: 25,
          ),
          iconSize: 25,
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (isDarkMode) {
                ref.read(changeTheme.notifier).enableLightMode();
              } else {
                ref.read(changeTheme.notifier).enableDarkMode();
              }
            },
            icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
            color: Colors.red,
          ),
          //     IconButton(
          //         onPressed: () => Navigator.of(context)
          //             .push(MaterialPageRoute(builder: (_) => SearchPage())),
          //         icon: Icon(Icons.search)),

          IconButton(
              onPressed: () => {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                              backgroundColor: ref.watch(changeTheme).darkMode
                                  ? Colors.grey.shade800
                                  : Colors.white,
                              insetPadding: const EdgeInsets.symmetric(
                                  horizontal: 75, vertical: 180),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              elevation: 16,
                              child: Column(children: <Widget>[
                                UserAccountsDrawerHeader(
                                  accountEmail: Text(user!.email ?? ""),
                                  accountName: Text(user!.displayName ?? ""),
                                  currentAccountPicture: CircleAvatar(
                                    radius: 10,
                                    backgroundImage: NetworkImage(user ==
                                                null ||
                                            user!.photoURL == null
                                        ? "https://thumbs.dreamstime.com/b/default-avatar-profile-icon-vector-unknown-social-media-user-photo-default-avatar-profile-icon-vector-unknown-social-media-user-184816085.jpg"
                                        : user!.photoURL!),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                      title: Icon(
                                        Icons.logout_rounded,
                                        color: ref.watch(changeTheme).darkMode
                                            ? Colors.white
                                            : Colors.grey.shade800,
                                      ),
                                      onTap: () {
                                        GoogleSignIn().signOut();
                                        Navigator.pushReplacementNamed(
                                            context, MyRoutes.loginRoute);
                                      }),
                                ),
                                Text(
                                  "Log Out",
                                  style: TextStyle(
                                      color: ref.watch(changeTheme).darkMode
                                          ? Colors.white
                                          : Colors.grey.shade800),
                                )
                              ]));
                        })
                  },
              icon: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(user == null ||
                        user!.photoURL == null
                    ? "https://thumbs.dreamstime.com/b/default-avatar-profile-icon-vector-unknown-social-media-user-photo-default-avatar-profile-icon-vector-unknown-social-media-user-184816085.jpg"
                    : user!.photoURL!),
              )
              //Image.asset('assets/account.png'),

              )

          // child: Image.asset("assets/search.png", height: 35, width: 24),
          // onTap: () {

          // Navigator.pushNamed(context, MyRoutes.searchRoute);
          // ),
          // SizedBox(
          //   width: 20,
          // )
        ],
      ),
      body: getBody(),

      //const CardWidget()
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBottomBar() {
    return CustomAnimatedBottomBar(
      containerHeight: 70,
      backgroundColor:
          ref.watch(changeTheme).darkMode ? Colors.black : Colors.white,
      selectedIndex: _currentIndex,
      showElevation: true,
      itemCornerRadius: 24,
      curve: Curves.easeIn,
      onItemSelected: (index) => setState(() => _currentIndex = index),
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
          icon: Icon(Icons.home),
          title: Text('Home'),
          activeColor: Colors.green,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.add_circle),
          title: Text('Add'),
          activeColor: Colors.green,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.notifications_rounded),
          title: Text(
            'Notifications ',
          ),
          activeColor: Colors.green,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.settings),
          title: Text('Settings'),
          activeColor: Colors.green,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget getBody() {
    List<Widget> pages = [
      Container(
        alignment: Alignment.topCenter,
        child: CardWidget(),
      ),
      Container(alignment: Alignment.center, child: Addingpass()),
      Container(
        alignment: Alignment.center,
      ),
      Container(
        alignment: Alignment.center,
        child: Text(
          "Settings",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
    ];
    return IndexedStack(
      index: _currentIndex,
      children: pages,
    );
  }

  Widget buildtabitem({
    required int index,
    required Icon icon,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: icon,
      iconSize: 29,
    );
  }
}

class CardWidget extends StatefulWidget {
  const CardWidget({Key? key}) : super(key: key);

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  bool isLoading = true;
  List<DocumentSnapshot> allDocs = [];
  // final  val;

  void updatefingerprint(String id) async {
    print(id);
    await FirebaseFirestore.instance
        .collection('websites')
        .doc(id)
        .update({"fingerprint": true});
  }

  final LocalAuthentication auth = LocalAuthentication();
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
    if (authenticated) {}
  }

  Future<void> _updateAuthentication(String id) async {
    try {
      final _authenticated = await auth.authenticate(
        localizedReason: 'Let OS determine authentication method',
        //  useErrorDialogs: true,
        //   stickyAuth: true
      );
      log("Website ID: $id");
      if (_authenticated) {
        FirebaseFirestore.instance.collection("websites").doc(id).update({
          "fingerprint": true,
          "notification": false,
        });
      } else {
        log("Not Recognized");
      }
    } catch (e) {
      return;
    }
  }

  late String? userId;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  Future<void> getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    userId = user?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 900,
      height: 450,
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () =>
                {Navigator.pushNamed(context, MyRoutes.allpasswordsroute)},
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.13,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.green.shade600,
                    elevation: 10,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const <Widget>[
                          ListTile(
                            leading: Icon(Icons.lock, size: 60),
                            title: Text('Saved Password',
                                style: TextStyle(fontSize: 30.0)),
                            subtitle: Text('Tap here to see passwords.',
                                style: TextStyle(fontSize: 18.0)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () =>
                      {Navigator.pushNamed(context, MyRoutes.addingpassroute)},
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.13,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.red.shade600,
                      elevation: 20,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const <Widget>[
                            ListTile(
                              leading: Icon(Icons.add, size: 60),
                              title: Text('Add Password',
                                  style: TextStyle(fontSize: 30.0)),
                              subtitle: Text('Tap here to Add passwords.',
                                  style: TextStyle(fontSize: 18.0)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection("websites")
                        .where("notification", isEqualTo: true)
                        .where("uid", isEqualTo: userId)
                        .snapshots(),
                    builder: ((context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return CircularProgressIndicator();
                      if (snapshot.hasData) {
                        if (snapshot.data == null) {
                          return Text("No Access from Yet");
                        }

                        return Column(
                          children: [
                            Container(
                              child: Column(
                                children: snapshot.data!.docs
                                    .map((e) => TextButton(
                                        onPressed: () {
                                          _updateAuthentication(e.id);
                                        },
                                        child: Text(e.data()["website_name"])))
                                    .toList(),
                              ),
                            ),
                          ],
                        );
                      }
                      return Text("No Data");
                    }))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
