import 'package:celepraty/Users/Exploer/ExploerApi.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../Models/Variables/Variables.dart';

class ShowVideo extends StatefulWidget {
  final String videoURL;
  final int videoLikes;

  const ShowVideo({Key? key, required this.videoURL, required this.videoLikes})
      : super(key: key);

  @override
  State<ShowVideo> createState() => _ShowVideoState();
}

class _ShowVideoState extends State<ShowVideo> {
  bool isPlay = true;
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    //  WidgetsBinding.instance?.addPostFrameCallback((_) async {
    _controller = VideoPlayerController.network(widget.videoURL)
      ..initialize().then((_) {
        _controller?.play();
        _controller?.setLooping(true);
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    // });
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _controller!.value.isInitialized && _controller != null
              ? InkWell(
                  onTap: () {
                    _controller?.play();
                  },
                  child: VideoPlayer(_controller!))
              : Center(
                  child: CircularProgressIndicator(
                  color: Colors.blue,
                  backgroundColor: grey,
                )),
        ],
      ),
    );
  }
}
