import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:women_safety_app/components/PrimaryButton.dart';
import 'package:women_safety_app/components/SecondaryButton.dart';
import 'package:women_safety_app/components/custom_textfield.dart';
import 'package:women_safety_app/utils/constants.dart';

class ReviewPage extends StatefulWidget {
  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  TextEditingController locationC = TextEditingController();
  TextEditingController viewsC = TextEditingController();
  bool isSaving = false;
  double? ratings;

  showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(2.0),
            title: Text("Review your place"),
            content: Form(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextField(
                    hintText: 'enter location',
                    controller: locationC,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextField(
                    controller: viewsC,
                    hintText: 'enter location',
                    maxLines: 3,
                  ),
                ),
                const SizedBox(height: 15),
                RatingBar.builder(
                  initialRating: 1,
                  minRating: 1,
                  direction: Axis.horizontal,
                  itemCount: 5,
                  unratedColor: Colors.grey.shade300,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) =>
                      const Icon(Icons.star, color: kColorDarkRed),
                  onRatingUpdate: (rating) {
                    setState(() {
                      ratings = rating;
                    });
                  },
                ),
              ],
            )),
            actions: [
              PrimaryButton(
                  title: "SAVE",
                  onPressed: () {
                    saveReview();
                    Navigator.pop(context);
                  }),
              TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }

  saveReview() async {
    setState(() {
      isSaving = true;
    });
    await FirebaseFirestore.instance.collection('reviews').add({
      'location': locationC.text,
      'views': viewsC.text,
      "ratings": ratings
    }).then((value) {
      setState(() {
        isSaving = false;
        Fluttertoast.showToast(msg: 'review uploaded successfully');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isSaving == true
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Recent Review by other",
                      style: TextStyle(fontSize: 25, color: Colors.black),
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('reviews')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }

                        return ListView.separated(
                          separatorBuilder: (context, index) {
                            return Divider();
                          },
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            final data = snapshot.data!.docs[index];
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Card(
                                elevation: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Location : ${data['location']}",
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.black),
                                      ),
                                      Text(
                                        "Comments : ${data['views']}",
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.black),
                                      ),
                                      RatingBar.builder(
                                        initialRating: data['ratings'],
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        itemCount: 5,
                                        ignoreGestures: true,
                                        unratedColor: Colors.grey.shade300,
                                        itemPadding: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        itemBuilder: (context, _) => const Icon(
                                            Icons.star,
                                            color: kColorDarkRed),
                                        onRatingUpdate: (rating) {
                                          setState(() {
                                            ratings = rating;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: () {
          showAlert(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
