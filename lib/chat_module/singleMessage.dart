import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SingleMessage extends StatelessWidget {
  final String? message;
  final bool? isMe;
  final String? image;
  final String? type;
  final String? friendName;
  final String? myName;
  final Timestamp? date;

  const SingleMessage(
      {super.key,
      this.message,
      this.isMe,
      this.image,
      this.type,
      this.friendName,
      this.myName,
      this.date});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    DateTime d = DateTime.parse(date!.toDate().toString());
    String cdate = "${d.hour}" + ":" + "${d.minute}";
    return type == "text"
        ? Container(
            constraints: BoxConstraints(
              maxWidth: size.width / 2,
            ),
            alignment: isMe! ? Alignment.centerRight : Alignment.centerLeft,
            padding: EdgeInsets.all(10),
            child: Container(
                decoration: BoxDecoration(
                  color: isMe! ? Colors.pink : Colors.black,
                  borderRadius: isMe!
                      ? BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                        )
                      : BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                ),
                padding: EdgeInsets.all(10),
                constraints: BoxConstraints(
                  maxWidth: size.width / 2,
                ),
                alignment: isMe! ? Alignment.centerRight : Alignment.centerLeft,
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          isMe! ? myName! : friendName!,
                          style: TextStyle(fontSize: 15, color: Colors.white70),
                        )),
                    Divider(),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          message!,
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        )),
                    Divider(),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "$cdate",
                          style: TextStyle(fontSize: 15, color: Colors.white70),
                        )),
                  ],
                )),
          )
        : type == 'img'
            ? Container(
                height: size.height / 2.5,
                width: size.width,
                // constraints: BoxConstraints(
                //   maxWidth: size.width / 2,
                // ),
                alignment: isMe! ? Alignment.centerRight : Alignment.centerLeft,
                padding: EdgeInsets.all(10),
                child: Container(
                    height: size.height / 2.5,
                    width: size.width,
                    decoration: BoxDecoration(
                      color: isMe! ? Colors.pink : Colors.black,
                      borderRadius: isMe!
                          ? BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                            )
                          : BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                    ),
                    // padding: EdgeInsets.all(10),
                    constraints: BoxConstraints(
                      maxWidth: size.width / 2,
                    ),
                    alignment:
                        isMe! ? Alignment.centerRight : Alignment.centerLeft,
                    child: Column(
                      children: [
                        Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              isMe! ? myName! : friendName!,
                              style: TextStyle(
                                  fontSize: 15, color: Colors.white70),
                            )),
                        Divider(),
                        CachedNetworkImage(
                          imageUrl: message!,
                          fit: BoxFit.cover,
                          height: size.height / 3.62,
                          width: size.width,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                        Divider(),
                        Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "$cdate",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.white70),
                            )),
                      ],
                    )),
              )
            : Container(
                constraints: BoxConstraints(
                  maxWidth: size.width / 2,
                ),
                alignment: isMe! ? Alignment.centerRight : Alignment.centerLeft,
                padding: EdgeInsets.all(10),
                child: Container(
                    decoration: BoxDecoration(
                      color: isMe! ? Colors.pink : Colors.black,
                      borderRadius: isMe!
                          ? BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                            )
                          : BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                    ),
                    padding: EdgeInsets.all(10),
                    constraints: BoxConstraints(
                      maxWidth: size.width / 2,
                    ),
                    alignment:
                        isMe! ? Alignment.centerRight : Alignment.centerLeft,
                    child: Column(
                      children: [
                        Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              isMe! ? myName! : friendName!,
                              style: TextStyle(
                                  fontSize: 15, color: Colors.white70),
                            )),
                        Divider(),
                        Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () async {
                                await launchUrl(Uri.parse("$message"));
                              },
                              child: Text(
                                message!,
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 16,
                                    color: Colors.white),
                              ),
                            )),
                        Divider(),
                        Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "$cdate",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.white70),
                            )),
                      ],
                    )),
              );
  }
}
