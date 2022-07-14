import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'Singup.dart';
import 'package:email_validator/email_validator.dart';

import '../ModelAPI/ModelsAPI.dart';

GlobalKey<FormState> userKey = GlobalKey();
GlobalKey<FormState> celebratyKey = GlobalKey();
int userContry = 0, celContry = 0, celCatogary = 0;

String? empty(value) {
  if (value.isEmpty) {
    return "املء الحقل اعلاه";
  }
  return null;
}

String? code(value) {
  if (value.isEmpty) {
    return "املء الحقل اعلاه";
  }
  if (value.length != 6) {
    return "عليك ادخال 6 ارقام";
  }
  return null;
}

String? valedEmile(value) {
  if (value.trim().isEmpty) {
    return "املء الحقل اعلاه";
  }

  if (EmailValidator.validate(value.trim()) == false) {
    return "البريد الالكتروني غير صالح";
  }
  return null;
}

String? valedpass(value) {
  if (value.trim().isEmpty) {
    return "املء الحقل اعلاه";
  }

  if (value.length < 6) {
    return "كلمة المرور يجب ان تكون اكثر من 5 خانات";
  }
  return null;
}

//------------------------------------------------------------------------------------------
userForm(context, List<String> countries) {
  return Form(
    key: userKey,
    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
//name------------------------------------------
      textField(
        context,
        nameIcon,
        "اسم المستخدم",
        14,
        false,
        userNameUserController,
        empty,
        keyboardType: TextInputType.text,
        inputFormatters: [
          FilteringTextInputFormatter(RegExp(r'[a-zA-Z]|[@]|[_]|[0-9]'),
              allow: true)
        ],
      ),
      SizedBox(
        height: 15.h,
      ),

//email------------------------------------------
      textField(
        context,
        emailIcon,
        "البريد الالكتروني",
        14,
        false,
        emailUserController,
        valedEmile,
        keyboardType: TextInputType.emailAddress,
        inputFormatters: [
          FilteringTextInputFormatter(RegExp(r'[a-zA-Z]|[@]|[_]|[0-9]|[.]'),
              allow: true)
        ],
      ),
      SizedBox(
        height: 15.h,
      ),
      //pass------------------------------------------
      textField(context, passIcon, "كلمة المرور", 14, true, passUserController,
          valedpass),
      SizedBox(
        height: 15.h,
      ),
//country------------------------------------------
      drowMenu("الدولة", countryIcon, 14, countries, (va) {
        userContry = countries.indexOf(va!) + 1;
      }, (val) {
        if (val == null) {
          return "اختر الدولة";
        } else {
          return null;
        }
      }),
      //getMen(),
      SizedBox(
        height: 15.h,
      ),
    ]),
  );
}

//CELEBRITY FORM-----------------------------------------------------------
celebratyForm(context, List<String> countries, List<String> catogary) {
  return Form(
    key: celebratyKey,
    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
//name------------------------------------------
      textField(
        context,
        nameIcon,
        "اسم المستخدم",
        14,
        false,
        userNameCeleController,
        empty,
        keyboardType: TextInputType.text,
        inputFormatters: [
          FilteringTextInputFormatter(RegExp(r'[a-zA-Z]|[@]|[_]|[0-9]'),
              allow: true)
        ],
      ),
      SizedBox(
        height: 15.h,
      ),
      //email------------------------------------------
      textField(
        context,
        emailIcon,
        "البريد الالكتروني",
        14,
        false,
        emailCeleController,
        valedEmile,
        keyboardType: TextInputType.emailAddress,
        inputFormatters: [
          FilteringTextInputFormatter(RegExp(r'[a-zA-Z]|[@]|[_]|[0-9]|[.]'),
              allow: true)
        ],
      ),
      SizedBox(
        height: 15.h,
      ),
      //pass------------------------------------------
      textField(context, passIcon, "كلمة المرور", 14, true, passCeleController,
          valedpass),
      SizedBox(
        height: 15.h,
      ),
//country------------------------------------------
      drowMenu("الدولة", countryIcon, 14, countries, (va) {
        celContry = countries.indexOf(va!) + 1;
      }, (val) {
        if (val == null) {
          return "اختر الدولة";
        } else {
          return null;
        }
      }),

//catogary------------------------------------------

      SizedBox(
        height: 15.h,
      ),

      drowMenu("التصنيف", catogaryIcon, 14, catogary, (va) {
        celCatogary = catogary.indexOf(va!) + 1;
      }, (val) {
        if (val == null) {
          return "اختر التصنيف";
        } else {
          return null;
        }
      }),

      SizedBox(
        height: 15.h,
      ),
    ]),
  );
}
