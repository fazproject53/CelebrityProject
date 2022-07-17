import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:celepraty/Celebrity/Activity/news/addNews.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Account/LoggingSingUpAPI.dart';
import '../../../Account/logging.dart';
import '../../setting/profileInformation.dart';

class news extends StatefulWidget {
  _newsState createState() => _newsState();
}

class _newsState extends State<news> {
  bool add = false;
  bool edit = false;
  Future<GeneralNews>? getNews;
String? userToken;
 Map<int, String> tempTitle = HashMap<int, String>();
 Map<int, String> tempDesc = HashMap<int, String>();
  int? theindex;
  bool? temp;
  final _baseUrl = 'https://jsonplaceholder.typicode.com/posts';
  TextEditingController newstitle = new TextEditingController();
  TextEditingController newsdesc = new TextEditingController();

  @override
  void initState() {
   DatabaseHelper.getToken().then((value) {
     setState(() {
       userToken = value;
       getNews = fetchNews(userToken!);
     });
   });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    // setState(() {
    //   getNews = fetchNews();
    // });
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: add
            ? addNews()
            : SafeArea(
                child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 30.w,
                        ),
                        gradientContainerNoborder2(
                            150.w,
                            45.h,
                            buttoms(context, 'اضافة خبر', 14, white, () {
                              setState(() {
                                add = true;
                              });
                            })),
                      ],
                    ),
                    FutureBuilder<GeneralNews>(
                      future: getNews,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: mainLoad(context));
                        } else if (snapshot.connectionState ==
                                ConnectionState.active ||
                            snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                            //---------------------------------------------------------------------------
                          } else if (snapshot.hasData) {
                            return paddingg(
                              10,
                              10,
                              20,
                              ListView.builder(
                                itemCount: snapshot.data!.data!.news!.length,
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemBuilder: (context, index) {

                                  return paddingg(
                                    8,
                                    8,
                                    5,
                                    SizedBox(
                                      height: edit && theindex == index
                                          ? 180.h
                                          : 150,
                                      width: 300.w,
                                      child: Card(
                                        elevation: 5,
                                        color: white,
                                        child: paddingg(
                                          0,
                                          0,
                                          8,
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  paddingg(
                                                    5,
                                                    5,
                                                    0,
                                                    Container(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(2.0),
                                                        child: Image.network(
                                                          Logging.theUser!.image!,
                                                          fit: BoxFit.fill,
                                                          height: edit
                                                              ? 150.h
                                                              : 130.h,
                                                          width: 100.w,
                                                        ),
                                                      ),
                                                      margin: EdgeInsets.only(
                                                          bottom: 5.h),
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        height: 10.h,
                                                      ),
                                                      Container(
                                                        width: 190.w,
                                                        height: 35.h,
                                                        child:
                                                            edit &&
                                                                    theindex ==
                                                                        index
                                                                ? TextFormField(
                                                                    cursorColor:
                                                                        black,
                                                                    controller:
                                                                        newstitle,
                                                                    style: TextStyle(
                                                                        color:
                                                                            black,
                                                                        fontSize:
                                                                            12,
                                                                        fontFamily:
                                                                            'Cairo'),
                                                                    decoration: InputDecoration(
                                                                        fillColor:
                                                                            lightGrey,
                                                                        focusedBorder: UnderlineInputBorder(
                                                                            borderSide: BorderSide(
                                                                                color:
                                                                                    pink)),
                                                                        contentPadding:
                                                                            EdgeInsets.all(0.h)),
                                                                  )
                                                                : text(
                                                                    context,
                                                                    tempTitle.containsKey(snapshot.data!.data!.news![index].id!)?
                                                                    tempTitle[snapshot.data!.data!.news![index].id!]! :snapshot.data!.data!.news![index].title!,
                                                                    14,
                                                                    black),
                                                      ),
                                                      SizedBox(
                                                        height: edit &&
                                                                theindex ==
                                                                    index
                                                            ? 8.h
                                                            : 0.h,
                                                      ),
                                                      Container(
                                                        width: 190.w,
                                                        child:
                                                            edit &&
                                                                    theindex ==
                                                                        index
                                                                ? TextFormField(
                                                                    cursorColor:
                                                                        black,
                                                                    controller:
                                                                        newsdesc,
                                                                    maxLines: 3,
                                                                    style: TextStyle(
                                                                        color:
                                                                            black,
                                                                        fontSize:
                                                                            12,
                                                                        fontFamily:
                                                                            'Cairo'),
                                                                    decoration: InputDecoration(
                                                                        fillColor:
                                                                            lightGrey,
                                                                        focusedBorder: UnderlineInputBorder(
                                                                            borderSide: BorderSide(
                                                                                color:
                                                                                    pink)),
                                                                        contentPadding:
                                                                            EdgeInsets.all(0.h)),
                                                                  )
                                                                : text(
                                                                    context,
                                                                tempDesc.containsKey(snapshot.data!.data!.news![index].id!)?
                                                                tempDesc[snapshot.data!.data!.news![index].id!]! :snapshot.data!.data!.news![index].description!,
                                                                    14,
                                                                    black),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              edit && theindex == index
                                                  ? Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 110.0.h,
                                                          left: 15.w,
                                                          right: 15.w),
                                                      child: InkWell(
                                                        child: Container(
                                                          child: Icon(
                                                            save,
                                                            color: white,
                                                            size: 18,
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              50),
                                                                  gradient:
                                                                      const LinearGradient(
                                                                    begin:
                                                                        Alignment(
                                                                            0.7,
                                                                            2.0),
                                                                    end: Alignment(
                                                                        -0.69,
                                                                        -1.0),
                                                                    colors: [
                                                                      Color(
                                                                          0xff0ab3d0),
                                                                      Color(
                                                                          0xffe468ca)
                                                                    ],
                                                                    stops: [
                                                                      0.0,
                                                                      1.0
                                                                    ],
                                                                  )),
                                                          height: 28.h,
                                                          width: 32.w,
                                                        ),
                                                        onTap: () {
                                                          setState(() {
                                                            tempTitle.putIfAbsent(snapshot.data!.data!.news![index].id!, () => newstitle.text);
                                                            tempDesc.putIfAbsent(snapshot.data!.data!.news![index].id!, () => newsdesc.text);
                                                            updateNews(snapshot.data!.data!.news![index].id!, userToken!);
                                                            edit = false;

                                                          });
                                                        },
                                                      ),
                                                    )
                                                  : Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 30.0.h,
                                                          left: 10.w,
                                                          right: 15.w),
                                                      child: Column(
                                                        children: [
                                                          InkWell(
                                                            child: Container(
                                                              child: Icon(
                                                                editDiscount,
                                                                color: white,
                                                                size: 18,
                                                              ),
                                                              decoration:
                                                                  BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              50),
                                                                      gradient:
                                                                          const LinearGradient(
                                                                        begin: Alignment(
                                                                            0.7,
                                                                            2.0),
                                                                        end: Alignment(
                                                                            -0.69,
                                                                            -1.0),
                                                                        colors: [
                                                                          Color(
                                                                              0xff0ab3d0),
                                                                          Color(
                                                                              0xffe468ca)
                                                                        ],
                                                                        stops: [
                                                                          0.0,
                                                                          1.0
                                                                        ],
                                                                      )),
                                                              height: 28.h,
                                                              width: 32.w,
                                                            ),
                                                            onTap: () {
                                                              setState(() {
                                                                newstitle.text = tempTitle.containsKey(snapshot.data!.data!.news![index].id!)?
                                                                tempTitle[snapshot.data!.data!.news![index].id!]! : snapshot.data!.data!.news![index].title!;
                                                                newsdesc.text = tempDesc.containsKey(snapshot.data!.data!.news![index].id!)?
                                                                tempDesc[snapshot.data!.data!.news![index].id!]! : snapshot.data!.data!.news![index].description!;
                                                                edit = true;
                                                                theindex =
                                                                    index;

                                                              });
                                                            },
                                                          ),
                                                          SizedBox(
                                                            height: 15.h,
                                                          ),
                                                          InkWell(
                                                            child: Container(
                                                              child: Icon(
                                                                removeDiscount,
                                                                color: white,
                                                                size: 18,
                                                              ),
                                                              decoration:
                                                                  BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              50),
                                                                      gradient:
                                                                          const LinearGradient(
                                                                        begin: Alignment(
                                                                            0.7,
                                                                            2.0),
                                                                        end: Alignment(
                                                                            -0.69,
                                                                            -1.0),
                                                                        colors: [
                                                                          Color(
                                                                              0xff0ab3d0),
                                                                          Color(
                                                                              0xffe468ca)
                                                                        ],
                                                                        stops: [
                                                                          0.0,
                                                                          1.0
                                                                        ],
                                                                      )),
                                                              height: 28.h,
                                                              width: 32.w,
                                                            ),
                                                            onTap: (){
                                                              setState(() {
                                                                showDialog<String>(
                                                                  context: context,
                                                                  builder: (BuildContext context) =>
                                                                      AlertDialog(
                                                                        title: Directionality(
                                                                            textDirection: TextDirection.rtl,
                                                                            child: text(context, 'حذف خبر', 16, black,)),
                                                                        content: Directionality(
                                                                            textDirection: TextDirection.rtl,
                                                                            child: text(context, 'هل انت متأكد من انك تريد حذف الخبر ؟', 14, black,)),
                                                                        actions: <Widget>[
                                                                          Padding(
                                                                            padding:  EdgeInsets.only(top: 0.h,),
                                                                            child: TextButton(
                                                                                onPressed: () =>
                                                                                    Navigator.pop(
                                                                                        context,
                                                                                        'الغاء'),
                                                                                child: text(context, 'الغاء', 15, purple)
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding:  EdgeInsets.only(bottom: 0.h, right: 0.w),
                                                                            child: TextButton(
                                                                                onPressed: () => setState(() {
                                                                                  deleteNew(snapshot.data!.data!.news![index].id!, userToken!);
                                                                                  Navigator.pop(
                                                                                      context,
                                                                                      'حذف');

                                                                                }),
                                                                                child: text(context, 'حذف', 15, purple)
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),);

                                                            });}
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          } else {
                            return const Center(child: Text('Empty data'));
                          }
                        } else {
                          return Center(
                              child:
                                  Text('State: ${snapshot.connectionState}'));
                        }
                      },
                    )
                  ],
                ),
              )),
      ),
    );
  }

  Future<http.Response> deleteNew(int id, String token) async {
    String token2 =
        'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiOWVjZjA0OGYxODVkOGZjYjQ5YTI3ZTgyYjQxYjBmNTg3OTMwYTA3NDY3YTc3ZjQwOGZlYWFmNjliNGYxMDQ4ZjEzMjgxMWU4MWNhMDJlNjYiLCJpYXQiOjE2NTAxOTc4MTIuNjUzNTQ5OTA5NTkxNjc0ODA0Njg3NSwibmJmIjoxNjUwMTk3ODEyLjY1MzU1MzAwOTAzMzIwMzEyNSwiZXhwIjoxNjgxNzMzODEyLjY0Mzg2NjA2MjE2NDMwNjY0MDYyNSwic3ViIjoiMTEiLCJzY29wZXMiOltdfQ.toMOLVGTbNRcIqD801Xs3gJujhMvisCzAHHQC_P8UYp3lmzlG3rwadB4M0rooMIVt82AB2CyZfT37tVVWrjAgNq4diKayoQC5wPT7QQrAp5MERuTTM7zH2n3anZh7uargXP1Mxz3X9PzzTRSvojDlfCMsX1PrTLAs0fGQOVVa-u3lkaKpWkVVa1lls0S755KhZXCAt1lKBNcm7GHF657QCh4_daSEOt4WSF4yq-F6i2sJH-oMaYndass7HMj05wT9Z2KkeIFcZ21ZEAKNstraKUfLzwLr2_buHFNmnziJPG1qFDgHLOUo6Omdw3f0ciPLiLD7FnCrqo_zRZQw9V_tPb1-o8MEZJmAH2dfQWQBey4zZgUiScAwZAiPNcTPBWXmSGQHxYVjubKzN18tq-w1EPxgFJ43sRRuIUHNU15rhMio_prjwqM9M061IzYWgzl3LW1NfckIP65l5tmFOMSgGaPDk18ikJNmxWxpFeBamL6tTsct7-BkEuYEU6GEP5D1L-uwu8GGI_T6f0VSW9sal_5Zo0lEsUuR2nO1yrSF8ppooEkFHlPJF25rlezmaUm0MIicaekbjwKdja5J5ZgNacpoAnoXe4arklcR6djnj_bRcxhWiYa-0GSITGvoWLcbc90G32BBe2Pz3RyoaiHkAYA_BNA_0qmjAYJMwB_e8U';

    final http.Response response = await http.delete(
      Uri.parse('https://mobile.celebrityads.net/api/celebrity/news/delete/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    setState(() {
      getNews = fetchNews(userToken!);
    });
    return response;
  }

  Future<http.Response> updateNews(int id, String token) async {
    String token2 =
        'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiOWVjZjA0OGYxODVkOGZjYjQ5YTI3ZTgyYjQxYjBmNTg3OTMwYTA3NDY3YTc3ZjQwOGZlYWFmNjliNGYxMDQ4ZjEzMjgxMWU4MWNhMDJlNjYiLCJpYXQiOjE2NTAxOTc4MTIuNjUzNTQ5OTA5NTkxNjc0ODA0Njg3NSwibmJmIjoxNjUwMTk3ODEyLjY1MzU1MzAwOTAzMzIwMzEyNSwiZXhwIjoxNjgxNzMzODEyLjY0Mzg2NjA2MjE2NDMwNjY0MDYyNSwic3ViIjoiMTEiLCJzY29wZXMiOltdfQ.toMOLVGTbNRcIqD801Xs3gJujhMvisCzAHHQC_P8UYp3lmzlG3rwadB4M0rooMIVt82AB2CyZfT37tVVWrjAgNq4diKayoQC5wPT7QQrAp5MERuTTM7zH2n3anZh7uargXP1Mxz3X9PzzTRSvojDlfCMsX1PrTLAs0fGQOVVa-u3lkaKpWkVVa1lls0S755KhZXCAt1lKBNcm7GHF657QCh4_daSEOt4WSF4yq-F6i2sJH-oMaYndass7HMj05wT9Z2KkeIFcZ21ZEAKNstraKUfLzwLr2_buHFNmnziJPG1qFDgHLOUo6Omdw3f0ciPLiLD7FnCrqo_zRZQw9V_tPb1-o8MEZJmAH2dfQWQBey4zZgUiScAwZAiPNcTPBWXmSGQHxYVjubKzN18tq-w1EPxgFJ43sRRuIUHNU15rhMio_prjwqM9M061IzYWgzl3LW1NfckIP65l5tmFOMSgGaPDk18ikJNmxWxpFeBamL6tTsct7-BkEuYEU6GEP5D1L-uwu8GGI_T6f0VSW9sal_5Zo0lEsUuR2nO1yrSF8ppooEkFHlPJF25rlezmaUm0MIicaekbjwKdja5J5ZgNacpoAnoXe4arklcR6djnj_bRcxhWiYa-0GSITGvoWLcbc90G32BBe2Pz3RyoaiHkAYA_BNA_0qmjAYJMwB_e8U';
    final response = await http.post(
      Uri.parse(
        'https://mobile.celebrityads.net/api/celebrity/news/update/${id}',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, dynamic>{
        "title" : newstitle.text,
        "description" : newsdesc.text
      }),
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      print(response.body);
      return response;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load activity');
    }
  }
}


Future<GeneralNews> fetchNews(String tokenn) async {
  String token =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiOWVjZjA0OGYxODVkOGZjYjQ5YTI3ZTgyYjQxYjBmNTg3OTMwYTA3NDY3YTc3ZjQwOGZlYWFmNjliNGYxMDQ4ZjEzMjgxMWU4MWNhMDJlNjYiLCJpYXQiOjE2NTAxOTc4MTIuNjUzNTQ5OTA5NTkxNjc0ODA0Njg3NSwibmJmIjoxNjUwMTk3ODEyLjY1MzU1MzAwOTAzMzIwMzEyNSwiZXhwIjoxNjgxNzMzODEyLjY0Mzg2NjA2MjE2NDMwNjY0MDYyNSwic3ViIjoiMTEiLCJzY29wZXMiOltdfQ.toMOLVGTbNRcIqD801Xs3gJujhMvisCzAHHQC_P8UYp3lmzlG3rwadB4M0rooMIVt82AB2CyZfT37tVVWrjAgNq4diKayoQC5wPT7QQrAp5MERuTTM7zH2n3anZh7uargXP1Mxz3X9PzzTRSvojDlfCMsX1PrTLAs0fGQOVVa-u3lkaKpWkVVa1lls0S755KhZXCAt1lKBNcm7GHF657QCh4_daSEOt4WSF4yq-F6i2sJH-oMaYndass7HMj05wT9Z2KkeIFcZ21ZEAKNstraKUfLzwLr2_buHFNmnziJPG1qFDgHLOUo6Omdw3f0ciPLiLD7FnCrqo_zRZQw9V_tPb1-o8MEZJmAH2dfQWQBey4zZgUiScAwZAiPNcTPBWXmSGQHxYVjubKzN18tq-w1EPxgFJ43sRRuIUHNU15rhMio_prjwqM9M061IzYWgzl3LW1NfckIP65l5tmFOMSgGaPDk18ikJNmxWxpFeBamL6tTsct7-BkEuYEU6GEP5D1L-uwu8GGI_T6f0VSW9sal_5Zo0lEsUuR2nO1yrSF8ppooEkFHlPJF25rlezmaUm0MIicaekbjwKdja5J5ZgNacpoAnoXe4arklcR6djnj_bRcxhWiYa-0GSITGvoWLcbc90G32BBe2Pz3RyoaiHkAYA_BNA_0qmjAYJMwB_e8U';

  final response = await http.get(
      Uri.parse('https://mobile.celebrityads.net/api/celebrity/news'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $tokenn'
      });
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print(response.body);
    return GeneralNews.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load activity');
  }
}

class GeneralNews {
  bool? success;
  Data? data;
  Message? message;

  GeneralNews({this.success, this.data, this.message});

  GeneralNews.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message =
        json['message'] != null ? new Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    return data;
  }
}

class Data {
  List<News>? news;
  int? status;

  Data({this.news, this.status});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['news'] != null) {
      news = <News>[];
      json['news'].forEach((v) {
        news!.add(new News.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.news != null) {
      data['news'] = this.news!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class News {
  int? id;
  String? title;
  String? description;

  News({this.id, this.title, this.description});

  News.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
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
