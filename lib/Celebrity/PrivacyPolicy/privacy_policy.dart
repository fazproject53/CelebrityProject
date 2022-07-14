///import section
import 'dart:convert';

import 'package:celepraty/Celebrity/PrivacyPolicy/ModelPrivicyPolicy.dart';
import 'package:celepraty/Models/Methods/classes/GradientIcon.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import '../../Account/LoggingSingUpAPI.dart';
import '../setting/profileInformation.dart';

class PrivacyPolicyMain extends StatelessWidget {
  const PrivacyPolicyMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: drowAppBar("الشروط والاحكام", context),
        body: const PrivacyPolicyHome(),
      ),
    );
  }
}

///----------------------------PrivacyPolicyHome----------------------------
class PrivacyPolicyHome extends StatefulWidget {
  const PrivacyPolicyHome({Key? key}) : super(key: key);

  @override
  _PrivacyPolicyHomeState createState() => _PrivacyPolicyHomeState();
}

class _PrivacyPolicyHomeState extends State<PrivacyPolicyHome>
    with AutomaticKeepAliveClientMixin {
  Future<PrivacyPolicy>? pp;

  ///Text Field
  final TextEditingController addYourAdvPP = TextEditingController();
  final TextEditingController addYourGiftingPP = TextEditingController();
  final TextEditingController addYourAdvAreaPP = TextEditingController();

  bool isVisible = false;
  bool isVisible2 = false;
  bool isVisible3 = false;

  int? helper = 0;

  bool? isUpdate = false;
  bool? isUpdate1 = false;
  bool? isUpdate2 = false;

  final _formKey = GlobalKey<FormState>();
  String? userToken;
  @override
  void initState() {
    DatabaseHelper.getToken().then((value) {
      setState(() {
        userToken = value;
        pp = fetchCelebritie(userToken!);
      });
    });
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: FutureBuilder<PrivacyPolicy>(
                          future: pp,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: mainLoad(context));
                            } else if (snapshot.connectionState ==
                                    ConnectionState.active ||
                                snapshot.connectionState ==
                                    ConnectionState.done) {
                              if (snapshot.hasError) {
                                return Text(snapshot.error.toString());
                                //---------------------------------------------------------------------------
                              } else if (snapshot.hasData) {
                                if (helper == 0) {
                                  ///get data and fill controller
                                  addYourAdvPP.text = snapshot.data!.data!
                                      .celebrity!.advertisingPolicy!;
                                  addYourGiftingPP.text = snapshot
                                      .data!.data!.celebrity!.giftingPolicy!;
                                  addYourAdvAreaPP.text = snapshot
                                      .data!.data!.celebrity!.adSpacePolicy!;
                                  helper = 1;
                                }
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      alignment: Alignment.topRight,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 25.h, right: 20.w),
                                        child: text(
                                          context,
                                          "قم بإضافة الشروط والاحكام الخاصة بك",
                                          19,
                                          ligthtBlack,
                                        ),
                                      ),
                                    ),

                                    ///Icons Buttons with title
                                    Container(
                                      alignment: Alignment.topRight,
                                      padding: EdgeInsets.only(
                                          top: 20.h, right: 16.w, bottom: 20.h),
                                      child: Column(
                                        children: [
                                          ///Adv PP
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: GradientIcon(
                                                  ad,
                                                  30.w,
                                                  const LinearGradient(
                                                    begin: Alignment(0.7, 2.0),
                                                    end: Alignment(-0.69, -1.0),
                                                    colors: [
                                                      Color(0xff0ab3d0),
                                                      Color(0xffe468ca)
                                                    ],
                                                    stops: [0.0, 1.0],
                                                  ),
                                                ),
                                                onPressed: () {
                                                  ///Text field will show
                                                  setState(() {
                                                    isVisible = !isVisible;
                                                  });
                                                },
                                              ),
                                              text(
                                                context,
                                                'سياسة الاعلان',
                                                20.sp,
                                                black,
                                              ),
                                            ],
                                          ),
                                          Visibility(
                                            visible: isVisible,
                                            child: Container(
                                              padding:
                                                  EdgeInsets.only(right: 10.w),
                                              child: Column(
                                                children: [
                                                  ///Text Field
                                                  paddingg(
                                                    20,
                                                    4,
                                                    9,
                                                    textFieldDescOnChange(
                                                      context,
                                                      'اكتب سياسة الاعلان الخاصة بك',
                                                      12,
                                                      false,
                                                      addYourAdvPP,
                                                      (String? value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                        } else {
                                                          return value.length >
                                                                  500
                                                              ? 'يجب ان لا يزيد الوصف عن 500 حرف'
                                                              : null;
                                                        }
                                                        return null;
                                                      },
                                                      counter: (context,
                                                          {required currentLength,
                                                          required isFocused,
                                                          maxLength}) {
                                                        return Text(
                                                          '$maxLength'
                                                          '/'
                                                          '$currentLength',
                                                          style: TextStyle(
                                                              fontSize: 12.sp,
                                                              color: grey),
                                                        );
                                                      },
                                                      maxLenth: 500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          ),

                                          ///Gifting PP
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: GradientIcon(
                                                    ad,
                                                    30.w,
                                                    const LinearGradient(
                                                      begin:
                                                          Alignment(0.7, 2.0),
                                                      end: Alignment(
                                                          -0.69, -1.0),
                                                      colors: [
                                                        Color(0xff0ab3d0),
                                                        Color(0xffe468ca)
                                                      ],
                                                      stops: [0.0, 1.0],
                                                    )),
                                                onPressed: () {
                                                  ///Text field will show
                                                  setState(
                                                    () {
                                                      isVisible2 = !isVisible2;
                                                    },
                                                  );
                                                },
                                              ),
                                              text(
                                                context,
                                                'سياسة الاهداء',
                                                20.sp,
                                                black,
                                              ),
                                            ],
                                          ),
                                          Visibility(
                                            visible: isVisible2,
                                            child: Container(
                                              padding:
                                                  EdgeInsets.only(right: 10.w),
                                              child: Column(
                                                children: [
                                                  ///Text Field
                                                  paddingg(
                                                    20,
                                                    4,
                                                    9,
                                                    textFieldDescOnChange(
                                                      context,
                                                      'اكتب سياسة الاهداء الخاصة بك',
                                                      12,
                                                      false,
                                                      addYourGiftingPP,
                                                      (String? value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                        } else {
                                                          return value.length >
                                                                  500
                                                              ? 'يجب ان لا يزيد الوصف عن 500 حرف'
                                                              : null;
                                                        }
                                                        return null;
                                                      },
                                                      counter: (context,
                                                          {required currentLength,
                                                          required isFocused,
                                                          maxLength}) {
                                                        return Text(
                                                          '$maxLength'
                                                          '/'
                                                          '$currentLength',
                                                          style: TextStyle(
                                                              fontSize: 12.sp,
                                                              color: grey),
                                                        );
                                                      },
                                                      maxLenth: 500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          ),

                                          ///Area PP
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: GradientIcon(
                                                    ad,
                                                    30.w,
                                                    const LinearGradient(
                                                      begin:
                                                          Alignment(0.7, 2.0),
                                                      end: Alignment(
                                                          -0.69, -1.0),
                                                      colors: [
                                                        Color(0xff0ab3d0),
                                                        Color(0xffe468ca)
                                                      ],
                                                      stops: [0.0, 1.0],
                                                    )),
                                                onPressed: () {
                                                  ///Text field will show
                                                  setState(
                                                    () {
                                                      isVisible3 = !isVisible3;
                                                    },
                                                  );
                                                },
                                              ),
                                              text(
                                                context,
                                                'سياسة المساحة الاعلانية',
                                                20.sp,
                                                black,
                                              ),
                                            ],
                                          ),
                                          Visibility(
                                            visible: isVisible3,
                                            child: Container(
                                              padding:
                                                  EdgeInsets.only(right: 10.w),
                                              child: Column(
                                                children: [
                                                  ///Text Field
                                                  paddingg(
                                                    20,
                                                    4,
                                                    9,
                                                    textFieldDescOnChange(
                                                      context,
                                                      'اكتب سياسة المساحة الاعلانية الخاصة بك',
                                                      12,
                                                      false,
                                                      addYourAdvAreaPP,
                                                      (String? value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                        } else {
                                                          return value.length >
                                                                  500
                                                              ? 'يجب ان لا يزيد الوصف عن 500 حرف'
                                                              : null;
                                                        }
                                                        return null;
                                                      },
                                                      counter: (context,
                                                          {required currentLength,
                                                          required isFocused,
                                                          maxLength}) {
                                                        return Text(
                                                          '$maxLength'
                                                          '/'
                                                          '$currentLength',
                                                          style: TextStyle(
                                                              fontSize: 12.sp,
                                                              color: grey),
                                                        );
                                                      },
                                                      maxLenth: 500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30.h,
                                          ),

                                          ///save button
                                          Visibility(
                                              visible: isVisible ||
                                                      isVisible2 ||
                                                      isVisible3
                                                  ? true
                                                  : false,
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(left: 20.w),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    ElevatedButton(
                                                        style: ButtonStyle(
                                                          shape: MaterialStateProperty.all<
                                                                  RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15.r))),
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all<Color>(
                                                                      white),
                                                          shadowColor:
                                                              MaterialStateProperty
                                                                  .all<Color>(
                                                            Colors.black38,
                                                          ),
                                                        ),
                                                        child: text(context,
                                                            'حفظ', 12, purple),
                                                        onPressed: () {
                                                          _formKey.currentState!.validate()
                                                              ? postFunction(userToken!)
                                                              .whenComplete(() => {
                                                            Flushbar(
                                                              flushbarPosition:
                                                              FlushbarPosition
                                                                  .TOP,
                                                              backgroundColor:
                                                              white,
                                                              margin:
                                                              const EdgeInsets
                                                                  .all(5),
                                                              flushbarStyle:
                                                              FlushbarStyle
                                                                  .FLOATING,
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  10.r),
                                                              duration:
                                                              const Duration(
                                                                  seconds: 5),
                                                              icon: Icon(
                                                                right,
                                                                color: green,
                                                                size: 30,
                                                              ),
                                                              titleText: text(
                                                                  context,
                                                                  'تم الحفظ',
                                                                  16,
                                                                  purple),
                                                              messageText: text(
                                                                  context,
                                                                  'تم حفظ المدخلات بنجاح',
                                                                  14,
                                                                  black,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w200),
                                                            ).show(context)

                                                          })
                                                              : null;

                                                        }),
                                                  ],
                                                ),
                                              )),
                                        ],
                                      ),
                                    )
                                  ],
                                );
                              } else {
                                return const Center(child: Text('Empty data'));
                              }
                            } else {
                              return Center(
                                  child: Text(
                                      'State: ${snapshot.connectionState}'));
                            }
                          }),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  ///Get
  Future<PrivacyPolicy> fetchCelebritie(String token) async {

    final response = await http.get(
        Uri.parse('https://mobile.celebrityads.net/api/celebrity/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(response.body);
      return PrivacyPolicy.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load activity');
    }
  }

  ///Post
  Future<http.Response> postFunction(String token) async {

    final response = await http.post(
      Uri.parse(
        'https://mobile.celebrityads.net/api/celebrity/terms-and-conditions/update',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, dynamic>{
        'advertising_policy': addYourAdvPP.text,
        'ad_space_policy': addYourAdvAreaPP.text,
        'gifting_policy': addYourGiftingPP.text
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
