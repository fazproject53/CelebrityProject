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

class _ShowVideoState extends State<ShowVideo>  with AutomaticKeepAliveClientMixin{
  bool isPlay = true;
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    //  WidgetsBinding.instance?.addPostFrameCallback((_) async {
    _controller = VideoPlayerController.network(widget.videoURL)
      ..addListener(()=>setState(() {}))
      ..setLooping(true)
    ..initialize().then((_) => _controller?.play());
     
    // });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: viduoFullScreenWidget(controller:_controller)
      // Stack(
      //   fit: StackFit.expand,
      //   children: [
      //     _controller!.value.isInitialized && _controller != null
      //         ? InkWell(
      //             onTap: () {
      //               _controller?.play();
      //             },
      //             child: VideoPlayer(_controller!))
      //         : Center(
      //             child: CircularProgressIndicator(
      //             color: Colors.blue,
      //             backgroundColor: grey,
      //           )),
      //   ],
      // ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  viduoFullScreenWidget({VideoPlayerController? controller}) {
    return ;
  }
}
