import 'package:flutter/material.dart';
import 'package:women_safety_app/child/bottom_screens/contacts_page.dart';
import 'package:women_safety_app/components/PrimaryButton.dart';

class AddContactsPage extends StatelessWidget {
  const AddContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              PrimaryButton(
                  title: "Add Trusted Contacts",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ContactsPage(),
                        ));
                  }),
            ],
          )),
    );
  }
}
