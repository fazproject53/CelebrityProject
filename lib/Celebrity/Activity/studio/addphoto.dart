import 'dart:io';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:celepraty/Celebrity/Activity/studio/studio.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart' as Path;
import '../../../Account/LoggingSingUpAPI.dart';
import '../activity_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';
import 'package:async/async.dart';


class addphoto extends StatefulWidget{

  _addphotoState createState() => _addphotoState();
}

class _addphotoState extends State<addphoto> {

  final _formKey = GlobalKey<FormState>();
 TextEditingController controlphototitle = new TextEditingController();
   TextEditingController controlphotodesc = new TextEditingController();

  File? studioimage;
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
                    child: Form(        key: _formKey,

                      child: paddingg(12, 12, 5, Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            padding(10, 12, Container( alignment : Alignment.topRight,child:  Text(' اضافة صورة جديدة', style: TextStyle(fontSize: 18.sp, color: textBlack , fontFamily: 'Cairo'), )),),

                            SizedBox(height: 20.h,),

                            paddingg(15, 15, 12,textFieldNoIcon(context, 'عنوان الصورة', 14, false, controlphototitle,(String? value) {if (
                            value == null || value.isEmpty) {
                              return 'حقل اجباري';}},false),),
                            paddingg(15, 15, 12,textFieldDesc(context, 'وصف الصورة', 14, false, controlphotodesc,(String? value) {if (
                            value == null || value.isEmpty) {
                              return 'حقل اجباري';}}),),


                            SizedBox(height: 20.h),
                            paddingg(15, 15, 12, uploadImg(200, 54,text(context, 'قم برفع صورة ', 12, black),(){getPhoto(context);}),),

                            SizedBox(height: 20.h),
                            padding(15, 15, gradientContainerNoborder(getSize(context).width,  buttoms(context, 'اضافة ', 15, white, (){
                              if(_formKey.currentState!.validate()){

                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    addPhoto(userToken!).whenComplete(() =>
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
                                            'تم اضافة صورة بنجاح',
                                            14,
                                            black,
                                            fontWeight:
                                            FontWeight.w200),
                                      ).show(context)});

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
                              })),),
                            const SizedBox(height: 30,),
                          ]),
                      ),

                    ))
            )
        ),
      ),
    );
  }

   addPhoto(String token) async {
    String token2 =
        'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiMWNjMTA1MjcxODRhN2QzYTIwNDJkYTdmNTMyNTA4ZTdjMDE4NWQwOWI3MzRkY2VhMGEzZjYxY2U3MjRmYmM4M2M5ZTcwNGYyYmNjYmIwNjAiLCJpYXQiOjE2NTA3MzU4NjEuMDQ2MzQwOTQyMzgyODEyNSwibmJmIjoxNjUwNzM1ODYxLjA0NjM0NTk0OTE3Mjk3MzYzMjgxMjUsImV4cCI6MTY4MjI3MTg2MS4wNDEzODQ5MzUzNzkwMjgzMjAzMTI1LCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.Dp0SkGykv6S4A3maaSmgkWMfKCXbumkxg8cmCJcgoBmFOjxwiKht2vywEnOXtPyFSV7BY48IpvrO6xlrfCE9Oy5wSp86caE-uYEo-uHgzsuRqf-hHpL9DcNsrfuZBQi4h3GiiCfyYV0362FkVl_hclamppj8VL-S7C02_Ddg7Ygnlce3-k8Hm8NRutBREsk4or75C-1mL70ArOCWuLazaUbAJexN2MuLMjqQF9h-pgcaQhEY3rhBEarcEcfdREJgGy_5zARbAdSi_mwclQCqNr9KatmRhkDL_My0GqmGvkt8RUSb_Uo93NXv9lvdw41gMcrStKvVbGg4RMRSxPRD_P9I8-26Ipasx5wMlFdZU10-mSrGKDLu3d4vxVcLFcQIwQqK19m5urFdgMVznRBqEnqceQUb_UjUh8i7VOa8rRUFFbLy7ALZaAk23DtVz25AHRIaYbV_jmgXbx_9IuJc3-dslYVvfGbtgRniKgLEDHKgWgVfiljUU9aUZmIh7i1uYgDZm1LBDWY_wPRQdPoQedfSiLs0Qy1ZmfahRBRWgNKFZDMoKvhtbuuP3rJLcIiQ6nLbyu1i4ma8ly74po4bYZcQDKTFx1oSi2fkUkDF_ZtqLFnx7xvzfXY-Za8krfB-AThg7Phi8-KVCdlTza_KwqkQciGzG4MD3-eY62JXIIU';

    var stream = new http.ByteStream(DelegatingStream.typed(studioimage!.openRead()));
    // get file length
    var length = await studioimage!.length();

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
        filename: basename(studioimage!.path));

    // add file to multipart
    request.files.add(multipartFile);
    request.headers.addAll(headers);
    request.fields["title"] = controlphototitle.text;
    request.fields["description"] = controlphotodesc.text;
    request.fields["type"] = "image";
    // send
    var response = await request.send();
    print(response.statusCode);

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });

  }

  Future<File?> getPhoto(context) async {
    PickedFile? pickedFile =
    await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return null;
    }
    final File file = File(pickedFile.path);
    final Directory directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final String fileName = Path.basename(pickedFile.path);
    final String fileExtension = Path.extension(fileName);
    File newImage = await file.copy('$path/$fileName');
    setState(() {
      if(fileExtension == ".png" || fileExtension == ".jpg"){
        studioimage = newImage;
      }else{ ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(
        content: Text(
            "امتداد الصورة المسموح به jpg, png",style: TextStyle(color: Colors.red)),
      ));}

    });
  }
}