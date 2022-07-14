
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import 'dart:io';

import '../Models/Methods/method.dart';
import '../Models/Variables/Variables.dart';


///create pdf document
class InvoicePdf {
  static Future<File> createInvoicePDF(
      String orderId, String invoiceId, String date, String taxNum ,String platformPhone, String userPhone, String country, String name,
      String price, String priceWithTax, String paymentMethod, String desc) async {
    final document = Document();
    String title = 'فاتورة';

    var arabicFont = Font.ttf(await rootBundle.load("assets/font/DINNextLTArabic-Regular-2.ttf"));
    var imageImage = MemoryImage((await rootBundle.load('assets/image/logo.png')).buffer.asUint8List());
    document.addPage(Page(
      theme: ThemeData.withFont(
        base: arabicFont,
      ),
      pageFormat: PdfPageFormat.a4,
      textDirection: TextDirection.rtl,
      build: (Context context) => Center(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    imageImage,
                    height: 130.h,
                    width: 130.w,
                  ),
                ],
              ),
              Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        date,
                        style: TextStyle(fontSize: 12.sp, color: PdfColors.grey),),
                      SizedBox(width: 20.w),
                      Padding(padding: EdgeInsets.only(right: 10.w),
                        child:Text( 'فاتورة ضريبية', style: TextStyle(fontSize: 13.sp, color: PdfColors.black),),),

                    ]),
                margin: EdgeInsets.only(top: 20.h, left: 0.w, right: 0.w),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.w , right:  5.w),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text( orderId + '#', style: TextStyle(fontSize: 13.sp, color: PdfColors.black),),
                    SizedBox(
                      height: 15.h,
                    ),
                    Text( 'رقم الطلب ' + orderId + ':', style: TextStyle(fontSize: 13.sp, color: PdfColors.black),),
                    Text( 'رقم الفاتورة '+ invoiceId + ':', style: TextStyle(fontSize: 13.sp, color: PdfColors.black),),
                    SizedBox(height: 10.h),
                    Divider(
                      color: PdfColors.grey,
                    )
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 0.w, right: 0.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(' مصدرة من :', style: TextStyle(color: PdfColors.blue,fontSize: 11.sp,)),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              child: Text( "منصة المشاهير",  style: TextStyle(color: PdfColors.grey700, fontSize: 10.sp,)),
                              margin: EdgeInsets.only(left: 0.w)),
                          Text( ' الموقع الالكتروني :',  style: TextStyle(color: PdfColors.black,fontSize: 10.sp,)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text(taxNum,  style: TextStyle(color: PdfColors.grey700, fontSize: 10.sp,)),
                            margin: EdgeInsets.only(left: 0.w),
                          ),
                          Text( ' الرقم الضريبي :', style: TextStyle(color: PdfColors.black, fontSize: 10.sp,),),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              child: Text( platformPhone, style: TextStyle(color: PdfColors.grey700, fontSize: 11.sp,)),
                              margin: EdgeInsets.only(left: 0.w)),
                          Text( ' الهاتف :',  style: TextStyle(color: PdfColors.black, fontSize: 11.sp,)),
                        ],
                      ),
                      Divider(
                        color: PdfColors.grey,
                      )
                    ],
                  )),
              Padding(
                  padding: EdgeInsets.only( right: 5.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(' مصدرة الى :',  style: TextStyle(color: PdfColors.pink200, fontSize: 11.sp,)),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              child: Text( country, style: TextStyle(color: PdfColors.grey700,fontSize: 10.sp,)),
                              margin: EdgeInsets.only(left: 0.w)),
                          Container(
                            margin: EdgeInsets.only(right: 5.w),
                            child: Text( 'name', style: TextStyle(color: PdfColors.grey700, fontSize: 10.sp,)),),
                        ],
                      ),
                      Container(
                        child: Text( 'userPhone', style: TextStyle(color: PdfColors.grey700 ,fontSize: 10.sp,)),
                        margin: EdgeInsets.only(left: 0.w),
                        alignment: Alignment.bottomLeft,
                      ),
                      Divider(
                        color: PdfColors.grey,
                      )
                    ],
                  )),
              Padding(
                  padding : EdgeInsets.only(left: 15.w, right: 5.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text( 'تفاصيل الدفع', style: TextStyle(color: PdfColors.blue,fontSize: 11.sp,)),

                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Text(  price + " ر . س",  style: TextStyle(color: PdfColors.grey700, fontSize: 10.sp,)),
                              ),
                              margin: EdgeInsets.only(left: 0.w)),
                          Text( ' المبلغ: ',  style: TextStyle(color: PdfColors.black, fontSize: 10.sp,)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text(paymentMethod, style: TextStyle(color: PdfColors.grey700,fontSize: 10.sp,)),
                            margin: EdgeInsets.only(left: 0.w),
                          ),
                          Container(
                              margin: EdgeInsets.only(right: 5.w),
                              child: Text( 'طريقة الدفع:',  style: TextStyle(color: PdfColors.black, fontSize: 11.sp,))),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      )
                    ],
                  )),
              Container(
                color: PdfColors.grey200,
                height: 40.h,
                margin: EdgeInsets.only(left: 0.w, right: 0.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 10.w,
                        ),
                        Text( 'المجموع',  style: TextStyle(color: PdfColors.black,fontSize: 11.sp,)),
                        SizedBox(
                          width: 100.w,
                        ),
                        Text( 'السعر', style: TextStyle(color: PdfColors.black,fontSize: 11.sp,)),
                        SizedBox(
                          width: 20.w,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text( 'المنتج', style: TextStyle(color: PdfColors.black,fontSize: 11.sp,)),
                        SizedBox(
                          width: 10.w,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Text(price + " ر . س  ", style: TextStyle(color: PdfColors.grey700,fontSize: 10.sp,)),
                            SizedBox(
                              width: 100.w,
                            ),
                            Text(price + " ر . س  ",style: TextStyle(color: PdfColors.grey700,fontSize: 10.sp,)),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 20.w,
                            ),

                            Container(
                              width: 100.w,
                              margin: EdgeInsets.only(right: 5.w),
                              child: Text(
                                  desc,
                                  style: TextStyle(color: PdfColors.grey700,fontSize: 11.sp,)),
                            ),
                            // SizedBox(width: 10.w,),
                            // Image.asset('assets/image/logo.png', height: 50.h, width: 50.w,),
                          ],
                        ),

                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Divider(
                      color: PdfColors.grey,
                      thickness: 1,
                    ),


                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(priceWithTax + ' ر . س ', style: TextStyle(color: PdfColors.grey700,fontSize: 10.sp,)),
                            SizedBox(
                              width: 20.w,
                            ),
                          ],
                        ),
                        Row(
                          children: [

                            Text( 'اجمالي الطلب',style: TextStyle(color: PdfColors.grey700,fontSize: 11.sp,) ),
                            SizedBox(
                              width: 5.w,
                            ),
                          ],
                        ),

                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Divider(
                      color: PdfColors.grey,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                        'شكرا لتعاملكم مع منصتنا ,,, نتمنى لكم يوما رائعا',
                        style: TextStyle(color: PdfColors.black,fontSize: 11.sp,)),
                    SizedBox(
                      height: 10.h,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),),
    ));

    return saveDocument(name:'فاتورة.pdf', pdf: document);
  }

  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}
