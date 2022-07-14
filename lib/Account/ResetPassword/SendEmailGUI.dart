import 'package:celepraty/Account/ResetPassword/PasswordCoding.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../Models/Methods/method.dart';
import '../UserForm.dart';
import 'Reset.dart';

class SendEmail extends StatefulWidget {
  const SendEmail({Key? key}) : super(key: key);

  @override
  _SendEmailState createState() => _SendEmailState();
}

class _SendEmailState extends State<SendEmail> {
  GlobalKey<FormState> emailKey = GlobalKey();
  final TextEditingController userNameEmailController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: black,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 90.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 60.w),
//image---------------------------------------------------------------
                child: Container(
                  width: double.infinity,
                  height: 160.h,
                  margin: EdgeInsets.all(9.w),
                  decoration: const BoxDecoration(
                      color: ligthtBlack,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage('assets/image/email1.png'))),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
//title---------------------------------------------------------------
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 10.h),
                child: text(
                  context,
                  'قم بإدخال اسم المستخدم او عنوان بريدك الالكتروني المرتبط بحسابك',
                  15,
                  white,
                  fontWeight: FontWeight.bold,
                  align: TextAlign.right,
                ),
              ),
//email Text field---------------------------------------------------------------
              Padding(
                padding: EdgeInsets.all(20.0.w),
                child: Form(
                    key: emailKey,
                    child: textField(
                      context,
                      emailIcon,
                      "اسم المستخدم او البريد الالكتروني",
                      12,
                      false,
                      userNameEmailController,
                      empty,
                      keyboardType: TextInputType.emailAddress,
                      inputFormatters: [
                        FilteringTextInputFormatter(
                            RegExp(r'[a-zA-Z]|[@]|[_]|[0-9]|[.]'),
                            allow: true)
                      ],
                    )),
              ),
//send bottom ---------------------------------------------------------------
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                child: gradientContainer(
                  double.infinity,
                  buttoms(
                    context,
                    "ارسال",
                    15,
                    white,
                    () {
                      //remove focus from textField when click outside
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (emailKey.currentState?.validate() == true) {
                        forgetPassword(userNameEmailController.text);
                      }
                    },
                    evaluation: 0,
                  ),
                  height: 50,
                  color: Colors.transparent,
                  gradient: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  //---------------------------------------------------------------------

  void forgetPassword(String username) async {
    loadingDialogue(context);
    getCreatePassword(username).then((result) {
      if (result == true) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(snackBar(context,
            'تم ارسال رمز التحقق علي البريد الالكتروني الخاص بك', green, done));
        goTopageReplacement(
            context,
            PasswordCoding(
              userNameEmail: username,
            ));
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(snackBar(context, 'المستخدم غير موجود', red, error));
      }
    });
  }

//--------------------------------------------------------------------------------

}
