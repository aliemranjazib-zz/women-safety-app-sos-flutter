import 'package:flutter/material.dart';

const Color kColorDarkRed = Color(0xFFB83B5E);
const Color kColorLightRed = Color(0xFFE23E57);
const Color kColorRed = Color(0xFFCC2029);
const Color kColorLightRed1 = Color(0xFFf67280);
const Color kLightBackground = Color(0xFFF5F5F5);
const Color kColorLightBlue = Color(0xFFA7CAFC);
const Color kColorBlue = Color(0xFF011ACD);
const Color darkGrey = Color(0xff707070);
const Color darkGreen = Color(0xff13D900);
const Color lightGrey = Color(0xff13D900);

void goTo(BuildContext context, Widget nextScreen) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => nextScreen,
      ));
}

dialogueBox(BuildContext context, String text) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(text),
    ),
  );
}

Widget progressIndicator(BuildContext context) {
  return Center(
      child: CircularProgressIndicator(
    backgroundColor: kColorRed,
    color: Colors.red,
    strokeWidth: 7,
  ));
}
