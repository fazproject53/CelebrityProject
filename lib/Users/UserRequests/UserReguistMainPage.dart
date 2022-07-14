import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';

import 'package:celepraty/celebrity/Requests/Gift/Gift.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'UserAds/UserAdvertisments.dart';
import 'UserAdvSpace/UserAdSpace.dart';
import 'UserGift/UserGift.dart';


class UserRequestMainPage extends StatefulWidget {
  UserRequestMainPage({Key? key}) : super(key: key);

  @override
  State<UserRequestMainPage> createState() => _UserRequestMainPageState();
}

class _UserRequestMainPageState extends State<UserRequestMainPage> {
  int? isSelected = 1;
  bool grandiedAds=false;
  bool grandiedAdsSpace=true;
  bool grandiedGift=true;

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: drowAppBar(requestBar, context),
          body:
          Column( children: [

             SizedBox(
               height: 26.h,
             ),
 //صف الاختيارات-------------------------------
             drowRowButton(context),
             SizedBox(
               height: 42.h,
             ),
 //النص-------------------------------

             Padding(
               padding: EdgeInsets.only(left: 28.w, right: 28.w),
               child: Align(
                 alignment: Alignment.topRight,
                 child: text(context,
                  isSelected == 1
                     ?  "طلبات الاعلانات الخاصة بك"
                     : isSelected == 2
                         ? "طلبات الاهداءات الخاصة بك"
                         : "طلبات المساحة الاعلانية الخاصة بك",
                  //,
                   18,
                    black,

                     fontWeight: FontWeight.bold),
               ),
             ),

             SizedBox(
               height: 20.h,
            ),

 //الطلبات وفق التصنيف-------------------------------

             Expanded(
              flex: 4,
              child: isSelected == 1
                   ? const UserAdvertisment()
                   : isSelected == 2
                       ? const UserGift()
                       : const UserAdSpace(),
            ),
           ]),
        ));
  }

//Selection----------------------------------------------------------------------
  drowRowButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 28.w, right: 28.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
//الاعلانات-------------------------------------------------------
          Expanded(
            child: gradientContainer(
              96,
              buttoms(
                context,
                'الاعلانات',
                12,
               grandiedAds? black:white,
                () {
                  setState(() {
                    isSelected = 1;
                    grandiedAdsSpace=true;
                    grandiedAds =false;
                    grandiedGift=true;
                  });
                  print("adv$isSelected");
                },
              ),
              gradient: grandiedAds
            ),
          ),

          SizedBox(width: 17.w),
//الاهداءات-------------------------------------------------------
          Expanded(
            child: gradientContainer(
              96,
              buttoms(
                context,
                'الاهداءات',
                12,
               grandiedGift? black:white,
                () {
                  setState(() {
                    isSelected = 2;
                    grandiedAdsSpace=true;
                    grandiedAds =true;
                    grandiedGift=false;
                  });
                  print("gift$isSelected");
                },
              ),
               gradient: grandiedGift
            ),
          ),

          SizedBox(width: 17.w),
//المساحة الاعلانية-------------------------------------------------------

          Expanded(
            child: gradientContainer(
              96,
              buttoms(
                context,
                'المساحة الاعلانية',
                12,
                grandiedAdsSpace? black:white,
                () {
                  setState(() {
                    isSelected = 3;
                    grandiedAdsSpace=false;
                    grandiedAds =true;
                    grandiedGift=true;
                  });
                  print("space$isSelected");
                },
              ),
               gradient: grandiedAdsSpace
            ),

          ),
//-------------------------------------------------------
        ],
      ),
    );
  }
}
