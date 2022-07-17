import 'dart:convert';
import 'dart:io';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:http/http.dart' as http;
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Account/LoggingSingUpAPI.dart';
import '../activity_screen.dart';

class addNews extends StatefulWidget{

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
                  child: Form(        key: _formKey,

                  child: paddingg(12, 12, 5, Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          padding(10, 12, Container( alignment : Alignment.topRight,child:  Text(' اضافة خبر جديد', style: TextStyle(fontSize: 18.sp, color: textBlack , fontFamily: 'Cairo'), )),),

                          SizedBox(height: 20.h,),

                          paddingg(15, 15, 12,textFieldNoIcon(context, 'عنوان الخبر', 14, false, controlnewstitle,(String? value) {if (value == null || value.isEmpty) {
                            return 'حقل اجباري';} return null;},false),),
                          paddingg(15, 15, 12,textFieldDesc(context, 'وصف الخبر', 14, false, controlnewsdesc,(String? value) {if (
                          value == null || value.isEmpty) {
                            return 'حقل اجباري';}else{
                            if(value.length > 63){
                              return 'الحد الاقصى للخبر 63 حرف';
                            }
                          };}, counter: (context, {required currentLength, required isFocused, maxLength}){return Container(child: Text('${maxLength!}' +  '/' + '${currentLength}'));}, maxLenth: 63),),

                          SizedBox(height: 20.h),
                          padding(15, 15, gradientContainerNoborder(getSize(context).width,  buttoms(context, 'اضافة الخبر', 15, white, (){
                            if(_formKey.currentState!.validate()){
                              addNews(userToken!).whenComplete(() => {
                                goTopageReplacement(context, ActivityScreen()),
                                Flushbar(
                                  flushbarPosition:
                                  FlushbarPosition.TOP,
                                  backgroundColor: white,
                                  margin:
                                  const EdgeInsets.all(5),
                                  flushbarStyle:
                                  FlushbarStyle.FLOATING,
                                  borderRadius:
                                  BorderRadius.circular(
                                      15.r),
                                  duration: const Duration(
                                      seconds: 5),
                                  icon: Padding(
                                    padding: const EdgeInsets.only(left: 18.0),
                                    child: Icon(
                                      done,
                                      color: green,
                                      size: 25.sp,
                                    ),
                                  ),
                                  titleText: text(context, 'تم بنجاح', 14, purple),
                                  messageText: text(
                                      context,
                                      'تم اضافة الخبر بنجاح',
                                      14,
                                      black,
                                      fontWeight:
                                      FontWeight.w200),
                                ).show(context)
                              });
                            }
                          })),),
                          const SizedBox(height: 30,),
                        ]),
                    ),

                  ))
            )
        ),
      ),
    );
  }
  Future<http.Response> addNews(String token) async {
    String token2 = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiOWVjZjA0OGYxODVkOGZjYjQ5YTI3ZTgyYjQxYjBmNTg3OTMwYTA3NDY3YTc3ZjQwOGZlYWFmNjliNGYxMDQ4ZjEzMjgxMWU4MWNhMDJlNjYiLCJpYXQiOjE2NTAxOTc4MTIuNjUzNTQ5OTA5NTkxNjc0ODA0Njg3NSwibmJmIjoxNjUwMTk3ODEyLjY1MzU1MzAwOTAzMzIwMzEyNSwiZXhwIjoxNjgxNzMzODEyLjY0Mzg2NjA2MjE2NDMwNjY0MDYyNSwic3ViIjoiMTEiLCJzY29wZXMiOltdfQ.toMOLVGTbNRcIqD801Xs3gJujhMvisCzAHHQC_P8UYp3lmzlG3rwadB4M0rooMIVt82AB2CyZfT37tVVWrjAgNq4diKayoQC5wPT7QQrAp5MERuTTM7zH2n3anZh7uargXP1Mxz3X9PzzTRSvojDlfCMsX1PrTLAs0fGQOVVa-u3lkaKpWkVVa1lls0S755KhZXCAt1lKBNcm7GHF657QCh4_daSEOt4WSF4yq-F6i2sJH-oMaYndass7HMj05wT9Z2KkeIFcZ21ZEAKNstraKUfLzwLr2_buHFNmnziJPG1qFDgHLOUo6Omdw3f0ciPLiLD7FnCrqo_zRZQw9V_tPb1-o8MEZJmAH2dfQWQBey4zZgUiScAwZAiPNcTPBWXmSGQHxYVjubKzN18tq-w1EPxgFJ43sRRuIUHNU15rhMio_prjwqM9M061IzYWgzl3LW1NfckIP65l5tmFOMSgGaPDk18ikJNmxWxpFeBamL6tTsct7-BkEuYEU6GEP5D1L-uwu8GGI_T6f0VSW9sal_5Zo0lEsUuR2nO1yrSF8ppooEkFHlPJF25rlezmaUm0MIicaekbjwKdja5J5ZgNacpoAnoXe4arklcR6djnj_bRcxhWiYa-0GSITGvoWLcbc90G32BBe2Pz3RyoaiHkAYA_BNA_0qmjAYJMwB_e8U';
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
        "title" : controlnewstitle.text,
        "description" : controlnewsdesc.text
      }),
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      print(response.body);
      return response;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load activity');
    }
  }
}