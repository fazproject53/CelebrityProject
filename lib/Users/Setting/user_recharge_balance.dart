import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:celepraty/SuccessfulAndFailureScreens/splash_screen.dart';
import 'package:celepraty/Users/Setting/radio_list_tile_user.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../../Models/Methods/method.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class UserRechargeBalance extends StatefulWidget {
  const UserRechargeBalance({Key? key}) : super(key: key);

  @override
  _UserRechargeBalanceState createState() => _UserRechargeBalanceState();
}

class _UserRechargeBalanceState extends State<UserRechargeBalance> {
  final TextEditingController amount = TextEditingController();


  OutlineInputBorder? border;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();



    border = OutlineInputBorder(
      borderSide: BorderSide(
        color: purple.withOpacity(0.6),
        width: 1.0,
      ),
    );
  }



  ///Credit card section
  final TextEditingController selectedCVV = TextEditingController();
  final TextEditingController creditCardController = TextEditingController();
  final TextEditingController creditCardDateController =
      TextEditingController();
  final TextEditingController creditCardCvvController = TextEditingController();

  String cardNumber = '';
  String expiryDate = '';
  String cvvCode = '';

  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  bool isVesible = true;
  bool isVesible2 = true;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: drowAppBar('إضافة رصيد', context),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  height: 140.h,
                  width: 200.w,
                  child:
                      Lottie.asset('assets/lottie/addMoreMoney.json')),
              text(context, 'ادخل المبلغ المراد إضافة للرصيد', 20,
                  black.withOpacity(0.6)),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textFieldSmallRE(
                      context,
                      '0',
                      18,
                      false,
                      amount,
                      (String? value) {
                        if (value!.startsWith('0')) {
                          return 'يجب ان لا يبدا بصفر';
                        }
                      },
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 35, right: 10.w),
                    child: text(context, 'ر.س', 14, black.withOpacity(0.8)),
                  )
                ],
              ),

              const Spacer(),

              padding(
                22,
                22,
                gradientContainerNoborder(
                    getSize(context).width,
                    buttoms(context, 'التالي', 16, white, () {
                      ///Bottom sheet
                      if (amount.text.isNotEmpty) {
                        showBottomSheetWhite(context,
                            bottomSheetRechargeMenu('1', 'rayana', '500'));
                      } else {
                            Flushbar(
                              flushbarPosition: FlushbarPosition.TOP,
                              backgroundColor: white,
                              margin: const EdgeInsets.all(5),
                              flushbarStyle: FlushbarStyle.FLOATING,
                              borderRadius: BorderRadius.circular(15.r),
                              duration: const Duration(seconds: 5),
                              icon: Icon(
                                error,
                                color: red!,
                                size: 30.sp,
                              ),
                              titleText: text(context, 'خطأ', 16, purple),
                              messageText: text(context,
                                  'أدخل المبلغ المراد إضافة للرصيد', 14, black,
                                  fontWeight: FontWeight.w200),
                            ).show(context);
                      }
                    })),
              ),
              SizedBox(
                height: 37.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomSheetRechargeMenu(String id, String name, String balance) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 30.h,
              ),
              Padding(
                padding: EdgeInsets.only(right: 18.w, left: 20.w),
                child: Column(
                  children: [
                    text(
                      context,
                      'أختر طريقة الشحن',
                      16,
                      black,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    const Divider(
                      thickness: 1,
                    ),

                    ///Apple pay
                    InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //applePayIcon.png
                          Column(
                            children: [
                              SizedBox(
                                height: 20.h,
                                width: 30.w,
                                child: Image.asset(
                                    'assets/image/applePayIcon.png'),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          text(
                            context,
                            'Apple Pay',
                            18,
                            black,
                          ),
                          SizedBox(
                            width: 230.w,
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
                      },
                    ),
                    const Divider(
                      thickness: 1,
                    ),

                    ///credit card
                    Visibility(
                        visible: true,
                        child: Column(
                          children: const [
                            SingleChildScrollView(
                              child: RadioWidgetUser(),

                            ),
                          ],
                        )),

                    const Divider(
                      thickness: 1,
                    ),

                    ///add new credit card
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
                        showBottomSheetWhite(context,
                            bottomSheetNewCreditCard('1', 'rayana', '500'));
                      },
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    SizedBox(
                      height: 30.h,
                    ),

                    ///bottom to withdraw balance
                    Visibility(
                      ///will show when the user choose one of the available credit card
                      visible: isVesible,
                      child: padding(
                        22,
                        22,
                        gradientContainerNoborder(
                          150.w,
                          buttoms(
                            context,
                            'إضافة رصيد',
                            15,
                            white,
                            () {
                              isVesible == true
                                  ?

                                  ///loading Screen the successful animation
                                  goTopagepush(
                                      context,
                                      const SplashScreen(
                                        trueOrFalse: 1,
                                      ))
                                  :

                              ///loading Screen the failure animation
                              Flushbar(
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
                                titleText: text(context, 'خطأ', 12, purple),
                                messageText: text(
                                    context,
                                    'قم بإختيار بطاقة او ادخال بطاقة جديدة',
                                    12,
                                    black,
                                    fontWeight: FontWeight.w200),
                              ).show(context);
                            },
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 30.h,
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }



  ///BottomSheet to Add New Credit Card
  Widget bottomSheetNewCreditCard(String id, String name, String balance) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30.h,
            ),
            text(context, 'إضافة بطاقة جديدة', 16, black,
                fontWeight: FontWeight.bold),
            SizedBox(
              height: 15.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ///Icon
                Icon(
                  protect,
                  size: 20,
                  color: darkBlue,
                ),
                SizedBox(
                  width: 5.w,
                ),

                ///text
                text(context, 'يتم حفظ معلومات الدفع الخاصة بك بشكل آمن', 12,
                    black.withOpacity(0.6))
              ],
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding:  MediaQuery.of(context).viewInsets,
                    child: CreditCardForm(
                      cardHolderName: '',
                      formKey: formKey,
                      obscureCvv: true,
                      isHolderNameVisible: false,
                      obscureNumber: true,
                      cardNumber: cardNumber,
                      cvvCode: cvvCode,
                      isCardNumberVisible: true,
                      isExpiryDateVisible: true,
                      expiryDate: expiryDate,
                      themeColor: purple,
                      textColor: Colors.black,
                      cardNumberDecoration: InputDecoration(
                        labelText: 'رقم البطاقة',
                        hintText: '0000 0000 0000 0000',
                        hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontSize: 12.sp,
                            fontFamily: 'Cairo'),
                        labelStyle: TextStyle(
                            color: black.withOpacity(0.8),
                            fontSize: 12.sp,
                            fontFamily: 'Cairo'),
                        focusedBorder: border,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: grey!.withOpacity(0.8),
                            width: 1.0,
                          ),
                        ),
                      ),
                      numberValidationMessage: 'يرجى إضافة رقم البطاقة',
                      expiryDateDecoration: InputDecoration(
                        hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontSize: 12.sp,
                            fontFamily: 'Cairo'),
                        labelStyle: TextStyle(
                            color: black.withOpacity(0.8),
                            fontSize: 12.sp,
                            fontFamily: 'Cairo'),
                        focusedBorder: border,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: grey!.withOpacity(0.8),
                            width: 1.0,
                          ),
                        ),
                        labelText: 'تاريخ الانتهاء',
                        hintText: 'شهر/سنة',
                      ),
                      dateValidationMessage: 'يرجى إضافة تاريخ انتهاء صلاحية البطاقة',
                      cvvCodeDecoration: InputDecoration(

                        hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontSize: 12.sp,
                            fontFamily: 'Cairo'),
                        labelStyle: TextStyle(
                            color: black.withOpacity(0.8),
                            fontSize: 12.sp,
                            fontFamily: 'Cairo'),
                        focusedBorder: border,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: grey!.withOpacity(0.8),
                            width: 1.0,
                          ),
                        ),
                        labelText: 'رمز التحقق''CVV',
                        hintText: '000',
                        suffixIcon: MyTooltip(
                            message: 'الرمز الموجود خلف البطاقة',
                            child: Icon(
                              infoIcon,
                              size: 15,
                            ))
                      ),
                      cvvValidationMessage: 'ادخل رمز التحقق',
                      onCreditCardModelChange: onCreditCardModelChange,
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  padding(
                    22,
                    22,
                    gradientContainerNoborder(
                      170.w,
                      buttoms(
                        context,
                        'التحقق من البطاقة',
                        15,
                        white,
                        () {
                          if (formKey.currentState!.validate()) {
                            ///loading Screen
                            goTopagepush(
                                context,
                                const SplashScreen(
                                  trueOrFalse: 1,
                                ));
                          } else {
                            ///successful animation
                            goTopagepush(
                                context,
                                const SplashScreen(
                                  trueOrFalse: 2,
                                ));
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


