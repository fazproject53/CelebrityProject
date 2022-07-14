import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';



class ShowStudio extends StatefulWidget {

  final String video;


   const ShowStudio({Key? key, required this.video}) : super(key: key);

  @override
  _ShowStudioState createState() => _ShowStudioState();
}

class _ShowStudioState extends State<ShowStudio> {

  late VideoPlayerController _videoPlayerController;
  bool clicked = false;

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.asset('assets/video/don.mp4')
      ..initialize().then((_) {

        _videoPlayerController.setLooping(true);
        _videoPlayerController.play();
        _videoPlayerController.setVolume(1.0);

      });
  }
  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
