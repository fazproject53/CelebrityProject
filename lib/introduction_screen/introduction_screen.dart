///import section

import 'package:celepraty/Account/LoggingSingUpAPI.dart';
import 'package:celepraty/Account/Singup.dart';
import 'package:celepraty/Account/logging.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:celepraty/introduction_screen/screen_four.dart';
import 'package:celepraty/introduction_screen/screen_one.dart';
import 'package:celepraty/introduction_screen/screen_three.dart';
import 'package:celepraty/introduction_screen/screen_two.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../Account/LoggingSingUpAPI.dart';
import '../Models/Methods/method.dart';
import '../main.dart';
import 'ModelIntro.dart';

class IntroductionScreen extends StatefulWidget {

  final List<Data>? data;

  const IntroductionScreen({Key? key, this.data}) : super(key: key);

  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen>
    with AutomaticKeepAliveClientMixin {
  ///Page Controller
  PageController pageController = PageController(viewportFraction: 0.8);

  ///selected index
  int selectedIndex = 0;

  ///current index
  int currentIndex = 0;

  // Future<IntroData>? futureIntro;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: selectedIndex);
    pageController.addListener(() {
      setState(() {
        currentIndex = pageController.page!.toInt();
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [

                  PageView(
                  controller: pageController,
                  children: [
                    ScreenOne(
                      title: widget.data![0].title!,
                      image: widget.data![0].image!,
                      subtitle: widget.data![0].text!,
                    ),
                    ScreenTwo(
                      title: widget.data![1].title!,
                      image: widget.data![1].image!,
                      subtitle: widget.data![1].text!,
                    ),
                    ScreenThree(
                      title: widget.data![2].title!,
                      image: widget.data![2].image!,
                      subtitle: widget.data![2].text!,
                    ),
                    ScreenFour(
                      title: widget.data![3].title!,
                      image: widget.data![3].image!,
                      subtitle:widget.data![3].text!,
                    )

                  ],
                ),


          Padding(
            padding: EdgeInsets.only(bottom: 50.h, right: 30.w, left: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ///Skip
                InkWell(
                  onTap: () async {
                    SharedPreferences preferences = await SharedPreferences.getInstance();
                    await preferences.setInt('initScreen', 1);
                    goTopagepush(context,  SingUp());

                  },
                  child: Visibility(
                    visible: currentIndex == 3 ? false : true,
                    child: text(context, "تخطي", 14, purple,
                        fontWeight: FontWeight.bold),
                  ),
                ),

                ///Dots
                SmoothPageIndicator(
                  controller: pageController,
                  count: 4,
                  onDotClicked: (index) {
                    pageController.jumpToPage(index);
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  effect: JumpingDotEffect(
                      spacing: 15.0,
                      radius: 25.0.r,
                      dotWidth: 10.0,
                      dotHeight: 10.0,
                      dotColor: Colors.grey,
                      verticalOffset: 15,
                      activeDotColor: purple),
                ),

                ///Start
                InkWell(
                    onTap: () async {
                      SharedPreferences preferences = await SharedPreferences.getInstance();
                      await preferences.setInt('initScreen', 1);
                      goTopagepush(context,  SingUp());

                    },
                    child: Visibility(
                      visible: currentIndex == 3 ? true : false,
                      child: text(context, "بدء", 16, purple,
                          fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

///API Section
