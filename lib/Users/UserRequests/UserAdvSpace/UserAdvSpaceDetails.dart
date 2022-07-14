import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../../../Account/UserForm.dart';
import '../../../Models/Methods/method.dart';
import '../../../Models/Variables/Variables.dart';
import '../../Exploer/viewDataImage.dart';
import '../../chat/chatRoom.dart';
import '../UserAds/UserAdsOrdersApi.dart';

bool clickUserAdvSpace = false;

class UserAdvSpaceDetails extends StatefulWidget {
  int? i;
  final String? image;
  final String? description;
  final int? price;
  final String? advTitle;
  final String? advType;
  final String? platform;
  final String? token;
  final int? state;
  final int? orderId;
  final String? rejectResonName;
  final int? rejectResonId;
  final String? link;

  UserAdvSpaceDetails({
    Key? key,
    this.description,
    this.price,
    this.advTitle,
    this.advType,
    this.platform,
    this.token,
    this.state,
    this.orderId,
    this.rejectResonName,
    this.rejectResonId,
    this.i,
    this.image,
    this.link,
  }) : super(key: key);

  @override
  State<UserAdvSpaceDetails> createState() => _UserAdvSpaceDetailsState();
}

class _UserAdvSpaceDetailsState extends State<UserAdvSpaceDetails> {
  int? resonRejectId;
  String? resonReject;
  bool isReject = true;
  List<String> rejectResonsList = [];
  TextEditingController reson = TextEditingController();
  GlobalKey<FormState> resonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    getRejectReson();
    print(rejectResonsList);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            appBar: drowAppBar("تفاصيل طلبات المساحة الاعلانية", context),
            body: Container(
              //color: black,
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  SizedBox(
                    height: 30.h,
                  ),
//title----------------------------------------------------------
                  Container(
                    // height: MediaQuery.of(context).size.height/4,
                    width: MediaQuery.of(context).size.width,
                    //color: red,
                    margin: EdgeInsets.symmetric(horizontal: 20.r),
                    child: text(
                      context,
                      'صورة الاعلان',
                      18,
                      black,
                      //fontWeight: FontWeight.bold,
                      align: TextAlign.right,
                    ),
                  ),
//image----------------------------------------------------------
                  Expanded(
                    flex: 3,
                    child: InkWell(
                      onTap: () {
                        goTopagepush(
                            context,
                            ImageData(
                              image: widget.image!,
                            ));
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height / 3,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(
                            vertical: 20.h, horizontal: 20.r),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.r)),
                            image: DecorationImage(
                                image: NetworkImage(
                                  widget.image!,
                                ),
                                fit: BoxFit.cover)),
                      ),
                    ),
                  ),
//link------------------------------------------------------------------------
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.r),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.ads_click,
                          color: pink,
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        InkWell(
                          onTap: () async {
                            var url = widget.link!;
                            if (await canLaunch(url.toString())) {
                              await launch(url.toString(), forceWebView: true);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  snackBar(
                                      context, 'الرابط غير صالح', red, error));
                            }
                          },
                          child: text(
                            context,
                            'تصفح الموقع الالكتروني  ',
                            18,
                            black,
                            //fontWeight: FontWeight.bold,
                            align: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
//reject reson------------------------------------------------------------------------

                  Visibility(
                      visible: isReject,
                      child: widget.state == 3 || widget.state == 5
                          ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.r),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.quiz,
                                          color: pink,
                                          size: 25.r,
                                        ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        text(
                                          context,
                                          'سبب الرفض',
                                          18,
                                          black,
                                          //fontWeight: FontWeight.bold,
                                          align: TextAlign.right,
                                        ),
                                      ],
                                    ),
                                    //-------------------------------
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 30.w),
                                      child: text(
                                        context,
                                        widget.rejectResonName!,
                                        16.5,
                                        deepBlack,
                                        //fontWeight: FontWeight.bold,
                                        align: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          :
//price field-------------------------------------------------------------------------------
                          const SizedBox()),
//accept buttom-----------------------------------------------------

                  isReject
                      ? Container(
                          width: double.infinity,
                          height: 50,
                          //color: Colors.red,
                          margin: EdgeInsets.all(20.r),
                          child: Row(children: [
                            Expanded(
                              flex: 2,
                              child: gradientContainer(
                                double.infinity,
                                buttoms(
                                  context,
                                  widget.state == 4
                                      ? "ادفع الان"
                                      : widget.state == 3
                                          ? 'قبول'
                                          : widget.state == 2
                                              ? 'قبول من المتابع'
                                              : widget.state == 6
                                                  ? 'تم الدفع'
                                                  : widget.state == 1
                                                      ? 'قيد الانتظار'
                                                      : 'قبول',
                                  15,
                                  widget.state == 3 ||
                                          widget.state == 1 ||
                                          widget.state == 2 ||
                                          widget.state == 5 ||
                                          widget.state == 6
                                      ? deepBlack
                                      : white,
                                  widget.state == 3 ||
                                          widget.state == 1 ||
                                          widget.state == 2 ||
                                          widget.state == 5 ||
                                          widget.state == 6
                                      ? null
                                      : widget.state == 4
                                          ? () {
                                              print('payment');
                                              // goTopagepush(
                                              //     context, CelebrityPayments());
                                            }
                                          : () {
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();

                                              loadingDialogue(context);
                                              Future<bool> result =
                                                  userAcceptAdvertisingOrder(
                                                      widget.token!,
                                                      widget.orderId!,
                                                      int.parse(''));
                                              result.then((value) {
                                                if (value == true) {
                                                  Navigator.pop(context);
                                                  setState(() {
                                                    clickUserAdvSpace = true;
                                                  });
                                                  successfullyDialog(
                                                      context,
                                                      'تم قبول سعر الاعلان',
                                                      "assets/lottie/SuccessfulCheck.json",
                                                      'حسناً', () {
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  });
                                                } else {
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar(
                                                          context,
                                                          'تم قبول الطلب مسبقا',
                                                          red,
                                                          error));
                                                }
                                              });
                                            },
                                  evaluation: 0,
                                ),
                                height: 50,
                                color: widget.state == 3 ||
                                        widget.state == 1 ||
                                        widget.state == 2 ||
                                        widget.state == 5 ||
                                        widget.state == 6
                                    ? deepBlack
                                    : Colors.transparent,
                                gradient: widget.state == 3 ||
                                        widget.state == 1 ||
                                        widget.state == 2 ||
                                        widget.state == 5 ||
                                        widget.state == 6
                                    ? true
                                    : false,
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),

//reject buttom-------------------------------------------------

                            Expanded(
                              flex: 2,
                              child: gradientContainer(
                                double.infinity,
                                buttoms(
                                  context,
                                  widget.state == 3
                                      ? "رفض من المشهور"
                                      : widget.state == 4
                                          ? 'رفض'
                                          : widget.state == 5
                                              ? 'رفض من المتابع'
                                              : widget.state == 6
                                                  ? 'رفض'
                                                  : 'رفض',
                                  15,
                                  widget.state == 3 ||
                                          widget.state == 4 ||
                                          widget.state == 5 ||
                                          widget.state == 2 ||
                                          widget.state == 6
                                      ? deepgrey!
                                      : black,
                                  widget.state == 4 ||
                                          widget.state == 3 ||
                                          widget.state == 5 ||
                                          widget.state == 2 ||
                                          widget.state == 6
                                      ? null
                                      : () {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          rejectResonsList.isNotEmpty
                                              ? showBottomSheetModel(context)
                                              : '';
                                        },
                                  //evaluation: 1,
                                ),
                                height: 50,
                                gradient: true,
                                color: widget.state == 3 ||
                                        widget.state == 4 ||
                                        widget.state == 5 ||
                                        widget.state == 2 ||
                                        widget.state == 6
                                    ? deepBlack
                                    : pink,
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
//---------------------------------------------------------
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: InkWell(
                                          onTap: widget.state == 3
                                              ? null
                                              : () {
                                                  goTopagepush(
                                                      context, chatRoom());
                                                },
                                          child: Icon(Icons.forum_outlined,
                                              color: widget.state == 3
                                                  ? deepBlack
                                                  : pink)))
                                ],
                              ),
                            ),
                            //height: 50,
                            //gradient: true,
                            //),
                            //)
                          ]))
                      :
                      //confirm reject---------------------------------------------------------------
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.r),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 4.0.w),
                                child: text(
                                  context,
                                  'سبب الرفض',
                                  17,
                                  black,
                                  //fontWeight: FontWeight.bold,
                                  align: TextAlign.right,
                                ),
                              ),
                              SizedBox(height: 10.h),
//-------------------------------------------------------------------------
                              resonReject == 'أخرى'
                                  ? Form(
                                      key: resonKey,
                                      child: textField2(
                                          context,
                                          Icons.unpublished,
                                          '',
                                          14,
                                          false,
                                          reson,
                                          empty,
                                          hitText: 'اختر سبب الرفض'),
                                    )
                                  : Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5.r),
                                      child: text(
                                        context,
                                        '$resonReject',
                                        17,
                                        black,
                                        //fontWeight: FontWeight.bold,
                                        align: TextAlign.right,
                                      ),
                                    ),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 25),
                              //--------------------------------
                              //const Spacer(),
                              gradientContainer(
                                double.infinity,
                                buttoms(
                                  context,
                                  "تاكيد",
                                  15,
                                  white,
                                  () {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    if (resonReject == 'أخرى') {
                                      if (resonKey.currentState?.validate() ==
                                          true) {
                                        loadingDialogue(context);
                                        Future<bool> result =
                                            userRejectAdvertisingOrder(
                                                widget.token!,
                                                widget.orderId!,
                                                reson.text,
                                                0);
                                        result.then((value) {
                                          if (value == true) {
                                            Navigator.pop(context);
                                            setState(() {
                                              clickUserAdvSpace = true;
                                            });
                                            successfullyDialog(
                                                context,
                                                'تم رفض سعر الاعلان',
                                                "assets/lottie/SuccessfulCheck.json",
                                                'حسناً', () {
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            });
                                          } else {
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar(
                                                    context,
                                                    'تم رفض الطلب مسبقا',
                                                    red,
                                                    error));
                                          }
                                        });
                                      }
                                    } else {
                                      loadingDialogue(context);
                                      Future<bool> result =
                                          userRejectAdvertisingOrder(
                                              widget.token!,
                                              widget.orderId!,
                                              resonReject!,
                                              resonRejectId!);
                                      result.then((value) {
                                        if (value == true) {
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar(context,
                                                  'تم رفض الطلب', green, done));
                                        } else {
                                          Navigator.pop(context);
                                          setState(() {
                                            clickUserAdvSpace = true;
                                          });
                                          successfullyDialog(
                                              context,
                                              'تم رفض سعر الاعلان',
                                              "assets/lottie/SuccessfulCheck.json",
                                              'حسناً', () {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          });
                                        }
                                      });
                                    }
                                  },
                                  evaluation: 0,
                                ),
                                height: 50,
                                color: Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            )));
  }

/*
*
* */
  //----------------------------------------------------------------------------------------------
  showBottomSheetModel(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        elevation: 10,
        backgroundColor: black,
        //isDismissible: false,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(70.r), topLeft: Radius.circular(70.r)),
          //side: BorderSide(color: Colors.white, width: 1),
        ),
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 40.h,
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height / 10),
                  decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.all(Radius.circular(50.r))),
                  width: MediaQuery.of(context).size.width / 9,
                  height: 4.h,
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
//Reject reson-----------------------------------------------------------------------------
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 2.7.h,
                  child: ListView.builder(
                      itemCount: rejectResonsList.length,
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.0.w, vertical: 3.h),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                resonReject = rejectResonsList[i];
                                resonRejectId = i;
                                isReject = false;
                              });
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 46.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0.r),
                                  color: deepPink),
                              child: Padding(
                                padding: EdgeInsets.all(8.0.r),
                                child: text(
                                  context,
                                  rejectResonsList[i],
                                  15,
                                  white,
                                  fontWeight: FontWeight.bold,
                                  align: TextAlign.right,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
//Another reson-----------------------------------------------------------------------------

              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 30.0.w, vertical: 3.h),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      resonReject = 'أخرى';
                      isReject = false;
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 46.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0.r),
                        color: deepPink),
                    child: Padding(
                      padding: EdgeInsets.all(8.0.r),
                      child: text(
                        context,
                        'أخرى',
                        15,
                        white,
                        fontWeight: FontWeight.bold,
                        align: TextAlign.right,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

//-------------------------------------------------------------------------
  void getRejectReson() async {
    String url = "https://mobile.celebrityads.net/api/reject-resons";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      for (int i = 0; i < body['data'].length; i++) {
        rejectResonsList.add(body['data'][i]['name']);
      }
    } else {
      throw Exception('Failed to load celebrity Reject reson');
    }
  }
}
