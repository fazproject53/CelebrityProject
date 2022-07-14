import 'package:flutter/material.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class userHomePage extends StatefulWidget{
  _userHomePageState createState() => _userHomePageState();
}

class _userHomePageState extends State<userHomePage> {

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: drowAppBar('الصفحة الرئيسية', context),
        body: Container(
          alignment: Alignment.topLeft,
          height: 800.h,
          child: SizedBox(
            height: 50.h,
            child: InkWell(child: gradientContainerNoborder(150.w, Center(
                child: text(context, 'انشاء طلب', 14, white,
                    fontWeight: FontWeight.bold))),
                onTap: () {

                }),

          ),

        ),

      ),
    );
  }
}