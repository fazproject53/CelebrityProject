import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:http/http.dart' as http;
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../Account/LoggingSingUpAPI.dart';
import '../activity_screen.dart';

class addNews extends StatefulWidget {
  _addNewsState createState() => _addNewsState();
}

class _addNewsState extends State<addNews> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController controlnewstitle = new TextEditingController();
  TextEditingController controlnewsdesc = new TextEditingController();
  String? userToken;

  @override
  void initState() {
    DatabaseHelper.getToken().then((value) {
      setState(() {
        userToken = value;
      });
      super.initState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                child: Container(
                    child: Form(
          key: _formKey,
          child: paddingg(
            12,
            12,
            5,
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              padding(
                10,
                12,
                Container(
                    alignment: Alignment.topRight,
                    child: Text(
                      ' اضافة خبر جديد',
                      style: TextStyle(
                          fontSize: 18.sp,
                          color: textBlack,
                          fontFamily: 'Cairo'),
                    )),
              ),
              SizedBox(
                height: 20.h,
              ),
              paddingg(
                15,
                15,
                12,
                textFieldDesc(context, 'وصف الخبر', 14, false, controlnewsdesc,
                    (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'حقل اجباري';
                  } else {
                    if (value.length > 63) {
                      return 'الحد الاقصى للخبر 63 حرف';
                    }
                  }
                  ;
                }, counter: (context,
                        {required currentLength,
                        required isFocused,
                        maxLength}) {
                  return Container(
                      child: Text('${maxLength!}' + '/' + '${currentLength}'));
                }, maxLenth: 63),
              ),
              SizedBox(height: 20.h),
              padding(
                15,
                15,
                gradientContainerNoborder(
                    getSize(context).width,
                    buttoms(context, 'اضافة الخبر', 15, white, () {
                      if (_formKey.currentState!.validate()) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            FocusManager.instance.primaryFocus?.unfocus();
                            addNews(userToken!).then((value) => {
                                  value.contains('true')
                                      ? {
                                          goTopageReplacement(
                                              context,
                                              ActivityScreen(
                                                move: 'nn',
                                              )),
                                          //done
                                          showMassage(context, 'تم بنجاح',
                                              value.replaceAll('true', ''),
                                              done: done),
                                        }
                                      : showMassage(
                                          context,
                                          'خطا',
                                          value.replaceAll('false', ''),
                                        ),
                                });

                            // == First dialog closed
                            return Align(
                              alignment: Alignment.center,
                              child: Lottie.asset(
                                "assets/lottie/loding.json",
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        );
                      }
                    })),
              ),
              const SizedBox(
                height: 30,
              ),
            ]),
          ),
        )))),
      ),
    );
  }

  Future<String> addNews(String token) async {
    try {
      final response = await http.post(
        Uri.parse(
          'https://mobile.celebrityads.net/api/celebrity/news/add',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{
          "title": " .",
          "description": controlnewsdesc.text
        }),
      );
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.

        print(response.body);
        return jsonDecode(response.body)['message']['ar'] +
            jsonDecode(response.body)['success'].toString();
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load activity');
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
