import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:celepraty/Celebrity/Activity/ExpandableFab%20.dart';
import 'package:celepraty/Celebrity/Activity/studio/addVideo.dart';
import 'package:celepraty/Celebrity/Activity/studio/addphoto.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

import '../../../Account/LoggingSingUpAPI.dart';
import '../../setting/profileInformation.dart';

class Studio extends StatefulWidget {
  _StudioState createState() => _StudioState();
}

class _StudioState extends State<Studio> {

  final _baseUrl ='https://mobile.celebrityads.net/api/celebrity/studio';
  int _page = 1;

  bool ActiveConnection = false;
  String T = "";
  // There is next page or not
  bool _hasNextPage = true;

  // Used to display loading indicators when _firstLoad function is running
  bool _isFirstLoadRunning = false;

  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunning = false;

  // This holds the posts fetched from the server
  List _posts = [];
   ScrollController _controller = ScrollController();

  bool isConnectSection = true;
  bool timeoutException = true;
  bool serverExceptions = true;

  Future<TheStudio>? getStudio;
  late VideoPlayerController _videoPlayerController;
  bool addp = false;
  bool addv = false;
  String? userToken;
  static const _actionTitles = ['Create Post', 'Upload Photo', 'Upload Video'];



  void _loadMore() async {

    print('#########################################################');

    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false && _controller.position.maxScrollExtent ==
        _controller.offset ) {

        setState(() {
          _isLoadMoreRunning = true; // Display a progress indicator at the bottom
        });
        _page += 1;
        try {
          final res =
          await http.get(Uri.parse("$_baseUrl?page=$_page"), headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $userToken'
          });

          if (TheStudio
              .fromJson(jsonDecode(res.body))
              .data!
              .studio!
              .isNotEmpty) {
            setState(() {
              _posts.addAll(TheStudio
                  .fromJson(jsonDecode(res.body))
                  .data!
                  .studio!);
            });
          } else {
            setState(() {
              _hasNextPage = false;
            });
          }
        } catch (err) {
          if (kDebugMode) {
            print('Something went wrong!');
          }
        }

          setState(() {
            _isLoadMoreRunning = false;
          });
        }
  }
  Future CheckUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          ActiveConnection = true;
          T = "Turn off the data and repress again";
        });
      }
    } on SocketException catch (_) {
      setState(() {
        ActiveConnection = false;
        T = "Turn On the data and repress again";
      });
    }
  }
  @override
  void initState() {
    super.initState();
    CheckUserConnection();
    DatabaseHelper.getToken().then((value) {
      setState(() {
        userToken = value;
        fetchStudio();
      });

    });
    _controller.addListener(_loadMore);
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        floatingActionButton: addv || addp
            ? null
            : ExpandableFab(
          distance: 80.0,
          children: [
            ActionButton(
              onPressed: () =>
              {
                setState(() {
                  addv = true;
                })
              },
              icon: Icon(
                videoIcon,
                color: white,
              ),
              color: pink,
            ),
            ActionButton(
              onPressed: () =>
              {
                setState(() {
                  addp = true;
                })
              },
              icon: Icon(
                imageIcon,
                color: white,
              ),
              color: pink,
            ),
          ],
        ),
        body: addp
            ? addphoto()
            : addv
            ? addVideo()
            : SingleChildScrollView(
          controller: _controller,
          child: _isFirstLoadRunning
              ?  ActiveConnection?Center(
            child: mainLoad(context),
          ):Center(
              child:SizedBox(
                  height: 300.h,
                  width: 250.w,
                  child: internetConnection(
                      context, reload: () {
                    CheckUserConnection();
                    _posts.clear();
                    _page = 1;
                    // There is next page or not
                    _hasNextPage = true;

                    // Used to display loading indicators when _firstLoad function is running
                    _isFirstLoadRunning = false;

                    // Used to display loading indicators when _loadMore function is running
                    _isLoadMoreRunning = false;
                    fetchStudio();
                  })))
              : _posts.isEmpty ? Padding(
            padding: EdgeInsets.only(top: getSize(context).height / 7),
            child: Center(child: Column(
              children: [
                Image.asset(
                  'assets/image/studio.png', height: 150.h, width: 150.w,),
                text(context, 'لا توجد وسائط حاليا', 23, black),
              ],
            )),
          ) : Column(
            children: [
              paddingg(
                10,
                10,
                0,
                 ListView.builder(
                    itemCount: _posts.length,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemBuilder: (_, index) {
                      return paddingg(
                        5,
                        5,
                        5,
                        SizedBox(
                          height: 140.h,
                          width: 270.w,
                          child: Card(
                            elevation: 5,
                            color: white,
                            child: paddingg(
                              0,
                              0,
                              0,
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      paddingg(
                                        5,
                                        2,
                                        0,
                                        Container(
                                          margin: EdgeInsets.only(
                                              bottom: 2.h, top: 2.h),
                                          alignment: Alignment
                                              .centerRight,
                                          child: ClipRRect(
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                                2.0),
                                            child: _posts[index].type! ==
                                                "image" ? Image.network(
                                              _posts[index].image!,
                                              fit: BoxFit
                                                  .fill,
                                              height: double.infinity.h,
                                              width: 125.w,
                                            ) : Container(
                                                height: double.infinity.h,
                                                width: 100.w,
                                                child: VideoPlayer(
                                                    VideoPlayerController
                                                        .network(
                                                        _posts[index].image!)
                                                      ..initialize())),

                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 3.w,),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                        children: [
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          SingleChildScrollView(
                                            child: Container(
                                              width: 180.w,
                                              height: 100.h,
                                              child: text(
                                                  context,
                                                  _posts[index].description!,
                                                  14,
                                                  black),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Padding(
                                    padding:
                                    EdgeInsets.only(
                                        bottom: 20.h,
                                        left: 15.w),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,
                                      children: [
                                        SizedBox(
                                          height: 30.h,
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
                                          onTap: () {
                                            showDialog<String>(
                                              context: context,
                                              builder: (
                                                  BuildContext context) =>
                                                  AlertDialog(
                                                    title: Directionality(
                                                        textDirection: TextDirection
                                                            .rtl,
                                                        child: text(context,
                                                          'حذف من الاستديو',
                                                          16, black,)),
                                                    content: Directionality(
                                                        textDirection: TextDirection
                                                            .rtl,
                                                        child: text(context,
                                                          'هل انت متأكد من انك تريد الحذف ؟',
                                                          14, black,)),
                                                    actions: <Widget>[
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .only(top: 0.h,),
                                                        child: TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context,
                                                                    'الغاء'),
                                                            child: text(
                                                                context,
                                                                'الغاء', 15,
                                                                purple)
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .only(bottom: 0.h,
                                                            right: 0.w),
                                                        child: TextButton(
                                                            onPressed: () =>
                                                                setState(() {
                                                                  deleteStudio(
                                                                      _posts[index]
                                                                          .id!);
                                                                  Navigator
                                                                      .pop(
                                                                      context,
                                                                      'حذف');
                                                                }),
                                                            child: text(
                                                                context,
                                                                'حذف', 15,
                                                                purple)
                                                        ),
                                                      ),
                                                    ],
                                                  ),);
                                          },
                                        )
                                      ],
                                    ),
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

              if (_isLoadMoreRunning == true)
                const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 40),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),

              // When nothing else to load

            ],
          ),


        )


      ),

    );

  }

void fetchStudio() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      final response = await http.get(
          Uri.parse('$_baseUrl?page=$_page'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $userToken'
          });
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        setState(() {
          _posts = TheStudio
              .fromJson(jsonDecode(response.body))
              .data!
              .studio!;
        });
        print(response.body);

      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load activity');
      }
    }catch (err) {
      if (kDebugMode) {
        print('first load Something went wrong');
      }
    }
    setState(() {
      _isFirstLoadRunning = false;
      print(_isFirstLoadRunning.toString()+'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    });

  }

  Future<http.Response> deleteStudio(int id) async {
    String token2 =
        'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiOWVjZjA0OGYxODVkOGZjYjQ5YTI3ZTgyYjQxYjBmNTg3OTMwYTA3NDY3YTc3ZjQwOGZlYWFmNjliNGYxMDQ4ZjEzMjgxMWU4MWNhMDJlNjYiLCJpYXQiOjE2NTAxOTc4MTIuNjUzNTQ5OTA5NTkxNjc0ODA0Njg3NSwibmJmIjoxNjUwMTk3ODEyLjY1MzU1MzAwOTAzMzIwMzEyNSwiZXhwIjoxNjgxNzMzODEyLjY0Mzg2NjA2MjE2NDMwNjY0MDYyNSwic3ViIjoiMTEiLCJzY29wZXMiOltdfQ.toMOLVGTbNRcIqD801Xs3gJujhMvisCzAHHQC_P8UYp3lmzlG3rwadB4M0rooMIVt82AB2CyZfT37tVVWrjAgNq4diKayoQC5wPT7QQrAp5MERuTTM7zH2n3anZh7uargXP1Mxz3X9PzzTRSvojDlfCMsX1PrTLAs0fGQOVVa-u3lkaKpWkVVa1lls0S755KhZXCAt1lKBNcm7GHF657QCh4_daSEOt4WSF4yq-F6i2sJH-oMaYndass7HMj05wT9Z2KkeIFcZ21ZEAKNstraKUfLzwLr2_buHFNmnziJPG1qFDgHLOUo6Omdw3f0ciPLiLD7FnCrqo_zRZQw9V_tPb1-o8MEZJmAH2dfQWQBey4zZgUiScAwZAiPNcTPBWXmSGQHxYVjubKzN18tq-w1EPxgFJ43sRRuIUHNU15rhMio_prjwqM9M061IzYWgzl3LW1NfckIP65l5tmFOMSgGaPDk18ikJNmxWxpFeBamL6tTsct7-BkEuYEU6GEP5D1L-uwu8GGI_T6f0VSW9sal_5Zo0lEsUuR2nO1yrSF8ppooEkFHlPJF25rlezmaUm0MIicaekbjwKdja5J5ZgNacpoAnoXe4arklcR6djnj_bRcxhWiYa-0GSITGvoWLcbc90G32BBe2Pz3RyoaiHkAYA_BNA_0qmjAYJMwB_e8U';

    final http.Response response = await http.delete(
      Uri.parse('https://mobile.celebrityads.net/api/celebrity/studio/delete/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $userToken'
      },
    );

    setState(() {
      _posts.clear();
      _page = 1;
      // There is next page or not
      _hasNextPage = true;

      // Used to display loading indicators when _firstLoad function is running
       _isFirstLoadRunning = false;

      // Used to display loading indicators when _loadMore function is running
       _isLoadMoreRunning = false;
      fetchStudio();
    });
    return response;
  }

}



class TheStudio {
  bool? success;
  Data? data;
  Message? message;

  TheStudio({this.success, this.data, this.message});

  TheStudio.fromJson(Map<String, dynamic> json) {
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
  List<StudioModel>? studio;
  int? status;

  Data({this.studio, this.status});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['studio'] != null) {
      studio = <StudioModel>[];
      json['studio'].forEach((v) {
        studio!.add(new StudioModel.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.studio != null) {
      data['studio'] = this.studio!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class StudioModel {
  int? id;
  String? title;
  String? description;
  String? image;
  String? type;

  StudioModel({this.id, this.title, this.description, this.image, this.type});

  StudioModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['image'] = this.image;
    data['type'] = this.type;
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
