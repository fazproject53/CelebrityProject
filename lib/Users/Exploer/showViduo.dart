import 'package:celepraty/Users/Exploer/ExploerApi.dart';
import 'package:flutter/material.dart';

class ShowVideo extends StatefulWidget {
  final String videoURL;
  final int videoLikes;

  const ShowVideo({Key? key, required this.videoURL, required this.videoLikes})
      : super(key: key);

  @override
  State<ShowVideo> createState() => _ShowVideoState();
}

class _ShowVideoState extends State<ShowVideo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
