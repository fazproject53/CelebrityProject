///import section
import 'dart:convert';

import 'package:celepraty/Celebrity/Pricing/ModelPricing.dart';
import 'package:celepraty/Models/Methods/classes/GradientIcon.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Account/LoggingSingUpAPI.dart';


class PricingMain extends StatelessWidget {
  const PricingMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: drowAppBar('التسعير', context),
        body: const PricingHome(),
      ),
    );
  }
}

///----------------------------- Pricing HomePage -----------------------------
class PricingHome extends StatefulWidget {
  const PricingHome({Key? key}) : super(key: key);

  @override
  _PricingHomeState createState() => _PricingHomeState();
}

class _PricingHomeState extends State<PricingHome> {
  Future<Pricing>? pricing;

  ///Text Filed
  final TextEditingController pricingAd = TextEditingController();
  final TextEditingController pricingAd1 = TextEditingController();
  final TextEditingController pricingGiftPhoto = TextEditingController();
  final TextEditingController pricingGiftVideo = TextEditingController();
  final TextEditingController pricingGiftVoice = TextEditingController();
  final TextEditingController pricingArea = TextEditingController();

  int? helper = 0;
  final _formKey = GlobalKey<FormState>();

  String? userToken;

  String? toolTipPhoto;
  String? toolTipVideo;
  String? toolTipVoice;

  String? toolTipAreaSpace;

  @override
  void initState() {
    DatabaseHelper.getToken().then((value) {
      setState(() {
        userToken = value;
        pricing = fetchCelebrityPricing(userToken!);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder<Pricing>(
              future: pricing,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: mainLoad(context));
                } else if (snapshot.connectionState == ConnectionState.active ||
                    snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                    //---------------------------------------------------------------------------
                  } else if (snapshot.hasData) {
                    if (helper == 0) {
                      ///get data and fill controller
                      snapshot.data!.data != null ? {
                      pricingAd.text = snapshot.data!.data!.price!.advertisingPriceFrom!.toString(),
                      pricingAd1.text =
                          snapshot.data!.data!.price!.advertisingPriceTo!
                              .toString(),

                      pricingGiftPhoto.text =
                          snapshot.data!.data!.price!.giftImagePrice!
                              .toString(),
                      pricingGiftVideo.text =
                          snapshot.data!.data!.price!.giftVedioPrice!
                              .toString(),
                      pricingGiftVoice.text = snapshot.data!.data!.price!.giftVoicePrice!
                              .toString(),

                      pricingArea.text = snapshot.data!.data!.price!.adSpacePrice!.toString(),

                        toolTipPhoto = snapshot.data!.data!.comments![0].value!,
                        toolTipVideo = snapshot.data!.data!.comments![1].value!,
                        toolTipVoice = snapshot.data!.data!.comments![2].value!,

                        toolTipAreaSpace = snapshot.data!.data!.comments![3].value!,

                        helper = 1,
                    } :  SizedBox();

          }

                    return Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: EdgeInsets.only(top: 20.h, right: 20.w),
                              child: text(
                                  context, "التسعير الخاص بك", 19, ligthtBlack),
                            ),
                          ),

                          SizedBox(
                            height: 10.h,
                          ),

                          ///Ad
                          Padding(
                            padding: EdgeInsets.only(
                                top: 10.h, bottom: 10.h, right: 8.w, left: 8.w),
                            child: Container(
                              height: 120.h,
                              width: 370.w,
                              alignment: Alignment.topRight,
                              decoration: BoxDecoration(
                                  color: white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 15.r,
                                      offset: const Offset(
                                          0, 15), // changes position of shadow
                                    ),
                                  ],
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10.r),
                                    bottomRight: Radius.circular(10.r),
                                    topRight: Radius.circular(10.r),
                                    topLeft: Radius.circular(10.r),
                                  )),

                              ///For text
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 7.h, right: 10.w, left: 10.w),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        GradientIcon(
                                            orders,
                                            25.w,
                                            const LinearGradient(
                                              begin: Alignment(0.7, 2.0),
                                              end: Alignment(-0.69, -1.0),
                                              colors: [
                                                Color(0xff0ab3d0),
                                                Color(0xffe468ca)
                                              ],
                                              stops: [0.0, 1.0],
                                            )),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        text(context, 'الإعلان', 16.sp, black,
                                            fontWeight: FontWeight.bold),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ///Text
                                        text(context, 'من', 16, grey!),

                                        ///Text Filed
                                        textFieldSmall(
                                          context,
                                          '2000 ر.س',
                                          12,
                                          false,
                                          pricingAd,
                                          (String? value) {
                                            /// Validation text field
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'حقل اجباري';
                                            }
                                            if (value.startsWith('0')) {
                                              return 'يجب ان لا يبدا بصفر';
                                            }
                                            return null;
                                          },
                                          keyboardType: TextInputType.phone,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                        ),
                                        text(context, 'الى', 16, grey!),

                                        ///Text Filed
                                        textFieldSmall(
                                          context,
                                          '5000 ر.س',
                                          12,
                                          false,
                                          pricingAd1,
                                          (String? value) {
                                            /// Validation text field
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'حقل اجباري';
                                            }
                                            if (value.startsWith('0')) {
                                              return 'يجب ان لا يبدا بصفر';
                                            }
                                            return null;
                                          },
                                          keyboardType: TextInputType.phone,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                        ),
                                        text(context, 'ر.س', 12, black),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          ///Gifting
                          Padding(
                            padding: EdgeInsets.only(
                                top: 10.h, bottom: 10.h, right: 8.w, left: 8.w),
                            child: Container(
                              height: 200.h,
                              width: 370.w,
                              alignment: Alignment.topRight,
                              decoration: BoxDecoration(
                                  color: white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 15.r,
                                      offset: const Offset(
                                          0, 15), // changes position of shadow
                                    ),
                                  ],
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10.r),
                                    bottomRight: Radius.circular(10.r),
                                    topRight: Radius.circular(10.r),
                                    topLeft: Radius.circular(10.r),
                                  )),
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 7.h, right: 25.w, left: 25.w),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          GradientIcon(
                                              gift,
                                              25.w,
                                              const LinearGradient(
                                                begin: Alignment(0.7, 2.0),
                                                end: Alignment(-0.69, -1.0),
                                                colors: [
                                                  Color(0xff0ab3d0),
                                                  Color(0xffe468ca)
                                                ],
                                                stops: [0.0, 1.0],
                                              )),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          text(context, 'الإهداء', 16.sp, black,
                                              fontWeight: FontWeight.bold),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20.h,
                                      ),

                                      ///Photo
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ///Text
                                          text(context, 'صورة', 16, grey!),
                                          SizedBox(
                                            width: 20.w,
                                          ),

                                          ///Text Filed
                                          textFieldSmall(
                                            context,
                                            '2000 ر.س',
                                            12,
                                            false,
                                            pricingGiftPhoto,
                                            (String? value) {
                                              /// Validation text field
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'حقل اجباري';
                                              }
                                              if (value.startsWith('0')) {
                                                return 'يجب ان لا يبدا بصفر';
                                              }
                                              return null;
                                            },
                                            keyboardType: TextInputType.phone,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            suffixIcon: MyTooltip(
                                                message: toolTipPhoto.toString(),
                                                child: Icon(
                                                  infoIcon,
                                                  size: 15,
                                                )),
                                          ),
                                          SizedBox(
                                            width: 20.w,
                                          ),

                                          ///Text
                                          text(context, 'ر.س', 12, black),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15.h,
                                      ),

                                      ///Video
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ///Text
                                          text(context, 'فيديو', 16, grey!),
                                          SizedBox(
                                            width: 20.w,
                                          ),

                                          ///Text Filed
                                          textFieldSmall(
                                            context,
                                            '2000 ر.س',
                                            12,
                                            false,
                                            pricingGiftVideo,
                                            (String? value) {
                                              /// Validation text field
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'حقل اجباري';
                                              }
                                              if (value.startsWith('0')) {
                                                return 'يجب ان لا يبدا بصفر';
                                              }
                                              return null;
                                            },
                                            keyboardType: TextInputType.phone,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            suffixIcon: MyTooltip(
                                                message: toolTipVideo.toString(),
                                                child: Icon(
                                                  infoIcon,
                                                  size: 15,
                                                )),
                                          ),
                                          SizedBox(
                                            width: 20.w,
                                          ),

                                          ///Text
                                          text(context, 'ر.س', 12, black),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15.h,
                                      ),

                                      ///Voice
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ///Text
                                          text(context, 'صوت', 16, grey!),
                                          SizedBox(
                                            width: 20.w,
                                          ),

                                          ///Text Filed
                                          textFieldSmall(
                                            context,
                                            '2000 ر.س',
                                            12,
                                            false,
                                            pricingGiftVoice,
                                            (String? value) {
                                              /// Validation text field
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'حقل اجباري';
                                              }
                                              if (value.startsWith('0')) {
                                                return 'يجب ان لا يبدا بصفر';
                                              }
                                              return null;
                                            },
                                            keyboardType: TextInputType.phone,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            suffixIcon: MyTooltip(
                                                message: toolTipVoice.toString(),
                                                child: Icon(
                                                  infoIcon,
                                                  size: 15,
                                                )),
                                          ),
                                          SizedBox(
                                            width: 20.w,
                                          ),

                                          ///Text
                                          text(context, 'ر.س', 12, black),
                                        ],
                                      ),
                                    ],
                                  )),
                            ),
                          ),

                          ///Area
                          Padding(
                            padding: EdgeInsets.only(
                                top: 10.h, bottom: 10.h, right: 8.w, left: 8.w),
                            child: Container(
                              height: 120.h,
                              width: 370.w,
                              alignment: Alignment.topRight,
                              decoration: BoxDecoration(
                                  color: white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 15.r,
                                      offset: const Offset(
                                          0, 15), // changes position of shadow
                                    ),
                                  ],
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10.r),
                                    bottomRight: Radius.circular(10.r),
                                    topRight: Radius.circular(10.r),
                                    topLeft: Radius.circular(10.r),
                                  )),

                              ///For text
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 7.h, right: 25.w, left: 25.w),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          GradientIcon(
                                              adArea,
                                              25.w,
                                              const LinearGradient(
                                                begin: Alignment(0.7, 2.0),
                                                end: Alignment(-0.69, -1.0),
                                                colors: [
                                                  Color(0xff0ab3d0),
                                                  Color(0xffe468ca)
                                                ],
                                                stops: [0.0, 1.0],
                                              )),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          text(context, 'المساحة الاعلانية',
                                              16.sp, black,
                                              fontWeight: FontWeight.bold),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 55.w,
                                          ),

                                          ///Text Filed
                                          textFieldSmall(
                                            context,
                                            '2000 ر.س',
                                            12,
                                            false,
                                            pricingArea,
                                            (String? value) {
                                              /// Validation text field
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'حقل اجباري';
                                              }
                                              if (value.startsWith('0')) {
                                                return 'يجب ان لا يبدا بصفر';
                                              }
                                              return null;
                                            },
                                            keyboardType: TextInputType.phone,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            suffixIcon: MyTooltip(
                                                message: toolTipAreaSpace.toString(),
                                                child: Icon(
                                                  infoIcon,
                                                  size: 15,
                                                )),
                                          ),
                                          SizedBox(
                                            width: 20.w,
                                          ),
                                          text(context, 'ر.س', 12, black),
                                        ],
                                      ),
                                    ],
                                  )),
                            ),
                          ),

                          ///Save Button
                          Padding(
                            padding: EdgeInsets.only(left: 20.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.r))),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(white),
                                    shadowColor:
                                        MaterialStateProperty.all<Color>(
                                      Colors.black38,
                                    ),
                                  ),
                                  child: text(context, 'حفظ', 12, purple),
                                  onPressed: () {
                                    //to
                                    var ad1 = int.parse(pricingAd1.text);
                                    //from
                                    var ad = int.parse(pricingAd.text);

                                    _formKey.currentState!.validate()
                                        ? {
                                            ///var c = int. parse(b);
                                            //to < from
                                            ad1 < ad
                                                ? Flushbar(
                                              flushbarPosition: FlushbarPosition.TOP,
                                              backgroundColor: white,
                                              margin: const EdgeInsets.all(5),
                                              flushbarStyle: FlushbarStyle.FLOATING,
                                              borderRadius: BorderRadius.circular(10.r),
                                              duration: const Duration(seconds: 5),
                                              icon: Icon(
                                                error,
                                                color: red!,
                                                size: 25.sp,
                                              ),
                                              titleText: text(context, 'خطأ', 16, purple),
                                              messageText: text(
                                                  context,
                                                  'يجب ان يكون الحد الاعلى للإعلان أكبر',
                                                  14,
                                                  black,
                                                  fontWeight: FontWeight.w200),
                                            ).show(context)



                                                : postFunction(userToken!)
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
                                          }
                                        : null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const Center(child: Text('Empty data'));
                  }
                } else {
                  return Center(
                      child: Text('State: ${snapshot.connectionState}'));
                }
              }),
        ),
      ),
    );
  }

  ///Get
  Future<Pricing> fetchCelebrityPricing(String token) async {
    final response = await http.get(
        Uri.parse('https://mobile.celebrityads.net/api/celebrity/price'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //print(response.body);
      return Pricing.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load activity');
    }
  }

  ///Post
  Future<http.Response> postFunction(String token) async {
    final response = await http.post(
      Uri.parse('https://mobile.celebrityads.net/api/celebrity/price/update'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, dynamic>{
        'advertising_price_from': pricingAd.text,
        'advertising_price_to': pricingAd1.text,
        'gift_image_price': pricingGiftPhoto.text,
        'gift_vedio_price': pricingGiftVideo.text,
        'gift_voice_price': pricingGiftVoice.text,
        'ad_space_price': pricingArea.text
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

///Tooltip
class MyTooltip extends StatelessWidget {
  final Widget child;
  final String message;

  const MyTooltip({Key? key, required this.message, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<State<Tooltip>>();
    return Tooltip(
      key: key,
      message: message,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onTap(key),
        child: child,
      ),
    );
  }

  void _onTap(GlobalKey key) {
    final dynamic tooltip = key.currentState;
    tooltip?.ensureTooltipVisible();
  }
}
