import 'package:celepraty/ModelAPI/ModelsAPI.dart';
import 'package:celepraty/Models/Methods/classes/GradientIcon.dart';
import 'package:celepraty/Users/Exploer/ExploerApi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

import '../../Celebrity/HomeScreen/celebrity_home_page.dart';
import '../../Models/Methods/method.dart';
import '../../Models/Variables/Variables.dart';

class ShowVideo extends StatefulWidget {
  final String videoURL;
  final int videoLikes;
  final String image;
  final String pageURL;

  const ShowVideo(
      {Key? key,
      required this.videoURL,
      required this.videoLikes,
      required this.image, required this.pageURL})
      : super(key: key);

  @override
  State<ShowVideo> createState() => _ShowVideoState();
}

class _ShowVideoState extends State<ShowVideo>
    with AutomaticKeepAliveClientMixin {
  bool isPlay = true;
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    //  WidgetsBinding.instance?.addPostFrameCallback((_) async {
    _controller = VideoPlayerController.network(widget.videoURL)
      ..addListener(() => setState(() {}))
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          body: _controller!.value.isInitialized && _controller != null
              ? Container(
                  alignment: Alignment.topCenter,
                  child: buildVideo(),
                )
              : Center(
                  child: CircularProgressIndicator(
                  color: Colors.blue,
                  backgroundColor: grey,
                ))),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  Widget buildVideo() {
    return Stack(
      fit: StackFit.expand,
      children: [buildVideoPlayer(), basicOverlayWidget()],
    );
  }

//BasicOverlayWidget
  Widget buildVideoPlayer() {
    return buildFullScreen(
      child: AspectRatio(
        aspectRatio: _controller!.value.aspectRatio,
        child: VideoPlayer(_controller!),
      ),
    );
  }

  Widget basicOverlayWidget() {
    return Padding(
      padding: EdgeInsets.only(right: 10.w, bottom: 100.h),
      child: Align(
        alignment: Alignment.bottomRight,
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 3.5,
          //color: red,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
///profile------------------------------------------------------------
              Expanded(
                  child: InkWell(
                    onTap: (){
                      goTopagepush(context, CelebrityHome(
                        pageUrl: widget.pageURL,
                      ));
                    },
                    child: CircleAvatar(
                backgroundColor: white,
                radius: 30.r,
                backgroundImage: NetworkImage(widget.image),
              ),
                  )),

///like bottom------------------------------------------------------------
              Expanded(
                  child: CircleAvatar(
                backgroundColor: white,
                radius: 30.r,
                child: Center(child: GradientIcon(disLike, 35.sp, gradient())),
              )),

///share bottom------------------------------------------------------------
              Expanded(
                child: CircleAvatar(
                  backgroundColor: white,
                  radius: 30.r,
                  child: Center(child: GradientIcon(share, 35.sp, gradient())),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFullScreen({required Widget child}) {
    final size = _controller?.value.size;
    final width = size?.width;
    final height = size?.height;
    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(width: width, height: height, child: child),
    );
  }
}
