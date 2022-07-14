
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';



///create pdf document
class PdfClass {
  static Future<File> createPDF(
      String textT, String id, String date, String adType) async {
    final document = Document();
    String title = 'التفاصيل الخاصة بالطلب';

    var arabicFont = Font.ttf(await rootBundle.load("assets/font/DINNextLTArabic-Regular-2.ttf"));
    var imageImage = MemoryImage((await rootBundle.load('assets/image/logo.png')).buffer.asUint8List());
    document.addPage(Page(
      theme: ThemeData.withFont(
        base: arabicFont,


      ),
      pageFormat: PdfPageFormat.roll80,
      textDirection: TextDirection.rtl,
      build: (Context context) => Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: 90.w,
                    height: 90.h,
                    child: Image(
                        imageImage
                    )
                )
              ]
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.only(right: 10.w),
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(title, style: TextStyle(fontSize: 10.sp,)),
                ]
            ),
            ),

            SizedBox(height: 10.h),
            Padding(
                padding: EdgeInsets.only(right: 20.w),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text( textT, style: TextStyle(fontSize: 10.sp,color: PdfColors.grey)),
                        Text('اسم طالب الخدمة:', style: TextStyle(fontSize: 9.sp,color: PdfColors.black,)),

                      ]),
                  SizedBox(height: 10.h),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text( id, style: TextStyle(fontSize: 10.sp,color: PdfColors.grey)),
                        Text('رقم الطلب:', style: TextStyle(fontSize: 9.sp,color: PdfColors.black )),

                      ]),
                  SizedBox(height: 10.h),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text( date, style: TextStyle(fontSize: 10.sp,color: PdfColors.grey)),
                        Text('تاريخ الطلب:', style: TextStyle(fontSize: 9.sp,color: PdfColors.black)),

                      ]),
                  SizedBox(height: 10.h),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text( adType, style: TextStyle(fontSize: 10.sp,color: PdfColors.grey)),
                        Text('نوع الطلب:', style: TextStyle(fontSize: 9.sp,color: PdfColors.black)),

                      ]),
                  SizedBox(height: 20.h),
                ]
              )
            ),
            Text('جميع الحقوق محفوظة © لمنصة المشاهير', style: TextStyle(fontSize: 5.sp,color: PdfColors.black)),
            SizedBox(height: 10.h),
      ]),
    ));

    return saveDocument(name:'تفاصيل الموعد.pdf', pdf: document);
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
