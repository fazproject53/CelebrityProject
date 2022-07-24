
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:celepraty/Models/Methods/classes/GradientIcon.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:celepraty/Users/invoice/invoice_info.dart';
import 'package:celepraty/invoice/ivoice_info_list.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../../Account/LoggingSingUpAPI.dart';
import '../../invoice/Invoice.dart';
import '../../invoice/InvoicePdf.dart';
//import 'package:pdf/widgets.dart' as pw;


class Invoice extends StatefulWidget{
  _InvoiceState createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {

  final _baseUrl = 'https://mobile.celebrityads.net/api/user/billings';
  int _page = 1;

  bool ActiveConnection = false;
  String T = "";

  // There is next page or not
  bool _hasNextPage = true;

  // Used to display loading indicators when _firstLoad function is running
  bool _isFirstLoadRunning = false;

  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunning = false;

  String? phone, taxnumber;
  // This holds the posts fetched from the server
  List _posts = [];
  ScrollController _controller = ScrollController();

  bool isConnectSection = true;
  bool timeoutException = true;
  bool serverExceptions = true;

  String? desc;
  Future<InvoiceModel>? invoices;
  List<String> imagePaths = [];
  final imagePicker = ImagePicker();
  final file = File('example.pdf');

  //  final pdf = pw.Document();
  DateTime date = DateTime.now();
  String userToken = "";

  @override
  void initState() {
    DatabaseHelper.getToken().then((value) {
      setState(() {
        userToken = value;
      getInvoicess();
      });
    });
    _controller.addListener(_loadMore);
    super.initState();
  }
  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    super.dispose();
  }

  void _loadMore() async {
    print('#########################################################');

    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false && _controller.position.maxScrollExtent ==
        _controller.offset) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _page += 1;
      try {
        final res =
        await http.get(Uri.parse("$_baseUrl?page=$_page"), headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $userToken'
        });

        if (InvoiceModel
            .fromJson(jsonDecode(res.body))
            .data!
            .billings!
            .isNotEmpty) {
          setState(() {
            _posts.addAll(InvoiceModel
                .fromJson(jsonDecode(res.body))
                .data!
                .billings!);
          });
        } else {
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!');
        }
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: drowAppBar('الفوترة', context),
          body: SafeArea(
            child: SingleChildScrollView(
              controller: _controller,
              child: _isFirstLoadRunning? Center(
                  child: mainLoad(context)):Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 30.h,),
                  Padding(
                    padding: EdgeInsets.only(right: 20.0.w),
                    child: text(context, 'الطلبات المالية ', 20, black),
                  ),
                  SizedBox(height: 20.h,),

                  _posts.isEmpty
                                ? Padding(
                              padding: EdgeInsets.only(
                                  top: getSize(context).height / 7),
                              child: Center(child: Column(
                                children: [
                                  LottieBuilder.asset(
                                      'assets/lottie/invoicesempty.json',
                                      height: 200.h),
                                  text(context, 'لا يوجد فواتير لعرضهم حاليا',
                                      20, black),
                                ],
                              ),),
                            )
                                :
                            ListView.builder(
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _posts.length,
                              itemBuilder: (context, index) {
                                desc =
                                _posts[index].order!
                                    .adType!.name! == "اعلان" ? ' طلب' +
                                    _posts[index].order!
                                        .adType!.name! + ' ل' +
                                    _posts[index].order!
                                        .advertisingAdType!.name! :
                                _posts[index].order!
                                    .adType!.name! == "اهداء" ? ' طلب ' +
                                    _posts[index].order!
                                        .adType!.name! + ' / ' +
                                    _posts[index].order!
                                        .giftType!.name! + " بمناسبة  " +
                                    'عيد ميلاد' :
                                _posts[index].order!
                                    .adType!.name! == "مساحة اعلانية"
                                    ? ' طلب ' + 'مساحة اعلانية'
                                    : '';
                                return Card(
                                    elevation: 3,
                                    child: ExpansionTile(
                                        title: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.receipt_long,
                                                  color: black.withOpacity(
                                                      0.80), size: 27,),
                                                SizedBox(width: 20.w),
                                                Container(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .start,
                                                    children: [

                                                      text(context,
                                                          _posts[index]
                                                              .celebrity!.name!,
                                                          16, black),


                                                      text(context,
                                                          _posts[index]
                                                              .order!.price!
                                                              .toString() +
                                                              " ر.س", 15,
                                                          green),

                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),

                                            text(context, _posts[index].price!
                                                .toString(), 12, grey!),
                                          ],
                                        ),
                                        children: [
                                          Container(
                                              margin:
                                              EdgeInsets.only(top: 10.h),
                                              height: 70.h,
                                              decoration: BoxDecoration(
                                                color: fillWhite,
                                                border: Border(top: BorderSide(
                                                    color: lightGrey
                                                        .withOpacity(0.10))),),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 15.0.w),
                                                    child: text(
                                                        context, 'التفاصيل', 12,
                                                        grey!),
                                                  ),
                                                  Container(child: text(context,
                                                      _posts[index]
                                                          .order!.description !=
                                                          null
                                                          ?_posts[index]
                                                          .order!.description!
                                                          : '', 14, black),
                                                    width: 200.w,
                                                    margin: EdgeInsets.only(
                                                        right: 10.w),),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10.w),
                                                    child: Row(children: [
                                                      InkWell(child: Icon(
                                                        Icons.info_outlined,
                                                        size: 20,), onTap: () {
                                                        showBottomSheettInvoice(
                                                            context,
                                                            invoice(index));
                                                      },),
                                                      SizedBox(width: 15.w,),
                                                      InkWell(
                                                        child: GradientIcon(
                                                          Icons.share, 20,
                                                          const LinearGradient(
                                                            begin: Alignment(
                                                                0.7, 2.0),
                                                            end: Alignment(
                                                                -0.69, -1.0),
                                                            colors: [
                                                              Color(0xff0ab3d0),
                                                              Color(0xffe468ca)
                                                            ],
                                                            stops: [0.0, 1.0],
                                                          ),),
                                                        onTap: () async {
                                                          final pdf = await InvoicePdf
                                                              .createInvoicePDF(
                                                              _posts[index]
                                                                  .order!.id!
                                                                  .toString(),
                                                              _posts[index]
                                                                  .id
                                                                  .toString(),
                                                              _posts[index]
                                                                  .date
                                                                  .toString(),
                                                              taxnumber!,
                                                             phone!,
                                                              _posts[index]
                                                                  .celebrity!
                                                                  .phonenumber
                                                                  .toString(),
                                                              _posts[index]
                                                                  .user!
                                                                  .country!
                                                                  .name!,
                                                              _posts[index]
                                                                  .user!.name!,
                                                              _posts[index]
                                                                  .price
                                                                  .toString(),
                                                              _posts[index]
                                                                  .priceAfterTax
                                                                  .toString(),
                                                              _posts[index]
                                                                  .paymentMehtod!
                                                                  .name!,
                                                              desc!);
                                                          InvoicePdf.openFile(
                                                              pdf);
                                                        },
                                                      ),

                                                    ]),
                                                  ),
                                                ],
                                              ))
                                        ]
                                    ));
                              },),
                  if (_isLoadMoreRunning == true)
                    const Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              ),
            ),

          )
      ),
    );
  }

  Widget invoice(index) {
    return SingleChildScrollView(
         child: Column(
                    children: [
                      Column(
                        children: [
                          InkWell(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(width: 450.w,
                                  height: 60.h,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20)),
                                      color: lightGrey.withOpacity(0.30)),),
                                Container(width: 60.w, height: 5.h,
                                  decoration: BoxDecoration(color: grey,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50))),),
                              ],
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),

                          SizedBox(height: 10.h,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 20.w),
                                child: GradientText(
                                  'منصة المشاهير',
                                  style: const TextStyle(
                                      fontSize: 20.0,
                                      fontFamily: "Cairo",
                                      fontWeight: FontWeight.bold
                                  ),
                                  colors: const [
                                    Color(0xff0ab3d0), Color(0xffe468ca)
                                  ],
                                ),
                              ),
                              Image.asset('assets/image/log.png', height: 90.h,
                                width: 90.w,),
                            ],
                          ),

                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Directionality(textDirection: TextDirection.rtl,
                                    child: text(context,
                                       _posts[index]
                                            .date.toString(), 15, grey!)),
                                text(context, 'فاتورة ضريبية', 18,
                                    black.withOpacity(0.75),
                                    fontWeight: FontWeight.bold),
                              ],),
                            margin: EdgeInsets.only(
                                top: 15.h, left: 15.w, right: 15.w),
                          ),

                          padding(15, 15, Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              text(context,
                                  _posts[index].order!
                                      .id!.toString() + '#', 18,
                                  black.withOpacity(0.75),
                                  fontWeight: FontWeight.bold),
                              SizedBox(height: 15.h,),
                              text(context, 'رقم الطلب: ' +
                                  _posts[index].order!
                                      .id!.toString(), 15, black),
                              text(context, 'رقم الفاتورة:  ' +
                                  _posts[index]
                                      .billingId.toString(), 15, black),
                              Divider(color: black,)
                            ],
                          ),
                          ),
                          padding(15, 15,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  text(context, ': مصدرة من ', 18, blue,
                                      fontWeight: FontWeight.bold),
                                  SizedBox(height: 10.h,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Container(child: text(
                                          context, "منصة المشاهير", 15, black),
                                          margin: EdgeInsets.only(left: 30.w)),
                                      text(context, ': الموقع الالكتروني', 15,
                                          black.withOpacity(0.75),
                                          fontWeight: FontWeight.bold),
                                    ],),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Container(child: text(context,
                                          taxnumber!, 15, black),
                                        margin: EdgeInsets.only(left: 10.w),),
                                      text(context, ': الرقم الضريبي', 15,
                                          black.withOpacity(0.75),
                                          fontWeight: FontWeight.bold),
                                    ],),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Container(child: text(context,
                                         phone!,
                                          15, black),
                                          margin: EdgeInsets.only(left: 10.w)),
                                      text(context, ': الهاتف', 15,
                                          black.withOpacity(0.75),
                                          fontWeight: FontWeight.bold),
                                    ],),
                                  Divider(color: black,)
                                ],)
                          ),

                          padding(15, 15,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  text(context, ': مصدرة الى ', 18, pink,
                                      fontWeight: FontWeight.bold),
                                  SizedBox(height: 10.h,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Container(child: text(context,
                                          _posts[index]
                                              .user!.country!.name!, 15, black),
                                          margin: EdgeInsets.only(left: 40.w)),
                                      Container(child: text(context,
                                          _posts[index]
                                              .user!.name!, 15,
                                          black.withOpacity(0.75),
                                          fontWeight: FontWeight.bold)),

                                    ],),
                                  Container(child: text(context,
                                      _posts[index]
                                          .user!.phonenumber.toString(), 15,
                                      black),
                                    margin: EdgeInsets.only(left: 30.w),
                                    alignment: Alignment.bottomLeft,),
                                  Divider(color: black,)
                                ],)
                          ),
                          padding(15, 15,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  text(context, 'تفاصيل الدفع', 17,
                                      black.withOpacity(0.75),
                                      fontWeight: FontWeight.bold),
                                  SizedBox(height: 10.h,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Container(child: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: text(context,
                                              _posts[index].price!
                                                  .toString() + ' ر.س ', 15,
                                              blue,
                                              fontWeight: FontWeight.bold)),
                                          margin: EdgeInsets.only(left: 70.w)),
                                      text(context, ': المبلغ', 17, blue,
                                          fontWeight: FontWeight.bold),
                                    ],),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Container(child: text(context,
                                          _posts[index]
                                              .paymentMehtod!.name!, 15, black),
                                        margin: EdgeInsets.only(left: 50.w),),
                                      Container(child: text(
                                          context, ':طريقة الدفع', 15,
                                          black.withOpacity(0.75),
                                          fontWeight: FontWeight.bold)),
                                    ],),
                                  SizedBox(height: 10.h,)
                                ],)
                          ),
                          Container(
                            color: grey!.withOpacity(0.40),
                            height: 45.h,
                            margin: EdgeInsets.only(left: 8.w, right: 8.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Row(
                                  children: [
                                    SizedBox(width: 20.w,),
                                    text(context, 'المجموع', 15, black),
                                    SizedBox(width: 50.w,),
                                    text(context, 'السعر', 15, black),
                                    SizedBox(width: 20.w,),

                                  ],
                                ),
                                Row(
                                  children: [
                                    text(context, 'المنتج', 15, black),
                                    SizedBox(width: 10.w,),
                                  ],
                                ),
                              ],),
                          ),

                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: Column(
                              children: [
                                SizedBox(height: 20.h,),
                                Row(mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                  children: [

                                    Row(
                                      children: [
                                        SizedBox(width: 20.w,),
                                        Container(
                                          width: 150.w,
                                          child: text(context,
                                              _posts[index].order!
                                                  .adType!.name! == "اعلان"
                                                  ? ' طلب ' +
                                                  _posts[index].order!
                                                      .adType!.name! + ' ل' +
                                                  _posts[index].order!
                                                      .advertisingAdType!.name!
                                                  :
                                              _posts[index].order!
                                                  .adType!.name! == "اهداء"
                                                  ? ' طلب ' +
                                                  _posts[index].order!
                                                      .adType!.name! + ' / ' +
                                                  _posts[index].order!
                                                      .giftType!.name! +
                                                  " بمناسبة  " + 'عيد ميلاد'
                                                  :
                                              _posts[index].order!
                                                  .adType!.name! ==
                                                  "مساحة اعلانية" ? ' طلب ' +
                                                  'مساحة اعلانية' : '', 15,
                                              black),),
                                        // SizedBox(width: 10.w,),
                                        // Image.asset('assets/image/logo.png', height: 50.h, width: 50.w,),

                                      ],
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(width: 30.w,),
                                        text(context,  _posts[index].price!
                                            .toString() + " ر . س  ", 15,
                                            black),
                                        SizedBox(width: 40.w,),
                                        text(context,   _posts[index].price!
                                            .toString() + " ر . س  ", 15,
                                            black),
                                        SizedBox(width: 20.w,),
                                      ],
                                    ),
                                  ],),
                                SizedBox(height: 10.h,),
                                Divider(color: black, thickness: 1.5,),
                                Row(mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                  children: [

                                    Row(
                                      children: [
                                        SizedBox(width: 20.w,),
                                        text(
                                            context, 'اجمالي الطلب', 15, black),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        text(context,   _posts[index].priceAfterTax! +
                                            ' ر . س ', 15, black),
                                        SizedBox(width: 20.w,),
                                      ],
                                    ),
                                  ],),
                                SizedBox(height: 10.h,),
                                Divider(color: black,),
                                SizedBox(height: 10.h,),
                                text(context,
                                    'شكرا لتعاملكم مع منصتنا ,,, نتمنى لكم يوما رائعا',
                                    17, black.withOpacity(0.75),
                                    fontWeight: FontWeight.bold),
                                SizedBox(height: 10.h,),
                                Divider(color: black,),
                              ],
                            ),
                          ),


                        ],
                      ),
                    ],
                  ),
    );
  }


  void getInvoicess() async {
    setState(() {
      _isFirstLoadRunning = true;
    });

    final response = await http.get(
        Uri.parse('$_baseUrl?page=$_page'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $userToken'
        });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      setState(() {
        _posts = InvoiceModel
            .fromJson(jsonDecode(response.body))
            .data!.billings!;
        phone= InvoiceModel
            .fromJson(jsonDecode(response.body)).data!.phone!;
        taxnumber= InvoiceModel
            .fromJson(jsonDecode(response.body)).data!.taxnumber!;
      });
      print(response.body);

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load activity');
    }


    setState(() {
      _isFirstLoadRunning = false;
      print(_isFirstLoadRunning.toString()+'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    });
  }
}
