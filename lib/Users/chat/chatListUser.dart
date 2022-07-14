import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:celepraty/Users/chat/chatRoom.dart';
import 'package:celepraty/celebrity/chat/chat_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class chatsListUser extends StatefulWidget{
  _chatsListUserState createState() => _chatsListUserState();
}

class _chatsListUserState extends State<chatsListUser> {

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBarNoIcon( 'المحادثات'),
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.only(top: 10.h, right: 15.w),
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox( height: 70.h, width: 70.w, child: CircleAvatar(backgroundColor: deepBlack,)),
                              SizedBox(width: 15.w,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  text(context, 'ليجسي' , 18, black, fontWeight: FontWeight.bold),
                                  text(context, 'مرحبا بابلو كيف حالك ؟' , 14, black),
                                ],
                              ),
                            ],
                          ),
                          paddingg(20.w,0.w,20.h, text(context, '4/1/2022', 15, deepBlack)),
                        ],
                      ),
                      onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => chatRoom()));},
                    ),
                    Divider()
                  ],
                );
              },),
          ),
        ),
      ),
    );
  }
}