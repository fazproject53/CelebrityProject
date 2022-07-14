///import section
import 'dart:convert';

import 'package:celepraty/Celebrity/Calendar/CalenderModel.dart';
import 'package:celepraty/Celebrity/Calendar/pdfClass.dart';
import 'package:celepraty/Models/Methods/classes/GradientIcon.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:flutter/material.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import '../../Account/LoggingSingUpAPI.dart';
import '../../Models/Variables/Variables.dart';


class CelebrityCalenderMain extends StatelessWidget {
  const CelebrityCalenderMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: drowAppBar("جدول المواعيد", context),
        body: const CelebrityCalenderHome(),
      ),
    );
  }
}

///---------------------CelebrityCalenderHome---------------------
class CelebrityCalenderHome extends StatefulWidget {

  const CelebrityCalenderHome({Key? key}) : super(key: key);

  @override
  _CelebrityCalenderHomeState createState() => _CelebrityCalenderHomeState();
}

class _CelebrityCalenderHomeState extends State<CelebrityCalenderHome> {

  ///future discount model variable
  Future<CalenderModel>? calender;

  String? userToken;
  @override
  void initState() {
    DatabaseHelper.getToken().then((value) {
      setState(() {
        userToken = value;
        calender = fetchCalender(userToken!);
      });
    });
    // TODO: implement initState
    super.initState();
  }

  late DateTime dateFormat;

  late String month;
  late int day;
  late int year;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(children: [
        Expanded(
          child: Stack(children: [
            Container(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(top: 23.h, right: 20.w),
                child: text(context, 'الجدول الخاص بالمواعيد المتفق عليها', 17,
                    ligthtBlack),
              ),
            ),
            paddingg(
              10,
              10,
              60,

              ///ListView
              FutureBuilder<CalenderModel>(
                future: calender,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center();
                  } else if (snapshot.connectionState ==
                      ConnectionState.active ||
                      snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                      //---------------------------------------------------------------------------
                    } else if (snapshot.hasData) {

                      return snapshot.data!.data!.orders!.isNotEmpty ? ListView.builder(
                        itemCount: snapshot.data!.data!.orders!.length,
                        itemBuilder: (context, index) {

                          dateFormat = DateTime.parse(snapshot.data!.data!.orders![index].date!);

                          ///Save the year
                          year  = dateFormat.year;

                          ///Save the day date
                          day = dateFormat.day;

                          ///Convert the month to text
                          if(dateFormat.month == 01){ ///1
                            month = 'يناير';
                          }else if(dateFormat.month == 02){ ///2
                            month = 'فبراير';
                          }else if(dateFormat.month == 03){ ///3
                            month = 'مارش';
                          }else if(dateFormat.month == 04){ ///4
                            month = 'ابريل';
                          }else if(dateFormat.month == 05){ ///5
                            month = 'مايو';
                          }else if(dateFormat.month == 06){ ///6
                            month = 'يونيو';
                          }else if(dateFormat.month == 07){ ///7
                            month = 'يوليو';
                          }else if(dateFormat.month == 08){ ///8
                            month = 'أغطسطس';
                          }else if(dateFormat.month == 09){ ///9
                            month = 'سبتمبر';
                          }else if(dateFormat.month == 10){ ///10
                            month = 'أكتوبر';
                          }else if(dateFormat.month == 11){ ///11
                            month = 'نوفمبر';
                          }else{ /// 12
                            month = 'ديسمبر';
                          }

                          return paddingg(
                            5,
                            12,
                            10,
                            SizedBox(
                              height: 90.h,
                              child: Card(
                                elevation: 20,
                                color: white,
                                shadowColor: Colors.black38,
                                child: paddingg(
                                  0,
                                  0,
                                  0,

                                  ///Row to store all info
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      paddingg(
                                          10,
                                          2,
                                          0,
                                          Row(
                                            children: [
                                              Container(

                                                ///the box of date
                                                alignment: Alignment.center,
                                                height: 80.h,
                                                width: 80.w,
                                                decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      begin: const Alignment(
                                                          0.8, 2.0),
                                                      end: const Alignment(
                                                          -0.69, -1.0),
                                                      colors: [
                                                        const Color(0xff0ab3d0)
                                                            .withOpacity(0.90),
                                                        const Color(0xffe468ca)
                                                            .withOpacity(0.90)
                                                      ],
                                                      stops: const [0.0, 1.0],
                                                    ),
                                                    borderRadius: BorderRadius
                                                        .only(
                                                      bottomLeft: Radius
                                                          .circular(10.r),
                                                      bottomRight:
                                                      Radius.circular(10.r),
                                                      topRight: Radius.circular(
                                                          10.r),
                                                      topLeft: Radius.circular(
                                                          10.r),
                                                    )),
                                                ///Text
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                     Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                           text(context, day.toString(), 16, white, fontWeight: FontWeight.bold),
                                                           SizedBox(
                                                             width: 5.w,
                                                           ),
                                                           text(context, month, 16, white, fontWeight: FontWeight.bold),
                                                        ],
                                                      ),
                                                    Padding(
                                                      padding: EdgeInsets.only(left: 10.w, right: 10.w),
                                                      child: text(context, year.toString(), 16, white, fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              ///SizedBox
                                              SizedBox(
                                                width: 20.w,
                                              ),

                                              ///type of order and date
                                              Center(
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 10.h,
                                                    ),
                                                    text(
                                                        context,
                                                        snapshot.data!.data!.orders![index].adType!.name!,
                                                        18,
                                                        black.withOpacity(0.9)),
                                                    text(
                                                        context,
                                                        snapshot.data!.data!.orders![index].adTiming!.name!,
                                                        14,
                                                        grey!.withOpacity(0.9)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
                                      Padding(
                                        padding: EdgeInsets.only(left: 7.w),
                                        child: Row(children: [
                                          InkWell(
                                            child: Icon(
                                              infoIcon,
                                              size: 23,
                                              color: black,
                                            ),
                                            onTap: () {
                                              ///When chick the pop card will show with all details
                                              showDialogFunc(
                                                  context,
                                                  snapshot.data!.data!.orders![index].user!.name!,
                                                  snapshot.data!.data!.orders![index].id!,
                                                  snapshot.data!.data!.orders![index].date!,
                                                  snapshot.data!.data!.orders![index].adType!.name!
                                              );
                                            },
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),

                                          InkWell(
                                            child: GradientIcon(
                                              share,
                                              25.w,
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
                                            onTap: () async {
                                              ///Click on it then you can share the details
                                              ///PDF File have all info of requests
                                              //Share.shareFiles(_createPDF());

                                              final pdf = await PdfClass.createPDF(
                                                  snapshot.data!.data!.orders![index].user!.name!,
                                                  snapshot.data!.data!.orders![index].id!.toString(),
                                                  snapshot.data!.data!.orders![index].date!.toString(),
                                                  snapshot.data!.data!.orders![index].adType!.name!);
                                              PdfClass.openFile(pdf);
                                            },
                                          ),
                                        ]),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ) : Center(
                          child: Center(
                              child: text(
                                context,
                                "لا توجد مواعيد لعرضها حاليا",
                                15,
                                black,
                              )));
                    } else {
                      return const Center(child: Text('No info to show!!'));
                    }
                  } else {
                    return Center(
                        child: Text('State: ${snapshot.connectionState}'));
                  }
                }
              )
            ),
          ]),
        ),
      ]),
    );
  }


  ///GET
  Future<CalenderModel> fetchCalender(String token) async {
    final response = await http.get(
        Uri.parse('https://mobile.celebrityads.net/api/celebrity/schedule'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // print(response.body);
      return CalenderModel.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load activity');
    }
  }
}

///This is a block of Model Dialog
showDialogFunc(context, personalName, invoices, date2, typeOfOrder) {
  return showDialog(
    context: context,
    builder: (context) {
      return Center(
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: white,
            ),
            padding: EdgeInsets.only(top: 15.h, right: 20.w, left: 20.w),
            height: 230.h,
            width: 300.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ///Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ///text
                    text(context, 'تفاصيل الموعد', 14, grey!),
                  ],
                ),
                SizedBox(
                  height: 15.h,
                ),

                ///Details
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textDirection: TextDirection.rtl,

                  ///icons
                  children: [
                    GradientIcon(
                        nameIcon,
                        25.w,
                        const LinearGradient(
                          begin: Alignment(0.7, 2.0),
                          end: Alignment(-0.69, -1.0),
                          colors: [Color(0xff0ab3d0), Color(0xffe468ca)],
                          stops: [0.0, 1.0],
                        )),

                    ///sizedBox
                    SizedBox(
                      width: 5.w,
                    ),

                    ///text
                    text(context, personalName, 17.sp, black,
                        family: 'DINNextLTArabic'),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textDirection: TextDirection.rtl,

                  ///icons
                  children: [
                    GradientIcon(
                        invoiceIcon,
                        25.w,
                        const LinearGradient(
                          begin: Alignment(0.7, 2.0),
                          end: Alignment(-0.69, -1.0),
                          colors: [Color(0xff0ab3d0), Color(0xffe468ca)],
                          stops: [0.0, 1.0],
                        )),

                    ///sizedBox
                    SizedBox(
                      width: 5.w,
                    ),

                    ///text
                    text(context, invoices.toString(), 17.sp, black,
                        family: 'DINNextLTArabic'),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textDirection: TextDirection.rtl,

                  ///icons
                  children: [
                    GradientIcon(
                        dateRange,
                        25.w,
                        const LinearGradient(
                          begin: Alignment(0.7, 2.0),
                          end: Alignment(-0.69, -1.0),
                          colors: [Color(0xff0ab3d0), Color(0xffe468ca)],
                          stops: [0.0, 1.0],
                        )),

                    ///sizedBox
                    SizedBox(
                      width: 5.w,
                    ),

                    ///text
                    text(context, date2, 17.sp, black,
                        family: 'DINNextLTArabic'),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textDirection: TextDirection.rtl,

                  ///icons
                  children: [
                    GradientIcon(
                        orders,
                        25.w,
                        const LinearGradient(
                          begin: Alignment(0.7, 2.0),
                          end: Alignment(-0.69, -1.0),
                          colors: [Color(0xff0ab3d0), Color(0xffe468ca)],
                          stops: [0.0, 1.0],
                        )),

                    ///sizedBox
                    SizedBox(
                      width: 5.w,
                    ),

                    ///text
                    text(context, typeOfOrder, 17.sp, black,
                        family: 'DINNextLTArabic'),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}


