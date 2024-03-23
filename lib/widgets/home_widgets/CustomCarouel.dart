import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:women_safety_app/utils/quotes.dart';
import 'package:women_safety_app/widgets/home_widgets/safewebview.dart';

class CustomCarouel extends StatelessWidget {
  const CustomCarouel({Key? key}) : super(key: key);

  void navigateToRoute(BuildContext context, Widget route) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) => route));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CarouselSlider(
        options: CarouselOptions(
          aspectRatio: 2.0,
          autoPlay: true,
          enlargeCenterPage: true,
        ),
        items: List.generate(
          imageSliders.length,
          (index) => Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: InkWell(
              onTap: () {
                if (index == 0) {
                  navigateToRoute(
                      context,
                      SafeWebView(
                          url:
                              "https://artsandculture.google.com/project/indias-women-in-culture"));
                } else if (index == 1) {
                  navigateToRoute(
                      context,
                      SafeWebView(
                          url:
                              "https://www.business-standard.com/content/press-releases-ani/top-10-inspiring-indian-women-achievers-you-should-follow-in-2023-123100300787_1.html"));
                } else if (index == 2) {
                  navigateToRoute(
                      context,
                      SafeWebView(
                          url:
                              "https://amritmahotsav.nic.in/blogdetail.htm?75"));
                } else {
                  navigateToRoute(
                      context,
                      SafeWebView(
                          url:
                              "https://www.herzindagi.com/inspiration/inspirational-quotes-by-powerful-women-of-india-article-67961"));
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          imageSliders[index],
                        ))),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(colors: [
                      Colors.black.withOpacity(0.5),
                      Colors.transparent,
                    ]),
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8, left: 8),
                      child: Text(
                        articleTitle[index],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
