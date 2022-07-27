///import section
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:celepraty/Celebrity/celebrityHomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:http/http.dart' as http;
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Account/LoggingSingUpAPI.dart';

import '../../celebrity/DiscountCodes/discount_codes_main.dart';
import '../setting/celebratyProfile.dart';
import 'ModelDiscountCode.dart';

///CreateNewDiscountCodeHome
class CreateNewDiscountCodeHome extends StatefulWidget {
  final int? putId;
  bool get isUpdate => putId != null;

  const CreateNewDiscountCodeHome({Key? key, this.putId}) : super(key: key);

  @override
  _CreateNewDiscountCodeHomeState createState() =>
      _CreateNewDiscountCodeHomeState();
}

class _CreateNewDiscountCodeHomeState extends State<CreateNewDiscountCodeHome>
    with AutomaticKeepAliveClientMixin {
  Future<DiscountModel>? discount;

  List<int> saveList = [];
  bool isValue1 = false;

  bool isCheck = false;

  final _formKey = GlobalKey<FormState>();

  ///Text Field
  TextEditingController discountCode = TextEditingController();
  TextEditingController discountValue = TextEditingController();
  TextEditingController numberOfUsers = TextEditingController();
  TextEditingController description = TextEditingController();

  DateTime currentStart = DateTime.now();
  DateTime currentEnd = DateTime.now();

  ///discount go to list

  var list = {
    1: false,
    2: false,
    3: false,
  };

  var listName = {
    1: 'اعلان',
    2: 'اهداء',
    3: 'مساحة اعلانية',
  };

  ///_value
  int? _value = 1;

  int? helper = 0;
  int? helper1 = 0;
  int? helper2 = 0;
  int? helper3 = 0;

  String? userToken;

  bool isConnectSection = true;
  bool timeoutException = true;
  bool serverExceptions = true;

  bool activeConnection = true;
  String T = "";

  @override
  void initState() {
    DatabaseHelper.getToken().then((value) {
      setState(() {
        userToken = value;
        discount = fetchDiscountCode(userToken!);
      });
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: drowAppBar(
              widget.isUpdate ? 'تعديل كود الخصم' : 'إنشاء كود خصم جديد',
              context),
          body: activeConnection
              ? SafeArea(
                  child: FutureBuilder<DiscountModel>(
                      future: discount,
                      builder: (BuildContext context,
                          AsyncSnapshot<DiscountModel> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: mainLoad(context));
                        } else if (snapshot.connectionState ==
                                ConnectionState.active ||
                            snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            if (snapshot.error.toString() ==
                                'SocketException') {
                              return Center(
                                  child: SizedBox(
                                      height: 500.h,
                                      width: 250.w,
                                      child: internetConnection(context,
                                          reload: () {
                                        setState(() {
                                          discount =
                                              fetchDiscountCode(userToken!);
                                          isConnectSection = true;
                                        });
                                      })));
                            } else {
                              return const Center(
                                  child: Text(
                                      'حدث خطا ما اثناء استرجاع البيانات'));
                            }

                            ///if has data
                          } else if (snapshot.hasData) {
                            widget.putId != null
                                ?

                                /// Update Case - if we have id fill the text fields otherwise null
                                {
                                    ///Fill the text fields with info
                                    if (helper3 == 0)
                                      {
                                        discountCode.text = snapshot.data!.data!
                                            .promoCode![widget.putId!].code!,
                                        discountValue.text = snapshot
                                            .data!
                                            .data!
                                            .promoCode![widget.putId!]
                                            .discount!
                                            .toString(),
                                        numberOfUsers.text = snapshot
                                            .data!
                                            .data!
                                            .promoCode![widget.putId!]
                                            .numOfPerson!
                                            .toString(),
                                        description.text = snapshot
                                            .data!
                                            .data!
                                            .promoCode![widget.putId!]
                                            .description!,
                                        helper3 = 1,
                                      },

                                    ///Discount type
                                    if (helper == 0)
                                      {
                                        snapshot
                                                    .data!
                                                    .data!
                                                    .promoCode![widget.putId!]
                                                    .discountType! ==
                                                "مبلغ ثابت"
                                            ? _value = 1
                                            : _value = 2,
                                        helper = 1,
                                      },

                                    ///Put a check sign on AD type
                                    if (helper1 == 0)
                                      {
                                        for (int i = 0;
                                            i <
                                                snapshot
                                                    .data!
                                                    .data!
                                                    .promoCode![widget.putId!]
                                                    .adTypes!
                                                    .length;
                                            i++)
                                          {
                                            list.containsKey(snapshot
                                                    .data!
                                                    .data!
                                                    .promoCode![widget.putId!]
                                                    .adTypes![i]
                                                    .id)
                                                ? list[snapshot
                                                    .data!
                                                    .data!
                                                    .promoCode![widget.putId!]
                                                    .adTypes![i]
                                                    .id!] = true
                                                : false,
                                            helper1 = 1,
                                          },
                                        for (int j = 0; j < list.length; j++)
                                          {
                                            list[j] == true
                                                ? saveList.add(j)
                                                : null
                                          },
                                      },

                                    ///Fetch the date from database and store in right variables
                                    if (helper2 == 0)
                                      {
                                        currentStart = DateTime.parse(snapshot
                                            .data!
                                            .data!
                                            .promoCode![widget.putId!]
                                            .dateFrom!),
                                        currentEnd = DateTime.parse(snapshot
                                            .data!
                                            .data!
                                            .promoCode![widget.putId!]
                                            .dateTo!),
                                        helper2 = 1,
                                      }
                                  }
                                : const SizedBox();

                            return Column(
                              children: [
                                Expanded(
                                  child: Stack(
                                    children: [
                                      SingleChildScrollView(
                                        child: Form(
                                          key: _formKey,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              ///Title
                                              Container(
                                                alignment: Alignment.topRight,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 20.h, right: 20.w),
                                                  child: text(
                                                      context,
                                                      widget.isUpdate
                                                          ? 'تعديل معلومات كود الخصم'
                                                          : 'إنشاء كود خصم جديد',
                                                      20,
                                                      ligthtBlack),
                                                ),
                                              ),

                                              ///subTitle
                                              Container(
                                                alignment: Alignment.topRight,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 10.h, right: 20.w),
                                                  child: text(
                                                      context,
                                                      widget.isUpdate
                                                          ? 'يمكنك الان تعديل كود الخصم الخاص بك يمكنك الان تعديل كود الخصم\n الخاص بك'
                                                          : 'يمكنك الان انشاء كود خصم جديد خاص بك يمكنك الان انشاء كود خصم\n جديد خاص بك',
                                                      12,
                                                      ligthtBlack),
                                                ),
                                              ),

                                              ///--------------------------Text Field Section--------------------------
                                              ///discount code
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  paddingg(
                                                    15,
                                                    15,
                                                    12,
                                                    textFieldNoIcon(
                                                        context,
                                                        'أدخل كود الخصم',
                                                        12,
                                                        false,
                                                        discountCode,
                                                        (String? value) {
                                                      /// Validation text field
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'حقل اجباري';
                                                      }
                                                      if (value
                                                          .startsWith('0')) {
                                                        return 'يجب ان لا يبدا بصفر';
                                                      }
                                                      if (value.startsWith(
                                                          RegExp(r'[0-9]'))) {
                                                        return 'يجب ان لا يبدا برقم';
                                                      }
                                                      return null;
                                                    }, false, inputFormatters: [
                                                      ///letters and numbers only
                                                      FilteringTextInputFormatter(
                                                          RegExp(
                                                              r'[a-zA-Z]|[0-9]'),
                                                          allow: true)
                                                    ]),
                                                  ),

                                                  ///Select The Type of Support
                                                  Container(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 10.h,
                                                          right: 20.w),
                                                      child: text(
                                                          context,
                                                          "اختر نوع الخصم",
                                                          18,
                                                          ligthtBlack,
                                                          family:
                                                              'DINNextLTArabic'),
                                                    ),
                                                  ),

                                                  ///Type of discount
                                                  paddingg(
                                                    0,
                                                    0,
                                                    9,

                                                    ///The Radio Buttons
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 3.h, right: 2.w),
                                                      child: Row(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Transform.scale(
                                                                scale: 0.8,
                                                                child: Radio<
                                                                        int>(
                                                                    value: 1,
                                                                    groupValue:
                                                                        _value,
                                                                    activeColor:
                                                                        purple,
                                                                    onChanged:
                                                                        (value) {
                                                                      setState(
                                                                          () {
                                                                        _value =
                                                                            value;
                                                                        isValue1 =
                                                                            false;
                                                                      });
                                                                    }),
                                                              ),
                                                              text(
                                                                  context,
                                                                  "مبلغ ثابت",
                                                                  14,
                                                                  ligthtBlack,
                                                                  family:
                                                                      'DINNextLTArabic'),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Transform.scale(
                                                                scale: 0.8,
                                                                child: Radio<
                                                                        int>(
                                                                    value: 2,
                                                                    groupValue:
                                                                        _value,
                                                                    activeColor:
                                                                        purple,
                                                                    onChanged:
                                                                        (value) {
                                                                      setState(
                                                                          () {
                                                                        _value =
                                                                            value;
                                                                        isValue1 =
                                                                            true;
                                                                      });
                                                                    }),
                                                              ),
                                                              text(
                                                                  context,
                                                                  "نسبة مئوية",
                                                                  14,
                                                                  ligthtBlack,
                                                                  family:
                                                                      'DINNextLTArabic'),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),

                                                  ///-----------------------------------------------------
                                                  ///Value of discount
                                                  paddingg(
                                                    15,
                                                    15,
                                                    12,

                                                    ///-------in case with مبلغ ثابت the text will be ادخل مبلغ الخصم-------///
                                                    textFieldNoIcon(
                                                      context,
                                                      isValue1
                                                          ? 'أدخل النسبة المئوية'
                                                          : 'أدخل مبلغ الخصم',
                                                      12,
                                                      false,
                                                      discountValue,
                                                      (String? value) {
                                                        /// Validation text field
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'حقل اجباري';
                                                        }
                                                        if (value
                                                            .startsWith('0')) {
                                                          return 'يجب ان لا يبدا بصفر';
                                                        }
                                                        return null;
                                                      },
                                                      false,
                                                      keyboardType:
                                                          TextInputType.phone,
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .digitsOnly
                                                      ],
                                                    ),
                                                  ),

                                                  ///number of users
                                                  paddingg(
                                                    15,
                                                    15,
                                                    12,
                                                    textFieldNoIcon(
                                                      context,
                                                      'أدخل عدد الاشخاص المستفيدين',
                                                      12,
                                                      false,
                                                      numberOfUsers,
                                                      (String? value) {
                                                        /// Validation text field
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'حقل اجباري';
                                                        }
                                                        if (value
                                                            .startsWith('0')) {
                                                          return 'يجب ان لا يبدا بصفر';
                                                        }
                                                        return null;
                                                      },
                                                      false,
                                                      keyboardType:
                                                          TextInputType.phone,
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .digitsOnly
                                                      ],
                                                    ),
                                                  ),

                                                  ///description
                                                  paddingg(
                                                    15,
                                                    15,
                                                    12,
                                                    textFieldDesc(
                                                      context,
                                                      'الوصف الخاص بكود الخصم',
                                                      12,
                                                      false,
                                                      description,
                                                      (String? value) {
                                                        if (value!
                                                            .startsWith('0')) {
                                                          return 'يجب ان لا يبدا بصفر';
                                                        }
                                                        if (value.isEmpty) {
                                                          return 'حقل اجباري';
                                                        } else {
                                                          return value.length >
                                                                  100
                                                              ? 'يجب ان لا يزيد الوصف عن 100 حرف'
                                                              : null;
                                                        }
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
                                                      maxLenth: 100,
                                                      keyboardType:
                                                          TextInputType
                                                              .multiline,
                                                    ),
                                                  ),

                                                  ///Check box
                                                  SizedBox(
                                                    height: 15.h,
                                                  ),

                                                  padding(
                                                      20,
                                                      20,
                                                      Row(
                                                        children: [
                                                          text(
                                                              context,
                                                              'الخصم الى',
                                                              18,
                                                              ligthtBlack,
                                                              family:
                                                                  'DINNextLTArabic',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          SizedBox(
                                                            width: 10.w,
                                                          ),
                                                          text(context, '*', 18,
                                                              red!),
                                                        ],
                                                      )),

                                                  SizedBox(
                                                    height: 15.h,
                                                  ),
                                                  SizedBox(
                                                    height: 180.h,
                                                    child: ListView(
                                                      children: list.keys
                                                          .map((int key) {
                                                        return CheckboxListTile(
                                                          title: Text(
                                                              listName[key]!),
                                                          value: list[key],
                                                          selected: list[key]!,
                                                          activeColor: Colors
                                                              .deepPurple[400],
                                                          checkColor:
                                                              Colors.white,
                                                          onChanged:
                                                              (bool? valueF) {
                                                            setState(() {
                                                              list[key] =
                                                                  valueF!;
                                                              if (!saveList
                                                                      .contains(
                                                                          key) &&
                                                                  list[key] ==
                                                                      true) {
                                                                saveList
                                                                    .add(key);
                                                              }
                                                              if (list[key] ==
                                                                      false &&
                                                                  saveList
                                                                      .contains(
                                                                          key)) {
                                                                saveList.remove(
                                                                    key);
                                                              }
                                                            });
                                                          },
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),

                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 20.w),
                                                    child: text(
                                                        context,
                                                        isCheck
                                                            ? '* قم بإختيار واحدة على الاقل'
                                                            : '',
                                                        10,
                                                        red!),
                                                  ),

                                                  ///Determine the Start and end date
                                                  Container(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 5.h,
                                                          right: 20.w),
                                                      child: Row(
                                                        children: [
                                                          text(
                                                              context,
                                                              'تحديد عدد الايام المتاح بها الكود',
                                                              18,
                                                              ligthtBlack),
                                                          SizedBox(
                                                            width: 10.w,
                                                          ),
                                                          text(context, '*', 18,
                                                              Colors.red)
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        alignment:
                                                            Alignment.topRight,
                                                        margin: EdgeInsets.only(
                                                            right: 20.w,
                                                            top: 10.h),
                                                        child: InkWell(
                                                          child:
                                                              gradientContainerNoborder2(
                                                            120,
                                                            40,
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                  scheduale,
                                                                  color: white,
                                                                ),
                                                                SizedBox(
                                                                  width: 5.w,
                                                                ),
                                                                text(
                                                                    context,
                                                                    'تاريخ البداية',
                                                                    15.sp,
                                                                    white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ],
                                                            ),
                                                          ),
                                                          onTap: () async {
                                                            DateTime?
                                                                startDate =
                                                                await showDatePicker(
                                                                    context:
                                                                        context,
                                                                    initialDate:
                                                                        currentStart,
                                                                    firstDate:
                                                                        DateTime(
                                                                            2000),
                                                                    lastDate:
                                                                        DateTime(
                                                                            2100));
                                                            if (startDate ==
                                                                null) {
                                                              return;
                                                            }
                                                            setState(() {
                                                              currentStart =
                                                                  startDate;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  //end date
                                                  Container(
                                                    alignment:
                                                        Alignment.topRight,
                                                    margin: EdgeInsets.only(
                                                        right: 20.w, top: 10.h),
                                                    child: InkWell(
                                                      child:
                                                          gradientContainerNoborder2(
                                                        120,
                                                        40,
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              scheduale,
                                                              color: white,
                                                            ),
                                                            SizedBox(
                                                              width: 5.w,
                                                            ),
                                                            text(
                                                                context,
                                                                'تاريخ النهاية',
                                                                15.sp,
                                                                white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ],
                                                        ),
                                                      ),
                                                      onTap: () async {
                                                        DateTime? endDate =
                                                            await showDatePicker(
                                                                context:
                                                                    context,
                                                                initialDate:
                                                                    currentEnd,
                                                                firstDate:
                                                                    DateTime(
                                                                        2000),
                                                                lastDate:
                                                                    DateTime(
                                                                        2100));
                                                        if (endDate == null)
                                                          return;
                                                        setState(() {
                                                          currentEnd = endDate;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: 20.w, top: 10.h),
                                                child: SizedBox(
                                                  height: 30.h,
                                                  child: text(
                                                      context,
                                                      '* ملاحظة: عند عدم اختيار التاريخ يتم تحديد تاريخ اليوم بشكل تلقائي',
                                                      10,
                                                      Colors.grey),
                                                ),
                                              ),

                                              ///Save box
                                              SizedBox(
                                                height: 30.h,
                                              ),

                                              padding(
                                                15,
                                                15,
                                                gradientContainerNoborder(
                                                    getSize(context).width,
                                                    buttoms(
                                                        context,
                                                        widget.isUpdate
                                                            ? 'حفظ التغيرات'
                                                            : 'حفظ',
                                                        20,
                                                        white, () {
                                                      ///Make sure all forms is selected
                                                      ///Discount go to and
                                                      _formKey.currentState!
                                                              .validate()
                                                          ? {
                                                              if (saveList
                                                                  .isNotEmpty)
                                                                {
                                                                  widget.putId !=
                                                                          null
                                                                      ? updateDiscountCode(userToken!, snapshot.data!.data!.promoCode![widget.putId!].id!)
                                                                          .then((value) {
                                                                          print('save change');
                                                                          if(value == 'true'){
                                                                            gotoPageAndRemovePrevious(context,  const DiscountCodes());
                                                                            showMassage(context, 'تم', 'تم حفظ التغيرات بنجاح', done: done);
                                                                          }

                                                                          else if (value == 'SocketException') {
                                                                            showMassage(context, 'مشكلة في الانترنت', 'لايوجد اتصال بالانترنت في الوقت الحالي');
                                                                          } else if (value == 'serverExceptions') {
                                                                            showMassage(context, 'مشكلة في الخادم', '');
                                                                          } else {
                                                                            ///TimeOut
                                                                          }
                                                                        })
                                                                      : createNewDiscountCode(userToken!).then((value) {
                                                                    if(value == 'true'){
                                                                      print('save');
                                                                      gotoPageAndRemovePrevious(context, const DiscountCodes());
                                                                      showMassage(context, 'تم', 'تم الحفظ بنجاح', done: done);
                                                                    }
                                                                    else if (value == 'SocketException') {
                                                                      showMassage(context, 'مشكلة في الانترنت', 'لايوجد اتصال بالانترنت في الوقت الحالي');
                                                                    } else if (value == 'serverExceptions') {
                                                                      showMassage(context, 'مشكلة في الخادم', '');
                                                                    } else {
                                                                      ///TimeOut
                                                                    }
                                                                  }),
                                                                }
                                                              else
                                                                {
                                                                  ///these text fields and is required
                                                                  setState(() {
                                                                    isCheck =
                                                                        true;
                                                                  }),
                                                                  print(
                                                                      'fill the required input')
                                                                }
                                                            }
                                                          : null;
                                                    })),
                                              ),
                                              SizedBox(
                                                height: 50.h,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );

                            ///if no data to show
                          } else {
                            return const Center(
                                child: Text('No info to show!!'));
                          }
                        } else {
                          return Center(
                              child:
                                  Text('State: ${snapshot.connectionState}'));
                        }
                      }),
                )
              : Center(
                  child: SizedBox(
                      height: 300.h,
                      width: 250.w,
                      child: internetConnection(context, reload: () {
                        checkUserConnection();
                        discount = fetchDiscountCode(userToken!);
                      }))),
        ));
  }

  Future checkUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          activeConnection = true;
          T = "Turn off the data and repress again";
        });
      }
    } on SocketException catch (_) {
      setState(() {
        activeConnection = false;
        T = "Turn On the data and repress again";
      });
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  ///POST
  Future<String> createNewDiscountCode(String token) async {
    try {
      final response = await http.post(
        Uri.parse(
          'https://mobile.celebrityads.net/api/celebrity/promo-codes/add',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{
          'code': discountCode.text,
          'discount_type': isValue1 == false ? 'مبلغ ثابت' : 'نسبة مئوية',
          'discount': discountValue.text,
          'num_of_person': numberOfUsers.text,
          'description': description.text,
          'ad_type_ids': saveList,
          'date_from': currentStart.toString(),
          'date_to': currentEnd.toString()
        }),
      );
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.

        // print(response.body);
        return 'true';
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        return 'serverExceptions';
      }
    } catch (error) {
      if (error is SocketException) {
        return 'SocketException';
      } else if (error is TimeoutException) {
        return 'TimeoutException';
      } else {
        return 'serverExceptions';
      }
    }
  }

  ///GET
  Future<DiscountModel> fetchDiscountCode(String token) async {
    try {
      final response = await http.get(
          Uri.parse(
              'https://mobile.celebrityads.net/api/celebrity/promo-codes'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          });
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        // print(response.body);
        return DiscountModel.fromJson(jsonDecode(response.body));
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load activity');
      }
    } catch (error) {
      if (error is SocketException) {
        setState(() {
          isConnectSection = false;
        });
        return Future.error('SocketException');
      } else if (error is TimeoutException) {
        setState(() {
          timeoutException = false;
        });
        return Future.error('TimeoutException');
      } else {
        setState(() {
          serverExceptions = false;
        });
        return Future.error('serverExceptions');
      }
    }
  }

  ///UPDATE
  Future<String> updateDiscountCode(String token, int id) async {
    try {
      final response = await http.post(
        Uri.parse(
          'https://mobile.celebrityads.net/api/celebrity/promo-codes/update/$id',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{
          'code': discountCode.text,
          'discount_type': _value == 1 ? 'مبلغ ثابت' : 'نسبة مئوية',
          'discount': discountValue.text,
          'num_of_person': numberOfUsers.text,
          'description': description.text,
          'ad_type_ids': saveList,
          'date_from': currentStart.toString(),
          'date_to': currentEnd.toString()
        }),
      );
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.

        print(response.body);
        setState(() {
          discount = fetchDiscountCode(userToken!);
        });
        return 'true';
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load activity');
      }
    } catch (error) {
      if (error is SocketException) {
        return 'SocketException';
      } else if (error is TimeoutException) {
        return 'TimeoutException';
      } else {
        return 'serverExceptions';
      }
    }
  }
}
