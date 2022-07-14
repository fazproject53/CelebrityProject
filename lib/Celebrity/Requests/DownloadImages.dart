
import 'package:gallery_saver/gallery_saver.dart';
import 'package:flutter/material.dart';
import '../../Models/Methods/method.dart';

import '../../Models/Variables/Variables.dart';
class DownloadImages extends StatefulWidget {
  final String? image;
  const DownloadImages({Key? key, this.image}) : super(key: key);

  @override
  _DownloadImagesState createState() => _DownloadImagesState();
}

class _DownloadImagesState extends State<DownloadImages> {
  bool clicked = false;
  String album = 'الطلبات';
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            appBar: drowAppBar("", context, download: Icons.download,
                onPressed: () async {
                  loadingDialogue(context);

                  await GallerySaver.saveImage(widget.image!, albumName: album)
                      .then((value) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(snackBar(
                        context, 'تم حفظ الصورة في البوم ' + album, green, done));
                  });
                }),
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
