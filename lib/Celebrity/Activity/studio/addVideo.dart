import 'dart:async';
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
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                            addvideo(userToken!).then((value) =>
                            value == ''?
                            {goTopageReplacement(context, ActivityScreen()),

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
                              ).show(context)}
                                : {
                              Navigator.pop(context),
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
                                  padding: const EdgeInsets.only(
                                      left: 18.0),
                                  child: Icon(
                                    error,
                                    color: red,
                                    size: 25.sp,
                                  ),
                                ),
                                titleText: text(
                                    context, 'قشل الاتصال بالانترنت',
                                    14, purple),
                                messageText: text(
                                    context,
                                    'قشل الاتصال بالانترنت حاول لاحقا',
                                    14,
                                    black,
                                    fontWeight:
                                    FontWeight.w200),
                              ).show(context),

                            }
                            );


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

  Future<String> addvideo(String token) async {

 try {
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
   return '';
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
