import 'dart:async';
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
  Timer? _timer;
  bool warnimage= false;
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
                            paddingg(15, 15, 12, uploadImg(200, 54,text(context, studioimage != null? 'تغيير الصورة':'قم برفع صورة', 12, black),(){getPhoto(context);}),),
                            InkWell(
                                onTap: (){image != null?
                                showDialog(
                                  useSafeArea: true,
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    _timer = Timer(Duration(seconds: 2), () {
                                      Navigator.of(context).pop();    // == First dialog closed
                                    });
                                    return
                                      Container(
                                          height: double.infinity,
                                          child: Image.file(studioimage!));},
                                )
                                    :null;},
                                child: paddingg(15.w, 30.w, studioimage != null?10.h: 0.h,Row(
                                  children: [
                                    studioimage != null? Icon(Icons.image, color: newGrey,): SizedBox(),
                                    SizedBox(width: studioimage != null?5.w: 0.w),
                                    text(context,warnimage && studioimage == null ? 'الرجاء اضافة صورة': studioimage != null? 'معاينة الصورة':'',12,studioimage != null?black:red!,)
                                  ],
                                ))),

                            SizedBox(height: 20.h),
                            padding(15, 15, gradientContainerNoborder(getSize(context).width,  buttoms(context, 'اضافة ', 15, white, (){
                              if(_formKey.currentState!.validate()){

                                studioimage == null? warnimage = true :
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    addPhoto(userToken!).then((value) =>

                                    value == ''? {
                                      gotoPageAndRemovePrevious(context, ActivityScreen()),
                                    showMassage(context, 'تم بنجاح',
                                        'تمت الاضافة بنجاح', done: done),}:
                                    showMassage(context, 'خطا', value.replaceAll('حدث خطا ما الرجاء المحاولة لاحقا', ''),),


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

 Future<String>  addPhoto(String token) async {

    try {
      var stream = new http.ByteStream(
          DelegatingStream.typed(studioimage!.openRead()));
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