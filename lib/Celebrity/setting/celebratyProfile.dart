import 'dart:async';

import 'package:celepraty/Users/Setting/userProfile.dart';
import 'package:celepraty/celebrity/setting/profileInformation.dart' as info;
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:celepraty/Celebrity/Activity/activity_screen.dart';
import 'package:celepraty/Celebrity/Balance/balance.dart';
import 'package:celepraty/Celebrity/Calendar/calendar_main.dart';
import 'package:celepraty/Celebrity/Pricing/pricing.dart';
import 'package:celepraty/Celebrity/setting/profileInformation.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:celepraty/Users/Setting/user_balance.dart';
import 'package:celepraty/celebrity/Brand/create_your_brand.dart';
import 'package:celepraty/celebrity/DiscountCodes/discount_codes_main.dart';
import 'package:celepraty/celebrity/PrivacyPolicy/privacy_policy.dart';
import 'package:celepraty/celebrity/Requests/ReguistMainPage.dart';
import 'package:celepraty/celebrity/TechincalSupport/contact_with_us.dart';
import 'package:celepraty/celebrity/blockList.dart';
import 'package:path/path.dart' as Path;
import 'package:celepraty/invoice/invoice_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:celepraty/Account/logging.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../Account/LoggingSingUpAPI.dart';
import '../../Account/TheUser.dart';

CelebrityInformation? thecelerbrity = CelebrityInformation();

class celebratyProfile extends StatefulWidget {
  _celebratyProfileState createState() => _celebratyProfileState();
}

class _celebratyProfileState extends State<celebratyProfile> {
  String userToken = '';
  Future<CelebrityInformation>? celebrity;

  bool isConnectSection = true;
  bool timeoutException = true;
  bool serverExceptions = true;
  bool ActiveConnection = false;
  String T = "";
  File? imagefile;
  String? imageurl;
  final labels = [
    'المعلومات الشخصية',
    'الفوترة',
    'الرصيد',
    'التسعير',
    'الطلبات',
    'علامتك التجارية',
    'اكواد الخصم',
    'جدول المواعيد',
    'التفاعلات',
    'الشروط والاحكام',
    'قائمة الحظر',
    'الدعم',
    'تسجيل الخروج'
  ];
  final List<IconData> icons = [
    nameIcon,
    invoice,
    money,
    price,
    orders,
    store,
    copun,
    scheduale,
    studio,
    pagesIcon,
    block,
    chat,
    support,
    logout
  ];
  final List<Widget> page = [
    profileInformaion(),
    invoiceScreen(),
    BalanceMain(),
    PricingMain(),
    RequestMainPage(),
    YourBrandHome(),
    DiscountCodes(),
    CelebrityCalenderMain(),
    ActivityScreen(),
    PrivacyPolicyMain(),
    blockList(),
    ContactWithUsHome(),
    Logging()
  ];
  @override
  void initState() {
    super.initState();
    CheckUserConnection();
    DatabaseHelper.getToken().then((value) {
      setState(() {
        userToken = value;
        celebrity = fetchCelebrities(userToken);
      });
    });
  }
  Future CheckUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if(mounted) {
          setState(() {
          ActiveConnection = true;
          T = "Turn off the data and repress again";
        });
        }
      }
    } on SocketException catch (_) {
      setState(() {
        ActiveConnection = false;
        T = "Turn On the data and repress again";
      });
    }
  }
  Future<CelebrityInformation> fetchCelebrities(String tokenn) async {
    try{
    String token =
        'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiNmNiMTQxN2NlMWY1NmQ5NDYwYWZlNmFiODkxN2YxZjUzNmU5NDFkYTFhZjkzZThkZTRhODg0MDhjY2NmODU5MTk1N2FlZDIyZmNiOTNlYWYiLCJpYXQiOjE2NTQ0MjY5NzguODI0OTc0MDYwMDU4NTkzNzUsIm5iZiI6MTY1NDQyNjk3OC44MjQ5NzgxMTMxNzQ0Mzg0NzY1NjI1LCJleHAiOjE2ODU5NjI5NzguODE2NTA0MDAxNjE3NDMxNjQwNjI1LCJzdWIiOiI3NyIsInNjb3BlcyI6W119.gi37nJk06pb4_27W45l8oItE3JkLa_gxyzUmYxJDQjFTMCHBllDU3GKXpJNWq_qEXTDUQB66QeP0mFCSmZZYdOczNSqu-0RfqQyzpOTUCp2uyXZGPehl7IhQ9T9cceKBzoz71kcHinYJLv-O0666XrEQMS7w6aRhi69TPRqew2RehPHgMmZuiXcF9uET2WYOGGZl3OIzDRrIP2PSt0GvgSWsWDLlOEgOwgJqBHeuBa7tVyoK2K1ZVQdJPRT0T2PPO9jc5w9nG82aXYUPqku-GqzYeGijdXukIjkStJJvBAiSvYeD1lQNXpLdy6dScN_SUyOEMgbwWnS8rDoD97QY59MY7GG3KYhOdTMpAzfO4h8tEoUT20olshRSPkfZZCAPAvVm158cA6_GEDRlCrHSBMfuDK7Em3xiUtOjbZaEtKuBfLLCws8IYLiJxXkEYCmOUNAmHP0Ml-xJN_jkv8ZYqy2CzAmHodvSGkw2z9XBSqMUi7MVKibH0yr486OmCEPmSwtT84qDE03XgwYaX4qCXB5RAhy3YoV_35hOgeoA51ONFdYawejMeQQa-CjiDLfLLdYzDS-cXRbz-wTFaem0qDOtL0VOi_Tn0Dhlx8oNuxVdbMA-E42vbSm76G9nL4WCd67JA9fE-K37e8DOrNVg2FNRsVACW';
    final response = await http.get(
        Uri.parse('https://mobile.celebrityads.net/api/celebrity/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $tokenn'
        });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(response.body);
      Logging.theUser = new TheUser();

      Logging.theUser!.name = jsonDecode(response.body)["data"]?["celebrity"]['name'] == null? '': jsonDecode(response.body)["data"]?["celebrity"]['name'];
      Logging.theUser!.email = jsonDecode(response.body)["data"]?["celebrity"]['email'];
      Logging.theUser!.id = jsonDecode(response.body)["data"]?["celebrity"]['id'].toString();
      Logging.theUser!.phone = jsonDecode(response.body)["data"]?["celebrity"]['phonenumber'].toString();
      Logging.theUser!.image = jsonDecode(response.body)["data"]?["celebrity"]['image'];
      Logging.theUser!.country = jsonDecode(response.body)["data"]?["celebrity"]['country']['name'];
      return CelebrityInformation.fromJson(jsonDecode(response.body));
    } else {
      print(userToken);
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

  @override
  Widget build(BuildContext context) {
   // CheckUserConnection();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBarNoIcon("حسابي"),
        body: ActiveConnection?Center(
          child: SingleChildScrollView(
            child: FutureBuilder<CelebrityInformation>(
              future: celebrity,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: mainLoad(context));
                } else if (snapshot.connectionState == ConnectionState.active ||
                    snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    if (snapshot.error.toString() ==
                        'SocketException') {
                      return Center(
                          child: SizedBox(
                              height: 300.h,
                              width: 250.w,
                              child: internetConnection(
                                  context, reload: () {
                                setState(() {
                                  celebrity = fetchCelebrities(userToken);
                                  isConnectSection = true;
                                });
                              })));
                    } else {
                      return const Center(
                          child: Text(
                              'حدث خطا ما اثناء استرجاع البيانات'));
                    }
                    //---------------------------------------------------------------------------
                  } else if (snapshot.hasData) {
                    return Column(children: [
                      //======================== profile header ===============================

                      Column(
                        children: [
                          SizedBox(
                            height: 20.h,
                          ),
                          InkWell(
                            child: padding(
                              8,
                              8,
                              CircleAvatar(
                                backgroundColor: lightGrey.withOpacity(0.30),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(70.r),
                                          child: imagefile != null? Image.file(imagefile!,fit: BoxFit.fill,
                                            height: double.infinity, width: double.infinity,):
                                          Image.network(
                                            snapshot.data!.data!.celebrity!.image!, fit: BoxFit.fill,
                                            height: double.infinity, width: double.infinity,
                                            loadingBuilder : (context, child, loadingProgress) {
                                            if (loadingProgress == null) return child;
                                            return Center(
                                                child: Lottie.asset('assets/lottie/grey.json', height: 80.h, width: 60.w )
                                            );
                                                  },),
                                        ),
                                radius: 55.r,
                                      ),
                            ),
                            onTap: () {
                              getImage().whenComplete(() => {
                              updateImage(),
                                if(imagefile != null){

                                  showMassage(context, 'تم بنجاح', "تم تغيير الصورة بنجاح",done: done)
                                        }
                                  });

                            },
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          padding(
                            8,
                            8,
                            text(context, snapshot.data!.data!.celebrity!.name!,
                                20, black,
                                fontWeight: FontWeight.bold, family: 'Cairo'),
                          ),
                          padding(
                            8,
                            8,
                            text(
                                context,
                                'الفئة : ' +
                                    snapshot
                                        .data!.data!.celebrity!.category!.name!,
                                12,
                                textBlack,
                                family: 'Cairo'),
                          ),
                          paddingg(
                            20,
                            20,
                            3,
                            text(
                                context,
                                snapshot.data!.data!.celebrity!.description!,
                                12,
                                textBlack,
                                family: 'Cairo',
                                align: TextAlign.center),
                          ),
                        ],
                      ), //profile image

                      //=========================== buttons listView =============================

                      SingleChildScrollView(
                        child: Container(
                          child: paddingg(
                            8,
                            0,
                            20,
                            ListView.separated(
                              primary: false,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return MaterialButton(
                                    onPressed: index == labels.length - 1
                                        ? () {
                                            singOut(context, userToken);
                                          }
                                        : () {
                                      goToPagePushRefresh(context,page[index], then: (value){setState(() {
                                        fetchCelebrities(userToken);
                                      });});
                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //       builder: (context) =>
                                            //           page[index]),
                                            // ).then((value) => null);
                                          },
                                    child: addListViewButton(
                                      labels[index],
                                      icons[index],
                                    ));
                              },
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                              itemCount: labels.length,
                            ),
                          ),
                        ),
                      ),

                      //========================== social media icons row =======================================

                      SizedBox(
                        height: 50.h,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            padding(
                              8,
                              8,
                              Container(
                                  width: 30,
                                  height: 30,
                                  child: Image.asset(
                                    'assets/image/icon- faceboock.png',
                                  )),
                            ),
                            padding(
                              8,
                              8,
                              Container(
                                width: 30,
                                height: 30,
                                child: Image.asset(
                                  'assets/image/icon- insta.png',
                                ),
                              ),
                            ),
                            padding(
                              8,
                              8,
                              Container(
                                width: 30,
                                height: 30,
                                child: Image.asset(
                                  'assets/image/icon- snapchat.png',
                                ),
                              ),
                            ),
                            padding(
                              8,
                              8,
                              Container(
                                width: 30,
                                height: 30,
                                child: Image.asset(
                                  'assets/image/icon- twitter.png',
                                ),
                              ),
                            ),
                            padding(
                              8,
                              8,
                              Container(
                                width: 30,
                                height: 30,
                                child: SvgPicture.asset('assets/Svg/ttt.svg',width: 30,
                                  height: 30,),
                              ),
                            ),
                          ]),


                      paddingg(
                        8,
                        8,
                        12,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              copyRight,
                              size: 14,
                            ),
                            text(
                                context, 'حقوق الطبع والنشر محفوظة', 14, black),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      )
                    ]);
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
        ):Center(
            child:SizedBox(
                height: 300.h,
                width: 250.w,
                child: internetConnection(
                    context, reload: () {
                  CheckUserConnection();
                })))
      ),
    );

  }

  updateImage() async {
    String token2 =
        'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiOWVjZjA0OGYxODVkOGZjYjQ5YTI3ZTgyYjQxYjBmNTg3OTMwYTA3NDY3YTc3ZjQwOGZlYWFmNjliNGYxMDQ4ZjEzMjgxMWU4MWNhMDJlNjYiLCJpYXQiOjE2NTAxOTc4MTIuNjUzNTQ5OTA5NTkxNjc0ODA0Njg3NSwibmJmIjoxNjUwMTk3ODEyLjY1MzU1MzAwOTAzMzIwMzEyNSwiZXhwIjoxNjgxNzMzODEyLjY0Mzg2NjA2MjE2NDMwNjY0MDYyNSwic3ViIjoiMTEiLCJzY29wZXMiOltdfQ.toMOLVGTbNRcIqD801Xs3gJujhMvisCzAHHQC_P8UYp3lmzlG3rwadB4M0rooMIVt82AB2CyZfT37tVVWrjAgNq4diKayoQC5wPT7QQrAp5MERuTTM7zH2n3anZh7uargXP1Mxz3X9PzzTRSvojDlfCMsX1PrTLAs0fGQOVVa-u3lkaKpWkVVa1lls0S755KhZXCAt1lKBNcm7GHF657QCh4_daSEOt4WSF4yq-F6i2sJH-oMaYndass7HMj05wT9Z2KkeIFcZ21ZEAKNstraKUfLzwLr2_buHFNmnziJPG1qFDgHLOUo6Omdw3f0ciPLiLD7FnCrqo_zRZQw9V_tPb1-o8MEZJmAH2dfQWQBey4zZgUiScAwZAiPNcTPBWXmSGQHxYVjubKzN18tq-w1EPxgFJ43sRRuIUHNU15rhMio_prjwqM9M061IzYWgzl3LW1NfckIP65l5tmFOMSgGaPDk18ikJNmxWxpFeBamL6tTsct7-BkEuYEU6GEP5D1L-uwu8GGI_T6f0VSW9sal_5Zo0lEsUuR2nO1yrSF8ppooEkFHlPJF25rlezmaUm0MIicaekbjwKdja5J5ZgNacpoAnoXe4arklcR6djnj_bRcxhWiYa-0GSITGvoWLcbc90G32BBe2Pz3RyoaiHkAYA_BNA_0qmjAYJMwB_e8U';

    var stream =
        new http.ByteStream(DelegatingStream.typed(imagefile!.openRead()));
    // get file length
    var length = await imagefile!.length();

    // string to uri
    var uri =
        Uri.parse("https://mobile.celebrityads.net/api/celebrity/image/update");

    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer $userToken"
    };
    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile =  http.MultipartFile('image', stream, length,
        filename: basename(imagefile!.path));

    // add file to multipart
    request.files.add(multipartFile);
    request.headers.addAll(headers);
    // send
    var response = await request.send();
    print(response.statusCode);

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

  Future<File?> getImage() async {
    PickedFile? pickedFile =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return null;
    }
    final File file = File(pickedFile.path);
    final Directory directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final String fileName = Path.basename(pickedFile.path);
// final String fileExtension = extension(image.path);
    File newImage = await file.copy('$path/$fileName');
    setState(() {
      imagefile = newImage;
      imageurl = imagefile!.path;
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
//--------------------------------------------------------------------------

  void singOut(context, String token) async {
    loadingDialogue(context);
    const url = 'https://mobile.celebrityads.net/api/logout';
    final respons = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userToken'
    });
    if (respons.statusCode == 200) {
      Navigator.pop(context);
      String massage=jsonDecode(respons.body)['message']['ar'];
      ScaffoldMessenger.of(context).showSnackBar(
          snackBar(context, massage, green, done));
      DatabaseHelper.removeRememberToken();
      goTopageReplacement(context,  Logging());
    } else {
      Navigator.pop(context);
      throw Exception('logout field');
    }
  }
}
