import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Users/Setting/user_balance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../Models/Variables/Variables.dart';

class SuccessfulScreen extends StatefulWidget {
  const SuccessfulScreen({Key? key}) : super(key: key);

  @override
  _SuccessfulScreenState createState() => _SuccessfulScreenState();
}

class _SuccessfulScreenState extends State<SuccessfulScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(top: 50.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/lottie/SuccessfulCheck.json'),
              text(context, 'تم شحن الرصيد بقيمة ٢٠ ريال', 18.w,
                  black.withOpacity(0.7),
                  fontWeight: FontWeight.w700),
              SizedBox(
                height: 310.h,
              ),
              padding(
                22,
                22,
                gradientContainerNoborder(
                    400.w, buttoms(context, 'تم', 15, white, () {
                      ///Go to Balance Screen with change in balance
///const UserBalance()
                      gotoPageAndRemovePrevious(context, const UserBalance());
                })),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
