import 'package:celepraty/Account/logging.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../Models/Methods/method.dart';
import '../UserForm.dart';
import 'Reset.dart';
import 'ResetNewPassword.dart';
import 'VerifyToken.dart';

class PasswordCoding extends StatefulWidget {
  final String? userNameEmail;

  const PasswordCoding({Key? key, this.userNameEmail}) : super(key: key);

  @override
  _PasswordCodingState createState() => _PasswordCodingState();
}

class _PasswordCodingState extends State<PasswordCoding> {
  GlobalKey<FormState> codeKey = GlobalKey();
  final TextEditingController codeController = TextEditingController();
  @override
  void initState() {
    print(widget.userNameEmail!);
    super.initState();
  }

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
                        image: AssetImage('assets/image/code.png')),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
//title---------------------------------------------------------------
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 20.w),
                child: text(
                  context,
                  'الرجاء إدخال الرمز المكون من 4 أرقام المرسل إلى البريد الالكتروني المدخل',
                  15,
                  white,
                  fontWeight: FontWeight.bold,
                  align: TextAlign.right,
                ),
              ),
//code Text field---------------------------------------------------------------
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 20.w),
                child: Form(
                    key: codeKey,
                    child: textField(
                      context,
                      Icons.lock,
                      "رمز التحقق",
                      12,
                      false,
                      codeController,
                      code,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    )),
              ),
//reSend message ---------------------------------------------------------------
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 20.w),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Wrap(
                      children: [
                        text(context, "لم يصل رمز التحقق؟", 13, white),
                        SizedBox(
                          width: 7.w,
                        ),
                        InkWell(
                            child: text(context, "إعادة ارسال", 13, pink),
                            onTap: () {
                              forgetPassword(widget.userNameEmail!);
                            }),
                      ],
                    )
                  ],
                ),
              ),
//send bottom ---------------------------------------------------------------
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 20.w),
                child: gradientContainer(
                  double.infinity,
                  buttoms(
                    context,
                    "تحقق",
                    15,
                    white,
                    () {
                      //remove focus from textField when click outside
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (codeKey.currentState?.validate() == true) {
                        verifyCode(widget.userNameEmail!,
                            int.parse(codeController.text));
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
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(snackBar(context, 'المستخدم غير موجود', red, error));
      }
    });
  }

//-------------------------------------------------------------------------------
  Future<String?> verifyCode(String username, int code) async {
    loadingDialogue(context);
    getVerifyCode(username, code).then((sendCode) async {
      if (sendCode == 'not verified') {
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(snackBar(context, 'الرمز المدخل خاطئ', red, error));
      } else {
        verifyToken();
      }
    });
    return '';
  }

//-----------------------------------------------------------------------------------------------
  void verifyToken() async {
    getVerifyToken(forgetToken).then((sendToken) async {
      if (sendToken == true) {
        Navigator.pop(context);
        goTopageReplacement(
            context,
            ResetNewPassword(
                code: int.parse(codeController.text),
                username: widget.userNameEmail));
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(snackBar(
            context,
            'حدث خطا اثناء استعادة كلمة السر الرجاء المحاولة مرة اخرى',
            red,
            error));
        goTopageReplacement(context, Logging());
      }
    });
  }
}
/*
*
* */
