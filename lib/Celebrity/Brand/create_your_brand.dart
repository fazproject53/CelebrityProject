///import section
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:flutter/material.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class YourBrandMain extends StatelessWidget {
  const YourBrandMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: drowAppBar("علامتك التجارية", context),
        body: const YourBrandHome(),
      ),
    );
  }
}

///-------------------------HomeBody YourBrand-------------------------
class YourBrandHome extends StatefulWidget {
  const YourBrandHome({Key? key}) : super(key: key);

  @override
  _YourBrandHomeState createState() => _YourBrandHomeState();
}

class _YourBrandHomeState extends State<YourBrandHome> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
            child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.topRight,
                    child: Padding(
                      ///Main title
                      padding: EdgeInsets.only(top: 25.h, right: 20.w),
                      child: text(
                        context,
                        "قم بإنشاء علامتك التجارية الان",
                        19,
                        ligthtBlack,fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  ///Text Description
                  Padding(
                    padding: EdgeInsets.only(top: 15.h,right: 20.w,left: 50.w),
                    child: text(context,'وصف العلامة وصف العلامة وصف العلامة وصف العلامة وصف العلامة وصف العلامة وصف العلامة وصف العلامة وصف العلامة وصف العلامة',14,ligthtBlack,
                        align: TextAlign.justify),
                  ),
                  ///Buttons to go to ALmattager app (outside api)
                  Container(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.only(top: 20.h, right: 20.w),
                      child: gradientContainerNoborder(
                        140.0,
                        buttoms(
                          context,
                          "إنشاء علامتك", 15, white, () {}, evaluation: 0,
                        ),
                        height: 40,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ],
    ));
  }
}






















