import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:celepraty/MainScreen/main_screen_navigation.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart' as Path;
import 'package:celepraty/Models/Methods/classes/GradientIcon.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:async/async.dart';

import '../../Account/LoggingSingUpAPI.dart';
import '../../Users/UserRequests/UserReguistMainPage.dart';
import '../Pricing/ModelPricing.dart';
import '../celebrityHomePage.dart';

class advArea extends StatefulWidget{
 final String? id;
  const advArea({Key? key,  this.id}) : super(key: key);

  _advAreaState createState() => _advAreaState();
}

class _advAreaState extends State<advArea>{

  final _formKey = GlobalKey<FormState>();
  final TextEditingController link = new TextEditingController();

  String? userToken;
  Future<Pricing>? pricing;
  File? image;
   DateTime dateTime = DateTime.now();
  final TextEditingController copun = new TextEditingController();
  bool activateIt = false;
  bool datewarn2= false;
  bool check2 = false;
  bool warn2= false;
  bool warnimage= false;

  Timer? _timer;

  @override
  void initState() {
    DatabaseHelper.getToken().then((value) {
      setState(() {
        userToken = value;
      });
    });
        pricing = fetchCelebrityPricing(widget.id!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
          appBar: drowAppBar('مساحة اعلانية', context),
          body: SingleChildScrollView(
          child: Container(
          child: Form(
          key: _formKey,
          child: paddingg(12, 12, 5, Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          SizedBox(height: 120.h,),
            padding(10, 12, Container( alignment : Alignment.topRight,child:  Text(' اطلب مساحتك الاعلانية', style: TextStyle(fontSize: 18.sp, color: textBlack , fontFamily: 'Cairo'), )),),

            SizedBox(height: 20.h,),
            FutureBuilder(
                future: pricing,
                builder: ((context, AsyncSnapshot<Pricing> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center();
                  } else if (snapshot.connectionState ==
                      ConnectionState.active ||
                      snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                      //---------------------------------------------------------------------------
                    } else if (snapshot.hasData) {
                      snapshot.data!.data != null && snapshot.data!.data!.price!.adSpacePrice != null  ?  activateIt = true :null;
                      return snapshot.data!.data == null?
                      SizedBox(): paddingg(15, 15, 12, Container(height: 55.h,decoration: BoxDecoration(color: deepPink, borderRadius: BorderRadius.circular(8)),
                        child:   Padding(
                          padding: EdgeInsets.all(10),
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:  [
                              Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Text('سعر الاعلان ', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17, color: white , fontFamily: 'Cairo'), ),
                              ),
                              Text( snapshot.data!.data!.price!.adSpacePrice.toString() + ' ر.س ', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17, color: white , fontFamily: 'Cairo'), ),
                            ],
                          ),),),
                      );
                    } else {
                      return const Center(child: Text('لايوجد لينك لعرضهم حاليا'));
                    }
                  } else {
                    return Center(
                        child: Text('State: ${snapshot.connectionState}'));
                  }
                })),
            paddingg(15, 15, 12,textFieldNoIcon(context, 'رابط صفحة المعلن', 14, false, link,(String? value) {if (value == null || value.isEmpty) {
              }else{
              bool _validURL = Uri.parse(value).isAbsolute;
             return  _validURL? null: 'رابط الفحة غير صحيح';
            }},false),),

            paddingg(15.w, 15.w, 12.h,textFieldNoIcon(context, 'ادخل كود الخصم', 14.sp, false, copun,(String? value) { return null;},true),),

             SizedBox(height: 20.h),
            paddingg(15, 15, 12, uploadImg(200, 54,text(context, image != null? 'تغيير الصورة':'قم برفع الصورة التي تريد وضعها بالاعلان', 12, black),(){getImage(context);}),),
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
                          child: Image.file(image!));},
                )
                    :null;},
                child: paddingg(15.w, 30.w, image != null?10.h: 0.h,Row(
                  children: [
                    image != null? Icon(Icons.image, color: newGrey,): SizedBox(),
                    SizedBox(width: image != null?5.w: 0.w),
                    text(context,warnimage && image == null ? 'الرجاء اضافة صورة': image != null? 'معاينة الصورة':'',12,image != null?black:red!,)
                  ],
                ))),
            SizedBox(height: 10.h),
            InkWell(
              child: padding(0.w,15.w, Row(children: [
                  GradientIcon(scheduale, 30, const LinearGradient(
                    begin: Alignment(0.7, 2.0),
                    end: Alignment(-0.69, -1.0),
                    colors: [Color(0xff0ab3d0), Color(0xffe468ca)],
                    stops: [0.0, 1.0],
                  ),),
                 SizedBox(width: 10.w,),
                  text(context, dateTime.day != DateTime.now().day ?dateTime.year.toString()+ '/'+dateTime.month.toString()+ '/'+dateTime.day.toString() : 'تاريخ الاعلان', 12, black)
                ],),
              ),
              onTap: () async { DateTime? endDate =
                  await showDatePicker(
                  builder: (context, child) {
                    return Theme(
                        data: ThemeData.light().copyWith(
                            colorScheme:
                            const ColorScheme.light(primary: purple, onPrimary: white)),
                        child: child!);}
                  context:
                  context,
                  initialDate:
                  dateTime,
                  firstDate:
                  DateTime(
                      2000),
                  lastDate:
                  DateTime(
                      2100));
              if (endDate == null)
                return;
              setState(() {
                dateTime= endDate;
              });},
            ),

            paddingg(15.w, 20.w, 0.h,text(context,datewarn2? 'الرجاء اختيار تاريخ النشر': '', 12,red!,)),

            paddingg(0,0,3.h, CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: text(context,'عند الطلب ، فإنك توافق على شروط الإستخدام و سياسة الخصوصية الخاصة بـ', 10, black, fontWeight: FontWeight.bold,family:'Cairo'),
              value: check2,
              selectedTileColor: warn2 == true? red: black,
              subtitle: Text(warn2 == true?'حتى تتمكن من الطلب  يجب الموافقة على الشروط والاحكام':'' ,style: TextStyle(color: red),),
              onChanged: (value) {
                setState(() {
                  setState(() {
                    check2 = value!;
                  });
                });
              },)

              ,),
             SizedBox(height: 30.h,),
           check2 && activateIt? padding(15, 15, gradientContainerNoborder(getSize(context).width,  buttoms(context, 'رفع الطلب', 15, white, (){
              _formKey.currentState!.validate()? {
                check2 && dateTime.day != DateTime.now().day && image != null?{
    showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    addAdAreaOrder().then((value) => {
    value.contains('true')
    ? {
      goTopageReplacement(context, UserRequestMainPage()),
    //done
    showMassage(context, 'تم بنجاح',
    value.replaceAll('true', ''),
    done: done),
    }
        :  value == 'SocketException'?
    { Navigator.pop(context),
      showMassage(
        context,
        'خطا',
        'فشل الاتصال بالانترنت ',
      )}
        :{
      Navigator.pop(context),
      showMassage(
        context,
        'خطا',
        value.replaceAll('false', ''),
      ),}
    });

    // == First dialog closed
    return Align(
    alignment: Alignment.center,
    child: Lottie.asset(
    "assets/lottie/loding.json",
    fit: BoxFit.cover,
    ),
    );
    },
    ),


                } : setState((){ !check2? warn2 = true: false;
                dateTime.day == DateTime.now().day? datewarn2 = true: false;
                image == null? warnimage =true:false;}),

              }: null;
            })),):

           padding(15, 15, Container(width: getSize(context).width,
               decoration: BoxDecoration( borderRadius: BorderRadius.circular(15.r),   color: grey,),
               child: buttoms(context,'رفع الطلب', 15, white, (){})
           ),),
            const SizedBox(height: 30,),

          ]),
          ),

          )))),
    );}

 Future<String> addAdAreaOrder() async {
    try {
      var stream = new http.ByteStream(
          DelegatingStream.typed(image!.openRead()));
      // get file length
      var length = await image!.length();

      // string to uri
      var uri = Uri.parse(
          "https://mobile.celebrityads.net/api/order/ad-space/add");

      Map<String, String> headers = {
        "Accept": "application/json",
        "Authorization": "Bearer $userToken"
      };
      // create multipart request
      var request = http.MultipartRequest("POST", uri);

      // multipart that takes file
      var multipartFile = http.MultipartFile('image', stream, length,
          filename: Path.basename(image!.path));

      // listen for response
      request.files.add(multipartFile);
      request.headers.addAll(headers);
      request.fields["celebrity_id"] = widget.id.toString();
      request.fields["date"] = dateTime.toString();
      request.fields["link"] = link.text;
      request.fields["celebrity_promo_code"] = copun.text;

      var response = await request.send();
      http.Response respo = await http.Response.fromStream(response);
      print(jsonDecode(respo.body)['message']['ar']);
      return jsonDecode(respo.body)['message']['ar'] +jsonDecode(respo.body)['success'].toString();
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

  Future<File?> getImage(context) async {
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
    if(fileExtension == ".png" || fileExtension == ".jpg"){
      setState(() {
        image = newImage;
      });
    }else{ ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(
      content: Text(
          "امتداد الصورة المسموح به jpg, png",style: TextStyle(color: Colors.red)),
    ));}

  }
  Future<Pricing> fetchCelebrityPricing(String id ) async {
    String token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiMDAzNzUwY2MyNjFjNDY1NjY2YjcwODJlYjgzYmFmYzA0ZjQzMGRlYzEyMzAwYTY5NTE1ZDNlZTYwYWYzYjc0Y2IxMmJiYzA3ZTYzODAwMWYiLCJpYXQiOjE2NTMxMTY4MjcuMTk0MDc3OTY4NTk3NDEyMTA5Mzc1LCJuYmYiOjE2NTMxMTY4MjcuMTk0MDg0ODgyNzM2MjA2MDU0Njg3NSwiZXhwIjoxNjg0NjUyODI3LjE5MDA0ODkzMzAyOTE3NDgwNDY4NzUsInN1YiI6IjExIiwic2NvcGVzIjpbXX0.GUQgvMFS-0VA9wOAhHf7UaX41lo7m8hRm0y4mI70eeAZ0Y9p2CB5613svXrrYJX74SfdUM4y2q48DD-IeT67uydUP3QS9inIyRVTDcEqNPd3i54YplpfP8uSyOCGehmtl5aKKEVAvZLOZS8C-aLIEgEWC2ixwRKwr89K0G70eQ7wHYYHQ3NOruxrpc_izZ5awskVSKwbDVnn9L9-HbE86uP4Y8B5Cjy9tZBGJ-6gJtj3KYP89-YiDlWj6GWs52ShPwXlbMNFVDzPa3oz44eKZ5wNnJJBiky7paAb1hUNq9Q012vJrtazHq5ENGrkQ23LL0n61ITCZ8da1RhUx_g6BYJBvc_10nMuwWxRKCr9l5wygmIItHAGXxB8f8ypQ0vLfTeDUAZa_Wrc_BJwiZU8jSdvPZuoUH937_KcwFQScKoL7VuwbbmskFHrkGZMxMnbDrEedl0TefFQpqUAs9jK4ngiaJgerJJ9qpoCCn4xMSGl_ZJmeQTQzMwcLYdjI0txbSFIieSl6M2muHedWhWscXpzzBhdMOM87cCZYuAP4Gml80jywHCUeyN9ORVkG_hji588pvW5Ur8ZzRitlqJoYtztU3Gq2n6sOn0sRShjTHQGPWWyj5fluqsok3gxpeux5esjG_uLCpJaekrfK3ji2DYp-wB-OBjTGPUqlG9W_fs';
    final response = await http.get(
        Uri.parse('https://mobile.celebrityads.net/api/celebrity/price/$id'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //print(response.body);
      return Pricing.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load activity');
    }
  }
}


