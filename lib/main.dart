//
import 'dart:async';
import 'package:celepraty/Account/VerifyUser.dart';
import 'package:celepraty/Account/logging.dart';
import 'package:celepraty/Celebrity/Activity/activity_screen.dart';
import 'package:celepraty/Celebrity/blockList.dart';
import 'package:celepraty/MainScreen/main_screen_navigation.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:celepraty/introduction_screen/ModelIntro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Account/LoggingSingUpAPI.dart';
import 'Users/CreateOrder/buildAdvOrder.dart';
import 'introduction_screen/introduction_screen.dart';

int? initScreen;
void main() async {
  //show splash screen one time
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  initScreen = preferences.getInt('initScreen');
  await preferences.setInt('initScreen', 1);
  runApp(
    MyApp(),
    // Wrap your app
  );
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with AutomaticKeepAliveClientMixin {
  Future<IntroData>? futureIntro;
  String? isLogging;
  StreamSubscription? streamSubscription;
  @override
  void initState() {
    super.initState();
    futureIntro = getIntroData();
    DatabaseHelper.getRememberToken().then((token) {
      setState(() {
        isLogging = token;
      });
    });
    print('isLogging:$isLogging');
  }

  @override
  void dispose() {
    streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(413, 763),
      // minTextAdapt: true,
      // splitScreenMode: true,
      builder: () => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'منصة المشاهير',
        theme: ThemeData(
          fontFamily: "Cairo",
          colorScheme: ColorScheme.fromSwatch().copyWith(primary: purple.withOpacity(0.5)),
          scaffoldBackgroundColor: Colors.white,
        ),
        builder: (context, widget) {
          ScreenUtil.setContext(context);
          return MediaQuery(
            //Setting font does not change with system font size
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: widget!,
          );
        },
        initialRoute: initScreen == 0 || initScreen == null
            ? 'firstPage'
            : isLogging == ''
                ? 'logging'
                : 'MainScreen',
        routes: {
          'firstPage': (context) => firstPage(),
          'logging': (context) => Logging(),
          'MainScreen': (context) => const MainScreen(),
        },
        //  home:
        //  VerifyUser()
      ),
    );
  }

//----------------------------------------------------------------------
  Widget firstPage() {
    return FutureBuilder<IntroData>(
      future: futureIntro,
      builder: (BuildContext context, AsyncSnapshot<IntroData> snapshot) {
        var getData = snapshot.data;
        if (snapshot.hasData) {
          return IntroductionScreen(data: getData?.data);
        }
        return Center(child: splash());
      },
    );
  }

//----------------------------------------------------------------------
  Widget splash() {
    return Scaffold(
      backgroundColor: black,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 100.r,
              backgroundColor: black,
              backgroundImage: Image.asset(
                'assets/image/log.png',
              ).image,
            ),
            text(context, 'مرحبا بكم في منصة المشاهير', 20, white,
                align: TextAlign.center)
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
// import 'package:video_player/video_player.dart';
// import 'package:flutter/material.dart';
//
// void main() => runApp(VideoApp());
//
// class VideoApp extends StatefulWidget {
//   @override
//   _VideoAppState createState() => _VideoAppState();
// }
//
// class _VideoAppState extends State<VideoApp> {
//   late VideoPlayerController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(
//         'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
//       ..initialize().then((_) {
//         // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
//         setState(() {});
//       });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Video Demo',
//       home: Scaffold(
//         body: Center(
//           child: _controller.value.isInitialized
//               ? AspectRatio(
//             aspectRatio: _controller.value.aspectRatio,
//             child: VideoPlayer(_controller),
//           )
//               : Container(),
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             setState(() {
//               _controller.value.isPlaying
//                   ? _controller.pause()
//                   : _controller.play();
//             });
//           },
//           child: Icon(
//             _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }
//}