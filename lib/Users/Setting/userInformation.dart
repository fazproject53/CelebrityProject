import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:celepraty/Account/logging.dart';
import 'package:celepraty/MainScreen/main_screen_navigation.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:celepraty/celebrity/setting/celebratyProfile.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import '../../Account/LoggingSingUpAPI.dart';
import '../../Account/TheUser.dart';
import '../../Celebrity/setting/profileInformation.dart';
import 'userProfile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

class userInformation extends StatefulWidget {
  _userInformationState createState() => _userInformationState();
}

class _userInformationState extends State<userInformation> {

  bool isConnectSection = true;
  bool timeoutException = true;
  bool serverExceptions = true;

  bool noint = false;
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final TextEditingController name =  TextEditingController();
  final TextEditingController email =  TextEditingController();
  final TextEditingController password =  TextEditingController();
  final TextEditingController newPassword =  TextEditingController();
  final TextEditingController currentPassword =  TextEditingController();
  final TextEditingController confirmPassword =  TextEditingController();
  final TextEditingController phone =  TextEditingController();
  String userToken ="";
  Future<CountryL>? countries;
  Future<CityL>? cities;
  bool noMatch =false;
  bool editPassword = false;

  bool? citychosen;
  Map<int, String> getid = HashMap();
  Map<int, String> cid = HashMap();

  int helper =0;
  bool hidden = true;
  bool hidden2 = true;
  String country = 'الدولة';
  String city = 'المدينة';
  String? countrycode;
  bool countryChanged = false;
  bool cityChanged = false;
  int? cityi;
  int? countryId;
  Future<UserProfile>? getUser;
  var currentFocus;
  var citilist = [];

  int? countryi, genderi,categoryi;
  var countrylist = [];

  List<DropdownMenuItem<Object?>> _dropdownTestItems = [];
  List<DropdownMenuItem<Object?>> _dropdownTestItems3 = [];

  ///_value
  var _selectedTest;
  onChangeDropdownTests(selectedTest) {
    print(selectedTest['no']);
    setState(() {
      city = selectedTest['keyword'];
      _selectedTest = selectedTest;
      citychosen = true;
      // cid.forEach((key, value) {
      //   if(value == selectedTest['keyword']){
      //     cityi = key;
      //   }
      // });
      cityChanged = true;
    });
  }

  var _selectedTest3;
  onChangeDropdownTests3(selectedTest) {
    print(selectedTest);
    setState(() {
      _selectedTest = null;
      countryChanged  = true;
      Logging.theUser!.country = selectedTest['keyword'];
      _selectedTest3 = selectedTest;
      city = 'المدينة';
      _dropdownTestItems.clear();
      citilist.clear();
      getid.forEach((key, value) {
        if(value == Logging.theUser!.country){
          print(key.toString()+ 'first country id');
          cities = fetCities(key+1);
        }
      });
    });

  }

  @override
  void initState() {
    DatabaseHelper.getToken().then((value) {
      setState(() {
        userToken = value;
        getUser = fetchUsers(userToken);
      });
    });
    countries = fetCountries();
    _dropdownTestItems = buildDropdownTestItems(citilist);
    _dropdownTestItems3 = buildDropdownTestItems(countrylist);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<DropdownMenuItem<Object?>> buildDropdownTestItems(List _testList) {
    List<DropdownMenuItem<Object?>> items = [];
    for (var i in _testList) {
      items.add(
        DropdownMenuItem(
          alignment: Alignment.topRight,
          value: i,
          child: Text(i['keyword']),
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {

    getid.forEach((key, value) {
      if(value == Logging.theUser!.country){
        print(key.toString()+ 'country id');
        cities = fetCities(key+1);
      }
    });
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: drowAppBar('المعلومات الشخصية', context),
        body: SingleChildScrollView(
          child: FutureBuilder<UserProfile>(
            future: getUser,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: mainLoad(context));
              } else if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  if (!isConnectSection) {
                    return Center(
                        child: Padding(
                          padding:  EdgeInsets.only(top: 150.h),
                          child: SizedBox(
                              height: 300.h,
                              width: 250.w,
                              child: internetConnection(
                                  context, reload: () {
                                setState(() {
                                  getUser = fetchUsers(userToken);
                                  isConnectSection = true;
                                });
                              })),
                        ));
                  } else {
                    if (!serverExceptions) {
                      return Container(
                        height: getSize(context).height/1.5,
                        child: Center(
                          child: checkServerException(context)
                        ),
                      );}else{
                      if (!timeoutException) {
                        return Center(
                          child: checkTimeOutException(context, reload: (){ setState(() {
                            getUser = fetchUsers(userToken);});}),
                        );}
                    }
                    return const Center(
                        child: Text(
                            'حدث خطا ما اثناء استرجاع البيانات'));
                  }
                  //---------------------------------------------------------------------------
                } else if (snapshot.hasData) {
                  int number;
                  helper ==0?{
                    name.text = snapshot.data!.data!.user!.name!,
                    email.text = snapshot.data!.data!.user!.email!,
                    snapshot.data!.data!.user!.phonenumber! != ""?{
                      number =
                          snapshot.data!.data!.user!.phonenumber!.length - 9,
                      phone.text =
                          snapshot.data!.data!.user!.phonenumber!.substring(number),}:
                    phone.text =
                    snapshot.data!.data!.user!.phonenumber!,
                    password.text = "********",
                    snapshot.data!.data!.user!.country != null
                        ? { country =snapshot.data!.data!.user!.country!.name!,
                      getid.forEach((key, value) {
                        if (value == snapshot.data!.data!
                            .user!.country!.name!) {
                          countryi =key+1;
                          print('country in build ============================ ' + (key +1).toString());
                        }
                      })
                    } : '',
                  snapshot.data!.data!.user!.city != null? {
                      city = snapshot.data!.data!.user!.city!.name.toString(),
                  citychosen = true, cityi =snapshot.data!.data!.user!.city!.id!}
                        : city = 'المدينة',
                    print('the length is = '+ getid.length.toString() + Logging.theUser!.country!),
                    getid.forEach((key, value) {
                      print(value);
                      if(value == Logging.theUser!.country){
                        print(key.toString()+ 'country id inside future');
                        cities = fetCities(key+1);
                      }
                    }),
                    helper =1,
                  }:null;


                  return Container(
                    child: Form(
                      key: _formKey,
                      child: paddingg(
                        12,
                        12,
                        5,
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(
                                height: 30.h,
                              ),
                              padding(
                                10,
                                12,
                                Container(
                                    alignment: Alignment.topRight,
                                    child: const Text(
                                      'قم بملئ او تعديل  معلوماتك الشخصية',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: textBlack,
                                          fontFamily: 'Cairo'),
                                    )),
                              ),

                              //========================== form ===============================================

                              const SizedBox(
                                height: 30,
                              ),

                              paddingg(
                                15,
                                15,
                                12,
                                textFieldNoIcon(
                                    context, 'الاسم', 14, false, name,
                                        (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return "حقل اجباري";
                                      }

                                    }, false),
                              ),
                              paddingg(
                                15,
                                15,
                                12,
                                textFieldNoIcon(context, 'البريد الالكتروني',
                                    14, false, email, (String? value) {
                                      if (value == null || value.isEmpty) {}
                                      return null;
                                    }, false),
                              ),
                              paddingg(
                                15,
                                15,
                                12,
                                textFieldNoIcon(context, 'رقم الجوال', 14,
                                  false, phone, (String? value) {
                                    RegExp regExp = new RegExp(
                                        r'(^(?:[+0]9)?[0-9]{10,12}$)');
                                    if (value != null) {
                                      if (value.isNotEmpty) {
                                        if (value.length != 9) {
                                          return "رقم الجوال يجب ان يتكون من 9 ارقام  ";
                                        }
                                        if (value.startsWith('0')) {
                                          return 'رقم الجوال يجب ان لا يبدا ب 0 ';
                                        }
                                        // if(!regExp.hasMatch(value)){
                                        //   return "رقم الجوال غير صالح";
                                        // }
                                      }
                                    }

                                    return null;
                                  }, false, child: Container(
                                    width: 60.w,
                                    height: 32.h,
                                    child: CountryCodePicker(
                                      padding: EdgeInsets.all(0),
                                      onChanged: print,
                                      // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                      initialSelection: country == 'السعودية'
                                          ? 'SA'
                                          : country == 'فلسطين'
                                          ? 'PS'
                                          : country == 'الاردن'
                                          ? 'JO'
                                          : country == 'الامارات'
                                          ? 'AE'
                                          : 'SA',
                                      countryFilter: const [
                                        'SA',
                                        'BH',
                                        'KW',
                                        'OM',
                                        'AE',
                                        'KW',
                                        'QA',
                                      ],
                                      showFlag: false,
                                      // optional. Shows only country name and flag
                                      showCountryOnly: false,
                                      showFlagDialog: true,
                                      textStyle:  TextStyle(color: black, fontSize: 15.sp),
                                      // optional. Shows only country name and flag when popup is closed.
                                      showOnlyCountryWhenClosed: false,
                                      // optional. aligns the flag and the Text left
                                      alignLeft: true,
                                    ),
                                  ),),
                              ),

                              paddingg(
                                15,
                                15,
                                12,
                                textFieldPassword(context, 'كلمة المرور', 14,
                                    hidden, password, (String? value) {
                                      if (value == null || value.isEmpty) {}
                                      return null;
                                    }, false, child: IconButton(icon: Icon(Icons.edit, color:  black,),onPressed: (){ setState(() {
                                      editPassword = !editPassword;
                                    });},)),
                              ),
                              // paddingg(
                              //   15,
                              //   15,
                              //   12,
                              //   textFieldPassword2(
                              //       context,
                              //       'اعادة ضبط كلمة المرور ',
                              //       14,
                              //       hidden2,
                              //       repassword, (String? value) {
                              //     if (value == null || value.isEmpty) {}
                              //     return null;
                              //   }, false),
                              // ),

                              editPassword
                                  ? Form(
                                key: _formKey2,
                                child: Column(
                                  children: [
                                    paddingg(
                                      15,
                                      15,
                                      12,
                                      textFieldNoIcon(
                                        context,
                                        'كلمة المرور الحالية',
                                        14,
                                        true,
                                        currentPassword, (String? value) {
                                        if (value == null ||
                                            value.isEmpty) {}
                                        return null;
                                      }, false, ),
                                    ),
                                    paddingg(
                                      15,
                                      15,
                                      12,
                                      textFieldNoIcon(
                                          context,
                                          'كلمة المرور الجديدة',
                                          14,
                                          true,
                                          newPassword, (String? value) {
                                        if (value == null ||
                                            value.isEmpty) {
                                          return 'حقل اجباري';
                                        }
                                        return null;
                                      }, false),
                                    ),
                                    paddingg(
                                      15,
                                      15,
                                      12,
                                      textFieldNoIcon(
                                          context,
                                          'تاكيد كلمة المرور ',
                                          14,
                                          true,
                                          confirmPassword, (String? value) {
                                        if (value == null ||
                                            value.isEmpty) {
                                          return 'حقل اجباري';
                                        }
                                        return noMatch ? 'كلمة المرور وتاكيد كلمة المرور غير متطابقين': null;
                                      }, false),
                                    ),
                                  ],
                                ),
                              )
                                  : const SizedBox(
                                height: 0,
                              ),
                              //===========dropdown lists ==================

                              FutureBuilder(
                                  future: countries,
                                  builder: ((context,
                                      AsyncSnapshot<CountryL> snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center();
                                    } else if (snapshot.connectionState ==
                                        ConnectionState.active ||
                                        snapshot.connectionState ==
                                            ConnectionState.done) {
                                      if (snapshot.hasError) {
                                        return Center();
                                        //---------------------------------------------------------------------------
                                      } else if (snapshot.hasData) {
                                        _dropdownTestItems3.isEmpty
                                            ? {
                                          countrylist.add({
                                            'no': 0,
                                            'keyword': 'الدولة'
                                          }),
                                          for (int i = 0;
                                          i <
                                              snapshot
                                                  .data!.data!.length;
                                          i++)
                                            {
                                              countrylist.add({
                                                'no': i,
                                                'keyword':
                                                '${snapshot.data!.data![i].name!}'
                                              }),
                                            },
                                          _dropdownTestItems3 =
                                              buildDropdownTestItems(
                                                  countrylist),

                                          getid.forEach((key, value) {
                                            if(value == country){cities = fetCities(key);}
                                          }),

                                        }:{};
                                        return paddingg(
                                          15,
                                          15,
                                          12,
                                          DropdownBelow(
                                            dropdownColor: white,
                                            itemWidth: 370.w,

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
                                            boxPadding: EdgeInsets.fromLTRB(
                                                13.w, 12.h, 13.w, 12.h),
                                            boxWidth: 500.w,
                                            boxHeight: 45.h,
                                            boxDecoration: BoxDecoration(
                                                border:  Border.all(color: newGrey, width: 0.5),
                                                color: lightGrey.withOpacity(0.10),
                                                borderRadius:
                                                BorderRadius.circular(8.r)),

                                            ///Icons
                                            icon: const Icon(
                                              Icons.arrow_drop_down,
                                              color: Colors.grey,
                                            ),
                                            hint: Text(
                                              country,
                                              textDirection: TextDirection.rtl,
                                            ),
                                            value: _selectedTest3,
                                            items: _dropdownTestItems3,
                                            onChanged: onChangeDropdownTests3,
                                          ),
                                        );
                                      } else {
                                        return const Center(
                                            child: Text(
                                                'لايوجد لينك لعرضهم حاليا'));
                                      }
                                    } else {
                                      return Center(
                                          child: Text(
                                              'State: ${snapshot.connectionState}'));
                                    }
                                  })),


                              FutureBuilder(
                                  future: cities,
                                  builder: ((context,
                                      AsyncSnapshot<CityL> snapshot) {
                                    print(countrylist.indexOf(_selectedTest3).toString()+'*************************************************************************************');
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center();
                                    } else if (snapshot.connectionState ==
                                        ConnectionState.active ||
                                        snapshot.connectionState ==
                                            ConnectionState.done) {
                                      if (snapshot.hasError) {
                                        return Center(
                                            );
                                        //---------------------------------------------------------------------------
                                      } else if (snapshot.hasData) {
                                        _dropdownTestItems.isEmpty
                                            ? {

                                          for (int i = 0;
                                          i <
                                              snapshot
                                                  .data!.data!.length;
                                          i++)
                                            {
                                              citilist.add({
                                                'no': snapshot.data!.data![i].id!,
                                                'keyword':
                                                '${snapshot.data!.data![i].name!}'
                                              }),
                                            },
                                          _dropdownTestItems =
                                              buildDropdownTestItems(
                                                  citilist)
                                        }
                                            : null;
                                        return paddingg(
                                          15,
                                          15,
                                          12,
                                          DropdownBelow(
                                            dropdownColor: white,
                                            itemWidth: 370.w,

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
                                            boxPadding: EdgeInsets.fromLTRB(
                                                13.w, 12.h, 13.w, 12.h),
                                            boxWidth: 500.w,
                                            boxHeight: 45.h,
                                            boxDecoration: BoxDecoration(
                                                border:  Border.all(color: newGrey, width: 0.5),
                                                color: lightGrey.withOpacity(0.10),
                                                borderRadius:
                                                BorderRadius.circular(8.r)),

                                            ///Icons
                                            icon: const Icon(
                                              Icons.arrow_drop_down,
                                              color: Colors.grey,
                                            ),
                                            hint: Text(
                                              city,
                                              textDirection: TextDirection.rtl,
                                            ),
                                            value: _selectedTest,
                                            items: _dropdownTestItems,
                                            onChanged: onChangeDropdownTests,
                                          ),
                                        );

                                      } else {
                                        return const Center(
                                            child: Text(
                                                'لايوجد لينك لعرضهم حاليا'));
                                      }
                                    } else {
                                      return Center();
                                      //   child: Text(
                                      // 'State: ${snapshot.connectionState}'));
                                    }
                                  })),


                              citychosen != null ?
                              citychosen == false ? Padding(
                                padding: const EdgeInsets.only(right: 18.0),
                                child: text(
                                    context, 'الرجاء تحديد المدينة', 14, red!),
                              ) : SizedBox()
                                  :
                              SizedBox(),
                              //=========== end dropdown ==================================

                              //===================== button ================================

                              const SizedBox(
                                height: 30,
                              ),
                              padding(
                                15,
                                15,
                                gradientContainerNoborder(
                                    getSize(context).width,
                                    buttoms(context, 'حفظ', 20, white, () {
                                      if (( currentPassword.text.isNotEmpty && newPassword.text.isNotEmpty)){
                                        _formKey2.currentState ==null?null:
                                        _formKey2.currentState!.validate()? {
                                          newPassword.text == confirmPassword.text?{ changePassword(userToken).then((value) => {
                                            value == 'SocketException' ||  value == 'TimeoutException' ||  value == 'ServerException'? {
                                            Navigator.pop(context),
                                            showMassage(context,'فشل الاتصال بالانترنت', "فشل الاتصال بالانترنت حاول لاحقا")
                                          }:
                                          value.contains('false')?showMassage(context, 'خطا',value.replaceAll('false', '')):showMassage(context, 'تم بنجاح',"تم التغيير بنجاح", done: done),

                                          })  , updateUserInformation(userToken).whenComplete(() => fetchUsers(userToken))}: setState((){noMatch = true;})}:null;}
                                      else{
                                        _formKey.currentState!.validate() &&  _formKey2.currentState == null && citychosen == true?

                                        {
                                          loadingDialogue(context),
                                          updateUserInformation(userToken)
                                              .then((value) {
                                                value == 'SocketException'?{
                                                  Navigator.pop(context),
                                                    showMassage(context,'فشل الاتصال بالانترنت', "فشل الاتصال بالانترنت حاول لاحقا")
                                                }: {

                                                  Navigator.pop(context),
                                                  countryChanged || cityChanged
                                                      ? setState(() {
                                                    helper = 0;
                                                    countryChanged =
                                                    false;
                                                    cityChanged =
                                                    false;
                                                    getUser =
                                                        fetchUsers(userToken);
                                                  })
                                                      : Navigator
                                                      .pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder:
                                                            (context) =>
                                                            MainScreen()),
                                                  ),
                                                  showMassage(context, 'تم بنجاح',value, done: done)
                                                };


                                            //   setState(() {
                                            //     helper = 0;
                                            //     celebrities =
                                            //         fetchCelebrities();
                                            //   }),
                                            //   ScaffoldMessenger.of(
                                            //           context)
                                            //       .showSnackBar(
                                            //           const SnackBar(
                                            //     content: Text(
                                            //         "تم تعديل المعلومات بنجاح"),
                                            //   ))

                                          })}: setState(() {
                                          citychosen==false? citychosen = true: null;
                                        },);};
                                    })),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                            ]),
                      ),
                    ),
                  );
                } else {
                  return const Center(child: Text('Empty data'));
                }
              } else {
                return Center(
                    child: Text('State: ${snapshot.connectionState}'));
              }
            },
          ),
        ),
      ),
    );
  }

  Future<CountryL> fetCountries() async {
    try {
      final response = await http.get(
        Uri.parse('https://mobile.celebrityads.net/api/countries'),
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.

        for (int i = 0; i < jsonDecode(response.body)['data'].length; i++) {
          setState(() {
            getid.putIfAbsent(
                i, () => jsonDecode(response.body)['data'][i]['name']);
          });
        }

        return CountryL.fromJson(jsonDecode(response.body));
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load activity');
      }
    }catch(e){
      if (e is SocketException) {
        setState(() {
          noint = true;
        });
        return Future.error('SocketException');
      }else {
        return Future.error('serverExceptions');
      }
    }
  }

  Future<CityL> fetCities(int countryId) async {
    try {
      final response = await http.get(
        Uri.parse('https://mobile.celebrityads.net/api/cities/$countryId'),
      );

      if (response.statusCode == 200) {
        return CityL.fromJson(jsonDecode(response.body));
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        print(countryId.toString() + 'in the city get');
        throw Exception('Failed to load activity');
      }
    }catch(e){
      if (e is SocketException) {
        setState(() {
          noint = true;
        });
        return Future.error('SocketException');
      }else {
        return Future.error('serverExceptions');
      }
    }
    }

  Future<UserProfile> fetchUsers(String token) async {

    try {
      final response = await http.get(
          Uri.parse('https://mobile.celebrityads.net/api/user/profile'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          });
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        Logging.theUser = new TheUser();
        Logging.theUser!.name =
        jsonDecode(response.body)["data"]?["user"]['name'] == null
            ? ''
            : jsonDecode(response.body)["data"]?["user"]['name'];
        Logging.theUser!.email =
        jsonDecode(response.body)["data"]?["user"]['email'];
        Logging.theUser!.id =
            jsonDecode(response.body)["data"]?["user"]['id'].toString();
        Logging.theUser!.phone =
        jsonDecode(response.body)["data"]?["user"]['phonenumber'] == null
            ? ''
            : jsonDecode(response.body)["data"]?["user"]['phonenumber'].toString();
        Logging.theUser!.image =
        jsonDecode(response.body)["data"]?["user"]['image'] == null
            ? ''
            : jsonDecode(response.body)["data"]?["user"]['image'];
        Logging.theUser!.country =
        jsonDecode(response.body)["data"]?["user"]['country'] == null
            ? ''
            : jsonDecode(response.body)["data"]?["user"]['country']['name'];
        print(response.body);
        return UserProfile.fromJson(jsonDecode(response.body));
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load activity');
      }
    }catch(e){
      if (e is SocketException) {
        setState(() {
          isConnectSection = false;
        });
        return Future.error('SocketException');
      } else if (e is TimeoutException) {
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

  Widget textFieldPassword(
      context,
      String keyy,
      double fontSize,
      bool hintPass,
      TextEditingController mycontroller,
      myvali,
      isOptional,
      {
        IconButton? child
      }) {
    return TextFormField(
      obscureText: hintPass ? true : false,
      validator: myvali,
      controller: mycontroller,
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
          suffixIcon: child,
          helperText: isOptional ? 'اختياري' : null,
          helperStyle: TextStyle(
              color: pink, fontSize: fontSize.sp, fontFamily: 'Cairo'),
          hintStyle: TextStyle(
              color: grey, fontSize: fontSize.sp, fontFamily: 'Cairo'),
          fillColor: lightGrey.withOpacity(0.10),
          labelStyle: TextStyle(color: white, fontSize: fontSize.sp),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
          focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: purple, width: 1)),
          // suffixIcon: hidden
          //     ? IconButton(
          //         onPressed: () {
          //           setState(() {
          //             hidden = false;
          //           });
          //         },
          //         icon: Icon(
          //           hide,
          //           color: lightGrey,
          //         ))
          //     : IconButton(
          //         onPressed: () {
          //           setState(() {
          //             hidden = true;
          //           });
          //         },
          //         icon: Icon(show, color: lightGrey)),
          hintText: keyy,
          contentPadding: EdgeInsets.all(10.h)),
    );
  }

  Future<String> updateUserInformation(String token) async {
    try {
      final response = await http.post(
        Uri.parse(
          'https://mobile.celebrityads.net/api/user/profile/update',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{
          'name': name.text,
          'email': email.text,
          'password': password.text,
          'phonenumber':
          countrycode != null ? countrycode! + phone.text : phone.text,
          'country_id':
          _selectedTest3 == null ?  countryi : countrylist.indexOf(_selectedTest3),
          'city_id': _selectedTest == null ? cityi : _selectedTest['no'],
        }),
      );
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        print(response.body);
        return jsonDecode(response.body)['message']['ar'] ;
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load activity');
      }
    }catch (e) {
      if (e is SocketException) {
        return 'SocketException';
      } else if(e is TimeoutException) {
        return 'TimeoutException';
      } else {
        return 'serverException';

      }
    }
  }
  Future<String> changePassword(String token) async {
    try {
      final response = await http.post(
        Uri.parse(
          'https://mobile.celebrityads.net/api/user/password/change',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{
          'current_password': currentPassword.text,
          'new_password': newPassword.text,
          'confirm_password': confirmPassword.text,
        }),
      );
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        print(response.body);
        return jsonDecode(response.body)['message']['ar'] + jsonDecode(response.body)['success'].toString();
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load activity');
      }
    }catch (e) {
      if (e is SocketException) {
        return 'SocketException';
      } else if(e is TimeoutException) {
        return 'TimeoutException';
      } else {
        return 'serverException';

      }
    }
  }
  Widget textFieldPassword2(
      context,
      String key,
      double fontSize,
      bool hintPass,
      TextEditingController mycontroller,
      myvali,
      isOptional,
      ) {
    return TextFormField(
      obscureText: hintPass ? true : false,
      validator: myvali,
      controller: mycontroller,
      style:
      TextStyle(color: white, fontSize: fontSize.sp, fontFamily: 'Cairo'),
      decoration: InputDecoration(
          isDense: false,
          filled: true,
          helperText: isOptional ? 'اختياري' : null,
          helperStyle: TextStyle(
              color: pink, fontSize: fontSize.sp, fontFamily: 'Cairo'),
          hintStyle: TextStyle(
              color: grey, fontSize: fontSize.sp, fontFamily: 'Cairo'),
          fillColor: textFieldBlack2.withOpacity(0.70),
          labelStyle: TextStyle(color: white, fontSize: fontSize.sp),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
          focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: pink, width: 1)),
          suffixIcon: hidden2
              ? IconButton(
              onPressed: () {
                setState(() {
                  hidden2 = false;
                });
              },
              icon: Icon(
                hide,
                color: lightGrey,
              ))
              : IconButton(
              onPressed: () {
                setState(() {
                  hidden2 = true;
                });
              },
              icon: Icon(show, color: lightGrey)),
          hintText: key,
          contentPadding: EdgeInsets.all(10.h)),
    );
  }
}
