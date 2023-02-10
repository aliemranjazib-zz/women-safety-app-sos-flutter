import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:women_safety_app/child/child_login_screen.dart';
import 'package:women_safety_app/components/PrimaryButton.dart';
import 'package:women_safety_app/components/custom_textfield.dart';
import 'package:women_safety_app/utils/constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameC = TextEditingController();
  final key = GlobalKey<FormState>();
  String? id;
  getName() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      nameC.text = value.docs.first['name'];
      id = value.docs.first.id;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Center(
            child: Form(
                key: key,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "UPDATE YOUR PROFILE",
                      style: TextStyle(fontSize: 25),
                    ),
                    SizedBox(height: 15),
                    CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 40,
                      child: Center(
                          child: Image.asset(
                        'assets/add_pic.png',
                        height: 35,
                        width: 35,
                      )),
                    ),
                    CustomTextField(
                      controller: nameC,
                      hintText: nameC.text,
                      validate: (v) {
                        if (v!.isEmpty) {
                          return 'please enter your updated name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 25),
                    PrimaryButton(
                        title: "UPDATE",
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(id)
                              .update({'name': nameC.text}).then((value) =>
                                  Fluttertoast.showToast(
                                      msg: 'name updatd successfully'));
                        })
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
