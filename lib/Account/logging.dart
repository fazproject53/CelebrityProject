import 'dart:convert';

import 'package:celepraty/Account/ResetPassword/Reset.dart';
import 'package:celepraty/Account/ResetPassword/SendEmailGUI.dart';
import 'package:celepraty/Account/ResetPassword/VerifyToken.dart';
import 'package:celepraty/MainScreen/main_screen_navigation.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import "package:flutter/material.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'LoggingSingUpAPI.dart';
import 'Singup.dart';
import 'TheUser.dart';
import 'UserForm.dart';
import 'VerifyUser.dart';

class Logging extends StatefulWidget {
  static TheUser? theUser;
  Logging({Key? key}) : super(key: key);

  @override
  State<Logging> createState() => _LoggingState();
}

class _LoggingState extends State<Logging> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  bool isChckid = true;
  late Image image1;
  String isFoundEmail = '';
  String getEmail = '';
  TextEditingController lgoingEmailConttroller = TextEditingController();
  final TextEditingController lgoingPassConttroller = TextEditingController();
  GlobalKey<FormState> logKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    image1 = Image.asset("assets/image/singup.jpg");
    DatabaseHelper.getRememberUserEmail().then((email) {
      setState(() {
        isFoundEmail = email;
        lgoingEmailConttroller =
            TextEditingController(text: isFoundEmail == '' ? '' : isFoundEmail);
      });
    });
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
//main container--------------------------------------------------
          body: Container(
        height: double.infinity,
        width: double.infinity,
        // decoration: BoxDecoration(
        //     color: Colors.white,
        //     image: DecorationImage(
        //         image: image1.image,
        //         colorFilter: ColorFilter.mode(
        //             Colors.black.withOpacity(0.7), BlendMode.darken),
        //         fit: BoxFit.cover)),
        child:

//==============================container===============================================================

            SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 80.h),
              //logo---------------------------------------------------------------------------
              SizedBox(
                height: 140.h,
                //color: red,
                child: Image.asset(
                  'assets/image/final-logo.png',
                  fit: BoxFit.cover,
                  height: 120.h,
                  width: 300.w,
                ),
              ),

//?????????? ???? ?????? ????????--------------------------------------------------
              //   text(context, "?????????? ???? ?????? ????????", 20, Colors.black87),
//?????????? ????????????--------------------------------------------------
              text(context, "?????????? ????????????", 18, Colors.black87),
              SizedBox(
                height: 40.h,
              ),

//=============================================================================================
              padding(
                  20,
                  20,
                  Form(
                    key: logKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
//====================================TextFields=========================================================

//email------------------------------------------
                        textField(
                            context,
                            emailIcon,
                            "???????????? ???????????????????? ???? ?????? ????????????????",
                            14,
                            false,
                            lgoingEmailConttroller,
                            empty),
                        SizedBox(
                          height: 15.h,
                        ),
//pass------------------------------------------
                        textField(context, passIcon, "???????? ????????????", 14, true,
                            lgoingPassConttroller, valedpass),
                        SizedBox(
                          height: 15.h,
                        ),
//remember me && forget pass------------------------------------------
                        rememberMe(),
                        SizedBox(
                          height: 15.h,
                        ),
//logging buttom-----------------------------------------------------------------------------
                        gradientContainer(
                            347,
                            buttoms(context, '?????????? ????????????', 14, white, () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              if (logKey.currentState?.validate() == true) {
                                loadingDialogue(context);
                                databaseHelper
                                    .loggingMethod(lgoingEmailConttroller.text,
                                        lgoingPassConttroller.text)
                                    .then((result) {
//if user select remember me----------------------------------------------------------------------------

                                  if (isChckid) {
                                    if (result == "user") {
                                      DatabaseHelper.saveRememberToken(result);
                                      DatabaseHelper.saveRememberUserEmail(
                                          lgoingEmailConttroller.text);
                                      Navigator.pop(context);
                                      DatabaseHelper.saveRememberUser("user");
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const MainScreen()));
                                    } else if (result == "celebrity") {
                                      DatabaseHelper.saveRememberToken(result);
                                      DatabaseHelper.saveRememberUserEmail(
                                          lgoingEmailConttroller.text);
                                      Navigator.pop(context);
                                      DatabaseHelper.saveRememberUser(
                                          "celebrity");
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const MainScreen()));
                                    } else if (result ==
                                        "Invalid Credentials") {
                                      Navigator.pop(context);
                                      showMassage(context, '???????????? ?????? ??????????',
                                          '?????? ???? ???????? ???????????? ???? ?????? ????????????????');
                                    } else if (result == "SocketException") {
                                      Navigator.pop(context);
                                      showMassage(context, '?????????? ???? ????????????????',
                                          ' ???????????? ?????????? ?????????????????? ???? ?????????? ???????????? ');
                                    } else if (result == "TimeoutException") {
                                      Navigator.pop(context);
                                      showMassage(context, '?????????? ???? ????????????',
                                          'TimeoutException');
                                    } else if (result == "User not verified") {
                                      Navigator.pop(context);

                                      failureDialog(
                                        context,
                                        '???????? ?????????? ?????????? ???????????? ?????? ?????????? ???????????????????? ???????????? ?????? ???????????? ',
                                        "assets/lottie/Failuer.json",
                                        '????????',
                                        () {
                                          Navigator.pop(context);
                                          goTopagepush(
                                              context,
                                              VerifyUser(
                                                  username:
                                                      lgoingEmailConttroller
                                                          .text));
                                        },
                                      );

                                      //showMassage(context, '???? ?????? ???????????? ???? ???????????? ???????????????????? ??????, ?????? ???? ?????????? ?????? ???????????? ?????? ???????????? ????????????', '?????????? ??????????');
                                    } else {
                                      Navigator.pop(context);
                                      showMassage(context, '?????????? ???? ????????????',
                                          '?????? ?????? ???? ?????????? ?????????????? ????????????????, ?????????? ?????????????? ??????????');
                                    }
//if user not select remember me----------------------------------------------------------------------------
                                  } else {
                                    if (result == "user") {
                                      DatabaseHelper.saveRememberUser("user");
                                      Navigator.pop(context);
                                      setState(() {
                                        currentuser = "user";
                                      });
                                      DatabaseHelper.removeRememberUserEmail();
                                      print('remove user email');
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const MainScreen()));
                                    } else if (result == "celebrity") {
                                      DatabaseHelper.saveRememberUser(
                                          "celebrity");

                                      Navigator.pop(context);
                                      setState(() {
                                        currentuser = "celebrity";
                                      });
                                      DatabaseHelper.removeRememberUserEmail();
                                      print('remove celebrity email');
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const MainScreen()));
                                    } else if (result ==
                                        "Invalid Credentials") {
                                      Navigator.pop(context);
                                      showMassage(context, '???????????? ?????? ??????????',
                                          '?????? ???? ???????? ???????????? ???? ?????? ????????????????');
                                    } else if (result == "User not verified") {
                                      Navigator.pop(context);

                                      failureDialog(
                                        context,
                                        '???????? ?????????? ?????????? ???????????? ?????? ?????????? ???????????????????? ???????????? ?????? ???????????? ',
                                        "assets/lottie/Failuer.json",
                                        '????????',
                                        () {
                                          Navigator.pop(context);
                                          goTopagepush(
                                              context,
                                              VerifyUser(
                                                  username:
                                                      lgoingEmailConttroller
                                                          .text));
                                        },
                                      );

                                      //showMassage(context, '???? ?????? ???????????? ???? ???????????? ???????????????????? ??????, ?????? ???? ?????????? ?????? ???????????? ?????? ???????????? ????????????', '?????????? ??????????');
                                    } else {
                                      Navigator.pop(context);
                                      showMassage(
                                          context,
                                          '???????? ?????????? ???? ?????? ??????????',
                                          '???????? ???? ?????????? ???? ???????????? ?????????? ??????????');
                                    }
                                  }
                                });
                              } else {
                                // showMassage(context, '???????? ?????????? ???? ?????? ??????????',
                                //     '???????? ???? ?????????? ???? ???????????? ?????????? ??????????',done: done);
                              }
                            }),
                            color: Colors.transparent),
                        SizedBox(
                          height: 34.h,
                        ),
//have Account buttom-----------------------------------------------------------
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Wrap(
                              children: [
                                text(context, "?????? ???????? ???????? ??????????????", 14,
                                    Colors.black87),
                                SizedBox(
                                  width: 7.w,
                                ),
                                InkWell(
                                    child: text(
                                        context, "?????????? ????????", 14, Colors.grey),
                                    onTap: () {
                                      goTopageReplacement(context, SingUp());
                                    }),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 27.h,
                        ),
//----------------------------------------------------------------------------------------------------------------------
                      ],
                    ),
                  ))
            ],
          ),
        ),
      )),
    );
  }

//-------------------------------------------------------
  Widget rememberMe() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // SizedBox(
            //   width: 5.w,
            // ),
            InkWell(
                child: Icon(Icons.check_box_rounded,
                    color: isChckid ? purple.withOpacity(0.5) : Colors.grey,
                    size: 23.sp),
                onTap: () {
                  setState(() {
                    isChckid = !isChckid;
                  });
                }),
            SizedBox(
              width: 4.w,
            ),
            text(context, '????????????', 15.sp, Colors.black87),
          ],
        ),
        // SizedBox(
        //   width: 180.w,
        // ),
        InkWell(
            onTap: () {
              goTopagepush(context, const SendEmail());
            },
            child: text(context, '???????? ???????? ??????????????', 15.sp, Colors.black87)),
      ],
    );
  }
}
