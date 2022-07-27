import 'package:celepraty/MainScreen/main_screen_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../Models/Methods/method.dart';
import '../Models/Variables/Variables.dart';
import '../Users/Setting/user_recharge_balance.dart';

class FailureScreen extends StatefulWidget {
  const FailureScreen({Key? key}) : super(key: key);

  @override
  _FailureScreenState createState() => _FailureScreenState();
}

class _FailureScreenState extends State<FailureScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(top: 50.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 180,
                  child: Lottie.asset('assets/lottie/Failuer.json')),
              text(context, 'فشلت عملية شحن الرصيد بقيمة ٢٠ ريال', 18.w,
                  black.withOpacity(0.7),
                  fontWeight: FontWeight.w700),
              SizedBox(
                height: 260.h,
              ),
              padding(
                  22,
                  22,
                  ///Recharge The Balance Button
                  gradientContainer(
                    400.w,
                    buttoms(
                      context,
                      'حاول مجددا', 14, black, () {
                      ///determine the amount of money
                      gotoPageAndRemovePrevious(context, const UserRechargeBalance());
                    },
                    ),
                    gradient: true,color: grey!, height: 45,
                  )),
              SizedBox(
                height: 10.h,
              ),
              padding(
                22,
                22,
                gradientContainerNoborder(
                    400.w,
                    buttoms(context, 'العودة للصفحة الرئيسية', 15, white, () {
                      ///Go to Balance Screen with change in balance
                      gotoPageAndRemovePrevious(context, const MainScreen() );
                    })),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
