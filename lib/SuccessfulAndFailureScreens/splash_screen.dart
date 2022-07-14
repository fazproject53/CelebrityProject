import 'dart:async';

import 'package:celepraty/SuccessfulAndFailureScreens/failure_screen.dart';
import 'package:celepraty/SuccessfulAndFailureScreens/successful_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../Models/Methods/method.dart';
import '../Models/Variables/Variables.dart';



class SplashScreen extends StatefulWidget {
  final int? trueOrFalse;

   const SplashScreen({Key? key, this.trueOrFalse}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    Timer(const Duration(seconds: 3), (){
      widget.trueOrFalse == 1 ?
      goTopagepush(context, const SuccessfulScreen()) : goTopagepush(context, const FailureScreen());
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white.withOpacity(0.5),
      body: Center(
        child: Padding(
          padding:  EdgeInsets.only(top: 100.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  height: 260.h,
                  width: 260.w,
                  child: Lottie.asset('assets/lottie/addMoreMoney.json')),
              text(context, 'إضافة ٢٠ ريال للرصيد', 20, black,
                  align: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
  }


