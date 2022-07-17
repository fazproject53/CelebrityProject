//================ convert hex colors to rgb colors================
import 'dart:core';
import 'dart:io';

import 'package:celepraty/Models/Methods/classes/GradientIcon.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

//===============================Text===============================

Widget text(
  context,
  String key,
  double fontSize,
  Color color, {
  family = "Cairo",
  align = TextAlign.right,
  double space = 0,
  FontWeight fontWeight = FontWeight.normal,
}) {
  return Text(
    key,
    textAlign: align,
    //softWrap: false,
    style: TextStyle(
      color: color,
     //overflow: TextOverflow.ellipsis,

      fontFamily: family,
      fontSize: fontSize.sp,
      letterSpacing: space.sp,
      fontWeight: fontWeight,
    ),
  );
}

///
///Flushbar
Widget flushBar(context, String title, String message, icon) {
  return Directionality(
    textDirection: TextDirection.rtl,
    child: Flushbar(
      titleText: Text(
        title,
        style: TextStyle(
          color: purple,
          fontFamily: 'Cairo',
          fontSize: 12.sp,
        ),
      ),
      messageText: Text(message),
      borderRadius: BorderRadius.circular(10.r),
      flushbarPosition: FlushbarPosition.TOP,
      margin: const EdgeInsets.all(5),
      flushbarStyle: FlushbarStyle.FLOATING,
      duration: const Duration(seconds: 5),
      backgroundColor: white,
      icon: icon,
    )..show(context),
  );
}

//===============================container===============================
Widget container(double height, double width, double marginL, double marginR,
    Color color, Widget child,
    {double blur = 0.0,
    Offset offset = Offset.zero,
    double spShadow = 0.0,
    double pL = 0.0,
    double pR = 0.0,
    double pT = 0.0,
    double pB = 0.0,
    double marginT = 0.0,
    double marginB = 0.0,
    double bottomLeft = 0.0,
    double topRight = 0.0,
    double topLeft = 0.0,
    double bottomRight = 0.0}) {
  return Container(
    padding: EdgeInsets.only(left: pL.w, right: pR.w, top: pT.h, bottom: pB.h),
    width: width.w,
    height: height.h,
    margin: EdgeInsets.only(
        left: marginL.w, right: marginR.w, top: marginT.h, bottom: marginB.h),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(bottomLeft),
            topRight: Radius.circular(topRight),
            topLeft: Radius.circular(topLeft),
            bottomRight: Radius.circular(bottomRight)),
        color: color,
        boxShadow: [
          BoxShadow(blurRadius: blur, offset: offset, spreadRadius: spShadow)
        ]),
    child: child,
  );
}

//gradient contaner------------------------------------------------------------------
Widget gradientContainer(double width, Widget child,
    {bool gradient = false,
    double height = 45,
    Color color = deepBlack,
    double bottomLeft = 4.0,
    double topRight = 4.0,
    double topLeft = 4.0,
    double bottomRight = 4.0}) {
  return Container(
    width: width.w,
    height: height.h,
    child: child,
    decoration: BoxDecoration(
      border: Border.all(color: color, width: 0.92.r),
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(bottomLeft.r),
          topRight: Radius.circular(topRight.r),
          topLeft: Radius.circular(topLeft),
          bottomRight: Radius.circular(bottomRight.r)),
      gradient: gradient == false
          ? const LinearGradient(
              begin: Alignment(0.7, 2.0),
              end: Alignment(-0.69, -1.0),
              colors: [Color(0xff0ab3d0), Color(0xffe468ca)],
              stops: [0.0, 1.0],
            )
          : null,
    ),
  );
}

Widget gradientContainerNoborder(double width, Widget child,
    {height = 40.0, double reids = 4.0, double blurRadius = 5}) {
  return Container(
    width: width.w,
    child: child,
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
            color: darkWhite, blurRadius: blurRadius, offset: Offset(2, 3))
      ],
      borderRadius: BorderRadius.circular(reids.r),
      gradient: const LinearGradient(
        begin: Alignment(0.7, 2.0),
        end: Alignment(-0.69, -1.0),
        colors: [Color(0xff0ab3d0), Color(0xffe468ca)],
        stops: [0.0, 1.0],
      ),
    ),
  );
}
//==================== container with no shadow ===========================

Widget gradientContainerNoborder2(double width, double height, Widget child) {
  return Container(
    width: width.w,
    child: child,
    height: height,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      gradient: const LinearGradient(
        begin: Alignment(0.7, 2.0),
        end: Alignment(-0.69, -1.0),
        colors: [Color(0xff0ab3d0), Color(0xffe468ca)],
        stops: [0.0, 1.0],
      ),
    ),
  );
}

Widget gradientContainerWithHeight(double width, double height, Widget child) {
  return Container(
    width: width.w,
    height: height.h,
    child: child,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10.0.r),
          topLeft: Radius.circular(10.0.r),
        ),
        color: lightGrey),
  );
}
//solid: contaner------------------------------------------------------------------

Widget solidContainer(double width, Color color, Widget child) {
  return Container(
    width: width.w,
    // height: height.h,

    child: child,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}
//============================profile buttons for listView ========================

Widget addListViewButton(String text, IconData icon) {
  return Row(children: [
    padding(
      0,
      5,
      SizedBox(
          child: Icon(
        icon,
        color: purple,
      )),
    ),
    const SizedBox(
      width: 10,
    ),
    Expanded(
      flex: 10,
      child: Text(
        text,
        style: TextStyle(color: black, fontSize: 14.sp),
      ),
    ),
  ]);
}
//=============================Padding Widget=================================

Widget padding(double left, double right, Widget child) {
  return Padding(
    padding: EdgeInsets.only(left: left.w, right: right.w),
    child: child,
  );
}

Widget paddingg(double pL, double pR, double pT, Widget child,
    {double pB = 0.0}) {
  return Padding(
    padding: EdgeInsets.only(left: pL.w, right: pR.w, top: pT.h, bottom: pB.h),
    child: child,
  );
}

//=================================Buttoms=============================
Widget buttoms(context, String key, double fontSize, Color textColor, onPressed,
    {Color backgrounColor = transparent,
    double horizontal = 0.0,
    double vertical = 0.0,
    double evaluation = 0.0}) {
  return TextButton(
    onPressed: onPressed,
    child: text(context, key, fontSize, textColor),
    style: ButtonStyle(
      elevation: MaterialStateProperty.all(evaluation),
      backgroundColor: MaterialStateProperty.all(backgrounColor),
      foregroundColor: MaterialStateProperty.all(textColor),
      padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(horizontal: horizontal.w, vertical: vertical.h)),
    ),
  );
}

//===============================Go To page(push)===============================
goTopagepush(context, pageName) {
  return Navigator.push(
      context, MaterialPageRoute(builder: (context) => pageName));
}

//===============================Go To page(pushReplacement)===============================
goTopageReplacement(BuildContext context, pageName) {
  return Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => pageName));
}

//===============================Go To page(push)===============================
goToPagePushRefresh(context, pageName, {then}) {
  return Navigator.push(
      context, MaterialPageRoute(builder: (context) => pageName)).then(then);
}

//get heghit and width===============================================================
Size getSize(context) {
  return MediaQuery.of(context).size;
}

//=============================TextFields=================================
Widget textField(context, icons, String key, double fontSize, bool hintPass,
    TextEditingController mycontroller, myvali,
    {Widget? suffixIcon,
    void Function()? onTap,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType}) {
  return TextFormField(
    obscureText: hintPass,
    validator: myvali,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    onTap: onTap,
    autofocus: false,
    inputFormatters: inputFormatters,
    keyboardType: keyboardType,
    controller: mycontroller,
    style: TextStyle(color: Colors.white, fontSize:  fontSize.sp),
    decoration: InputDecoration(
        isDense: true,
        filled: true,
        suffixIcon: suffixIcon,
        hintStyle: TextStyle(
            color: Colors.white, fontSize: fontSize.sp),
        fillColor: Colors.white12,
        labelStyle: TextStyle(color: Colors.white, fontSize: 15.0.sp),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.r),borderSide: BorderSide(
          color: purple.withOpacity(0.6),
          width: 1.0,
        ),),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4.r),borderSide: BorderSide(
          color: purple.withOpacity(0.6),
          width: 1.0,
        ),) ,
        enabledBorder:  OutlineInputBorder(borderRadius: BorderRadius.circular(4.r),borderSide: BorderSide(
          color: Colors.grey.withOpacity(0.8),
          width: 1.0,
        ),),
        prefixIcon: Icon(icons, color: purple.withOpacity(0.6), size: 25.sp),
        labelText: key,
        errorStyle: TextStyle(color: Colors.red, fontSize: 15.0.sp),
        contentPadding: EdgeInsets.all(10.h)),
  );
}

//=============================TextFields=================================
Widget textField3(context, icons, String key, double fontSize, bool hintPass,
    TextEditingController mycontroller, myvali,
    {Widget? suffixIcon,
    void Function()? onTap,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType}) {
  return TextFormField(
    obscureText: hintPass,
    validator: myvali,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    onTap: onTap,
    autofocus: false,
    inputFormatters: inputFormatters,
    keyboardType: keyboardType,
    controller: mycontroller,
    style: TextStyle(color: white, fontSize: fontSize.sp),
    decoration: InputDecoration(
        isDense: true,
        filled: true,
        suffixIcon: suffixIcon,
        hintStyle: TextStyle(
            color: Colors.white, fontSize: fontSize.sp),
        fillColor: Colors.white12,
        labelStyle: TextStyle(color: Colors.white, fontSize: 15.0.sp),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.r),borderSide: BorderSide(
          color: purple.withOpacity(0.6),
          width: 1.0,
        ),),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4.r),borderSide: BorderSide(
          color: purple.withOpacity(0.6),
          width: 1.0,
        ),) ,
        enabledBorder:  OutlineInputBorder(borderRadius: BorderRadius.circular(4.r),borderSide: BorderSide(
          color: Colors.grey.withOpacity(0.8),
          width: 1.0,
        ),),prefixIcon: Icon(icons, color: deepBlack, size: 25.sp),
        labelText: key,
        errorStyle: TextStyle(color: Colors.red, fontSize: 15.0.sp),
        contentPadding: EdgeInsets.all(10.h)),
  );
}

//=============================TextFields price=================================
Widget textField2(context, icons, String key, double fontSize, bool hintPass,
    TextEditingController mycontroller, myvali,
    {Widget? suffixIcon,
    onTap,
    hitText,
    bool isEdit = true,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType}) {
  return TextFormField(
    obscureText: hintPass,
    enabled: isEdit,
    onTap: onTap,
    validator: myvali,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    autofocus: false,
    inputFormatters: inputFormatters,
    keyboardType: keyboardType,
    controller: mycontroller,
    style: TextStyle(color: deepgrey, fontSize:  fontSize.sp),
    decoration: InputDecoration(
        isDense: true,
        filled: true,
        suffixIcon: suffixIcon,
        hintStyle: TextStyle(color: deepgrey, fontSize: 12.0.sp),
        fillColor: white,
        labelStyle: TextStyle(color: deepgrey, fontSize: 12.0.sp),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: pink, width: 1.0.r),
          borderRadius: BorderRadius.circular(10.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: pink, width: 1.0.r),
          borderRadius: BorderRadius.circular(10.r),
        ),
        disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: pink, width: 1.0.r),
            borderRadius: BorderRadius.circular(10.r)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: pink, width: 1.0.r),
            borderRadius: BorderRadius.circular(10.r)),
        prefixIcon: Icon(icons, color: pink, size: 25.sp),
        labelText: key,
        hintText: hitText,
        errorStyle: TextStyle(color: Colors.red, fontSize: 10.0.sp),
        contentPadding: EdgeInsets.all(10.h)),
  );
}

//SingWith bouttom------------------------------------------------------------------
Widget singWithsButtom(
    context, String key, Color textColor, Color backColor, onPressed, image) {
  return Container(
    height: 45.h,
    width: 45.w,
    decoration: BoxDecoration(
        boxShadow: [BoxShadow(blurRadius: 3,)],
        color: backColor,
        image: DecorationImage(
            image: AssetImage(
              image,
            ),
            fit: BoxFit.contain),
        borderRadius: BorderRadius.all(Radius.circular(5.r))),
  );
}

Widget textFieldNoIcon(context, String key, double fontSize, bool hintPass,
    TextEditingController mycontroller, myvali, isOptional,
    {List<TextInputFormatter>? inputFormatters, TextInputType? keyboardType, Widget? child}) {
  return Container(
    // height: 50.h,
    child: TextFormField(
      obscureText: hintPass,
      validator: myvali,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: mycontroller,
      style: TextStyle(color: black, fontSize: fontSize.sp, fontFamily: 'Cairo'),
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius:BorderRadius.circular(8.r),
            borderSide: BorderSide(
              color: newGrey,
              width: 0.5,
            ),),
          isDense: false,
          filled: true,
          errorStyle: TextStyle(fontSize: 12.sp),
          helperText: isOptional ? 'اختياري' : null,
          helperStyle:
          TextStyle(color: pink, fontSize: fontSize.sp, fontFamily: 'Cairo'),
          hintStyle:
          TextStyle(color: grey, fontSize: fontSize.sp, fontFamily: 'Cairo'),
          fillColor: lightGrey.withOpacity(0.10),
          labelStyle: TextStyle(color: black, fontSize: fontSize.sp),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
          focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: purple, width: 1.w)),
          suffix: child,
          hintText: key,
          contentPadding: EdgeInsets.all(10.h)),
    ),
  );
}

///text field iban
Widget textFieldIban(
  context,
  String key,
  String label,
  double fontSize,
  bool hintPass,
  TextEditingController mycontroller,
  myvali,
  isOptional, {
  List<TextInputFormatter>? inputFormatters,
  TextInputType? keyboardType,
  onChanged,
}) {
  return TextFormField(
    obscureText: hintPass,
    validator: myvali,
    inputFormatters: inputFormatters,
    keyboardType: keyboardType,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    controller: mycontroller,
    onChanged: onChanged,
    style: TextStyle(
        color: black,
        fontSize: fontSize.sp,
        fontFamily: 'Cairo',
        letterSpacing: 2),
    decoration: InputDecoration(
        isDense: false,
        filled: true,
        errorStyle: TextStyle(fontSize: 12.sp),
        helperText: isOptional ? 'اختياري' : null,
        helperStyle:
            TextStyle(color: pink, fontSize: fontSize.sp, fontFamily: 'Cairo'),
        hintStyle:
            TextStyle(color: grey, fontSize: fontSize.sp, fontFamily: 'Cairo'),
        fillColor: white,
        labelStyle: TextStyle(color: black, fontSize: fontSize.sp),
        hintText: key,
        labelText: label,
        contentPadding: EdgeInsets.all(10.h)),
  );
}

///the long one
Widget textFieldNoIconWhite(context, String key, double fontSize, bool hintPass,
    TextEditingController myController, myValidation,
    {Widget? suffixIcon,
    void Function()? onTap,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType}) {
  return TextFormField(
    obscureText: hintPass,
    validator: myValidation,
    onTap: onTap,
    autofocus: false,
    inputFormatters: inputFormatters,
    keyboardType: keyboardType,
    controller: myController,
    style: TextStyle(color: black, fontSize: 14.sp),
    decoration: InputDecoration(
      isDense: true,
      filled: true,
      hintStyle: TextStyle(color: grey, fontSize: 14.sp),
      fillColor: white,
      labelStyle: TextStyle(color: grey, fontSize: 14.sp),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: purple, width: 4.w)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
        borderSide: BorderSide(width: 1.w, color: grey!.withOpacity(0.8)),
      ),
      labelText: key,
      hintText: '0000 0000 0000 0000',
    ),
  );
}

///text field with width
Widget textFieldWhiteWidth(context, String key, String hintKey, double fontSize,
    bool hintPass, TextEditingController myController, myValidation,
    {Widget? suffixIcon,
    void Function()? onTap,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType}) {
  return SizedBox(
    width: 140.w,
    child: TextFormField(
      obscureText: hintPass,
      validator: myValidation,
      onTap: onTap,
      autofocus: false,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      controller: myController,
      style: TextStyle(color: black, fontSize: 14.sp),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        hintStyle: TextStyle(color: grey, fontSize: 14.sp),
        fillColor: white,
        labelStyle: TextStyle(color: grey, fontSize: 14.sp),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: purple, width: 4.w)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
          borderSide: BorderSide(width: 1.w, color: grey!.withOpacity(0.8)),
        ),
        labelText: key,
        hintText: hintKey,
      ),
    ),
  );
}

///Text Field small
Widget textFieldSmall(context, String key, double fontSize, bool hintPass,
    TextEditingController mycontroller, myvali,
    {Widget? suffixIcon,
    void Function()? onTap,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
    focusNode})

///The icons will be optional

{
  return SizedBox(
    height: 30.h,
    width: 130.w,
    child: TextFormField(
      validator: myvali,
      controller: mycontroller,
      textAlign: TextAlign.center,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      autofocus: false,
      focusNode: focusNode,
      style:
          TextStyle(color: black, fontSize: fontSize.sp, fontFamily: 'Cairo'),
      decoration: InputDecoration(
          isDense: false,
          filled: true,
          suffixIcon: suffixIcon,
          hintStyle: TextStyle(
              color: grey, fontSize: fontSize.sp, fontFamily: 'Cairo'),
          fillColor: textColor,
          labelStyle: TextStyle(
            color: white,
            fontSize: fontSize.sp,
          ),
          alignLabelWithHint: true,
          border: const OutlineInputBorder(borderSide: BorderSide.none),
          hintText: key,
          errorStyle: TextStyle(
            color: red!,
            fontSize: 10.sp,
            fontFamily: 'Cairo',
          ),
          contentPadding: EdgeInsets.all(10.h)),
    ),
  );
}

///Text Field small
Widget textFieldSmallRE(context, String key, double fontSize, bool hintPass,
    TextEditingController mycontroller, myvali,
    {Widget? suffixIcon,
    void Function()? onTap,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
    focusNode}) {
  ///The icons will be optional
  return SizedBox(
    height: 100.h,
    width: 130.w,
    child: TextFormField(
      validator: myvali,
      controller: mycontroller,
      textAlign: TextAlign.center,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      autofocus: false,
      focusNode: focusNode,
      style:
          TextStyle(color: black, fontSize: fontSize.sp, fontFamily: 'Cairo'),
      decoration: InputDecoration(
          isDense: false,
          filled: true,
          suffixIcon: suffixIcon,
          hintStyle: TextStyle(
              color: grey, fontSize: fontSize.sp, fontFamily: 'Cairo'),
          fillColor: textColor,
          labelStyle: TextStyle(
            color: white,
            fontSize: fontSize.sp,
          ),
          alignLabelWithHint: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: BorderSide.none),
          hintText: key,
          errorStyle: TextStyle(
            color: red!,
            fontSize: 10.sp,
            fontFamily: 'Cairo',
          ),
          contentPadding: EdgeInsets.all(10.h)),
    ),
  );
}

//======================== for description multiline ====================
Widget textFieldDesc(context, String key, double fontSize, bool hintPass,
    TextEditingController mycontroller, myvali,
    {InputCounterWidgetBuilder? counter,
    int? maxLenth,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType}) {
  return SizedBox(
    height: 200.h,
    child: TextFormField(
      buildCounter: counter,
      controller: mycontroller,
      keyboardType: TextInputType.multiline,
      validator: myvali,
      inputFormatters: inputFormatters,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLines: null,
      minLines: 10,
      maxLength: maxLenth,
      textAlignVertical: TextAlignVertical.top,
      style:
          TextStyle(color: black, fontSize: fontSize.sp, fontFamily: 'Cairo'),
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius:BorderRadius.circular(8.r),
            borderSide: BorderSide(
              color: newGrey,
              width: 0.5,
            ),),
          isDense: false,
          filled: true,
          hintStyle: TextStyle(
              color: grey, fontSize: fontSize.sp, fontFamily: 'Cairo'),
          fillColor:  lightGrey.withOpacity(0.10),
          labelStyle: TextStyle(
            color: white,
            fontSize: fontSize.sp,
          ),
          alignLabelWithHint: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: purple, width: 1)),
          hintText: key,
          contentPadding: EdgeInsets.all(10.h)),
    ),
  );
}

//============================ text feild curved from one side ==================================

Widget textFieldNoIcon2(
  context,
  String key,
  double fontSize,
  bool hintPass,
  TextEditingController mycontroller,
  myvali,
) {
  return TextFormField(
    obscureText: hintPass,
    validator: myvali,
    controller: mycontroller,
    style: TextStyle(color: black, fontSize: fontSize.sp, fontFamily: 'Cairo'),
    decoration: InputDecoration(
    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.only(
      bottomRight: Radius.circular(10.0),
      topRight: Radius.circular(10.0),
    ),
    borderSide: BorderSide(
    color: newGrey,
    width: 0.5,
    ),),
        isDense: false,
        filled: true,
        hintStyle:
            TextStyle(color: grey, fontSize: fontSize.sp, fontFamily: 'Cairo'),
        fillColor:  lightGrey.withOpacity(0.10),
        labelStyle: TextStyle(color: black, fontSize: fontSize.sp),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        )),

        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: purple, width: 1)),
        hintText: key,
        contentPadding: EdgeInsets.all(10.h)),
  );
}

Widget textFeildWithButton(context, child1, child2) {
  return paddingg(
    15,
    15,
    0,
    SizedBox(
      width: getSize(context).width,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 4,
            child: paddingg(
              0,
              0,
              12,
              Container(width: getSize(context).width / 1.2, child: child1),
            ),
          ),
          Expanded(
            flex: 1,
            child: paddingg(0, 0, 12, child2),
          ),
        ],
      ),
    ),
  );
}
//============================ show bottomsheet takes a column ==============================

void showBottomSheett(context, buttomMenue) {
  showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50), topRight: Radius.circular(50)),
      ),
      context: context,
      builder: (context) {
        return Container(
          height: 400.h,
          child: buttomMenue,
        );
      });
}

void showBottomSheetWhite(context, bottomMenu) {
  showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r)),
      ),
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SizedBox(
            height: 350.h,
            child: bottomMenu,
          ),
        );
      });
}

void showBottomSheetWhite2(context, bottomMenu) {
  showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r)),
      ),
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SizedBox(
            height: 400.h,
            child: bottomMenu,
          ),
        );
      });
}

Widget uploadImg(double width, double hight, child, onTap) {
  return InkWell(
    child: Container(
      width: width.w,
      height: hight.h,
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GradientIcon(attach, 30.w,
                const LinearGradient(colors: <Color>[pink, blue])),
            child
          ]),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.r)),
          border: Border.all(color: black)),
    ),
    onTap: onTap,
  );
}

//============================== Calendar ===========================================

Future<void> tableCalendar(context, dateTime) async {
  final DateTime picked = showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(2020, 1, 1),
      lastDate: DateTime(2025, 1, 1),
      builder: (context, child) {
        return Theme(
            data: ThemeData.light().copyWith(
                colorScheme:
                    const ColorScheme.light(primary: purple, onPrimary: white)),
            child: child!);
      }) as DateTime;
  if (picked != null && picked != dateTime) {
    dateTime = picked;
  }
}

//====================== image file picker ===================================
Future pickImage(imagee) async {
  try {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final temp = File(image.path);
    imagee = temp;
  } on PlatformException catch (e) {
    print('could not pick image $e');
  }
}

Widget buildCkechboxList22(list) {
  List<Widget> w = [];
  Widget cb;
  for (var i = 0; i < list.length; i++) {
    cb = Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          children: [
            Checkbox(value: false, onChanged: (value) {}),
            Text(list[i])
          ],
        ),
      ),
    );
    w.add(cb);
  }

  return Row(mainAxisAlignment: MainAxisAlignment.start, children: w);
}

Widget buildCkechboxList2(list) {
  List<Widget> w = [];
  Widget cb;
  for (var i = 0; i < list.length; i++) {
    cb = Expanded(
      child: Row(
        children: [
          Checkbox(value: false, onChanged: (value) {}),
          Text(list[i])
        ],
      ),
    );
    w.add(cb);
  }

  return Row(mainAxisAlignment: MainAxisAlignment.start, children: w);
}

divider({
  double thickness = 2,
  double indent = 15,
  double endIndent = 15,
}) {
  return Align(
    alignment: Alignment.topCenter,
    child: VerticalDivider(
      color: Colors.grey[400],
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      //width: 12,
    ),
  );
}
//===============================Container===============================

//gradient color---------------------------------------------------------------------
LinearGradient gradient() {
  return const LinearGradient(
    begin: Alignment(0.7, 2.0),
    end: Alignment(-0.69, -1.0),
    colors: [Color(0xff0ab3d0), Color(0xffe468ca)],
    stops: [0.0, 1.0],
  );
}

///on change text filed
Widget textFieldDescOnChange(context, String key, double fontSize,
    bool hintPass, TextEditingController mycontroller, myvali,
    {InputCounterWidgetBuilder? counter, int? maxLenth}) {
  var expand = false;
  return SizedBox(
    height: 150.h,
    child: TextFormField(
      controller: mycontroller,
      buildCounter: counter,
      keyboardType: TextInputType.multiline,
      validator: myvali,
      maxLines: null,
      minLines: 10,
      maxLength: maxLenth,
      textAlignVertical: TextAlignVertical.top,
      style:
          TextStyle(color: white, fontSize: fontSize.sp, fontFamily: 'Cairo'),
      decoration: InputDecoration(
          isDense: false,
          filled: true,
          hintStyle: TextStyle(
              color: Colors.grey, fontSize: fontSize.sp, fontFamily: 'Cairo'),
          fillColor: textFieldBlack2.withOpacity(0.70),
          labelStyle: TextStyle(
            color: Colors.grey,
            fontSize: fontSize.sp,
          ),
          alignLabelWithHint: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: pink, width: 1)),
          hintText: key,
          contentPadding: EdgeInsets.all(10.h)),
    ),
  );
}

//============================ text field curved from one side ==================================

//Drow app bar----------------------------------------------------

drowAppBar(String title, BuildContext context,
    {color = deepwhite, IconData? download, onPressed}) {
  return AppBar(
    title: Text(
      title,
      style: TextStyle(fontSize: 22.sp, fontFamily: 'Cairo', color: black),
    ),
    centerTitle: true,
    leading: IconButton(
      padding: EdgeInsets.only(right: 20.w),
      icon: const Icon(Icons.arrow_back_ios),
      color: Colors.black,
      onPressed: () {
        Navigator.pop(context);
      },
    ),
    actions: [
      download != null
          ? Padding(
              padding: EdgeInsets.only(left: 20.w),
              child: IconButton(
                padding: EdgeInsets.only(right: 20.w),
                icon: Icon(download),
                color: Colors.black,
                onPressed: onPressed,
              ),
            )
          : const Icon(
              Icons.download,
              size: 0,
            ),
    ],
    backgroundColor: color,
    elevation: 0,
  );
}

appBarNoIcon(String title, BuildContext context,
    {color = deepwhite, }) {
  return AppBar(
    title: Text(
      title,
      style: TextStyle(fontSize: 22.sp, fontFamily: 'Cairo', color: black),
    ),
    centerTitle: true,
    backgroundColor: color,
    elevation: 0,
  );
}

drawAppBar(Widget title, BuildContext context, {Color color = deepwhite}) {
  return AppBar(
    title: title,
    centerTitle: true,
    leading: IconButton(
      padding: EdgeInsets.only(right: 20.w),
      icon: const Icon(Icons.arrow_back_ios),
      color: Colors.black,
      onPressed: () {
        Navigator.pop(context);
      },
    ),
    backgroundColor: color,
    elevation: 0,
  );
}

///app bar without back icon
AppBarNoIcon(String title, {Color color = deepwhite}) {
  return AppBar(
    title: Text(
      title,
      style: TextStyle(fontSize: 22.sp, fontFamily: 'Cairo', color: black),
    ),
    centerTitle: true,
    backgroundColor: color,
    elevation: 0,
  );
}

///
///
class MyTooltip extends StatelessWidget {
  final Widget child;
  final String message;

  MyTooltip({required this.message, required this.child});

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<State<Tooltip>>();
    return Tooltip(
      key: key,
      message: message,
      textStyle: TextStyle(
        color: white,
        fontSize: 12.sp,
      ),
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

void showBottomSheettInvoice(context, buttomMenue) {
  showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return Container(
          height: 670.h,
          child: buttomMenue,
        );
      });
}

void showBottomSheett2(context, buttomMenue) {
  showModalBottomSheet(
      isScrollControlled: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          // margin: EdgeInsets.only(right: 10, left: 10),
          // color: Colors.transparent.withOpacity(0.5),
          height: 250.h,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 5, right: 5),
                height: 180.h,
                child: buttomMenue,
                decoration: BoxDecoration(
                    color: white, borderRadius: BorderRadius.circular(8)),
              ),
              SizedBox(
                height: 10.h,
              ),
              InkWell(
                  child: Container(
                    alignment: Alignment.center,
                    height: 45.h,
                    width: 400.w,
                    child: text(context, 'الغاء', 20, purple,
                        align: TextAlign.center),
                    decoration: BoxDecoration(
                        color: fillWhite,
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  }),
            ],
          ),
        );
      });
}

// combo box============================================================abstract
Widget drowMenu(
    String inisValue,
    IconData prefixIcon,
    double fontSize,
    List<String> item,
    void Function(String?)? onChanged,
    String? Function(String?)? validator,
    {double width = double.infinity}) {
  return DropdownButtonFormField2<String>(
    autovalidateMode: AutovalidateMode.onUserInteraction,
    validator: validator,
    hint: Text(
      inisValue,
      style:
          TextStyle(color: Colors.white, fontSize:  fontSize.sp),
    ),
    //dropdownColor: black,
    items: item
        .map((type) => DropdownMenuItem(
              alignment: Alignment.center,
              value: type,
              child: Text(
                type,
                style: TextStyle(
                    color: Colors.white, fontSize:  fontSize.sp),
                textAlign: TextAlign.center,
              ),
            ))
        .toList(),
    decoration: InputDecoration(
        isDense: false,
        filled: true,
        prefixIcon: Icon(
          prefixIcon,
          color: purple.withOpacity(0.6),
        ),
        fillColor: Colors.white12,
        alignLabelWithHint: true,
        errorStyle: TextStyle(color: Colors.red, fontSize: 14.0.sp),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.r),borderSide: BorderSide(
          color: purple.withOpacity(0.6),
          width: 1.0,
        ),),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4.r),borderSide: BorderSide(
          color: purple.withOpacity(0.6),
          width: 1.0,
        ),) ,
        enabledBorder:  OutlineInputBorder(borderRadius: BorderRadius.circular(4.r),borderSide: BorderSide(
          color: Colors.grey.withOpacity(0.8),
          width: 1.0,
        ),),
        contentPadding: EdgeInsets.all(10.h)),
    onChanged: onChanged,
    dropdownMaxHeight: 140.h,
    dropdownWidth: 180.w,
    dropdownDecoration:  BoxDecoration(
      color:purple.withOpacity(0.6),
      borderRadius: BorderRadius.all(Radius.circular(4.r))
    ),
    iconDisabledColor:purple.withOpacity(0.6) ,
    iconEnabledColor: purple.withOpacity(0.6),
    scrollbarAlwaysShow: true,
  );
}

//--------------------------------------------------------------
loadingDialogue(context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          titlePadding: EdgeInsets.zero,
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: SizedBox(
            width: double.infinity,
            height: 150.h,
            child: Align(
              alignment: Alignment.topCenter,
              child: Lottie.asset(
                "assets/lottie/loding.json",
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      });
}
loadingRequestDialogue(context) {
  return showDialog(
    barrierDismissible: false,
    barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Center(
          child: AlertDialog(
            titlePadding: EdgeInsets.zero,
            elevation: 0,
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.only(top: 170.h),
            content: SizedBox(
              width: double.infinity,
              height: 150.h,
              child: Align(
                alignment: Alignment.topCenter,
                child: Lottie.asset(
                  "assets/lottie/grey.json",
                  fit: BoxFit.contain,
                  height: 90.h
                ),
              ),
            ),
          ),
        );
      });
}

//lode one card----------------------------------------------------------------------------
Widget lodeOneData() {
  return Container(
    margin: EdgeInsets.only(left: 18.w, right: 18.w, bottom: 18.h),
    height: 200.h,
    width: 200.w,
    child: Shimmer(
        enabled: true,
        gradient: LinearGradient(
          tileMode: TileMode.mirror,
          // begin: Alignment(0.7, 2.0),
          //end: Alignment(-0.69, -1.0),
          colors: [mainGrey, Colors.white],
          stops: const [0.1, 0.88],
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(10.h),
            ),
          ),
        )),
  );
}
//show no data----------------------------------------------------------------------
Widget noData(context) {
  return Center(
    child: text(
      context,
      "لاتوجد طلبات لعرضها حاليا",
      15,
      black,
    ),
  );
}
//showErrorMassage----------------------------------------------------------------------
showMassage(context,String titleText,String messageText,{IconData? done}) {
  Flushbar(
    flushbarPosition: FlushbarPosition.BOTTOM,
    backgroundColor: white,
    margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
    padding: const EdgeInsets.all(10),
    flushbarStyle: FlushbarStyle.FLOATING,
    borderRadius: BorderRadius.circular(5.r),
    forwardAnimationCurve: Curves.linearToEaseOut,
    reverseAnimationCurve: Curves.easeInOutCubicEmphasized,
    duration: const Duration(seconds: 6),
    leftBarIndicatorColor: done==null?red:green,
    onTap: (bar) {
      bar.dismiss();
    },
    icon: Icon(
      done ?? error,
      color: done==null?red:green,
      size: 30,
    ),
    titleText: text(context, titleText, 16, done==null?red!:green),
    messageText: text(context, messageText, 14, black,
        fontWeight: FontWeight.w200),
  ).show(context);
}
//----------------------------------------------------------------------

successfullyDialog(context,String massage,String lottie,String bottomName,action,{double? height}) {
  return showDialog(
     barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.70),
      context: context,
      builder: (context) {
        return AlertDialog(
          titlePadding: EdgeInsets.zero,
          elevation: 5,
          backgroundColor: white,
          contentPadding: EdgeInsets.only(top: 30.h),
          actionsPadding: EdgeInsets.zero,
          content: SizedBox(
            height: height??200.h,
            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
               text(context, massage, 18, black,align: TextAlign.center),
                Expanded(
                  child: Lottie.asset(
                      lottie,
                      fit: BoxFit.cover,
                      //height: 90.h
                  ),
                ),
              ],
            ),
          ),
           actions: [
             Padding(
               padding:  EdgeInsets.only(bottom: 10.h),
               child: Center(child: buttoms(context, bottomName, 18, Colors.grey, action,backgrounColor: white)),
             )
           ],
        );
      });
}
//snackBar------------------------------------------------------------------------------------
SnackBar snackBar(context, String title, Color? color, IconData? icon) {
  return SnackBar(
      backgroundColor: color ?? white,

      elevation: 20,
      content: Row(
        children: [
          Icon(
            icon,
            color: white,
            size: 20.sp,
          ),
          SizedBox(
            width: 5.w,
          ),
          text(context, title, 13, white)
        ],
      ));
}

Widget mainLoad(context) {
  return SizedBox(
    height: MediaQuery.of(context).size.height,
    width: 100.w,
    child: Padding(
      padding: EdgeInsets.only(bottom: 100.h),
      child: Lottie.asset('assets/lottie/grey.json', height: 200.h),
    ),
  );
}

//--------------------------------------------------------------------------
BoxDecoration decoration(String famusImage) {
  return BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(4.r)),
    image: DecorationImage(
      image: NetworkImage(famusImage),
      colorFilter: ColorFilter.mode(black.withOpacity(0.4), BlendMode.darken),
      fit: BoxFit.cover,
    ),
  );
}

//--------------------------------------------------------------------------
BoxDecoration decoration2() {
  return BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(4.r)),
  );
}

//check internet Connection--------------------------------------------------------------------------
Widget internetConnection(context, {reload}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Spacer(),
      SizedBox(
          height: MediaQuery.of(context).size.height / 5,
          width: MediaQuery.of(context).size.height / 5,
          child: Lottie.asset('assets/lottie/connection.json')),
      SizedBox(
        height: 10.h,
      ),
      text(context, 'لايوجد اتصال بالانترنت', 20, black),
      SizedBox(
        height: 5.h,
      ),
      buttoms(context, 'إعادة تحميل', 14, black, reload,
          backgrounColor: grey!, horizontal: 20),
      Spacer(),
    ],
  );
}
