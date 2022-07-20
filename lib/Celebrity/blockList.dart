import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:celepraty/Account/logging.dart' as login;
import 'package:lottie/lottie.dart';

import '../Account/LoggingSingUpAPI.dart';
class blockList extends StatefulWidget {
  _blockListState createState() => _blockListState();
}

class _blockListState extends State<blockList> {
  Future<Block>? blockedUsers;

  String? userToken;
  @override
  void initState() {
    DatabaseHelper.getToken().then((value) {
      setState(() {
        userToken = value;
        blockedUsers = getBlockList(userToken!);
      });
    });
    // TODO: implement initState
    super.initState();
  }

  bool isConnectSection = true;
  bool timeoutException = true;
  bool serverExceptions = true;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: drowAppBar( 'قائمة الحظر', context),
        body:  FutureBuilder(
            future: blockedUsers,
            builder: ((context, AsyncSnapshot<Block> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: mainLoad(context));
              } else if (snapshot.connectionState ==
                  ConnectionState.active ||
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
                                blockedUsers = getBlockList(userToken!);
                                isConnectSection = true;
                              });
                            })));
                  } else {
                    if(snapshot.error.toString() ==
                        'ServerException'){
                      Center(
                          child: serverError(context));
                    }
                    return  Center(
                        child: serverError(context));
                  }
                  //---------------------------------------------------------------------------
                } else if (snapshot.hasData) {
                  return snapshot.data!.data!.blackList!.isEmpty? Padding(
                    padding:  EdgeInsets.only(top: getSize(context).height/4),
                    child: Center(child: Column(
                      children: [
                        Padding(
                          padding:  EdgeInsets.only(left:50.0.w, right: 50.w),
                          child: LottieBuilder.asset('assets/lottie/peace.json'),
                        ),
                        text(context, 'لايوجد متابعين محظورين', 20, black),
                      ],
                    )),
                  ) :Stack(
          children: [
            Container(
              height: 300.h,
              width: 1000.w,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(0.7, 2.0),
                    end: Alignment(-0.69, -1.0),
                    colors: [
                      Color(0xff0ab3d0).withOpacity(0.60),
                      Color(0xffe468ca).withOpacity(0.80)
                    ],
                    stops: [0.0, 1.0],
                  ),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.r),
                      bottomRight: Radius.circular(30.r))),
            ),

                       paddingg(
                        10,
                        10,
                        10,
                        ListView.builder(
                          itemCount: snapshot.data!.data!.blackList!.length,
                          itemBuilder: (context, index) {
                            return paddingg(
                              8,
                              8,
                              5,
                              SizedBox(
                                height: 160.h,
                                width: 100.w,
                                child: Card(
                                  elevation: 10,
                                  color: white,
                                  child: paddingg(
                                    0,
                                    0,
                                    10,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        paddingg(
                                          15,
                                          30,
                                          0,
                                          Container(
                                            alignment: Alignment.centerRight,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              child: Image.network(
                                                snapshot.data!.data!.blackList![index].user!.image!,
                                                fit: BoxFit.fill,
                                                height: 100.h,
                                                width: 100.w,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10.h,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            text(context, snapshot.data!.data!.blackList![index].user!.name!, 14,
                                                black),
                                            text(
                                                context,
                                                'وقت الحظر: ' + snapshot.data!.data!.blackList![index].date.toString(),
                                                14,
                                                black),
                                            text(context, 'الحظر بسبب ' + snapshot.data!.data!.blackList![index].banReson!.name!,
                                                14, black),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            Row(
                                              children: [
                                                gradientContainerNoborder2(
                                                  80,
                                                  33,
                                                  buttoms(context, 'فك الحظر',
                                                      12, white, () {}),
                                                ),
                                                SizedBox(
                                                  width: 10.w,
                                                ),
                                                InkWell(
                                                    child: Container(
                                                      width: 80.w,
                                                      height: 33.h,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      10.r)),
                                                          border: Border.all(
                                                              color:
                                                                  deepBlack)),
                                                      child: Center(
                                                          child: text(
                                                              context,
                                                              'ابلاغ',
                                                              12,
                                                              black,
                                                              align: TextAlign
                                                                  .center)),
                                                    ),
                                                    onTap: () {}),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ]);
                    } else {
                      return const Center(
                          child: Text('لايوجد لينك لعرضهم حاليا'));
                    }
                  } else {
                    return Center(
                        child: Text('State: ${snapshot.connectionState}'));
                  }
                })),

        ),
      );

  }

  Future<Block> getBlockList(String tokenn) async {

    try {
      final response = await http.get(
          Uri.parse('https://mobile.celebrityads.net/api/celebrity/black-list'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $tokenn'
          });


      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        Block o = Block.fromJson(jsonDecode(response.body));
        return o;
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
}


class Block {
  bool? success;
  Data? data;
  Message? message;

  Block({this.success, this.data, this.message});

  Block.fromJson(Map<String, dynamic> json) {
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
  List<BlackList>? blackList;
  int? status;

  Data({this.blackList, this.status});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['blackList'] != null) {
      blackList = <BlackList>[];
      json['blackList'].forEach((v) {
        blackList!.add(new BlackList.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.blackList != null) {
      data['blackList'] = this.blackList!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class BlackList {
  String? date;
  Celebrity? celebrity;
  User? user;
  AccountStatus? banReson;

  BlackList({this.date, this.celebrity, this.user, this.banReson});

  BlackList.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    celebrity = json['celebrity'] != null
        ? new Celebrity.fromJson(json['celebrity'])
        : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    banReson = json['ban_reson'] != null
        ? new AccountStatus.fromJson(json['ban_reson'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    if (this.celebrity != null) {
      data['celebrity'] = this.celebrity!.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.banReson != null) {
      data['ban_reson'] = this.banReson!.toJson();
    }
    return data;
  }
}

class Celebrity {
  int? id;
  String? username;
  String? name;
  String? image;
  String? email;
  String? phonenumber;
  Country? country;
  Null? city;
  Null? gender;
  AccountStatus? accountStatus;
  String? type;

  Celebrity(
      {this.id,
      this.username,
      this.name,
      this.image,
      this.email,
      this.phonenumber,
      this.country,
      this.city,
      this.gender,
      this.accountStatus,
      this.type});

  Celebrity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    name = json['name'];
    image = json['image'];
    email = json['email'];
    phonenumber = json['phonenumber'];
    country =
        json['country'] != null ? new Country.fromJson(json['country']) : null;
    city = json['city'];
    gender = json['gender'];
    accountStatus = json['account_status'] != null
        ? new AccountStatus.fromJson(json['account_status'])
        : null;
    type = json['type'];
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
    data['gender'] = this.gender;
    if (this.accountStatus != null) {
      data['account_status'] = this.accountStatus!.toJson();
    }
    data['type'] = this.type;
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

class AccountStatus {
  int? id;
  String? name;
  String? nameEn;

  AccountStatus({this.id, this.name, this.nameEn});

  AccountStatus.fromJson(Map<String, dynamic> json) {
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

class User {
  int? id;
  String? username;
  String? name;
  String? image;
  String? email;
  String? phonenumber;
  Country? country;
  City? city;
  Null? gender;
  AccountStatus? accountStatus;
  String? type;

  User(
      {this.id,
      this.username,
      this.name,
      this.image,
      this.email,
      this.phonenumber,
      this.country,
      this.city,
      this.gender,
      this.accountStatus,
      this.type});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    name = json['name'];
    image = json['image'];
    email = json['email'];
    phonenumber = json['phonenumber'];
    country =
        json['country'] != null ? new Country.fromJson(json['country']) : null;
    city = json['city'] != null ? new City.fromJson(json['city']) : null;
    gender = json['gender'];
    accountStatus = json['account_status'] != null
        ? new AccountStatus.fromJson(json['account_status'])
        : null;
    type = json['type'];
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
    if (this.city != null) {
      data['city'] = this.city!.toJson();
    }
    data['gender'] = this.gender;
    if (this.accountStatus != null) {
      data['account_status'] = this.accountStatus!.toJson();
    }
    data['type'] = this.type;
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
