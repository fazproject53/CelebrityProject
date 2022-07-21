import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../MainScreen/main_screen_navigation.dart';
import '../Models/Methods/method.dart';
import '../Models/Variables/Variables.dart';
import 'LoggingSingUpAPI.dart';
import 'UserForm.dart';

class VerifyUser extends StatefulWidget {
  final String? username;

  const VerifyUser({Key? key, this.username}) : super(key: key);

  @override
  State<VerifyUser> createState() => _VerifyUserState();
}

class _VerifyUserState extends State<VerifyUser> {
  GlobalKey<FormState> codeKey = GlobalKey();
  final TextEditingController codeController = TextEditingController();
  String? token;
  late Image image1;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    image1 = Image.asset("assets/image/singup.jpg");
  }

  @override
  void didChangeDependencies() {
    precacheImage(image1.image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: black,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                  image: image1.image,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.7), BlendMode.darken),
                  fit: BoxFit.cover)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 40.h,
                ),
                text(
                  context,
                  'تأكيد عنوان البريد الالكتروني',
                  18,
                  white,
                  fontWeight: FontWeight.bold,
                  align: TextAlign.right,
                ),
                SizedBox(
                  height: 70.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 60.w),
//image---------------------------------------------------------------
                  child: Container(
                    width: double.infinity,
                    height: 160.h,
                    margin: EdgeInsets.all(9.w),
                    decoration: const BoxDecoration(
                      color: Colors.white12,
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
                    'تتطلب هذه الخطوة تأكيد عنوان البريد الالكتروني. \n يرجى التحقق من صندوق البريد الوارد الخاص بك واتبع التعليمات.',
                    15,
                    white,
                    fontWeight: FontWeight.bold,
                    align: TextAlign.justify,
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
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
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
                                //print(widget.username);
                                loadingDialogue(context);
                                resendCode(widget.username!)
                                    .then((result) {
                                  if (result == true) {
                                    Navigator.pop(context);
                                    successfullyDialog(
                                        context,
                                        'تم اعادة ارسال رمز التحقق مجددا الرجاء تفقد البريد الخاص بك',
                                        "assets/lottie/SuccessfulCheck.json",
                                        'تم', () {
                                      Navigator.pop(context);
                                    });
                                  } else {
                                    if (result == "SocketException") {
                                      Navigator.pop(context);
                                      showMassage(context, 'مشكلة في الانترنت',
                                          ' لايوجد اتصال بالانترنت في الوقت الحالي ');
                                    } else if (result == "TimeoutException") {
                                      Navigator.pop(context);
                                      showMassage(context, 'مشكلة في الخادم',
                                          'TimeoutException');
                                    } else if (result == false) {
                                      Navigator.pop(context);
                                      showMassage(context, 'بيانات غير صحيحة',
                                          ' اسم المستخدم او البريد الالكتروني غير موجود, فضلا تاكد من صحته وحاول مرة اخرى');
                                    } else {
                                      Navigator.pop(context);
                                      showMassage(context, 'مشكلة في الخادم',
                                          'حدث خطأ ما اثناء استعادة كلمة المرور, سنقوم باصلاحه قريبا');
                                    }
                                  }
                                });
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
                          loadingDialogue(context);
                          verifyUserCode(widget.username!,
                                  int.parse(codeController.text))
                              .then((result) {
                            if (result == true) {
                              Navigator.pop(context);
                              successfullyDialog(
                                  context,
                                  'تمت العملية بنجاح يمكنك الان الدخول للمنصة ',
                                  "assets/lottie/SuccessfulCheck.json",
                                  'تم', () {
                                DatabaseHelper.saveToken(token!);
                                goTopageReplacement(context, const MainScreen());
                              });
                            } else {
                              if (result == "SocketException") {
                                Navigator.pop(context);
                                showMassage(context, 'مشكلة في الانترنت',
                                    ' لايوجد اتصال بالانترنت في الوقت الحالي ');
                              } else if (result == "TimeoutException") {
                                Navigator.pop(context);
                                showMassage(context, 'مشكلة في الخادم',
                                    'TimeoutException');
                              } else if (result == false) {
                                Navigator.pop(context);
                                showMassage(context, 'بيانات غير صحيحة',
                                    'الرمز المدخل خاطئ');
                              } else if (result == "serverException") {
                                Navigator.pop(context);
                                showMassage(context, 'مشكلة في الخادم',
                                    'حدث خطأ ما اثناء استعادة كلمة المرور, سنقوم باصلاحه قريبا');
                              }
                            }
                          });
                          //verifyUserCode(widget.userNameEmail!,
                          // int.parse(codeController.text));
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
      ),
    );
  }

//resend Code---------------------------------------------------------------------------
  resendCode(String username) async {
    Map<String, dynamic> data = {"username": username};
    String url = "https://mobile.celebrityads.net/api/send-verify-message";
    try {
      final respons = await http.post(Uri.parse(url), body: data).timeout(const Duration(seconds: 8));
      if (respons.statusCode == 200) {
        var state = jsonDecode(respons.body)?["success"];

        print('state respons: $state');
        if (state == true) {
          return true;
        } else {
          return false;
          //المستخدم غير موجود
        }
      } else {
        return 'serverException';
      }
    } catch (e) {
      if (e is SocketException) {
        return 'SocketException';
      } else if (e is TimeoutException) {
        return 'TimeoutException';
      } else {
        return 'serverException';
      }
    }
  }

//Verify Code---------------------------------------------------------------------------
  verifyUserCode(String username, int code) async {
    Map<String, dynamic> data = {"username": username, 'code': '$code'};
    String url = "https://mobile.celebrityads.net/api/verify-user";
    try {
      final respons = await http.post(Uri.parse(url), body: data).timeout(const Duration(seconds: 8));
      if (respons.statusCode == 200) {
        var state = jsonDecode(respons.body)?["message"]["en"];
        var getToken = jsonDecode(respons.body)?["data"]?["token"];
        print('state respons: $state');
        if (state == "verified") {
          setState(() {
            token=getToken;
          });
          print(token);
          return true;
        } else if (state == "not verified") {
          return false;
          //المستخدم غير موجود
        }
      } else {
        return 'serverException';
      }
    } catch (e) {
      if (e is SocketException) {
        return 'SocketException';
      } else if (e is TimeoutException) {
        return 'TimeoutException';
      } else {
        return 'serverException';
      }
    }
  }


}
