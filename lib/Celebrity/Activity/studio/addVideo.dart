import 'dart:io';
import 'dart:convert';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:http/http.dart' as http;
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';
import '../../../Account/LoggingSingUpAPI.dart';
import '../activity_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../activity_screen.dart';

class addVideo extends StatefulWidget {
  _addVideoState createState() => _addVideoState();
}

class _addVideoState extends State<addVideo> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController controlvideotitle = new TextEditingController();
  TextEditingController controlvideodesc = new TextEditingController();

  File? studioVideo;
  String? userToken;
  @override
  void initState() {
    DatabaseHelper.getToken().then((value) {
      setState(() {
        userToken = value;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                child: Container(
                    child: Form(
          key: _formKey,
          child: paddingg(
            12,
            12,
            5,
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              padding(
                10,
                12,
                Container(
                    alignment: Alignment.topRight,
                    child: Text(
                      ' اضافة فيديو جديد',
                      style: TextStyle(
                          fontSize: 18.sp,
                          color: textBlack,
                          fontFamily: 'Cairo'),
                    )),
              ),
              SizedBox(
                height: 20.h,
              ),
              paddingg(
                15,
                15,
                12,
                textFieldNoIcon(
                    context, 'عنوان الفيديو', 14, false, controlvideotitle,
                    (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'حقل اجباري';
                  }
                }, false),
              ),
              paddingg(
                15,
                15,
                12,
                textFieldDesc(
                    context, 'وصف الفيديو', 14, false, controlvideodesc,
                        (String? value) {if (
                    value == null || value.isEmpty) {
                      return 'حقل اجباري';}}),
              ),
              SizedBox(height: 20.h),
              paddingg(
                15,
                15,
                12,
                uploadImg(200, 54, text(context, 'قم برفع فيديو ', 12, black),
                    () {
                  getVideo(context);
                }),
              ),
              SizedBox(height: 20.h),
              padding(
                15,
                15,
                gradientContainerNoborder(
                    getSize(context).width,
                    buttoms(context, 'اضافة ', 15, white, () {
                      if(_formKey.currentState!.validate()){
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            FocusManager.instance.primaryFocus
                                ?.unfocus();
                            addvideo(userToken!).whenComplete(() => {goTopageReplacement(context, ActivityScreen()),
                            Flushbar(
                            flushbarPosition:
                            FlushbarPosition.TOP,
                            backgroundColor: white,
                            margin:
                            const EdgeInsets.all(5),
                            flushbarStyle:
                            FlushbarStyle.FLOATING,
                            borderRadius:
                            BorderRadius.circular(
                            15.r),
                            duration: const Duration(
                            seconds: 5),
                            icon: Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child: Icon(
                            done,
                            color: green,
                            size: 25.sp,
                            ),
                            ),
                            titleText: text(context, 'تم بنجاح', 14, purple),
                            messageText: text(
                            context,
                            'تم اضافة فيديو بنجاح',
                            14,
                            black,
                            fontWeight:
                            FontWeight.w200),
                            ).show(context)

                            });


                            // == First dialog closed
                            return
                              Align(
                                alignment: Alignment.center,
                                child: Lottie.asset(
                                  "assets/lottie/loding.json",
                                  fit: BoxFit.cover,
                                ),
                              );},
                        );


                      }
                    })),
              ),
              const SizedBox(
                height: 30,
              ),
            ]),
          ),
        )))),
      ),
    );
  }

  addvideo(String token) async {
    String token2 =
        'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiOWVjZjA0OGYxODVkOGZjYjQ5YTI3ZTgyYjQxYjBmNTg3OTMwYTA3NDY3YTc3ZjQwOGZlYWFmNjliNGYxMDQ4ZjEzMjgxMWU4MWNhMDJlNjYiLCJpYXQiOjE2NTAxOTc4MTIuNjUzNTQ5OTA5NTkxNjc0ODA0Njg3NSwibmJmIjoxNjUwMTk3ODEyLjY1MzU1MzAwOTAzMzIwMzEyNSwiZXhwIjoxNjgxNzMzODEyLjY0Mzg2NjA2MjE2NDMwNjY0MDYyNSwic3ViIjoiMTEiLCJzY29wZXMiOltdfQ.toMOLVGTbNRcIqD801Xs3gJujhMvisCzAHHQC_P8UYp3lmzlG3rwadB4M0rooMIVt82AB2CyZfT37tVVWrjAgNq4diKayoQC5wPT7QQrAp5MERuTTM7zH2n3anZh7uargXP1Mxz3X9PzzTRSvojDlfCMsX1PrTLAs0fGQOVVa-u3lkaKpWkVVa1lls0S755KhZXCAt1lKBNcm7GHF657QCh4_daSEOt4WSF4yq-F6i2sJH-oMaYndass7HMj05wT9Z2KkeIFcZ21ZEAKNstraKUfLzwLr2_buHFNmnziJPG1qFDgHLOUo6Omdw3f0ciPLiLD7FnCrqo_zRZQw9V_tPb1-o8MEZJmAH2dfQWQBey4zZgUiScAwZAiPNcTPBWXmSGQHxYVjubKzN18tq-w1EPxgFJ43sRRuIUHNU15rhMio_prjwqM9M061IzYWgzl3LW1NfckIP65l5tmFOMSgGaPDk18ikJNmxWxpFeBamL6tTsct7-BkEuYEU6GEP5D1L-uwu8GGI_T6f0VSW9sal_5Zo0lEsUuR2nO1yrSF8ppooEkFHlPJF25rlezmaUm0MIicaekbjwKdja5J5ZgNacpoAnoXe4arklcR6djnj_bRcxhWiYa-0GSITGvoWLcbc90G32BBe2Pz3RyoaiHkAYA_BNA_0qmjAYJMwB_e8U';
    var stream =
        new http.ByteStream(DelegatingStream.typed(studioVideo!.openRead()));
    // get file length
    var length = await studioVideo!.length();

    // string to uri
    var uri =
        Uri.parse("https://mobile.celebrityads.net/api/celebrity/studio/add");

    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    };
    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = new http.MultipartFile('image', stream, length,
        filename: basename(studioVideo!.path));

    // add file to multipart
    request.files.add(multipartFile);
    request.headers.addAll(headers);
    request.fields["title"] = controlvideotitle.text;
    request.fields["description"] = controlvideodesc.text;
    request.fields["type"] = "vedio";
    // send
    var response = await request.send();
    print(response.statusCode);

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

  Future<File?> getVideo(context) async {
    PickedFile? pickedFile =
        await ImagePicker.platform.pickVideo(source: ImageSource.gallery);
    if (pickedFile == null) {
      return null;
    }
    final File file = File(pickedFile.path);
    final Directory directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final String fileName = Path.basename(pickedFile.path);
    final String fileExtension = Path.extension(fileName);
    File newVideo = await file.copy('$path/$fileName');
    setState(() {
      if (fileExtension == ".mp4") {
        studioVideo = newVideo;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("يجب ان يكون امتداد الفديو .mp4",
              style: TextStyle(color: Colors.red)),
        ));
      }
    });
  }
}
