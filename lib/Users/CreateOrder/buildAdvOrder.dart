import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:celepraty/Celebrity/PrivacyPolicy/ModelPrivicyPolicy.dart';
import 'package:celepraty/MainScreen/main_screen_navigation.dart';
import 'package:celepraty/celebrity/setting/profileInformation.dart';
import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter/material.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';
import '../../Account/LoggingSingUpAPI.dart';
import '../../ModelAPI/ModelsAPI.dart' as cat;
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';

import '../UserRequests/UserAds/UserAdvertisments.dart';
import '../UserRequests/UserReguistMainPage.dart';



class buildAdvOrder extends StatefulWidget {
  _buildAdvOrderState createState() => _buildAdvOrderState();
}

class _buildAdvOrderState extends State<buildAdvOrder> {
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();

  int? celebrityId;
  int current = 0;
  bool isCompleted = false;
  bool platformChosen = true;
  final TextEditingController subject = new TextEditingController();
  final TextEditingController desc = new TextEditingController();
  final TextEditingController pageLink = new TextEditingController();
  final TextEditingController coupon = new TextEditingController();

  final TextEditingController name = new TextEditingController();
  final TextEditingController email = new TextEditingController();
  final TextEditingController description = new TextEditingController();
  final TextEditingController couponcode = new TextEditingController();

  Future<Platform>? platforms;
  Future<Budget>? budgets;
  int? _value = 1;
  bool isValue1 = false;
  int? _value5 = 1;
  int? _value6 = 1;
  int? _value2 = 1;
  int? _value3 = 1;
  int? _value4 = 1;

  bool warnimage = false;

  static double ww = 0.0;
  List sampleData = [];
  DateTime currentt = DateTime.now();
  static List<int> selectedIndex = [];
  String budgetn = 'الميزانية ';
  String countryn = 'الدولة';
  String categoryn = 'التصنيف';
  Future<CountryL>? countries;
  Future<CategoryL>? categories;

  File? file;
  bool checkit = false;
  bool checkit2 = false;
  File? img;
  DateTime date = DateTime.now();
  bool warn2 = false;
  bool datewarn2 = false;
  int? gender;
  int? status;
  String? userToken;

  var platformlist =[];
  var budgetlist = [];
  var countrylist = [];
  var categorylist = [];

  String platform = 'اختر منصة العرض';
  List<DropdownMenuItem<Object?>> _dropdownTestItems = [];
  List<DropdownMenuItem<Object?>> _dropdownTestItems2 = [];
  List<DropdownMenuItem<Object?>> _dropdownTestItems3 = [];
  List<DropdownMenuItem<Object?>> _dropdownTestItems4 = [];

  ///_value
  var _selectedTest;

  Timer? _timer;

  onChangeDropdownTests(selectedTest) {

    setState(() {
      print(_selectedTest);
      _selectedTest = selectedTest;
    });
  }

  var _selectedTest2;

  onChangeDropdownTests2(selectedTest) {
    print(selectedTest);
    print(categorylist.indexOf(selectedTest).toString());
    setState(() {

      _selectedTest2 = selectedTest;
    });
  }

  var _selectedTest3;

  onChangeDropdownTests3(selectedTest) {
    print(selectedTest);
    setState(() {
      _selectedTest3 = selectedTest;
    });
  }

  var _selectedTest4;

  onChangeDropdownTests4(selectedTest) {
    setState(() {

      print(selectedTest);
      _selectedTest4 = selectedTest;
      if(selectedTest['no'] == 0){
        _selectedTest4 =null;
      }
    });
  }
  @override
  void dispose() {
    super.dispose();
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

  @override
  void initState() {
    DatabaseHelper.getToken().then((value) {
      setState(() {
        userToken = value;
      });
    });
    budgets = fetchBudget();
    platforms = fetchPlatform();
    countries = fetCountries();
    categories = fetCategories();
    _dropdownTestItems = buildDropdownTestItems(budgetlist);
    _dropdownTestItems2 = buildDropdownTestItems(categorylist);
    _dropdownTestItems3 = buildDropdownTestItems(countrylist);
    _dropdownTestItems4 = buildDropdownTestItems(platformlist);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      ww = getSize(context).width;
    });

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: isCompleted ? null : drowAppBar('انشاء طلب اعلان', context),
        body:Stepper(
                margin: EdgeInsets.symmetric(horizontal: 24),
                steps: getSteps(),
                type: StepperType.horizontal,
                onStepContinue: () {
                  bool isLastStep = current == getSteps().length - 1;
                  if (isLastStep) {
                    setState(() {
                      _formKey3.currentState!.validate()? {
                        checkit2 && date.day != DateTime.now().day && file != null ?{
                          showDialog(
                          context: context,
                          barrierDismissible: false,
    builder: (BuildContext context) {
      FocusManager.instance.primaryFocus
          ?.unfocus();
      addAdOrder().then((value) => {
        Navigator.of(context).pop(),
      print(value),
      ScaffoldMessenger.of(context)
          .showSnackBar(
      SnackBar(
      duration:  Duration(seconds: 1),
      content: Text(value != null? value : 'تم ارسال الطلب',),
      )),
      
      }).whenComplete(() => { Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                UserRequestMainPage()),
      ),});

        // == First dialog closed
    return
    Align(
    alignment: Alignment.center,
    child: Lottie.asset(
    "assets/lottie/loding.json",
    fit: BoxFit.cover,
    ),
    );},
    ),

    }
        : setState((){
    _selectedTest4 == null? platformChosen= false: platformChosen = true;
    date.day == DateTime.now().day? datewarn2 = true: false;
    file == null? warnimage =true:false;}),

    }:null;


                    });
                  }
                  setState(() {
                    current == 1
                        ? selectedIndex.isEmpty
                            ? null
                            : current += 1
                        : isLastStep?current = current: current += 1;
                  });
                },
                onStepCancel: () {
                  current == 0
                      ? null
                      : setState(() {
                          current -= 1;
                          selectedIndex.clear();
                          file =null;
                          date = DateTime.now();
                          checkit2 = false;
                          _selectedTest4 = null;
                        });
                },
                currentStep: current,
                onStepTapped: (value) => setState(() {
                  selectedIndex.isNotEmpty || current == 0?
                  current = value : current;

                }),
                controlsBuilder: (context, controls) {
                  return Row(
                    children: [
                      TextButton(
                        onPressed: controls.onStepContinue,
                        child: (current != getSteps().length - 1 &&
                                current != getSteps().length - 3)
                            ? const Text('متابعة')
                            : current != getSteps().length - 3 && file != null && date.day != DateTime.now().day && _selectedTest4 != null
                                ? const Text('تاكيد')
                                : checkit == true &&
                                        current != getSteps().length - 1
                                    ? const Text('متابعة')
                                    : const Text(''),
                      ),
                      TextButton(
                        onPressed: controls.onStepCancel,
                        child: current != getSteps().length - 3
                            ? const Text('رجوع')
                            : const Text(''),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }

  List<Step> getSteps() {
    return [
      Step(
        state: current > 0 ? StepState.complete : StepState.indexed,
        title: Text('خطوة 1'),
        content: stepOne(),
        isActive: current >= 0,
      ),
      Step(
        state: current > 1 ? StepState.complete : StepState.indexed,
        title: Text('خطوة 2'),
        content: stepTwo(),
        isActive: current >= 1,
      ),
      Step(
        state: current > 1 ? StepState.complete : StepState.indexed,
        title: Text('خطوة 3'),
        content: stepThree(),
        isActive: current >= 2,
      ),
    ];
  }

  Future<CategoryL> fetCategories() async {
    final response = await http.get(
      Uri.parse('https://mobile.celebrityads.net/api/categories'),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      return CategoryL.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load activity');
    }
  }



  Future<CountryL> fetCountries() async {
    final response = await http.get(
      Uri.parse('https://mobile.celebrityads.net/api/countries'),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      return CountryL.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load activity');
    }
  }

  Future<Budget> fetchBudget() async {
    final response = await http.get(
      Uri.parse('https://mobile.celebrityads.net/api/budgets'),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      return Budget.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load activity');
    }
  }


  Future<Filter> fetchCelebrity(int country, int category, int budget,int status, int gender ) async {
    final response = await http.get(Uri.parse(
        'https://mobile.celebrityads.net/api/celebrity/search?country_id=$country&category_id=$category&account_status_id=$status&gender_id=$gender&budget_id=$budget'));
    if (response.statusCode == 200) {
      final body = response.body;
     Filter filter =Filter.fromJson(jsonDecode(body));
      print("Reading category from network------------ ");
      return filter;
    } else {
      throw Exception('Failed to load Category');
    }
  }

  Future<String> addAdOrder() async {
    var stream;
    var length;
    var uri;
    var request;
    Map<String, String> headers;
    var response ;

    stream = await http.ByteStream(DelegatingStream.typed(file!.openRead()));
    // get file length
    length = await file!.length();

    // string to uri
    uri = Uri.parse("https://mobile.celebrityads.net/api/order/advertising/add");

    headers = {
      "Accept": "application/json",
      "Authorization": "Bearer $userToken"
    };
    // create multipart request
    request = http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: Path.basename(file!.path));
    // multipart that takes file
    // multipartFile = new http.MultipartFile('file', file!.bytes.toList(), length,
    //     filename: file!.name),
    print('the id is = ' + celebrityId.toString());
    // listen for response
    request.files.add(multipartFile);
    request.headers.addAll(headers);
    request.fields["celebrity_id"] =celebrityId != null?celebrityId.toString(): null;
    request.fields["date"]= date.toString();
    request.fields["description"]= desc.text;
    request.fields[" platform_id"]= platformlist.indexOf(_selectedTest4).toString();
    request.fields["celebrity_promo_code_id"]= couponcode.text;
    request.fields["ad_owner_id"]= _value.toString();
    request.fields["ad_feature_id"]= _value2.toString();
    request.fields["ad_timing_id"]= _value4.toString();
    request.fields["advertising_ad_type_id"]= _value3.toString();
    request.fields["advertising_name"]= subject.text;
    request.fields["advertising_link"]= pageLink.text;

    response = await request.send();
    http.Response respo = await http.Response.fromStream(response);
    print(respo.body);
    return jsonDecode(respo.body)['message']['ar'];

  }

  stepOne() {
    return SingleChildScrollView(
      child: Container(
        child: Form(
          key: _formKey2,
          child: paddingg(
            8,
            8,
            5,
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              SizedBox(
                height: 20.h,
              ),
              padding(
                10,
                12,
                Container(
                    alignment: Alignment.topRight,
                    child: text(
                      context,
                      ' قم بملئ   \n البيانات التالية',
                      18,
                      textBlack,
                      fontWeight: FontWeight.bold,
                      family: 'DINNextLTArabic-Regular-2',
                    )),
              ),

              //========================== form ===============================================

              FutureBuilder(
                  future: countries,
                  builder: ((context, AsyncSnapshot<CountryL> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center();
                    } else if (snapshot.connectionState ==
                            ConnectionState.active ||
                        snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return Center(child: Text(snapshot.error.toString()));
                        //---------------------------------------------------------------------------
                      } else if (snapshot.hasData) {
                        _dropdownTestItems3.isEmpty
                            ? {
                                countrylist.add({'no': 0, 'keyword': 'الدولة'}),
                                for (int i = 0;
                                    i < snapshot.data!.data!.length;
                                    i++)
                                  {
                                    countrylist.add({
                                      'no': i,
                                      'keyword':
                                          '${snapshot.data!.data![i].name!}'
                                    }),
                                  },
                                _dropdownTestItems3 =
                                    buildDropdownTestItems(countrylist)
                              }
                            : null;

                        return paddingg(
                          10,
                          15,
                          12,
                          DropdownBelow(
                            itemWidth: 330.w,
                            dropdownColor: white,

                            ///text style inside the menu
                            itemTextstyle: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: black,
                              fontFamily: 'Cairo',
                            ),

                            ///hint style
                            boxTextstyle: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: black,
                                fontFamily: 'Cairo'),

                            ///box style
                            boxPadding:
                                EdgeInsets.fromLTRB(13.w, 12.h, 13.w, 12.h),
                            boxWidth: 500.w,
                            boxHeight: 40.h,
                            boxDecoration: BoxDecoration(
                                border:  Border.all(color: newGrey, width: 0.5),
                                color: lightGrey.withOpacity(0.10),
                                borderRadius: BorderRadius.circular(8.r)),
                            

                            ///Icons
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey,
                            ),
                            hint: Text(
                              countryn,
                              textDirection: TextDirection.rtl,
                            ),
                            value: _selectedTest3,
                            items: _dropdownTestItems3,
                            onChanged: onChangeDropdownTests3,
                          ),
                        );
                      } else {
                        return const Center(
                            child: Text('لايوجد لينك لعرضهم حاليا'));
                      }
                    } else {
                      return Center(
                          child: Text('State: ${snapshot.connectionState}'));
                    }
                  })),

              FutureBuilder(
                  future: categories,
                  builder: ((context, AsyncSnapshot<CategoryL> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center();
                    } else if (snapshot.connectionState ==
                            ConnectionState.active ||
                        snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return Center(child: Text(snapshot.error.toString()));
                        //---------------------------------------------------------------------------
                      } else if (snapshot.hasData) {
                        _dropdownTestItems2.isEmpty
                            ? {
                                categorylist
                                    .add({'no': 0, 'keyword': 'التصنيف'}),
                                for (int i = 0;
                                    i < snapshot.data!.data!.length;
                                    i++)
                                  {
                                    categorylist.add({
                                      'no': i,
                                      'keyword':
                                          '${snapshot.data!.data![i].name}'
                                    }),
                                  },
                                _dropdownTestItems2 =
                                    buildDropdownTestItems(categorylist)
                              }
                            : null;

                        return paddingg(
                          10,
                          15,
                          12,
                          DropdownBelow(
                            itemWidth: 330.w,
                            dropdownColor: white,

                            ///text style inside the menu
                            itemTextstyle: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: black,
                              fontFamily: 'Cairo',
                            ),

                            ///hint style
                            boxTextstyle: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: black,
                                fontFamily: 'Cairo'),

                            ///box style
                            boxPadding:
                                EdgeInsets.fromLTRB(13.w, 12.h, 13.w, 12.h),
                            boxWidth: 500.w,
                            boxHeight: 40.h,
                            boxDecoration: BoxDecoration(
                                border:  Border.all(color: newGrey, width: 0.5),
                                color: lightGrey.withOpacity(0.10),
                                borderRadius: BorderRadius.circular(8.r)),

                            ///Icons
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey,
                            ),
                            hint: Text(
                              categoryn,
                              textDirection: TextDirection.rtl,
                            ),
                            value: _selectedTest2,
                            items: _dropdownTestItems2,
                            onChanged: onChangeDropdownTests2,
                          ),
                        );
                      } else {
                        return const Center(
                            child: Text('لايوجد لينك لعرضهم حاليا'));
                      }
                    } else {
                      return Center(
                          child: Text('State: ${snapshot.connectionState}'));
                    }
                  })),

              //-------------------------------------------------------------------------------------------------------------------------------------------------------

    FutureBuilder(
    future: budgets,
    builder: ((context, AsyncSnapshot<Budget> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return Center();
    } else if (snapshot.connectionState ==
    ConnectionState.active ||
    snapshot.connectionState == ConnectionState.done) {
    if (snapshot.hasError) {
    return Center(child: Text(snapshot.error.toString()));
    //---------------------------------------------------------------------------
    } else if (snapshot.hasData) {
    _dropdownTestItems.isEmpty
    ? {
    budgetlist
        .add({'no': 0, 'keyword': 'الميزانية'}),
    for (int i = 0;
    i < snapshot.data!.data!.length;
    i++)
    {
    budgetlist.add({
    'no': i,
    'keyword':
    ' ${snapshot.data!.data![i].to} من ${snapshot.data!.data![i].from} الى   '
    }),
    },
    _dropdownTestItems =
    buildDropdownTestItems(budgetlist)
    }
        : null;

    return paddingg(
                10,
                15,
                12,
                DropdownBelow(
                  itemWidth: 330.w,
                  dropdownColor: white,

                  ///text style inside the menu
                  itemTextstyle: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: black,
                    fontFamily: 'Cairo',
                  ),

                  ///hint style
                  boxTextstyle: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: black,
                      fontFamily: 'Cairo'),

                  ///box style
                  boxPadding:
                  EdgeInsets.fromLTRB(13.w, 12.h, 13.w, 12.h),
                  boxWidth: 500.w,
                  boxHeight: 40.h,
                  boxDecoration: BoxDecoration(
                      border:  Border.all(color: newGrey, width: 0.5),
                      color: lightGrey.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(8.r)),

                  ///Icons
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.grey,
                  ),
                  hint: Text(
                    budgetn,
                    textDirection: TextDirection.rtl,
                  ),
                  value: _selectedTest,
                  items: _dropdownTestItems,
                  onChanged: onChangeDropdownTests,
                ),
              );} else {
      return const Center(
          child: Text('لايوجد لينك لعرضهم حاليا'));
    }
    } else {
      return Center(
          child: Text('State: ${snapshot.connectionState}'));
    }
    })),

              // paddingg(10.w, 10.w, 12.h,textFieldNoIcon(context, 'موضوع الاعلان', 12.sp, true, subject,(String? value) {if (value == null || value.isEmpty) {
              //   return 'Please enter some text';} return null;},false),),
              // paddingg(10.w, 10.w, 12.h,textFieldDesc(context, 'وصف الاعلان', 12.sp, true, desc,(String? value) {if (value == null || value.isEmpty) {
              //   return 'Please enter some text';} return null;},),),
              // paddingg(10.w, 10.w, 12.h,textFieldNoIcon(context, 'رابط صفحة الاعلان', 12.sp, true, pageLink,(String? value) {if (value == null || value.isEmpty) {
              //   return 'Please enter some text';} return null;},false),),

              SizedBox(
                height: 20,
              ),
              padding(
                  8,
                  20,
                  text(context, 'حساب المشهور', 14, black,
                      fontWeight: FontWeight.bold)),
              Container(
                margin: EdgeInsets.only(top: 3.h, right: 2.w),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Transform.scale(
                          scale: 0.8,
                          child: Radio<int>(
                              value: 1,
                              groupValue: _value5,
                              activeColor: blue,
                              onChanged: (value) {
                                setState(() {
                                  _value5 = value;
                                  isValue1 = false;
                                  status= 1;
                                });
                              }),
                        ),
                        text(context, "موثق", 14, ligthtBlack,
                            family: 'DINNextLTArabic'),
                      ],
                    ),
                    Row(
                      children: [
                        Transform.scale(
                          scale: 0.8,
                          child: Radio<int>(
                              value: 2,
                              groupValue: _value5,
                              activeColor: blue,
                              onChanged: (value) {
                                setState(() {
                                  _value5 = value;
                                  isValue1 = true;
                                  status= 2;
                                });
                              }),
                        ),
                        text(context, "غير موثق", 14, ligthtBlack,
                            family: 'DINNextLTArabic'),
                      ],
                    ),
                  ],
                ),
              ),

              Divider(),
              padding(
                  8,
                  20,
                  text(context, 'الجنس', 14, black,
                      fontWeight: FontWeight.bold)),
              Container(
                margin: EdgeInsets.only(top: 3.h, right: 2.w),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Transform.scale(
                          scale: 0.8,
                          child: Radio<int>(
                              value: 1,
                              groupValue: _value6,
                              activeColor: blue,
                              onChanged: (value) {
                                setState(() {
                                  _value6 = value;
                                  isValue1 = false;
                                  gender=1;
                                });
                              }),
                        ),
                        text(context, "ذكر", 14, ligthtBlack,
                            family: 'DINNextLTArabic'),
                      ],
                    ),
                    Row(
                      children: [
                        Transform.scale(
                          scale: 0.8,
                          child: Radio<int>(
                              value: 2,
                              groupValue: _value6,
                              activeColor: blue,
                              onChanged: (value) {
                                setState(() {
                                  _value6 = value;
                                  isValue1 = true;
                                  gender = 2;
                                });
                              }),
                        ),
                        text(context, "انثى", 14, ligthtBlack,
                            family: 'DINNextLTArabic'),
                      ],
                    ),
                  ],
                ),
              ),

              Divider(),


              paddingg(
                0,
                0,
                12,
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: RichText(
                      text: const TextSpan(children: [
                    TextSpan(
                        text:
                            ' عند الطلب ، فإنك توافق على شروط الإستخدام و سياسة الخصوصية الخاصة بـ',
                        style: TextStyle(
                            color: black, fontFamily: 'Cairo', fontSize: 12)),
                    TextSpan(
                        text: 'الشروط والاحكام',
                        style: TextStyle(
                            color: blue, fontFamily: 'Cairo', fontSize: 12))
                  ])),
                  value: checkit,
                  selectedTileColor: black,
                  onChanged: (value) {
                    setState(() {
                      setState(() {
                        checkit = value!;
                      });
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),

            ]),
          ),
        ),
      ),
    );
  }
  stepTwo() {
    print(categorylist.indexOf(_selectedTest2).toString()+'////////////////////////////////////-');
    return countrylist.indexOf(_selectedTest3) != -1 && categorylist.indexOf(_selectedTest2)   != -1 && budgetlist.indexOf(_selectedTest)   != -1 ?
      FutureBuilder<Filter>(
        future:
        fetchCelebrity(countrylist.indexOf(_selectedTest3),categorylist.indexOf(_selectedTest2),budgetlist.indexOf(_selectedTest),status == null?1: status!
            ,gender==null? 1: gender!),
        builder: ((context, AsyncSnapshot<Filter> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center();
      } else if (snapshot.connectionState ==
          ConnectionState.active ||
          snapshot.connectionState == ConnectionState.done) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
          //---------------------------------------------------------------------------
        } else if (snapshot.hasData) {
          return snapshot.data!.data!.isEmpty?  Center(child: Column(
            children: [
              SizedBox(height: 30.h,),
              Text('لا يوجد نتائج'),
              SizedBox(height: 30.h,),
            ],
          )):
         SizedBox(
          height: 540.h,
        child: GridView.count(
          physics: ScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10,
          shrinkWrap: true,
          children: List.generate(snapshot.data!.data == null? 0 : snapshot.data!.data!.length, (index) {
            return InkWell(
              onTap: () {
                if (!selectedIndex.contains(index)) {
                  selectedIndex.add(index);
                } else {
                  selectedIndex.remove(index);
                }
                setState(() {
                  celebrityId = snapshot.data!.data![index].id;
                });
              },
              child: Container(
                height: double.infinity,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        snapshot.data!.data![index].image!,
                        color: selectedIndex.contains(index)
                            ? deepBlack.withOpacity(0.90)
                            : deepwhite.withOpacity(0.60),
                        colorBlendMode: BlendMode.modulate,
                        fit: BoxFit.fill,
                        height: double.infinity,
                        width: double.infinity ,
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: text(context, snapshot.data!.data![index].name! == ""? "اسم المشهور" : snapshot.data!.data![index].name!,
                                    ww > 400 ? 30 : 12, selectedIndex.contains(index)?white : black,
                                    fontWeight: FontWeight.bold)),
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.only(right: 8.w),
                          ),
                          Container(
                              child: text(context, snapshot.data!.data![index].category!.name! , 10, selectedIndex.contains(index)? white : black),
                              alignment: Alignment.centerRight,
                              margin: EdgeInsets.only(right: 8.w)),

                          SizedBox(
                            height: 10.h,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      );
        } else {
          return const Center(
              child: Text('لايوجد لينك لعرضهم حاليا'));
        }
      } else {
        return Center(
            child: Text('State: ${snapshot.connectionState}'));
      }
        })):Center(child: Column(
          children: [
           SizedBox(height: 30.h,),
            Text('لا يوجد نتائج'),
            SizedBox(height: 30.h,),
          ],
        ));
  }

  stepThree() {
    print(celebrityId.toString()+ '---------------------------------------------------------------------------------------------------------------------------------------');
    return Container(
      child: SingleChildScrollView(
        child: Column(
            children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                  height: 250.h,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/image/featured.png',
                    color: Colors.white.withOpacity(0.60),
                    colorBlendMode: BlendMode.modulate,
                    fit: BoxFit.fill,
                  )),
              Container(
                margin: EdgeInsets.only(bottom: 10.h, right: 10.h),
                child: const Text(
                  'اطلب اعلان \n شخصي من ليجسي ميوزك الان',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: white,
                      fontFamily: 'DINNextLTArabic-Regular-2'),
                ),
              )
            ],
          ),
          Container(
            child: Form(
              key: _formKey3,
              child: paddingg(
                10,
                10,
                5,
                Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  padding(
                    10,
                    12,
                    Container(
                        alignment: Alignment.topRight,
                        child: text(
                          context,
                          ' قم بملئ   \n البيانات التالية',
                          18,
                          textBlack,
                          fontWeight: FontWeight.bold,
                          family: 'DINNextLTArabic-Regular-2',
                        )),
                  ),

                  //========================== form ===============================================

                  SizedBox(
                    height: 10,
                  ),

                  FutureBuilder(
                      future: platforms,
                      builder: ((context, AsyncSnapshot<Platform> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return  paddingg(15, 15, 12,
                            DropdownBelow(
                              itemWidth: 330.w,
                              ///text style inside the menu
                              itemTextstyle: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: black,
                                fontFamily: 'Cairo',),
                              ///hint style
                              boxTextstyle: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: grey,
                                  fontFamily: 'Cairo'),
                              ///box style
                              boxPadding:
                              EdgeInsets.fromLTRB(13.w, 12.h, 13.w, 12.h),
                              boxWidth: 500.w,
                              boxHeight: 45.h,
                              boxDecoration: BoxDecoration(
                                  color: textFieldBlack2.withOpacity(0.70),
                                  borderRadius: BorderRadius.circular(8.r)),
                              ///Icons
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white54,
                              ),
                              hint:  Text(
                                platform,
                                textDirection: TextDirection.rtl,
                              ),
                              value: _selectedTest4,
                              items: _dropdownTestItems4,
                              onChanged: onChangeDropdownTests4,
                            ),
                          );
                        } else if (snapshot.connectionState == ConnectionState.active ||
                            snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Center(child: Text(snapshot.error.toString()));
                            //---------------------------------------------------------------------------
                          } else if (snapshot.hasData) {
                            _dropdownTestItems4.isEmpty?{
                              platformlist.add({'no': 0, 'keyword': 'اختر منصة الاعلان'}),
                              for(int i =0; i< snapshot.data!.data!.length; i++) {
                                platformlist.add({'no': snapshot.data!.data![i].id!, 'keyword': '${snapshot.data!.data![i].name!}'}),
                              },
                              _dropdownTestItems4 = buildDropdownTestItems(platformlist),
                            } : null;

                            return paddingg(10, 10, 12,
                              DropdownBelow(
                                itemWidth: 330.w,
                                ///text style inside the menu
                                itemTextstyle: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: black,
                                  fontFamily: 'Cairo',),
                                ///hint style
                                boxTextstyle: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: grey,
                                    fontFamily: 'Cairo'),
                                ///box style
                                dropdownColor: white,
                                boxPadding:
                                EdgeInsets.fromLTRB(13.w, 12.h, 13.w, 12.h),
                                boxWidth: 500.w,
                                boxHeight: 45.h,
                                boxDecoration: BoxDecoration(
                                    border:  Border.all(color: newGrey, width: 0.5),
                                    color: lightGrey.withOpacity(0.10),
                                    borderRadius: BorderRadius.circular(8.r)),
                                ///Icons
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.grey,
                                ),
                                hint:  Text(
                                  platform,
                                  textDirection: TextDirection.rtl,
                                ),
                                value: _selectedTest4,
                                items: _dropdownTestItems4,
                                onChanged: onChangeDropdownTests4,
                              ),
                            );
                          } else {
                            return const Center(child: Text('لايوجد لينك لعرضهم حاليا'));
                          }
                        } else {
                          return Center(
                              child: Text('State: ${snapshot.connectionState}'));
                        }
                      })),

                  _selectedTest4 == null && checkit2?
                  padding( 10,20, text(context, _selectedTest4 != null  && checkit2 ?'':'الرجاء اختيار منصة الاعلان', 13, _selectedTest4 != null  ?white:red!,)):
                      SizedBox(),

                  paddingg(
                    10.w,
                    10.w,
                    12.h,
                    textFieldNoIcon(
                        context, 'موضوع الاعلان', 12.sp, false, subject,
                        (String? value) {
                      if (value == null || value.isEmpty) {
                      }
                      return null;
                    }, false),
                  ),
                  paddingg(
                    10.w,
                    10.w,
                    12.h,
                    textFieldDesc(
                      context,
                      'وصف الاعلان',
                      12.sp,
                      true,
                      desc,
                      (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'حقل اجباري';
                        }
                        return null;
                      },
                    ),
                  ),
                  paddingg(
                    10.w,
                    10.w,
                    12.h,
                    textFieldNoIcon(
                        context, 'رابط صفحة الاعلان', 12.sp, false, pageLink,
                        (String? value) {
                      if (value == null || value.isEmpty) {
                      }
                      return null;
                    }, false),
                  ),

                  paddingg(
                    10.w,
                    10.w,
                    12.h,
                    textFieldNoIcon(
                        context, 'ادخل كود الخصم', 12.sp, false, couponcode,
                        (String? value) {
                      if (value == null || value.isEmpty) {

                      }
                      return null;
                    }, false),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  padding(
                      8,
                      20,
                      text(context, 'مالك الاعلان', 14, black,
                          fontWeight: FontWeight.bold)),
                  Container(
                    margin: EdgeInsets.only(top: 3.h, right: 2.w),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            Transform.scale(
                              scale: 0.8,
                              child: Radio<int>(
                                  value: 1,
                                  groupValue: _value,
                                  activeColor: blue,
                                  onChanged: (value) {
                                    setState(() {
                                      _value = value;
                                      isValue1 = false;
                                    });
                                  }),
                            ),
                            text(context, "فرد", 14, ligthtBlack,
                                family: 'DINNextLTArabic'),
                          ],
                        ),
                        Row(
                          children: [
                            Transform.scale(
                              scale: 0.8,
                              child: Radio<int>(
                                  value: 2,
                                  groupValue: _value,
                                  activeColor: blue,
                                  onChanged: (value) {
                                    setState(() {
                                      _value = value;
                                      isValue1 = true;
                                    });
                                  }),
                            ),
                            text(context, "مؤسسة", 14, ligthtBlack,
                                family: 'DINNextLTArabic'),
                          ],
                        ),
                        Row(
                          children: [
                            Transform.scale(
                              scale: 0.8,
                              child: Radio<int>(
                                  value: 3,
                                  groupValue: _value,
                                  activeColor: blue,
                                  onChanged: (value) {
                                    setState(() {
                                      _value = value;
                                      isValue1 = true;
                                    });
                                  }),
                            ),
                            text(context, "شركة", 14, ligthtBlack,
                                family: 'DINNextLTArabic'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  padding(
                      8,
                      20,
                      text(context, 'صفة الاعلان', 14, black,
                          fontWeight: FontWeight.bold)),
                  Container(
                    margin: EdgeInsets.only(top: 3.h, right: 2.w),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            Transform.scale(
                              scale: 0.8,
                              child: Radio<int>(
                                  value: 1,
                                  groupValue: _value2,
                                  activeColor: blue,
                                  onChanged: (value) {
                                    setState(() {
                                      _value2 = value;
                                      isValue1 = false;
                                    });
                                  }),
                            ),
                            text(context, "يلزم الحضور", 14, ligthtBlack,
                                family: 'DINNextLTArabic'),
                          ],
                        ),
                        Row(
                          children: [
                            Transform.scale(
                              scale: 0.8,
                              child: Radio<int>(
                                  value: 2,
                                  groupValue: _value2,
                                  activeColor: blue,
                                  onChanged: (value) {
                                    setState(() {
                                      _value2 = value;
                                      isValue1 = true;
                                    });
                                  }),
                            ),
                            text(context, "لا يلزم الحضور", 14, ligthtBlack,
                                family: 'DINNextLTArabic'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  padding(
                      8,
                      20,
                      text(context, 'نوع الاعلان', 14, black,
                          fontWeight: FontWeight.bold)),
                  Container(
                    margin: EdgeInsets.only(top: 3.h, right: 2.w),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            Transform.scale(
                              scale: 0.8,
                              child: Radio<int>(
                                  value: 2,
                                  groupValue: _value3,
                                  activeColor: blue,
                                  onChanged: (value) {
                                    setState(() {
                                      _value3 = value;
                                      isValue1 = false;
                                    });
                                  }),
                            ),
                            text(context, "خدمة", 14, ligthtBlack,
                                family: 'DINNextLTArabic'),
                          ],
                        ),
                        Row(
                          children: [
                            Transform.scale(
                              scale: 0.8,
                              child: Radio<int>(
                                  value: 1,
                                  groupValue: _value3,
                                  activeColor: blue,
                                  onChanged: (value) {
                                    setState(() {
                                      _value3 = value;
                                      isValue1 = true;
                                    });
                                  }),
                            ),
                            text(context, "منتج", 14, ligthtBlack,
                                family: 'DINNextLTArabic'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  padding(
                      8,
                      20,
                      text(context, 'توقيت الاعلان', 14, black,
                          fontWeight: FontWeight.bold)),
                  Container(
                    margin: EdgeInsets.only(top: 3.h, right: 2.w),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            Transform.scale(
                              scale: 0.8,
                              child: Radio<int>(
                                  value: 1,
                                  groupValue: _value4,
                                  activeColor: blue,
                                  onChanged: (value) {
                                    setState(() {
                                      _value4 = value;
                                      isValue1 = false;
                                    });
                                  }),
                            ),
                            text(context, "صباحا", 14, ligthtBlack,
                                family: 'DINNextLTArabic'),
                          ],
                        ),
                        Row(
                          children: [
                            Transform.scale(
                              scale: 0.8,
                              child: Radio<int>(
                                  value: 2,
                                  groupValue: _value4,
                                  activeColor: blue,
                                  onChanged: (value) {
                                    setState(() {
                                      _value4 = value;
                                      isValue1 = true;
                                    });
                                  }),
                            ),
                            text(context, "مساء", 14, ligthtBlack,
                                family: 'DINNextLTArabic'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(),

                  paddingg(
                    15,
                    15,
                    15,
                    uploadImg(
                        50, 45, text(context,file != null? 'تغيير الصورة': 'فم ارفاق ملف الاعلان', 12, black),
                        () {
                      getFile(context);
                    }),
                  ),
                  InkWell(
                      onTap: (){
                        file != null? showDialog(
                        useSafeArea: true,
                        context: this.context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          _timer = Timer(Duration(seconds: 2), () {
                            Navigator.of(context).pop();    // == First dialog closed
                          });
                          return
                            Container(
                                height: double.infinity,
                                child: Image.file(file!));},
                      ):null;},
                      child: paddingg(15.w, 30.w, file != null?10.h: 0.h,Row(
                        children: [
                          file != null? Icon(Icons.image, color: newGrey,): SizedBox(),
                          SizedBox(width: file != null?5.w: 0.w),
                          text(context,  file == null && checkit2 ? 'الرجاء اضافة صورة': file != null? 'معاينة الصورة':'' , file != null?15 :13,file != null?black:red!,),
                        ],
                      ))),

                  paddingg(
                    15,
                    15,
                    15,
                    SizedBox(
                        height: 45.h,
                        child: InkWell(
                          child: gradientContainerNoborder(
                              97,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    scheduale,
                                    color: white,
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  text(context, date.day != DateTime.now().day ?date.year.toString()+ '/'+date.month.toString()+ '/'+date.day.toString() :'تاريخ الاعلان', 15.sp, white,
                                      fontWeight: FontWeight.bold),
                                ],
                              )),
                          onTap: () async {
                            DateTime? endDate =
                                await showDatePicker(
                                  context: this.context,
                                builder: (context, child) {
                                  return Theme(
                                      data: ThemeData.light().copyWith(
                                          colorScheme:
                                          const ColorScheme.light(primary: purple, onPrimary: white)),
                                      child: child!);}
                                initialDate:
                                date,
                                firstDate:
                                DateTime(2000),
                                lastDate: DateTime(2100));

                            if (endDate == null)
                              return;
                            setState(() {
                              date= endDate;
                              FocusManager.instance.primaryFocus
                                  ?.unfocus();
                            });
                          },
                        )),
                  ),

                  paddingg(15.w, 20.w, 2.h,text(context,  checkit2 && date.day == DateTime.now().day ? 'الرجاء اختيار تاريخ النشر': '', 13,red!,)),


  paddingg(
                    0,
                    0,
                    12,
                    CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      title: RichText(
                          text: const TextSpan(children: [
                        TextSpan(
                            text:
                                ' عند الطلب ، فإنك توافق على شروط الإستخدام و سياسة الخصوصية الخاصة بـ',
                            style: TextStyle(
                                color: black, fontFamily: 'Cairo', fontSize: 12)),
                        TextSpan(
                            text: 'الشروط والاحكام',
                            style: TextStyle(
                                color: blue, fontFamily: 'Cairo', fontSize: 12))
                      ])),
                      value: checkit2,
                      selectedTileColor: black,
                      onChanged: (value) {
                        setState(() {
                          setState(() {
                            checkit2 = value!;
                            if(_formKey3.currentState!.validate()){
                            if( date.day == DateTime.now().day || file == null ){
                            setState(() {
                            _selectedTest4 == null? platformChosen= false: platformChosen = true;
                            date.day == DateTime.now().day? datewarn2 = true: false;
                            file == null? warnimage =true:false;
                            });
                            }
                            }
                          });
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  buildCompleted(context) {
   goTopagepush(context, MainScreen());
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
    if(fileExtension == ".png" || fileExtension == ".jpg"){
     setState(() {
       file = newImage;
     });
    }else{ ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(
      content: Text(
          "امتداد الصورة المسموح به jpg, png",style: TextStyle(color: Colors.red)),
    ));}

    // }else{ ScaffoldMessenger.of(context)
    //     .showSnackBar(const SnackBar(
    //   content: Text(
    //       "امتداد الصورة غير مسموح به",style: TextStyle(color: Colors.red)),
    // ));}
  }
}


class Filter {
  bool? success;
  List<Data>? data;
  Message? message;

  Filter({this.success, this.data, this.message});

  Filter.fromJson(Map<String, dynamic> json) {
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
  String? username;
  String? name;
  String? image;
  String? email;
  String? phonenumber;
  Country? country;
  City? city;
  String? description;
  String? pageUrl;
  String? snapchat;
  String? tiktok;
  String? youtube;
  String? instagram;
  String? twitter;
  String? facebook;
  CategoryFilter? category;
  String? brand;
  String? advertisingPolicy;
  String? giftingPolicy;
  String? adSpacePolicy;

  Data(
      {this.id,
        this.username,
        this.name,
        this.image,
        this.email,
        this.phonenumber,
        this.country,
        this.city,
        this.description,
        this.pageUrl,
        this.snapchat,
        this.tiktok,
        this.youtube,
        this.instagram,
        this.twitter,
        this.facebook,
        this.category,
        this.brand,
        this.advertisingPolicy,
        this.giftingPolicy,
        this.adSpacePolicy});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    name = json['name'];
    image = json['image'];
    email = json['email'];
    phonenumber = json['phonenumber'];
    country =
    json['country'] != null ? new Country.fromJson(json['country']) : null;
    city = json['city']!= null ? new City.fromJson(json['city']) : null;
    description = json['description'];
    pageUrl = json['page_url'];
    snapchat = json['snapchat'];
    tiktok = json['tiktok'];
    youtube = json['youtube'];
    instagram = json['instagram'];
    twitter = json['twitter'];
    facebook = json['facebook'];
    category = json['category'] != null ? new CategoryFilter.fromJson(json['category'])
        : null;
    brand = json['brand'];
    advertisingPolicy = json['advertising_policy'];
    giftingPolicy = json['gifting_policy'];
    adSpacePolicy = json['ad_space_policy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['name'] = this.name;
    data['image'] = this.image;
    data['email'] = this.email;
    data['phonenumber'] = this.phonenumber;
    if (this.country != null) {
      data['country'] = this.country!.toJson();
    }
    data['city'] = this.city;
    data['description'] = this.description;
    data['page_url'] = this.pageUrl;
    data['snapchat'] = this.snapchat;
    data['tiktok'] = this.tiktok;
    data['youtube'] = this.youtube;
    data['instagram'] = this.instagram;
    data['twitter'] = this.twitter;
    data['facebook'] = this.facebook;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    data['brand'] = this.brand;
    data['advertising_policy'] = this.advertisingPolicy;
    data['gifting_policy'] = this.giftingPolicy;
    data['ad_space_policy'] = this.adSpacePolicy;
    return data;
  }
}

class Country {
  String? name;
  String? nameEn;
  String? flag;

  Country({this.name, this.nameEn, this.flag});

  Country.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    nameEn = json['name_en'];
    flag = json['flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['name_en'] = this.nameEn;
    data['flag'] = this.flag;
    return data;
  }
}

class City {
  String? name;
  String? nameEn;

  City({this.name, this.nameEn});

  City.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    nameEn = json['name_en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['name_en'] = this.nameEn;
    return data;
  }
}
class CategoryFilter {
  String? name;
  String? nameEn;

  CategoryFilter({this.name, this.nameEn});

  CategoryFilter.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    nameEn = json['name_en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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


class Budget {
  bool? success;
  List<DataBudget>? data;
  MessageBudget? message;

  Budget({this.success, this.data, this.message});

  Budget.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <DataBudget>[];
      json['data'].forEach((v) {
        data!.add(new DataBudget.fromJson(v));
      });
    }
    message =
    json['message'] != null ? new MessageBudget.fromJson(json['message']) : null;
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

class DataBudget {
  int? id;
  int? from;
  int? to;

  DataBudget({this.id, this.from, this.to});

  DataBudget.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    from = json['from'];
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['from'] = this.from;
    data['to'] = this.to;
    return data;
  }
}

class MessageBudget {
  String? en;
  String? ar;

  MessageBudget({this.en, this.ar});

  MessageBudget.fromJson(Map<String, dynamic> json) {
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