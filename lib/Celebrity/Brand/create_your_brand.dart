///import section
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:flutter/material.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../Account/LoggingSingUpAPI.dart';
import 'ModelBrand.dart';



///-------------------------HomeBody YourBrand-------------------------
class YourBrandHome extends StatefulWidget {
  const YourBrandHome({Key? key}) : super(key: key);

  @override
  _YourBrandHomeState createState() => _YourBrandHomeState();
}

class _YourBrandHomeState extends State<YourBrandHome> {

  Future<ModelBrand>? brand;

  bool isConnectSection = true;
  bool timeoutException = true;
  bool serverExceptions = true;

  bool activeConnection = true;
  String T = "";

  String? userToken;
  @override
  void initState() {
    DatabaseHelper.getToken().then((value) {
      setState(() {
        userToken = value;
        brand = getBrandInfo(userToken!);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: drowAppBar("علامتك التجارية", context),
        body: activeConnection ?  SingleChildScrollView(
          child: FutureBuilder<ModelBrand>(
            future: brand,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: mainLoad(context));
              }else if(snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done){
                if (snapshot.hasError) {
                  if (snapshot.error.toString() == 'SocketException') {
                    return Center(
                        child: SizedBox(
                            height: 500.h,
                            width: 250.w,
                            child: internetConnection(context, reload: () {
                              setState(() {
                                brand = getBrandInfo(userToken!);
                                isConnectSection = true;
                              });
                            })));
                  } else {
                    return const Center(
                        child: Text('حدث خطا ما اثناء استرجاع البيانات'));
                  }
                  //---------------------------------------------------------------------------
                }else if (snapshot.hasData) {
                  return  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.topRight,
                        child: Padding(
                          ///Main title
                          padding: EdgeInsets.only(top: 25.h, right: 20.w),
                          child: text(
                            context,
                            snapshot.data!.data!.title!,
                            19,
                            ligthtBlack,fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      ///Text Description
                      Padding(
                        padding: EdgeInsets.only(top: 15.h,right: 20.w,left: 50.w),
                        child: text(context,snapshot.data!.data!.description!,14,ligthtBlack,
                            align: TextAlign.justify),
                      ),
                      ///Buttons to go to ALmattager app (outside api)
                      Container(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.only(top: 20.h, right: 20.w),
                          child: gradientContainerNoborder(
                            140.0,
                            buttoms(
                              context,
                              "إنشاء علامتك", 15, white, () => launch(snapshot.data!.data!.link!), evaluation: 0,
                            ),
                            height: 40,
                          ),
                        ),
                      )
                    ],
                  );
                }else{
                  return const Center(child: Text('Empty data'));
                }

              }else{
                return Center(
                    child: Text('State: ${snapshot.connectionState}'));
              }
            },
          ),
        ) : Center(
            child: SizedBox(
                height: 300.h,
                width: 250.w,
                child: internetConnection(
                    context, reload: () {
                  checkUserConnection();
                  brand = getBrandInfo(userToken!);
                })))
      ),
    );
  }

///Get
Future<ModelBrand> getBrandInfo(String token) async {
  try {
    final response = await http.get(
        Uri.parse('https://mobile.celebrityads.net/api/brand'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //print(response.body);
      return ModelBrand.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load activity');
    }
  } catch (error) {
    if (error is SocketException) {
      setState(() {
        isConnectSection = false;
      });
      return Future.error('SocketException');
    } else if (error is TimeoutException) {
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

  Future checkUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          activeConnection = true;
          T = "Turn off the data and repress again";
        });
      }
    } on SocketException catch (_) {
      setState(() {
        activeConnection = false;
        T = "Turn On the data and repress again";
      });
    }
  }
}






















