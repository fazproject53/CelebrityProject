import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class notifications extends StatefulWidget {
  _notificationsState createState() => _notificationsState();
}

class _notificationsState extends State<notifications> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBarNoIcon( 'التنبيهات'),
        body: paddingg(
          10.w,
          10.w,
          20.h,
          ListView.separated(
            itemCount: 3,
            separatorBuilder: (BuildContext context, int index) { return Divider(color: black,);},
            itemBuilder: (BuildContext context, int index) {

              return
                InkWell(
                  child: SizedBox(
                    height: 75.h,
                    width: 340.w,
                    child: Container(
                      height: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                alignment: Alignment.centerRight,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50.0),
                                  child: Image.asset(
                                    'assets/image/celebrityimg.png',
                                    fit: BoxFit.fill,
                                    height: 48.h,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 8.h,
                                  ),
                                  text(context, 'المشهور ليجسي', 14, black),

                                  Container(
                                    height: 40.h,
                                    width: 250.w,
                                    child: text(
                                        context, 'هذا هو محتوى التنبيه للمستخدم', 13, black),
                                  ),


                                ],
                              ),
                            ],
                          ),



                          Padding(
                            padding:  EdgeInsets.only(bottom: 10.0.h),
                            child: text(context, ' 12/10/2021', 13,
                                grey!),
                          ),

                        ],
                      ),

                    ),
                  ),
                  onTap: (){},
                );

            },
          ),
        ),
      ),
    );
  }
}
