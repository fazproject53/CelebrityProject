import 'package:celepraty/Account/logging.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Models/Methods/method.dart';
import '../UserForm.dart';
import 'Reset.dart';
import 'ResetNewPassword.dart';
import 'VerifyToken.dart';

class PasswordCoding extends StatefulWidget {
  final String? userNameEmail;

  const PasswordCoding({Key? key, this.userNameEmail}) : super(key: key);

  @override
  _PasswordCodingState createState() => _PasswordCodingState();
}

class _PasswordCodingState extends State<PasswordCoding> {
  GlobalKey<FormState> codeKey = GlobalKey();
  final TextEditingController codeController = TextEditingController();
  late Image image1;
  @override
  void initState() {
    print(widget.userNameEmail!);
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    image1 = Image.asset("assets/image/singup.jpg");
  }

  @override
  void didChangeDependencies() {
    precacheImage(image1.image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: black,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                  image: image1.image,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.7), BlendMode.darken),
                  fit: BoxFit.cover)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 40.h,
                ),
                text(
                  context,
                  'التحقق من الرمز المدخل',
                  18,
                  white,
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
                      color: Colors.white12,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage('assets/image/code.png')),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
//title---------------------------------------------------------------
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 20.w),
                  child: text(
                    context,
                    'الرجاء إدخال الرمز المكون من 4 أرقام المرسل إلى البريد الالكتروني المدخل',
                    15,
                    white,
                    fontWeight: FontWeight.bold,
                    align: TextAlign.right,
                  ),
                ),
//code Text field---------------------------------------------------------------
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 20.w),
                  child: Form(
                      key: codeKey,
                      child: textField(
                        context,
                        Icons.lock,
                        "رمز التحقق",
                        12,
                        false,
                        codeController,
                        code,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      )),
                ),
//reSend message ---------------------------------------------------------------
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 20.w),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Wrap(
                        children: [
                          text(context, "لم يصل رمز التحقق؟", 13, white),
                          SizedBox(
                            width: 7.w,
                          ),
                          InkWell(
                              child: text(context, "إعادة ارسال", 13, pink),
                              onTap: () {
                                forgetPassword(widget.userNameEmail!);
                              }),
                        ],
                      )
                    ],
                  ),
                ),
//send bottom ---------------------------------------------------------------
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 20.w),
                  child: gradientContainer(
                    double.infinity,
                    buttoms(
                      context,
                      "تحقق",
                      15,
                      white,
                      () {
                        //remove focus from textField when click outside
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (codeKey.currentState?.validate() == true) {
                          verifyCode(widget.userNameEmail!,
                              int.parse(codeController.text));
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
        showMassage(context, 'استعادة كلمة السر',
            'تم ارسال رمز التحقق علي البريد الالكتروني الخاص بك',
            done: done);
      } else {
        Navigator.pop(context);
        showMassage(context, 'بيانات غير صحيحة', 'المستخدم غير موجود');
      }
    });
  }

//-------------------------------------------------------------------------------
  Future<String?> verifyCode(String username, int code) async {
    loadingDialogue(context);
    getVerifyCode(username, code).then((sendCode) async {
      if (sendCode == 'not verified') {
        Navigator.pop(context);
        showMassage(context, 'بيانات غير صحيحة',
            'الرمز المدخل خاطئ او ان صلاحيته قد انتهت');
      } else if (sendCode == "SocketException") {
        Navigator.pop(context);
        showMassage(context, 'مشكلة في الانترنت',
            ' لايوجد اتصال بالانترنت في الوقت الحالي ');
      } else if (sendCode == "TimeoutException") {
        Navigator.pop(context);
        showMassage(context, 'مشكلة في الخادم', 'TimeoutException');
      } else if (sendCode == 'serverException') {
        Navigator.pop(context);
        showMassage(context, 'مشكلة في الخادم',
            'حدث خطأ ما اثناء استعادة كلمة المرور, سنقوم باصلاحه قريبا');
      } else {
        //Navigator.pop(context);
        verifyToken();
      }
    });
  }

//-----------------------------------------------------------------------------------------------
  void verifyToken() async {
    getVerifyToken(forgetToken).then((sendToken) async {
      if (sendToken == true) {
        Navigator.pop(context);
        goTopagepush(
            context,
            ResetNewPassword(
                code: int.parse(codeController.text),
                username: widget.userNameEmail));
      } else {
        Navigator.pop(context);

        showMassage(
            context, 'استعادة كلمة السر', 'انتهت المدة الزمنية لصلاحية الدخول');
        goTopageReplacement(context, Logging());
      }
    });
  }
}
/*
*
* */
