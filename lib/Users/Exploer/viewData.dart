import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';


class viewData extends StatefulWidget {

  final String? video;
  const viewData({Key? key,  this.video}) : super(key: key);

  @override
  State<viewData> createState() => _viewDataState();
}

class _viewDataState extends State<viewData> {
  late VideoPlayerController _videoPlayerController;
  bool clicked = false;

  @override
  void initState() {
    super.initState();

    widget.video == null ? {
      _videoPlayerController = VideoPlayerController.asset('assets/video/don.mp4')
        ..initialize().then((_) {
          setState(() {});
          _videoPlayerController.setLooping(true);
          _videoPlayerController.play();
          _videoPlayerController.setVolume(1.0);
        })
    } : _videoPlayerController = VideoPlayerController.network(widget.video!);
  }


  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return  Directionality(
      textDirection: TextDirection.rtl,
      child:  Scaffold(
        backgroundColor: black.withOpacity(0.80),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 30.h, right: 20.w),
            child: Row(
              children: [
                ///back icon to the main screen
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  color: white,
                  iconSize: 30,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              InkWell(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: getSize(context).height/9),
                        height: 400.h,child: _videoPlayerController.value.isInitialized ? VideoPlayer(_videoPlayerController) : VideoPlayer(_videoPlayerController..initialize())),

                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: VideoProgressIndicator(
                        _videoPlayerController,
                        allowScrubbing: true,
                        colors: const VideoProgressColors(
                            backgroundColor: pink,
                            bufferedColor: black,
                            playedColor: purple),
                      ),
                    )
                  ],
                ),
                onTap: (){
                  setState(() {
                  clicked? _videoPlayerController.play(): _videoPlayerController.pause();
                  clicked = clicked? false: true;
                });},
              ),
              clicked? Padding(
                padding:  EdgeInsets.only(left: 120.w),
                child: IconButton(onPressed: (){
                }, icon: Icon(playViduo, size:120,color: white,),),
              ): const SizedBox()
            ],
          ),
        ],
      ), ),
    );
  }
}
