import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../../Models/Methods/method.dart';
import 'dart:io';

import '../../Models/Variables/Variables.dart';

//    <string>هل تريد السماح لتطبيق منصة المشاهير بالوصول الي الصور والوسائط والملفات الأخرى الموجودة على جهازك؟</string>
class ImageData extends StatefulWidget {
  final String? image;
  const ImageData({Key? key, this.image}) : super(key: key);

  @override
  _ImageDataState createState() => _ImageDataState();
}

class _ImageDataState extends State<ImageData> {
  bool clicked = false;
  String album = 'الطلبات';
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            appBar: drowAppBar("", context),
            //backgroundColor: black.withOpacity(0.80),
            body: Container(
              // color: red,
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: NetworkImage(
                  widget.image!,
                ),
                fit: BoxFit.contain,
              )),
            )));
  }

  Future<void> _download() async {
    // try {
    //   loadingDialogue(context);
    //   // Saved with this method.
    //   var imageId =
    //   await ImageDownloader.downloadImage("https://raw.githubusercontent.com/wiki/ko2ic/image_downloader/images/bigsize.jpg");
    //   if (imageId == null) {
    //     return;
    //   }
    //   // Below is a method of obtaining saved image information.
    //   var fileName = await ImageDownloader.findName(imageId);
    //   var path = await ImageDownloader.findPath(imageId);
    //   var size = await ImageDownloader.findByteSize(imageId);
    //   var mimeType = await ImageDownloader.findMimeType(imageId);
    //   Navigator.pop(context);
    //   print('Image downloaded.');
    // } on PlatformException catch (error) {
    //   print(error);
    // }
  }
}
