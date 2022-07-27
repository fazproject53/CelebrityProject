import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:celepraty/Celebrity/orders/gifttingForm.dart';
import 'package:dropdown_below/dropdown_below.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';

import '../../Account/LoggingSingUpAPI.dart';
import '../../MainScreen/main_screen_navigation.dart';
import '../../Users/Exploer/viewData.dart';
import '../../Users/UserRequests/UserReguistMainPage.dart';
import '../Pricing/ModelPricing.dart';
import '../celebrityHomePage.dart';
import 'AdvFormResponse.dart';

class advForm extends StatefulWidget{
  final String? id,image, name;
  const advForm({Key? key,  this.id, this.image, this.name}) : super(key: key);
  _advFormState createState() => _advFormState();
}

class _advFormState extends State<advForm> {
  String? resp;
  Future<Platform>? platforms;
  String? userToken;
  int? _value = 1;
  bool isValue1 = false;
  int? _value2 = 1;
  int? _value3 = 1;
  int? _value4 = 1;
  Future<Pricing>? pricing;
  var platformlist = [];

  bool platformChosen = true;
  String platform = 'اختر منصة العرض';

  List<DropdownMenuItem<Object?>> _dropdownTestItem = [];
  bool activateIt = false;
  var _selectedTest;

  Timer? _timer;

  onChangeDropdownTests(selectedTest) {
    print(selectedTest);
    setState(() {
      _selectedTest = selectedTest;
      platformChosen = true;
      if (selectedTest['no'] == 0) {
        _selectedTest = null;
      }
    });
  }

  List<DropdownMenuItem<Object?>> buildDropdownTestItems(List _testList) {
    List<DropdownMenuItem<Object?>> items = [];
    for (var i in _testList) {
      items.add(
        DropdownMenuItem(

          alignment: Alignment.centerRight,
          value: i,
          child: Text(i['keyword']),

        ),
      );
    }
    return items;
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController description = new TextEditingController();
  final TextEditingController coupon = new TextEditingController();
  List<int> saveList = [];
  DateTime current = DateTime.now();
  bool checkit = false;
  bool warn2 = false;
  bool datewarn2 = false;
  bool warnimage = false;

  File? file;
  Stream? streamm;

  @override
  void initState() {
    DatabaseHelper.getToken().then((value) {
      setState(() {
        userToken = value;
        platforms = fetchPlatform();
        pricing = fetchCelebrityPricingg(widget.id!);
      });
    });
    _dropdownTestItem = buildDropdownTestItems(platformlist);
    super.initState();
  }

  Future<Platform> fetchPlatform() async {
    final response = await http.get(
      Uri.parse('https://mobile.celebrityads.net/api/platforms'),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      return Platform.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load activity');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: drowAppBar('طلب اعلان', context),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                  alignment: Alignment.bottomRight,
                  children: [ Container(height: 340.h,
                      width: 1000.w,
                      child: Image.network(widget.image!, color: Colors.black45,
                        colorBlendMode: BlendMode.darken,
                        fit: BoxFit.cover,)),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        'اطلب اعلان\n' + 'شخصي من ' + widget.name! + ' الان',
                        style: TextStyle(fontWeight: FontWeight.normal,
                            fontSize: 17,
                            color: white,
                            fontFamily: 'Cairo'),),
                    ),
                  ]),
              Container(
                child: Form(
                  key: _formKey,
                  child: paddingg(12, 12, 5, Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 20.h,),
                        padding(10, 12, Container(alignment: Alignment.topRight,
                            child: text(
                              context, ' قم بملئ   البيانات التالية', 18,
                              textBlack, fontWeight: FontWeight.normal,
                              family: 'Cairo',)),),

                        //========================== form ===============================================
                        FutureBuilder(
                            future: pricing,
                            builder: ((context, AsyncSnapshot<
                                Pricing> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center();
                              } else if (snapshot.connectionState ==
                                  ConnectionState.active ||
                                  snapshot.connectionState ==
                                      ConnectionState.done) {
                                if (snapshot.hasError) {
                                  return Center(
                                      child: Text(snapshot.error.toString()));
                                  //---------------------------------------------------------------------------
                                } else if (snapshot.hasData) {
                                  snapshot.data!.data != null &&
                                      snapshot.data!.data!.price!
                                          .advertisingPriceFrom != null &&
                                      snapshot.data!.data!.price!
                                          .advertisingPriceTo != null ?
                                  activateIt = true : null;
                                  return SizedBox();
                                } else {
                                  return const Center(
                                      child: Text('لايوجد لينك لعرضهم حاليا'));
                                }
                              } else {
                                return Center(
                                    child: Text(
                                        'State: ${snapshot.connectionState}'));
                              }
                            })),
                        SizedBox(height: 30,),
                        FutureBuilder(
                            future: platforms,
                            builder: ((context, AsyncSnapshot<
                                Platform> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return paddingg(15, 15, 12,
                                  DropdownBelow(
                                    itemWidth: 380.w,

                                    ///text style inside the menu
                                    itemTextstyle: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: black,
                                      fontFamily: 'Cairo',),

                                    ///hint style
                                    boxTextstyle: TextStyle(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w400,
                                        color: grey,
                                        fontFamily: 'Cairo'),

                                    ///box style
                                    boxPadding:
                                    EdgeInsets.fromLTRB(13.w, 12.h, 13.w, 12.h),
                                    boxWidth: 500.w,
                                    boxHeight: 40.h,
                                    boxDecoration: BoxDecoration(
                                        border: Border.all(
                                            color: newGrey, width: 0.5),
                                        color: lightGrey.withOpacity(0.10),
                                        borderRadius: BorderRadius.circular(
                                            8.r)),

                                    ///Icons
                                    icon: const Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.grey,
                                    ),
                                    hint: Text(
                                      platform,
                                      textDirection: TextDirection.rtl,
                                    ),
                                    value: _selectedTest,
                                    items: _dropdownTestItem,
                                    onChanged: onChangeDropdownTests,
                                  ),
                                );
                              } else if (snapshot.connectionState ==
                                  ConnectionState.active ||
                                  snapshot.connectionState ==
                                      ConnectionState.done) {
                                if (snapshot.hasError) {
                                  return Center(
                                      child: Text(snapshot.error.toString()));
                                  //---------------------------------------------------------------------------
                                } else if (snapshot.hasData) {
                                  _dropdownTestItem.isEmpty ? {
                                    platformlist.add({
                                      'no': 0,
                                      'keyword': 'اختر منصة الاعلان'
                                    }),
                                    for(int i = 0; i <
                                        snapshot.data!.data!.length; i++) {
                                      platformlist.add({
                                        'no': snapshot.data!.data![i].id!,
                                        'keyword': '${snapshot.data!.data![i]
                                            .name!}'
                                      }),
                                    },
                                    _dropdownTestItem =
                                        buildDropdownTestItems(platformlist),
                                  } : null;

                                  return paddingg(15, 15, 12,
                                    DropdownBelow(
                                      itemWidth: 380.w,

                                      ///text style inside the menu
                                      itemTextstyle: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: black,
                                        fontFamily: 'Cairo',),

                                      ///hint style
                                      boxTextstyle: TextStyle(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w400,
                                          color: grey,
                                          fontFamily: 'Cairo'),

                                      ///box style
                                      boxPadding:
                                      EdgeInsets.fromLTRB(
                                          13.w, 12.h, 13.w, 12.h),
                                      boxWidth: 500.w,
                                      boxHeight: 40.h,
                                      boxDecoration: BoxDecoration(
                                          border: Border.all(
                                              color: newGrey, width: 0.5),
                                          color: lightGrey.withOpacity(0.10),
                                          borderRadius: BorderRadius.circular(
                                              8.r)),

                                      ///Icons
                                      icon: const Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.grey,
                                      ),
                                      hint: Text(
                                        platform,
                                        textDirection: TextDirection.rtl,
                                      ),
                                      value: _selectedTest,
                                      items: _dropdownTestItem,
                                      onChanged: onChangeDropdownTests,
                                    ),
                                  );
                                } else {
                                  return const Center(
                                      child: Text('لايوجد لينك لعرضهم حاليا'));
                                }
                              } else {
                                return Center(
                                    child: Text(
                                        'State: ${snapshot.connectionState}'));
                              }
                            })),

                        padding(10, 20, text(context, platformChosen &&
                            _selectedTest == null
                            ? ''
                            : 'الرجاء اختيار منصة الاعلان', 13, _selectedTest !=
                            null ? white : red!,)),
                        paddingg(15.w, 15.w, 0.h, textFieldDesc(
                          context, ' الوصف الخاص بالاعلان', 14.sp, true,
                          description, (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'حقل اجباري';
                          }
                          return null;
                        },),),
                        paddingg(15.w, 15.w, 12.h, textFieldNoIcon(
                            context,
                            'ادخل كود الخصم',
                            14.sp,
                            false,
                            coupon, (String? value) {
                          return null;
                        },
                            true),),

                        SizedBox(height: 20,),

                        padding(8, 20, text(context, 'مالك الاعلان', 14, black,
                            fontWeight: FontWeight.bold)),
                        Container(
                          margin: EdgeInsets.only(
                              top: 3.h, right: 2.w),
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  Transform.scale(
                                    scale: 0.8,
                                    child: Radio<int>(
                                        value: 1,
                                        groupValue:
                                        _value,
                                        activeColor:
                                        blue,
                                        onChanged:
                                            (value) {
                                          setState(() {
                                            _value =
                                                value;
                                            isValue1 =
                                            false;
                                          });
                                        }),
                                  ),
                                  text(
                                      context,
                                      "فرد",
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
                                    child: Radio<int>(
                                        value: 2,
                                        groupValue:
                                        _value,
                                        activeColor:
                                        blue,
                                        onChanged:
                                            (value) {
                                          setState(() {
                                            _value =
                                                value;
                                            isValue1 =
                                            true;
                                          });
                                        }),
                                  ),
                                  text(
                                      context,
                                      "مؤسسة",
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
                                    child: Radio<int>(
                                        value: 3,
                                        groupValue:
                                        _value,
                                        activeColor:
                                        blue,
                                        onChanged:
                                            (value) {
                                          setState(() {
                                            _value =
                                                value;
                                            isValue1 =
                                            true;
                                          });
                                        }),
                                  ),
                                  text(
                                      context,
                                      "شركة",
                                      14,
                                      ligthtBlack,
                                      family:
                                      'DINNextLTArabic'),
                                ],
                              ),
                            ],
                          ),
                        ),

                        padding(8, 20, text(context, 'صفة الاعلان', 14, black,
                            fontWeight: FontWeight.bold)),
                        Container(
                          margin: EdgeInsets.only(
                              top: 3.h, right: 2.w),
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  Transform.scale(
                                    scale: 0.8,
                                    child: Radio<int>(
                                        value: 1,
                                        groupValue:
                                        _value2,
                                        activeColor:
                                        blue,
                                        onChanged:
                                            (value) {
                                          setState(() {
                                            _value2 =
                                                value;
                                            isValue1 =
                                            false;
                                          });
                                        }),
                                  ),
                                  text(
                                      context,
                                      "يلزم الحضور",
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
                                    child: Radio<int>(
                                        value: 2,
                                        groupValue:
                                        _value2,
                                        activeColor:
                                        blue,
                                        onChanged:
                                            (value) {
                                          setState(() {
                                            _value2 =
                                                value;
                                            isValue1 =
                                            true;
                                          });
                                        }),
                                  ),
                                  text(
                                      context,
                                      "لا يلزم الحضور",
                                      14,
                                      ligthtBlack,
                                      family:
                                      'DINNextLTArabic'),
                                ],
                              ),
                            ],
                          ),
                        ),

                        padding(8, 20, text(context, 'نوع الاعلان', 14, black,
                            fontWeight: FontWeight.bold)),
                        Container(
                          margin: EdgeInsets.only(
                              top: 3.h, right: 2.w),
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  Transform.scale(
                                    scale: 0.8,
                                    child: Radio<int>(
                                        value: 2,
                                        groupValue:
                                        _value3,
                                        activeColor:
                                        blue,
                                        onChanged:
                                            (value) {
                                          setState(() {
                                            _value3 =
                                                value;
                                            isValue1 =
                                            false;
                                          });
                                        }),
                                  ),
                                  text(
                                      context,
                                      "خدمة",
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
                                    child: Radio<int>(
                                        value: 1,
                                        groupValue:
                                        _value3,
                                        activeColor:
                                        blue,
                                        onChanged:
                                            (value) {
                                          setState(() {
                                            _value3 =
                                                value;
                                            isValue1 =
                                            true;
                                          });
                                        }),
                                  ),
                                  text(
                                      context,
                                      "منتج",
                                      14,
                                      ligthtBlack,
                                      family:
                                      'DINNextLTArabic'),
                                ],
                              ),
                            ],
                          ),
                        ),

                        padding(8, 20, text(context, 'توقيت الاعلان', 14, black,
                            fontWeight: FontWeight.bold)),
                        Container(
                          margin: EdgeInsets.only(
                              top: 3.h, right: 2.w),
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  Transform.scale(
                                    scale: 0.8,
                                    child: Radio<int>(
                                        value: 1,
                                        groupValue:
                                        _value4,
                                        activeColor:
                                        blue,
                                        onChanged:
                                            (value) {
                                          setState(() {
                                            _value4 =
                                                value;
                                            isValue1 =
                                            false;
                                          });
                                        }),
                                  ),
                                  text(
                                      context,
                                      "صباحا",
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
                                    child: Radio<int>(
                                        value: 2,
                                        groupValue:
                                        _value4,
                                        activeColor:
                                        blue,
                                        onChanged:
                                            (value) {
                                          setState(() {
                                            _value4 =
                                                value;
                                            isValue1 =
                                            true;
                                          });
                                        }),
                                  ),
                                  text(
                                      context,
                                      "مساء",
                                      14,
                                      ligthtBlack,
                                      family:
                                      'DINNextLTArabic'),
                                ],
                              ),
                            ],
                          ),
                        ),

                        //


                        paddingg(15, 15, 30, uploadImg(50, 45, text(context,
                            file != null
                                ? 'تغيير الصورة'
                                : 'فم ارفاق ملف الاعلان', 12, black), () {
                          getFile(context);
                        }),),
                        InkWell(
                            onTap: () {
                              file != null ? showDialog(
                                useSafeArea: true,
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  _timer = Timer(Duration(seconds: 2), () {
                                    Navigator.of(context)
                                        .pop(); // == First dialog closed
                                  });
                                  return
                                    Container(
                                        height: double.infinity,
                                        child: Image.file(file!));
                                },
                              ) : null;
                            },
                            child: paddingg(15.w, 30.w, file != null ? 10.h : 0
                                .h, Row(
                              children: [
                                file != null ? Icon(
                                  Icons.image, color: newGrey,) : SizedBox(),
                                SizedBox(width: file != null ? 5.w : 0.w),
                                text(context, warnimage && file == null
                                    ? 'الرجاء اضافة صورة'
                                    : file != null ? 'معاينة الصورة' : '',
                                  file != null ? 15 : 13,
                                  file != null ? black : red!,),
                              ],
                            ))),

                        paddingg(15, 15, 15, SizedBox(height: 45.h,
                            child: InkWell(
                              child: gradientContainerNoborder(97, Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(scheduale, color: white,),
                                  SizedBox(width: 15.w,),
                                  text(context, current.day != DateTime
                                      .now()
                                      .day ? current.year.toString() + '/' +
                                      current.month.toString() + '/' +
                                      current.day.toString() : 'تاريخ الاعلان',
                                      15.sp, white,
                                      fontWeight: FontWeight.bold),
                                ],
                              )), onTap: () async {
                              DateTime? endDate =
                              await showDatePicker(
                                  builder: (context, child) {
                                    return Theme(
                                        data: ThemeData.light().copyWith(
                                            colorScheme:
                                            const ColorScheme.light(
                                                primary: purple,
                                                onPrimary: white)),
                                        child: child!);
                                  }
                                  context:context,
                                  initialDate:
                                  current,
                                  firstDate:
                                  DateTime(2000),
                                  lastDate: DateTime(2100));

                              if (endDate == null)
                                return;
                              setState(() {
                                current = endDate;
                              });
                              FocusManager.instance.primaryFocus
                                  ?.unfocus();
                            },
                            )),),
                        paddingg(15.w, 20.w, 2.h, text(
                          context, datewarn2 ? 'الرجاء اختيار تاريخ النشر' : '',
                          13, current.day != DateTime
                            .now()
                            .day ? white : red!,)),

                        paddingg(0, 0, 12, CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: text(context,
                              'عند طلب الاهداء، فإنك توافق على شروط الإستخدام و سياسة الخصوصية الخاصة بـ',
                              10, black, fontWeight: FontWeight.bold,
                              family: 'Cairo'),
                          value: checkit,
                          subtitle: Text(warn2
                              ? 'حتى تتمكن من الطلب  يجب الموافقة على الشروط والاحكام'
                              : '',
                            style: TextStyle(color: red, fontSize: 12.sp),),
                          selectedTileColor: black,
                          onChanged: (value) {
                            setState(() {
                              setState(() {
                                checkit = value!;
                              });
                            });
                          },),),
                        const SizedBox(height: 30,),
                        checkit && activateIt ?
                        padding(15, 15, gradientContainerNoborder(getSize(
                            context).width, buttoms(
                            context, 'رفع الطلب', 15, white, () {
                          _formKey.currentState!.validate() ? {
                            checkit && current.day != DateTime
                                .now()
                                .day && file != null && platformChosen == true
                                ? {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context2) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  addAdOrder().then((value) => {
                                    value.contains('true')
                                        ? {
                                      gotoPageAndRemovePrevious(context, UserRequestMainPage()),
                                      Navigator.pop(context2),
                                      //done
                                      showMassage(context2, 'تم بنجاح',
                                          value.replaceAll('true', ''),
                                          done: done),
                                    }
                                        :  value == 'SocketException'?
                                    { Navigator.pop(context2),
                                      showMassage(
                                        context2,
                                        'خطا',
                                        'فشل الاتصال بالانترنت ',
                                      )}
                                        :{
                                      value == 'serverException'? {
                                        Navigator.pop(context2),
                                        showMassage(
                                          context2,
                                          'خطا',
                                          'حدثت مشكلة في الخادم سنقوم باصلاحها قريبا ',
                                        )
                                      }:{
                                        Navigator.pop(context2),
                                        showMassage(
                                          context2,
                                          'خطا',
                                          'حدث خطا ما الرجاء المحاولة لاحقا ',
                                        )
                                      }

                                    }
                                  });

                                  // == First dialog closed
                                  return Align(
                                    alignment: Alignment.center,
                                    child: Lottie.asset(
                                      "assets/lottie/loding.json",
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                              ),


                            }
                                : setState(() {
                              _selectedTest == null
                                  ? platformChosen = false
                                  : platformChosen = true;
                              !checkit ? warn2 = true : false;
                              current.day == DateTime
                                  .now()
                                  .day ? datewarn2 = true : false;
                              file == null ? warnimage = true : false;
                            }),

                          } : null;
                        }))) :

                        padding(15, 15, Container(width: getSize(context).width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.r),
                              color: grey,),
                            child: buttoms(
                                context, 'رفع الطلب', 15, white, () {})
                        ),),
                        const SizedBox(height: 30,),

                      ]),
                  ),),),
            ],
          ),
        ),),
    );
  }

  buildCkechboxList(list) {
    return SizedBox(
      height: 150.h,
      child: Padding(
        padding: const EdgeInsets.all(2.0),

      ),
    );
  }

  Future<File?> getFile(context) async {
    PickedFile? pickedFile =
    await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return null;
    }
    final File f = File(pickedFile.path);
    final Directory directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final String fileName = Path.basename(pickedFile.path);
    final String fileExtension = Path.extension(fileName);
    File newImage = await f.copy('$path/$fileName');
    if (fileExtension == ".png" || fileExtension == ".jpg") {
      setState(() {
        file = newImage;
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(
        duration: Duration(seconds: 1),
        content: Text(
            "امتداد الصورة المسموح به jpg, png",
            style: TextStyle(color: Colors.red)),
      ));
    }

    // }else{ ScaffoldMessenger.of(context)
    //     .showSnackBar(const SnackBar(
    //   content: Text(
    //       "امتداد الصورة غير مسموح به",style: TextStyle(color: Colors.red)),
    // ));}
  }

  Future<Pricing> fetchCelebrityPricingg(String id) async {
    String token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiMDAzNzUwY2MyNjFjNDY1NjY2YjcwODJlYjgzYmFmYzA0ZjQzMGRlYzEyMzAwYTY5NTE1ZDNlZTYwYWYzYjc0Y2IxMmJiYzA3ZTYzODAwMWYiLCJpYXQiOjE2NTMxMTY4MjcuMTk0MDc3OTY4NTk3NDEyMTA5Mzc1LCJuYmYiOjE2NTMxMTY4MjcuMTk0MDg0ODgyNzM2MjA2MDU0Njg3NSwiZXhwIjoxNjg0NjUyODI3LjE5MDA0ODkzMzAyOTE3NDgwNDY4NzUsInN1YiI6IjExIiwic2NvcGVzIjpbXX0.GUQgvMFS-0VA9wOAhHf7UaX41lo7m8hRm0y4mI70eeAZ0Y9p2CB5613svXrrYJX74SfdUM4y2q48DD-IeT67uydUP3QS9inIyRVTDcEqNPd3i54YplpfP8uSyOCGehmtl5aKKEVAvZLOZS8C-aLIEgEWC2ixwRKwr89K0G70eQ7wHYYHQ3NOruxrpc_izZ5awskVSKwbDVnn9L9-HbE86uP4Y8B5Cjy9tZBGJ-6gJtj3KYP89-YiDlWj6GWs52ShPwXlbMNFVDzPa3oz44eKZ5wNnJJBiky7paAb1hUNq9Q012vJrtazHq5ENGrkQ23LL0n61ITCZ8da1RhUx_g6BYJBvc_10nMuwWxRKCr9l5wygmIItHAGXxB8f8ypQ0vLfTeDUAZa_Wrc_BJwiZU8jSdvPZuoUH937_KcwFQScKoL7VuwbbmskFHrkGZMxMnbDrEedl0TefFQpqUAs9jK4ngiaJgerJJ9qpoCCn4xMSGl_ZJmeQTQzMwcLYdjI0txbSFIieSl6M2muHedWhWscXpzzBhdMOM87cCZYuAP4Gml80jywHCUeyN9ORVkG_hji588pvW5Ur8ZzRitlqJoYtztU3Gq2n6sOn0sRShjTHQGPWWyj5fluqsok3gxpeux5esjG_uLCpJaekrfK3ji2DYp-wB-OBjTGPUqlG9W_fs';
    final response = await http.get(
        Uri.parse('https://mobile.celebrityads.net/api/celebrity/price/$id'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //print(response.body);
      return Pricing.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load activity');
    }
  }

  Future<String> addAdOrder() async {
    try {
      var stream;
      var length;
      var uri;
      var request;
      Map<String, String> headers;
      var response;
      var body;
      String message = '';
      stream = await http.ByteStream(DelegatingStream.typed(file!.openRead()));
      // get file length
      length = await file!.length();

      // string to uri
      uri =
          Uri.parse(
              "https://mobile.celebrityads.net/api/order/advertising/add");

      headers = {
        "Accept": "application/json",
        "Authorization": "Bearer $userToken"
      };
      // create multipart request
      request = http.MultipartRequest("POST", uri);
      var multipartFile = http.MultipartFile('file', stream, length,
          filename: Path.basename(file!.path));
      // multipart that takes file
      // multipartFile = new http.MultipartFile('file', file!.bytes.toList(), length,
      //     filename: file!.name),
      // listen for response

      ///value
      ///value1
      ///value2
      ///value3

      request.files.add(multipartFile);
      request.headers.addAll(headers);
      request.fields["celebrity_id"] = widget.id.toString();
      request.fields["date"] = current.toString();
      request.fields[" platform_id"] =
          platformlist.indexOf(_selectedTest).toString();
      request.fields["description"] = description.text;
      request.fields["celebrity_promo_code"] = coupon.text;

      request.fields["ad_owner_id"] = _value.toString();
      request.fields["ad_feature_id"] = _value2.toString();
      request.fields["ad_timing_id"] = _value4.toString();

      request.fields["advertising_ad_type_id"] = _value3.toString();
      request.fields["advertising_name"] = '';
      request.fields["advertising_link"] = '';
      response = await request.send();
      // response.stream.transform(utf8.decoder).listen((value) async {
      //   print(value);
      //   setState(()  {
      //     Responsee rr = Responsee.fromJson(jsonDecode(value));
      //     resp = 'تم';
      //
      //   });
      // });

      http.Response respo = await http.Response.fromStream(response);
      print("Result: ${response.statusCode}");
      return jsonDecode(respo.body)['message']['ar']+jsonDecode(respo.body)['success'].toString();
    } catch (e) {
      if (e is SocketException) {
        return 'SocketException';
      } else if (e is TimeoutException) {
        return 'TimeoutException';
      } else {
        return 'serverException';
      }
    }
  }
}

class Platform {
  bool? success;
  List<Data>? data;
  Message? message;

  Platform({this.success, this.data, this.message});

  Platform.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    message =
    json['message'] != null ? new Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? nameEn;

  Data({this.id, this.name, this.nameEn});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameEn = json['name_en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['name_en'] = this.nameEn;
    return data;
  }
}

class Message {
  String? en;
  String? ar;

  Message({this.en, this.ar});

  Message.fromJson(Map<String, dynamic> json) {
    en = json['en'];
    ar = json['ar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en'] = this.en;
    data['ar'] = this.ar;
    return data;
  }
}