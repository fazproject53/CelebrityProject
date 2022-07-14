///import section

import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

import 'introduction_screen.dart';
import 'package:path_provider/path_provider.dart';

class ScreenFour extends StatefulWidget {
  final String image;
  final String title;
  final String subtitle;

  const ScreenFour(
      {Key? key,
        required this.image,
        required this.title,
        required this.subtitle})
      : super(key: key);

  @override
  _ScreenFourState createState() => _ScreenFourState();
}

class _ScreenFourState extends State<ScreenFour> with AutomaticKeepAliveClientMixin{



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black.withOpacity(0.8),
      body:Stack(
              children: [
              ClipRRect(
                child: CachedNetworkImage(
                imageUrl: widget.image,
                imageBuilder: (context, imageProvider) => Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration:  BoxDecoration(
                        image: DecorationImage(
                            image:  imageProvider,
                            fit: BoxFit.cover,
                          ),),
                    child: Padding(
                      padding:
                          EdgeInsets.only(top: 500.h, left: 20.w, right: 20.w),
                      child: ListTile(
                        title: text(context, widget.title, 25, white,
                            fontWeight: FontWeight.bold, align: TextAlign.center),
                        subtitle: text(
                            context,
                            widget.subtitle,
                            13,
                            white,
                            align: TextAlign.center),
                      ),
                    ),
                  ),

                ),
              )
              ],
            ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
