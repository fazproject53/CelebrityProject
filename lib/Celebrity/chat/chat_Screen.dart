import 'dart:io';
import 'package:celepraty/Models/Methods/classes/GradientIcon.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class chatScreen extends StatefulWidget {
  _chatScreenState createState() => _chatScreenState();
}

class _chatScreenState extends State<chatScreen> {
  List<Widget>? listwidget;
  File? imagee;
  File? file;
  File? vid;
  String help = "";
  static bool isWritting = false;
  bool isPressed = false;
  bool wrote = false;
  var currentFocus;

  TextEditingController m = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    listwidget = [
      container('بخير الحمد لله'),
      container('مرحبا'),
      containerUser('ليجسي كيف حالك ؟'),
      containerUser('مرحبا'),
    ];

    return GestureDetector(
      onTap: () {
        unfocus();
        setState(() {
          isWritting = false;
        });
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(child: Center(child: text(context, 'حظر', 17.sp, black)),),
                PopupMenuItem(child: Center(child: text(context, 'تبليغ', 17.sp, black))),
              ],
            ),
          ],
          title: Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                text(context, 'مروان بابلو', 15, white),
                SizedBox(
                  width: 10.w,
                ),
                CircleAvatar(
                  backgroundColor: white,
                  foregroundImage: imagee == null
                      ? Image.asset(
                          'assets/image/user.png',
                          fit: BoxFit.fill,
                        ).image
                      : Image.file(imagee!).image,
                )
              ],
            ),
          ),
          centerTitle: true,
          backgroundColor: purple,
          elevation: 0,
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ListView(
                      reverse: true,
                      children: listwidget!,
                    ),
                  ),
                ),
                Padding(
                  padding: MediaQuery.of(context).viewInsets.bottom != 0
                      ? EdgeInsets.only(bottom: 0.h)
                      : EdgeInsets.only(bottom: 0.h),
                  child: Container(
                    height: 60.h,
                    decoration: const BoxDecoration(
                        border:
                            Border(top: BorderSide(color: purple, width: 2))),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 10.w,
                                ),
                                GestureDetector(
                                  child: isWritting
                                      ? SizedBox(
                                          width: 1.w,
                                        )
                                      : CircleAvatar(
                                          backgroundColor:
                                              isPressed ? fillWhite : null,
                                          child: Container(
                                            height: 50.h,
                                            width: 50.w,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                gradient: !isPressed
                                                    ? const LinearGradient(
                                                        begin:
                                                            Alignment(0.7, 2.0),
                                                        end: Alignment(
                                                            -0.69, -1.0),
                                                        colors: [
                                                          Color(0xff0ab3d0),
                                                          Color(0xffe468ca)
                                                        ],
                                                        stops: [0.0, 1.0],
                                                      )
                                                    : const LinearGradient(
                                                        colors: [white, white],
                                                      )),
                                            child: !isPressed
                                                ? Icon(
                                                    voiceIcon,
                                                    color: white,
                                                    size: isPressed ? 30 : 25,
                                                  )
                                                : GradientIcon(
                                                    voiceIcon,
                                                    30,
                                                    const LinearGradient(
                                                      begin:
                                                          Alignment(0.2, 3.0),
                                                      end: Alignment(
                                                          -0.69, -1.0),
                                                      colors: [
                                                        Color(0xff0ab3d0),
                                                        Color(0xffe468ca)
                                                      ],
                                                      stops: [0.0, 1.0],
                                                    ),
                                                  ),
                                          )),
                                  onLongPress: () {
                                    setState(() {
                                      isPressed = true;
                                    });
                                  },
                                  onLongPressUp: () {
                                    setState(() {
                                      isPressed = false;
                                    });
                                  },
                                ),
                                isWritting
                                    ? SizedBox(
                                        width: 1.w,
                                      )
                                    : SizedBox(
                                        width: 15.w,
                                      ),
                                isWritting
                                    ? Container(
                                        margin: isWritting
                                            ? EdgeInsets.only(right: 20.w)
                                            : EdgeInsets.only(right: 15.w),
                                        child: InkWell(
                                          onTap: () {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            setState(() {
                                              isWritting = false;
                                              m.clear();
                                            });
                                          },
                                          child: GradientIcon(
                                            send,
                                            30,
                                            const LinearGradient(
                                              begin: Alignment(0.7, 2.0),
                                              end: Alignment(-0.69, -1.0),
                                              colors: [
                                                Color(0xff0ab3d0),
                                                Color(0xffe468ca)
                                              ],
                                              stops: [0.0, 1.0],
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox(
                                        width: 0.w,
                                      )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 35.h,
                              margin: EdgeInsets.only(
                                  top: 10.h, bottom: 10.h, left: 5.w),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: const Border(
                                      top: BorderSide(color: Colors.grey),
                                      bottom: BorderSide(color: Colors.grey),
                                      left: BorderSide(color: Colors.grey),
                                      right: BorderSide(color: Colors.grey))),
                              child: TextFormField(
                                validator: (value) {
                                  if (value!.isNotEmpty) isWritting = true;
                                },
                                controller: m,
                                onTap: () {
                                  setState(() {
                                    m.addListener(() {
                                      MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom !=
                                                  0 &&
                                              m.text.isNotEmpty
                                          ? isWritting = true
                                          : isWritting = false;
                                    });
                                  });
                                },
                                onChanged: (value) {
                                  setState(() {
                                    value = m.text;
                                  });
                                },
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.h, horizontal: 20.w),
                                  hintText: 'اكتب هنا .....',
                                ),
                              ),
                            ),
                          ),
                          isWritting
                              ? SizedBox(
                                  width: 1.w,
                                )
                              : InkWell(
                                  child: Icon(
                                    add,
                                    color: grey,
                                  ),
                                  onTap: () {
                                    showBottomSheett2(
                                        context, BottomSheetMenue());
                                  },
                                )
                        ]),
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  Widget container(text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 45.h,
          margin: EdgeInsets.only(top: 10, bottom: 10, left: 3, right: 5),
          decoration: BoxDecoration(
              color: purple,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  topLeft: Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              style: TextStyle(color: white),
            ),
          ),
        ),
      ],
    );
  }

  Widget containerUser(text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          height: 45.h,
          margin: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 2),
          decoration: BoxDecoration(
              color: grey,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  topRight: Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              style: TextStyle(color: white),
            ),
          ),
        ),
      ],
    );
  }

  unfocus() {
    currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  Widget BottomSheetMenue() {
    return SingleChildScrollView(
      child: Column(children: [
        SizedBox(
          height: 20.h,
        ),
        SizedBox(
          height: 20.h,
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            SizedBox(
              width: 20.h,
            ),
            text(context, 'الكاميرا', 15, black),
            SizedBox(
              width: 10.h,
            ),
            Container(
                margin: EdgeInsets.only(right: 8.w),
                child: Icon(cam, color: purple)),
          ]),
        ),
        SizedBox(
          height: 10.h,
        ),
        const Divider(
          color: darkWhite,
        ),
        SizedBox(
          height: 10.h,
        ),
        SizedBox(
          height: 20.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 20.h,
              ),
              Container(
                  width: 200.w,
                  child: text(context, 'مكتبة الصور والفيديوهات', 15, black)),
              SizedBox(
                width: 10.h,
              ),
              Container(
                  margin: EdgeInsets.only(right: 8.w),
                  child: Icon(imageIcon, color: purple)),
            ],
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        const Divider(color: darkWhite),
        SizedBox(
          height: 10.h,
        ),
        Container(
          alignment: Alignment.centerRight,
          height: 20.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 30.h,
              ),
              text(context, 'مستند', 15, black),
              SizedBox(
                width: 20.h,
              ),
              Container(
                  margin: EdgeInsets.only(right: 10.w),
                  child: Icon(
                    discountDes,
                    color: purple,
                  )),
            ],
          ),
        ),
      ]),
    );
  }
}
