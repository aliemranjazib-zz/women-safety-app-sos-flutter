import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:women_safety_app/chat_module/chat_screen.dart';
import 'package:women_safety_app/child/child_login_screen.dart';
import 'package:women_safety_app/db/share_pref.dart';
import 'package:women_safety_app/parent/parent_home_screen.dart';

import '../../utils/constants.dart';

class CheckUserStatusBeforeChat extends StatelessWidget {
  const CheckUserStatusBeforeChat({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          if (snapshot.hasData) {
            print("===>${snapshot.data}");
            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .where("id",
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snap.hasData) {
                  if (snap.data!.docs.first.data()['type'] == "parent") {
                    return ParentHomeScreen();
                  } else {
                    return ChatPage();
                  }
                }
                return SizedBox();
              },
            );
            //return ChatPage();
          } else {
            Fluttertoast.showToast(msg: 'please login first');
            return LoginScreen();
          }
        }
      },
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // @override
  // void initState() {
  //   super.initState();

  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     setState(() {
  //       if (FirebaseAuth.instance.currentUser == null ||
  //           FirebaseAuth.instance.currentUser!.uid.isEmpty) {
  //         if (mounted) {
  //           Navigator.push(
  //               context, MaterialPageRoute(builder: (_) => LoginScreen()));
  //         }
  //       }
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addObserver();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        // backgroundColor: Color.fromARGB(255, 250, 163, 192),
        title: Text("SELECT GUARDIAN"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('type', isEqualTo: 'parent')
            .where('childEmail',
                isEqualTo: FirebaseAuth.instance.currentUser!.email)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: progressIndicator(context));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              final d = snapshot.data!.docs[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Color.fromARGB(255, 250, 163, 192),
                  child: ListTile(
                    onTap: () {
                      goTo(
                          context,
                          ChatScreen(
                              currentUserId:
                                  FirebaseAuth.instance.currentUser!.uid,
                              friendId: d.id,
                              friendName: d['name']));
                      // Navigator.push(context, MaterialPa)
                    },
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(d['name']),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
