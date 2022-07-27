///import section
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:celepraty/Users/Setting/user_recharge_balance.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Celebrity/Balance/radioListTile.dart';

class UserBalance extends StatelessWidget {
  const UserBalance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: drowAppBar('الرصيد', context),
          body: const UserBalanceHome(),
        ));
  }
}

///Balance home page
class UserBalanceHome extends StatefulWidget {
  const UserBalanceHome({Key? key}) : super(key: key);

  @override
  _UserBalanceHomeState createState() => _UserBalanceHomeState();
}

class _UserBalanceHomeState extends State<UserBalanceHome> {
  ///Text Field
  final TextEditingController userCardHolderName = TextEditingController();
  final TextEditingController userIbanNumber = TextEditingController();

  ///formKey
  final _formKey = GlobalKey<FormState>();

  ///
  bool isVesible = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 40.h, right: 20.w, left: 20.w),
            child: gradientContainerNoborder(
              390,
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ///The Total Title
                  Padding(
                    padding: EdgeInsets.only(top: 10.h, right: 20.w),
                    child: Row(
                      children: [
                        text(context, 'الإجمالي', 14, white),
                      ],
                    ),
                  ),

                  ///The Total Balance
                  Padding(
                    padding: EdgeInsets.only(right: 20.w),
                    child: Row(
                      children: [
                        text(context, '1025', 24, white,
                            fontWeight: FontWeight.bold),
                        SizedBox(
                          width: 5.w,
                        ),
                        text(context, 'ر.س', 14, white,
                            fontWeight: FontWeight.w200),
                      ],
                    ),
                  ),

                  ///SizedBox
                  SizedBox(
                    height: 30.h,
                  ),

                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 20.w),

                        ///The Available Balance
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                text(context, 'الرصيد المتاح', 14, white)
                              ],
                            ),
                            Row(
                              children: [
                                text(context, '725', 14, white,
                                    fontWeight: FontWeight.bold),
                                SizedBox(
                                  width: 5.w,
                                ),
                                text(context, 'ر.س', 10, white,
                                    fontWeight: FontWeight.w200),
                              ],
                            ),
                          ],
                        ),
                      ),

                      ///SizedBox
                      SizedBox(
                        width: 140.w,
                      ),

                      ///Suspend Balance
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              text(context, 'الرصيد المعلق', 14, white)
                            ],
                          ),
                          Row(
                            children: [
                              text(context, '300', 14, white,
                                  fontWeight: FontWeight.bold),
                              SizedBox(
                                width: 5.w,
                              ),
                              text(context, 'ر.س', 10, white,
                                  fontWeight: FontWeight.w200),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  ///SizedBox
                  SizedBox(
                    height: 10.h,
                  ),
                ],
              ),
            ),
          ),

          ///SizedBox
          SizedBox(
            height: 50.h,
          ),

          ///Withdrawable Balance
          Center(
            child: Padding(
              padding: EdgeInsets.only(
                  top: 20.h, right: 20.w, left: 20.w, bottom: 15.h),
              child: text(context, "رصيد السحب", 16, ligthtBlack),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 34.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 150.w,
                      height: 64.5.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          color: blue),
                      child: text(context, '725', 24, white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                ///SizedBox
                SizedBox(
                  width: 10.w,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 40.h,
                    ),
                    text(context, 'ر.س', 14, black),
                  ],
                ),
              ],
            ),
          ),

          ///SizedBox
          SizedBox(
            height: 100.h,
          ),
          Column(
            children: [
              ///Withdrew Balance button
              padding(
                22,
                22,
                gradientContainerNoborder(
                    getSize(context).width,
                    buttoms(context, 'سحب الرصيد', 16, white, () {
                      ///Bottom sheet
                      showBottomSheetWhite(context,
                          bottomSheetMenuPayments('1', 'rayana', '500'));
                    })),
              ),
              SizedBox(
                height: 10.h,
              ),
              padding(
                  22,
                  22,

                  ///Recharge The Balance Button
                  gradientContainer(
                    getSize(context).width,
                    buttoms(
                      context,
                      'شحن الحساب',
                      14,
                      black,
                      () {
                        ///determine the amount of money
                        goTopagepush(context, UserRechargeBalance());
                      },
                    ),
                    gradient: true,
                    color: grey!,
                    height: 40,
                  ))
            ],
          ),
        ],
      ),
    );
  }

  ///Bottom Sheet for Payments
  Widget bottomSheetMenuPayments(String id, String name, String balance) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 30.h,
              ),
              Padding(
                padding: EdgeInsets.only(right: 18.w, left: 20.w),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        text(
                          context,
                          'أختر طريقة الدفع',
                          16,
                          black,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),

                    ///--------------------------
                    Visibility(
                        visible: true,
                        ///true
                        child: Column(
                          children:  [
                            SizedBox(
                              height: 10.h,
                            ),
                            const Divider(
                              thickness: 1,
                            ),
                            SingleChildScrollView(child: RadioWidgetDemo()),
                          ],
                        )),
                    SizedBox(
                      height: 10.h,
                    ),
                    const Divider(
                      thickness: 1,
                    ),

                    InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            add,
                            size: 23,
                            color: black,
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          text(
                            context,
                            'إضافة بطاقة جديدة',
                            18,
                            black,
                          ),
                          SizedBox(
                            width: 170.w,
                          ),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Icon(
                              backIcon,
                              size: 20,
                              color: black,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        ///Go To New Bottom Sheet To Add New Credit Card
                        ///Bottom sheet
                        showBottomSheetWhite2(context,
                            bottomSheetCreditCard('1', 'rayana', '500'));
                      },
                    ),
                    const Divider(
                      thickness: 1,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        text(context, 'الإجمالي المستحق', 16, black,
                            fontWeight: FontWeight.bold),
                        text(context, '140' + ' ريال', 16, black,
                            fontWeight: FontWeight.bold),
                      ],
                    ),
                    SizedBox(
                      height: 40.h,
                    ),

                    ///bottom to withdraw balance
                    padding(
                      22,
                      22,
                      gradientContainerNoborder(
                          150.w,
                          buttoms(context, 'إسحب الرصيد', 15, white, () {
                            isVesible == false
                            //'خطأ'
                            //'قم بإختيار بطاقة او ادخال بطاقة جديدة'
                                ? showMassage(context, 'خطأ', 'قم بإختيار بطاقة او ادخال بطاقة جديدة')
                                : showMassage(context, 'تم إرسال طلبك بنجاح', 'سوف نقوم بالتواصل معك في مدة لاتزيد عن ٣ ايام', done: done);

                          })),
                    ),
                    SizedBox(
                      height: 20.h,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomSheetCreditCard(String id, String name, String balance) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 30.h,
              ),
              Padding(
                  padding: EdgeInsets.only(right: 20.w, left: 20.w),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          text(
                            context,
                            'إضافة بطاقة جديدة',
                            18,
                            black,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(right: 10.w, left: 10.w, top: 25.h),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              textFieldIban(
                                  context,
                                  'اسم صاحب البطاقة',
                                  'اسم صاحب البطاقة الكامل',
                                  12,
                                  false,
                                  userCardHolderName, (String? value) {
                                /// Validation text field
                                if (value == null || value.isEmpty) {
                                  return 'حقل اجباري';
                                }
                                if (value.startsWith('0')) {
                                  return 'يجب ان لا يبدا بصفر';
                                }
                                if (value.startsWith(RegExp(r'[0-9]'))) {
                                  return 'يجب ان لا يبدا برقم';
                                }
                                if (value.startsWith(RegExp(r'[a-z]'))) {
                                  return 'يجب ان يبدا بأحرف كبيرة';
                                }
                                return null;
                              }, false, inputFormatters: [
                                ///letters only
                                FilteringTextInputFormatter(
                                    RegExp(r'[a-zA-Z]|[\s]'),
                                    allow: true)
                              ]),
                              SizedBox(
                                height: 15.h,
                              ),

                              ///Iban number
                              textFieldIban(
                                context,
                                'SA00 0000 0000 0000 0000 0000',
                                'رقم الايبان',
                                12,
                                false,
                                userIbanNumber,
                                (String? value) {
                                  /// Validation text field
                                  if (value == null || value.isEmpty) {
                                    return 'حقل اجباري';
                                  }
                                  if (value.startsWith(RegExp(r'[0-9]'))) {
                                    return 'يجب ان يبدا ب SA';
                                  }
                                  if (value.length > 24) {
                                    return 'رقم الايبان يجب ان يكون مكون من ٢٤ أحرف';
                                  }
                                  return null;
                                },
                                false,
                                inputFormatters: [
                                  ///letters only
                                  FilteringTextInputFormatter(
                                      RegExp(r'[A-Z]|[0-9]'),
                                      allow: true)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      const Divider(
                        thickness: 1,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(context, 'الإجمالي المستحق', 16, black,
                              fontWeight: FontWeight.bold),
                          text(context, '140' + ' ريال', 16, black,
                              fontWeight: FontWeight.bold),
                        ],
                      ),
                      SizedBox(
                        height: 40.h,
                      ),

                      ///bottom to withdraw balance
                      padding(
                        22,
                        22,
                        gradientContainerNoborder(
                            150.w,
                            buttoms(context, 'إضافة بطاقة جديدة', 15, white, () {
                              _formKey.currentState!.validate()
                                  ? {
                                showMassage(context, 'تم إضافة بطاقة جديدة بنجاح', 'سوف نقوم بالتواصل معك في مدة لاتزيد عن ٣ ايام', done: done)
                                    }
                                  : null;
                            })),
                      ),
                    ],
                  ))
            ],
          ),
        ));
  }
}
