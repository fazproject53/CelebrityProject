import 'package:celepraty/Models/Methods/classes/GradientIcon.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:celepraty/Users/Exploer/viewData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Explower extends StatefulWidget {
  const Explower({Key? key}) : super(key: key);

  @override
  State<Explower> createState() => _ExplowerState();
}

class _ExplowerState extends State<Explower> {
  bool isSelect = false;
  int liksCounter = 100;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: AppBarNoIcon("اكسبلور"),
          body: Padding(
              padding: EdgeInsets.all(12.h),
              child: Column(
                children: [
//icon and text-----------------------------------------------------
                  Expanded(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                        Expanded(
                            flex: 3,
                            child:
                                text(context, "اكسبلور المشاهير", 18, black)),
                        //filter----------------------------------------------
                         Expanded(
                          flex:1,
                          child: gradientContainer(
                            double.infinity,
                            Row(
                              children: [
                                Expanded(
                                    flex:2,
                                    child: Padding(
                                      padding:  EdgeInsets.only(right:8.0,bottom: 2),
                                      child: text(context, "فرز حسب", 13, textBlack),
                                    )),
                                Expanded(

                                  child: Padding(
                                    padding:  EdgeInsets.only(left:8.0,bottom: 2),
                                    child: Icon(
                                      filter,
                                      size: 25.sp,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            gradient: true,
                            color: blue,
                            height: 30,
                          ),
                        )
                      ])),
//view data-----------------------------------------------------

                  Expanded(
                    flex: 6,
                    child: GridView.builder(
                        itemCount: 10,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, //عدد العناصر في كل صف
                            crossAxisSpacing: 13.h, // المسافات الراسية
                            childAspectRatio: 0.70, //حجم العناصر
                            mainAxisSpacing: 13.w //المسافات الافقية

                            ),
                        itemBuilder: (context, i) {
                          return viewCard();
                        }),
                  )
                ],
              ))),
    );
  }

//----------------view data method-------------------------------------------------------------------------------
  Widget viewCard() {
    return Card(
        elevation: 10,
        color: black,
        child: Container(
          decoration: BoxDecoration(
              color: black,
              borderRadius: BorderRadius.all(Radius.circular(4.r)),
              image: DecorationImage(
                image: AssetImage(
                  videoImage,
                ),
                fit: BoxFit.cover,
              )),
          child: Column(
            children: [
//صوره المشهور+الاسم+التصنيف------------------------------------------
              Expanded(
                flex: 2,
                child: Align(
                    alignment: Alignment.topRight,
                    child: ListTile(
                      title: text(context, "ليجسي ليجسي", 15, white),
                      subtitle: text(context, "مطرب", 12, white),
                    )),
              ),
//play viduo--------------------------------------------------------

              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    backgroundColor: white.withOpacity(0.12),
                    radius: 25.h,
                    child: IconButton(
                        onPressed: () {
                        setState(() {
                          goTopagepush(context, viewData());});
                        },
                        icon: GradientIcon(playViduo, 35.sp, gradient())),
                  ),
                ),
              ),

//like icon------------------------------------------
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 10.r, right: 10.r),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: CircleAvatar(
                      backgroundColor: white.withOpacity(0.0),
                      radius: 20.h,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            isSelect = !isSelect;
                          });
                          if (isSelect) {
                            setState(() {
                              liksCounter++;
                            });
                          }
                        },
                        icon: GradientIcon(Icons.share, 27.sp, gradient()),
                      ),
                    ),
                  ),
                ),
              ),
//share----------------------------------------------------------------------
              Padding(
                padding: EdgeInsets.only(left: 10.r, right: 10.r),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: CircleAvatar(
                    backgroundColor: white.withOpacity(0.0),
                    radius: 20.h,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          isSelect = !isSelect;
                        });
                        if (isSelect) {
                          setState(() {
                            liksCounter++;
                          });
                        }
                      },
                      icon: GradientIcon(
                          isSelect ? like : disLike, 27.sp, gradient()),
                    ),
                  ),
                ),
              ),

//conuter of like number------------------------------------------
              Padding(
                padding: EdgeInsets.only(left: 20.r, right: 20.r),
                child: Align(
                    alignment: Alignment.bottomLeft,
                    child: text(context, "$liksCounter", 15, white,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ));
  }
}
