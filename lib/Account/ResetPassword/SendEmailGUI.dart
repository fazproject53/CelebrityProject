import 'package:celepraty/Account/ResetPassword/PasswordCoding.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../Models/Methods/method.dart';
import '../UserForm.dart';
import 'Reset.dart';

class SendEmail extends StatefulWidget {
  const SendEmail({Key? key}) : super(key: key);

  @override
  _SendEmailState createState() => _SendEmailState();
}

class _SendEmailState extends State<SendEmail> {


  late Image image1;
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    image1 = Image.asset("assets/image/singup.jpg");
  }
  @override
  void didChangeDependencies() {
    precacheImage(image1.image, context);
    super.didChangeDependencies();
  }
  GlobalKey<FormState> emailKey = GlobalKey();
  final TextEditingController userNameEmailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          // decoration: BoxDecoration(
          //     color: Colors.black,
          //     image: DecorationImage(
          //         image: image1.image,
          //         colorFilter: ColorFilter.mode(
          //             Colors.black.withOpacity(0.7), BlendMode.darken),
          //         fit: BoxFit.cover)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 40.h,
                ),
                text(
                  context,
                  'التحقق من المستخدم',
                  18,
                  Colors.black87,
                  fontWeight: FontWeight.bold,
                  align: TextAlign.right,
                ),
                SizedBox(
                  height: 70.h,
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 60.w),
//image---------------------------------------------------------------
                  child: Container(
                    width: double.infinity,
                    height: 160.h,
                    margin: EdgeInsets.all(9.w),
                    decoration: const BoxDecoration(
                        color: Colors.black38,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage('assets/image/email1.png'))),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
//title---------------------------------------------------------------
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 10.h),
                  child: text(
                    context,
                    'قم بإدخال اسم المستخدم او عنوان بريدك الالكتروني المرتبط بحسابك',
                    15,
                    Colors.black87,
                    //fontWeight: FontWeight.bold,
                    align: TextAlign.right,
                  ),
                ),
//email Text field---------------------------------------------------------------
                Padding(
                  padding: EdgeInsets.all(20.0.w),
                  child: Form(
                      key: emailKey,
                      child: textField(
                        context,
                        emailIcon,
                        "اسم المستخدم او البريد الالكتروني",
                        12,
                        false,
                        userNameEmailController,
                        empty,
                        keyboardType: TextInputType.emailAddress,
                        inputFormatters: [
                          FilteringTextInputFormatter(
                              RegExp(r'[a-zA-Z]|[@]|[_]|[0-9]|[.]|[-]'),
                              allow: true)
                        ],
                      )),
                ),
//send bottom ---------------------------------------------------------------
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                  child: gradientContainer(
                    double.infinity,
                    buttoms(
                      context,
                      "ارسال",
                      15,
                      white,
                      () {
                        //remove focus from textField when click outside
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (emailKey.currentState?.validate() == true) {
                          forgetPassword(userNameEmailController.text);
                        }
                      },
                      evaluation: 0,
                    ),
                    height: 50,
                    color: Colors.transparent,
                    gradient: false,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  //---------------------------------------------------------------------

  void forgetPassword(String username) async {
    loadingDialogue(context);
    getCreatePassword(username).then((result) {
      if (result == true) {
        Navigator.pop(context);
        successfullyDialog(
            context,
            'تم ارسال رمز التحقق الى البريد الالكتروني الخاص بك',
            "assets/lottie/SuccessfulCheck.json",
            'التالي', () {
              Navigator.pop(context);
          goTopagepush(
              context,
              PasswordCoding(
                userNameEmail: username,
              ));
        });
      } else {
        if (result == "SocketException") {
          Navigator.pop(context);
          showMassage(context, 'مشكلة في الانترنت',
              ' لايوجد اتصال بالانترنت في الوقت الحالي ');
        } else if (result == "TimeoutException") {
          Navigator.pop(context);
          showMassage(context, 'مشكلة في الخادم', 'TimeoutException');
        } else if (result == false) {
          Navigator.pop(context);
          showMassage(context, 'بيانات غير صحيحة',
              ' اسم المستخدم او البريد الالكتروني غير موجود, فضلا تاكد من صحته وحاول مرة اخرى');
        } else {
          Navigator.pop(context);
          showMassage(context, 'مشكلة في الخادم',
              'حدث خطأ ما اثناء استعادة كلمة المرور, سنقوم باصلاحه قريبا');
        }
      }
    });
  }

//--------------------------------------------------------------------------------

}
