///import section
import 'dart:convert';
import 'dart:io';

import 'package:card_swiper/card_swiper.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:celepraty/Users/Exploer/viewData.dart';
import 'package:celepraty/Users/Exploer/viewDataImage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../../MainScreen/main_screen_navigation.dart';
import '../../ModelAPI/CelebrityScreenAPI.dart';
import '../../Models/Methods/classes/GradientIcon.dart';

import '../orders/advArea.dart';
import '../orders/advForm.dart';
import '../orders/gifttingForm.dart';
import 'package:http/http.dart' as http;

class CelebrityHome extends StatefulWidget {
  final String? pageUrl;
  const CelebrityHome({Key? key, this.pageUrl}) : super(key: key);

  @override
  _CelebrityHomeState createState() => _CelebrityHomeState();
}

class _CelebrityHomeState extends State<CelebrityHome>
    with AutomaticKeepAliveClientMixin {
  bool isSelect = false;
  Future<introModel>? celebrityHome;

  ///list of string to store the advertising area images
  List<String> advImage = [];

  bool isConnectSection = true;
  bool timeoutException = true;
  bool serverExceptions = true;

  bool activeConnection = true;
  String T = "";

  ///---------------------------------------------------------------------------
  ///Pagination Variable Section News
  int page = 1;
  // There is next page or not
  bool _hasNextPage = true;

  // Used to display loading indicators when _firstLoad function is running
  bool _isFirstLoadRunning = false;

  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunning = false;

  //This holds the news fetched from the server
  List _news = [];
  ScrollController scrollController = ScrollController();

  ///---------------------------------------------------------------------------
  ///Pagination Variable Section Studio
  int pageStudio = 1;
  // There is next page or not
  bool _hasNextPageStudio = true;

  // Used to display loading indicators when _firstLoad function is running
  bool _isFirstLoadRunningStudio = false;

  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunningStudio = false;

  //This holds the news fetched from the server
  List _studio = [];
  ScrollController scrollControllerStudio = ScrollController();

  ///This function will be called when the app launches
  void _firstLoadNews(String pageUrl) async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      final res = await http.get(Uri.parse(
          "https://mobile.celebrityads.net/api/celebrity-page/$pageUrl?page=$page"));
      introModel newsModel = introModel.fromJson(jsonDecode(res.body));
      var newNews = newsModel.data!.news;
      setState(() {
        _news = newNews!;
      });
    } catch (err) {
      if (kDebugMode) {
        print('first load Something went wrong');
      }
    }
    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  ///LoadMore Function will be triggered whenever the user scroll
  void _loadMoreNews() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        scrollController.position.extentAfter < 200) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      page += 1; // Increase _page by 1
      try {
        final res = await http.get(Uri.parse(
            "https://mobile.celebrityads.net/api/celebrity-page/${widget.pageUrl}?page=$page"));
        introModel newsModel = introModel.fromJson(jsonDecode(res.body));
        final List<News> fetchedNews = newsModel.data!.news!;
        if (fetchedNews.isNotEmpty) {
          setState(() {
            _news.addAll(fetchedNews);
          });
        } else {
          // This means there is no more data
          // and therefore, we will not send another GET request
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!2222');
        }
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  ///This function will be called when the app launches
  void _firstLoadStudio(String pageUrl) async {
    setState(() {
      _isFirstLoadRunningStudio = true;
    });
    try {
      final res = await http.get(Uri.parse(
          "https://mobile.celebrityads.net/api/celebrity-page-studio/$pageUrl?page=$pageStudio"));
      introModel studioModel = introModel.fromJson(jsonDecode(res.body));
      var newStudio = studioModel.data!.studio;
      setState(() {
        _studio = newStudio as List;
        print('Studio is $_studio');
      });
    } catch (err) {
      if (kDebugMode) {
        print('first load Something went wrong newStudio');
      }
    }
    setState(() {
      _isFirstLoadRunningStudio = false;
    });
  }

  ///LoadMore Function will be triggered whenever the user scroll
  void _loadMoreStudio() async {
    if (_hasNextPageStudio == true &&
        _isFirstLoadRunningStudio == false &&
        _isLoadMoreRunningStudio == false &&
        scrollControllerStudio.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunningStudio =
            true; // Display a progress indicator at the bottom
      });
      pageStudio += 1; // Increase _page by 1
      try {
        final res = await http.get(Uri.parse(
            "https://mobile.celebrityads.net/api/celebrity-page/${widget.pageUrl}?page=$pageStudio"));
        introModel newsModelStudio = introModel.fromJson(jsonDecode(res.body));
        final List<Studio> fetchedStudio = newsModelStudio.data!.studio!;
        if (fetchedStudio.isNotEmpty) {
          setState(() {
            _studio.addAll(fetchedStudio);
          });
        } else {
          // This means there is no more data
          // and therefore, we will not send another GET request
          setState(() {
            _hasNextPageStudio = false;
          });
        }
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!777777777');
        }
      }

      setState(() {
        _isLoadMoreRunningStudio = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    celebrityHome = getSectionsData(widget.pageUrl!);

    _firstLoadNews(widget.pageUrl!);
    _firstLoadStudio(widget.pageUrl!);
    scrollController = ScrollController()..addListener(_loadMoreNews);
    scrollControllerStudio = ScrollController()..addListener(_loadMoreStudio);
  }

  @override
  void dispose() {
    scrollController.removeListener(_loadMoreNews);
    scrollControllerStudio.removeListener(_loadMoreStudio);
    super.dispose();
  }

  Future<introModel> getSectionsData(String pageUrl) async {
    final response = await http.get(
        Uri.parse(
            'https://mobile.celebrityads.net/api/celebrity-page/$pageUrl'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(response.body);

      return introModel.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load activity');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: activeConnection
            ? SingleChildScrollView(
                child: FutureBuilder<introModel>(
                    future: celebrityHome,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: mainLoad(context));
                      } else if (snapshot.connectionState ==
                              ConnectionState.active ||
                          snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          //throw snapshot.error.toString();
                          if (snapshot.error.toString() == 'SocketException') {
                            return Center(
                                child: SizedBox(
                                    height: 500.h,
                                    width: 250.w,
                                    child:
                                        internetConnection(context, reload: () {
                                      setState(() {
                                        celebrityHome =
                                            getSectionsData(widget.pageUrl!);
                                        isConnectSection = true;
                                      });
                                    })));
                          } else {
                            return const Center(
                                child:
                                    Text('حدث خطا ما اثناء استرجاع البيانات'));
                          }
                          //---------------------------------------------------------------------------
                        } else if (snapshot.hasData) {
                          ///get the adv image from API and store it inside th list
                          for (int i = 0;
                              i < snapshot.data!.data!.adSpaceOrders!.length;
                              i++) {
                            advImage.contains(snapshot
                                    .data!.data!.adSpaceOrders![i].image!)
                                ? null
                                : advImage.add(snapshot
                                    .data!.data!.adSpaceOrders![i].image!);
                          }
                          return Column(
                            children: [
                              ///Stack for image and there information
                              Column(
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        width: 500.w,
                                        height: 400.h,
                                        child: Image.network(
                                            snapshot.data!.data!.celebrity!.image!,
                                          fit: BoxFit.cover,
                                            color:
                                            black.withOpacity(0.4),
                                          colorBlendMode: BlendMode.darken,
                                            loadingBuilder : (context, child, loadingProgress) {
                                              if (loadingProgress == null) return child;
                                              return Center(
                                                child: CircularProgressIndicator(
                                                  backgroundColor: grey,
                                                  color: purple.withOpacity(0.5),
                                                  value: loadingProgress.expectedTotalBytes != null
                                                      ? loadingProgress.cumulativeBytesLoaded /
                                                      loadingProgress.expectedTotalBytes!
                                                      : null,
                                                ),
                                              );
                                            }
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 30.h, right: 20.w),
                                        child: Row(
                                          children: [
                                            ///back icon to the main screen
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.arrow_back_ios),
                                              color: white,
                                              iconSize: 30,
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 165.h, right: 25.w),
                                            child: Row(children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 5.h),
                                                child: Icon(
                                                  verified,
                                                  color: blue.withOpacity(0.6),
                                                  size: 27,
                                                ),
                                              ),

                                              ///SizedBox
                                              SizedBox(
                                                width: 6.w,
                                              ),
                                              text(
                                                  context,
                                                  snapshot.data!.data!
                                                      .celebrity!.name!,
                                                  35,
                                                  white,
                                                  fontWeight: FontWeight.bold),
                                            ]),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(right: 25.w),
                                            child: Row(
                                              children: [
                                                text(
                                                    context,
                                                    snapshot
                                                        .data!
                                                        .data!
                                                        .celebrity!
                                                        .category!
                                                        .name!,
                                                    14,
                                                    white),

                                                ///SizedBox
                                                SizedBox(
                                                  width: 7.w,
                                                ),
                                                CircleAvatar(
                                                  backgroundImage:
                                                      Image.network(snapshot
                                                              .data!
                                                              .data!
                                                              .celebrity!
                                                              .country!
                                                              .flag!)
                                                          .image,
                                                  radius: 10.r,
                                                ),

                                                ///SizedBox
                                                SizedBox(
                                                  width: 7.w,
                                                ),
                                                text(
                                                    context,
                                                    snapshot
                                                        .data!
                                                        .data!
                                                        .celebrity!
                                                        .country!
                                                        .name!,
                                                    14,
                                                    white),
                                              ],
                                            ),
                                          ),

                                          Padding(
                                            padding: EdgeInsets.only(top: 12.h,right: 25.w
                                            ),
                                            child: text(
                                                context,
                                                snapshot.data!.data!.celebrity!
                                                    .description!,
                                                14,
                                                white.withOpacity(0.9),
                                                ),
                                          ),
                                          Container(
                                              alignment: Alignment.centerRight,
                                              margin:
                                                  EdgeInsets.only(top: 12.h,right: 25.w),
                                              child: InkWell(
                                                  onTap: () {
                                                    showDialogFunc(
                                                        context,
                                                        '',
                                                        snapshot
                                                            .data!
                                                            .data!
                                                            .celebrity!
                                                            .advertisingPolicy!,
                                                        snapshot
                                                            .data!
                                                            .data!
                                                            .celebrity!
                                                            .giftingPolicy!,
                                                        snapshot
                                                            .data!
                                                            .data!
                                                            .celebrity!
                                                            .adSpacePolicy!);
                                                  },
                                                  child: text(
                                                      context,
                                                      'سياسة التعامل مع ' +
                                                          snapshot.data!.data!
                                                              .celebrity!.name!,
                                                      16,
                                                      purple))),

                                          ///SizedBox
                                          SizedBox(
                                            height: 10.h,
                                          ),

                                          ///Social media icons
                                          Padding(
                                            padding:
                                                EdgeInsets.only(right: 25.w),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 8.w),
                                                  child: SizedBox(
                                                    width: 30,
                                                    height: 30,
                                                    child: InkWell(
                                                      child: Image.asset(
                                                        'assets/image/icon- faceboock.png',
                                                      ),
                                                      onTap: () async {
                                                        var url = snapshot
                                                            .data!
                                                            .data!
                                                            .celebrity!
                                                            .facebook!;
                                                        if (url == "") {
                                                          ///Do nothing
                                                        } else {
                                                          await launch(url,
                                                              forceWebView:
                                                                  true);
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 8.w),
                                                  child: SizedBox(
                                                    width: 30,
                                                    height: 30,
                                                    child: InkWell(
                                                        child: Image.asset(
                                                          'assets/image/icon- insta.png',
                                                        ),
                                                        onTap: () async {
                                                          var url = snapshot
                                                              .data!
                                                              .data!
                                                              .celebrity!
                                                              .instagram!;
                                                          if (url == "") {
                                                            ///Do nothing
                                                          } else {
                                                            await launch(url,
                                                                forceWebView:
                                                                    true);
                                                          }
                                                        }),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 8.w),
                                                  child: SizedBox(
                                                    width: 30,
                                                    height: 30,
                                                    child: InkWell(
                                                        child: Image.asset(
                                                          'assets/image/icon- snapchat.png',
                                                        ),
                                                        onTap: () async {
                                                          var url = snapshot
                                                              .data!
                                                              .data!
                                                              .celebrity!
                                                              .snapchat!;
                                                          if (url == "") {
                                                            ///Do nothing
                                                          } else {
                                                            await launch(url,
                                                                forceWebView:
                                                                    true);
                                                          }
                                                        }),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:  EdgeInsets.only(left: 8.w),
                                                  child: SizedBox(
                                                    width: 30,
                                                    height: 30,
                                                    child: InkWell(
                                                        child: Image.asset(
                                                          'assets/image/icon- twitter.png',
                                                        ),
                                                        onTap: () async {
                                                          var url = snapshot
                                                              .data!
                                                              .data!
                                                              .celebrity!
                                                              .twitter!;
                                                          if (url == "") {
                                                            ///Do nothing
                                                          } else {
                                                            await launch(url,
                                                                forceWebView:
                                                                    true);
                                                          }
                                                        }),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 8.w),
                                                  child: SizedBox(
                                                    width: 30,
                                                    height: 30,
                                                    child: InkWell(
                                                      child: SvgPicture.asset(
                                                        'assets/Svg/ttt.svg',
                                                      ),
                                                      onTap: () async {
                                                        var url = snapshot
                                                            .data!
                                                            .data!
                                                            .celebrity!
                                                            .tiktok!;
                                                        if (url == "") {
                                                          ///Do nothing
                                                        } else {
                                                          await launch(url,
                                                              forceWebView:
                                                              true);
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),

                              ///SizedBox
                              SizedBox(
                                height: 20.h,
                              ),

                              ///horizontal listView for news
                              _isFirstLoadRunning
                                  ? mainLoad(context)
                                  : Visibility(
                                      visible: _news.isEmpty ? false : true,
                                      child: SizedBox(
                                        height: 60.h,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          controller: scrollController,
                                          itemCount: _news.length,
                                          itemBuilder: (_, index) =>
                                              Row(children: [
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(right: 8.w),
                                                child: Container(
                                                  height: 70.h,
                                                  width: 208.w,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(50.r),
                                                      bottomRight:
                                                          Radius.circular(50.r),
                                                      topLeft:
                                                          Radius.circular(15.r),
                                                      bottomLeft:
                                                          Radius.circular(15.r),
                                                    ),
                                                    gradient:
                                                        const LinearGradient(
                                                      begin:
                                                          Alignment(0.5, 2.0),
                                                      end: Alignment(
                                                          -0.69, -1.0),
                                                      colors: [
                                                        Color(0xffe468ca),
                                                        Color(0xff0ab3d0),

                                                      ],
                                                      stops: [0.0, 1.0],
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 8.w),
                                                    child: Row(
                                                      children: [
                                                        CircleAvatar(
                                                          backgroundImage: Image.network(snapshot.data!.data!.celebrity!.image!,
                                                              loadingBuilder : (context, child, loadingProgress) {
                                                                if (loadingProgress == null) return child;
                                                                return Center(
                                                                  child: CircularProgressIndicator(
                                                                    backgroundColor: grey,
                                                                    color: purple.withOpacity(0.5),
                                                                    value: loadingProgress.expectedTotalBytes != null
                                                                        ? loadingProgress.cumulativeBytesLoaded /
                                                                        loadingProgress.expectedTotalBytes!
                                                                        : null,
                                                                  ),
                                                                );
                                                              }).image,
                                                          radius: 30.r,
                                                        ),
                                                        SizedBox(
                                                          width: 10.w,
                                                        ),
                                                        SizedBox(
                                                          height: 70.h,
                                                          width: 110.w,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              text(
                                                                context,
                                                                _news[index]
                                                                    .description,
                                                                11,
                                                                white,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ))
                                          ]),
                                        ),
                                      ),
                                    ),
                              // when the _loadMore function is running
                              if (_isLoadMoreRunning == true)
                                //mainLoad(context),

                                // When nothing else to load
                                if (_hasNextPage == false) SizedBox(),

                              ///SizedBox
                              Visibility(
                                visible: advImage.isEmpty ? false : true,
                                child: SizedBox(
                                  height: 20.h,
                                ),
                              ),

                              Visibility(
                                visible: advImage.isEmpty ? false : true,
                                child: Container(
                                    margin: EdgeInsets.only(
                                        right: 10.w, left: 10.w),
                                    height: 150.h,
                                    decoration: BoxDecoration(
                                        color: black,
                                        borderRadius:
                                            BorderRadius.circular(7.r)),
                                    child: imageSlider(advImage)
                                ),
                              ),

                              Visibility(
                                visible: snapshot.data!.data!.celebrity!.brand!.isNotEmpty,
                                child: SizedBox(
                                  height: 20.h,
                                ),
                              ),

                              ///Container for celebrity store
                              Visibility(
                                visible: snapshot.data!.data!.celebrity!.store!.isNotEmpty,
                                child: Container(
                                  margin:
                                      EdgeInsets.only(right: 10.w, left: 10.w),
                                  height: 90.h,
                                  width: 440.w,
                                  decoration: BoxDecoration(
                                      color: black,
                                      borderRadius: BorderRadius.circular(7.r)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(right: 10.w),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            text(context, 'قم بزيارة المتجر الان',
                                                12, white),
                                            text(
                                                context,
                                                'المتجر الخاص بمروان بابلو',
                                                16,
                                                white),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 15.w),
                                        child: InkWell(
                                          child: gradientContainerNoborder2(
                                              90,
                                              30,
                                              text(context, 'زيارة المتجر', 15,
                                                  white,
                                                  align: TextAlign.center)),
                                          onTap: () {
                                            snapshot
                                                .data!.data!.celebrity!.brand!;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              Visibility(
                                visible: snapshot.data!.data!.celebrity!
                                    .brand!.isNotEmpty,
                                child: SizedBox(
                                  height: 20.h,
                                ),
                              ),

                              ///studio
                              _isFirstLoadRunningStudio
                                  ? mainLoad(context)
                                  : Visibility(
                                      visible: _studio.isEmpty ? false : true,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            right: 10.w, left: 10.w),
                                        child: SizedBox(
                                          height: 350.h,
                                          width: 400.w,
                                          child: GridView.builder(
                                            itemCount: _studio.length,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount:
                                                  2, //عدد العناصر في كل صف
                                              crossAxisSpacing:
                                                  15.h, // المسافات الراسية
                                              childAspectRatio:
                                                  0.90, //حجم العناصر
                                              mainAxisSpacing: 5.w,
                                            ),
                                            controller: scrollControllerStudio,
                                            itemBuilder: (context, i) {
                                              ///play the celebrity video
                                              return Card(
                                                elevation: 10,
                                                child: Stack(
                                                  children: [
                                                    ///IMAGE SECTION
                                                    _studio[i].type! == "image"
                                                        ? InkWell(
                                                            child: Image.network(
                                                                _studio[i].image!,
                                                                height: double.infinity, width: double.infinity,
                                                                fit: BoxFit.cover,
                                                                loadingBuilder : (context, child, loadingProgress) {
                                                                  if (loadingProgress == null) return child;
                                                                  return Center(
                                                                    child: Lottie.asset('assets/lottie/grey.json',
                                                                        height: 70.h, width: 70.w)
                                                                  );
                                                                }
                                                            ),
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          ImageData(
                                                                            image:
                                                                                _studio[i].image!,
                                                                          )));
                                                            },
                                                          )
                                                    ///Video Section
                                                        : Stack(
                                                            children: [
                                                              ///Video
                                                              VideoPlayer(VideoPlayerController.network(_studio[i].image!,)..initialize()),

                                                              ///Play Icon
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  ///play video
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsets.only(
                                                                          top: 10
                                                                              .h,
                                                                          right:
                                                                              75.w),
                                                                      child:
                                                                          IconButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                  builder: (context) => viewData(
                                                                                        video: _studio[i].image!,
                                                                                      )));
                                                                          print(
                                                                              'Tap it');
                                                                        },
                                                                        icon: GradientIcon(
                                                                            playViduo,
                                                                            40.sp,
                                                                            const LinearGradient(
                                                                              begin: Alignment(0.7, 2.0),
                                                                              end: Alignment(-0.69, -1.0),
                                                                              colors: [
                                                                                Color(0xff0ab3d0),
                                                                                Color(0xffe468ca)
                                                                              ],
                                                                              stops: [
                                                                                0.0,
                                                                                1.0
                                                                              ],
                                                                            )),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          )
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                              if (_isLoadMoreRunningStudio == true)
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 5.h, bottom: 50.h),
                                  child: CircularProgressIndicator(
                                    color: purple.withOpacity(0.5),
                                  ),
                                ),

                              // When nothing else to load
                              if (_hasNextPageStudio == false) SizedBox(),

                              SizedBox(
                                height: 20.h,
                              ),

                              Visibility(
                                  visible: currentuser == 'user' ? true : false,
                                  child: padding(
                                    15,
                                    15,
                                    gradientContainerNoborder(
                                        getSize(context).width,
                                        buttoms(context, 'اطلب حالا', 20, white,
                                            () {
                                          showBottomSheett(
                                              context,
                                              bottomSheetMenu(
                                                  snapshot.data!.data!
                                                      .celebrity!.id!
                                                      .toString(),
                                                  snapshot.data!.data!
                                                      .celebrity!.image!,
                                                  snapshot.data!.data!
                                                      .celebrity!.name!
                                                      .toString()));
                                        })),
                                  )),
                              SizedBox(
                                height: 20.h,
                              ),
                            ],
                          );
                        } else {
                          return const Center(child: Text('No info to show!!'));
                        }
                      } else {
                        return Center(
                            child: Text('State: ${snapshot.connectionState}'));
                      }
                    }),
              )
            : Center(
                child: SizedBox(
                    height: 300.h,
                    width: 250.w,
                    child: internetConnection(context, reload: () {
                      checkUserConnection();
                      celebrityHome = getSectionsData(widget.pageUrl!);
                    }))),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  Future checkUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          activeConnection = true;
          T = "Turn off the data and repress again";
        });
      }
    } on SocketException catch (_) {
      setState(() {
        activeConnection = false;
        T = "Turn On the data and repress again";
      });
    }
  }

  ///image slider
  Widget imageSlider(List adImage) {
    return Swiper(
      indicatorLayout: PageIndicatorLayout.COLOR,
      autoplay: true,
      itemCount: adImage.length,
      pagination: const SwiperPagination(),
      control:
          SwiperControl(color: white, padding: EdgeInsets.only(right: 8.w)),
      itemBuilder: (context, index) {
        return Container(
          height: 90.h,
          width: 440.w,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7.r),
              image: DecorationImage(
                image: NetworkImage(
                  adImage[index],
                ),
                fit: BoxFit.cover,
              )),
        );
      },
      onIndexChanged: (int index) {
        setState(() {
          //currentIndex = index;
        });
      },
    );
  }

  ///order from the celebrity
  Widget bottomSheetMenu(String id, image, name) {
    return SingleChildScrollView(
      child: Column(children: [
        SizedBox(
          height: 50.h,
        ),
        text(context, 'قم باختيار ما يناسبك من التالي', 22, white),
        SizedBox(
          height: 30.h,
        ),
        SizedBox(
          height: 80.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                child: Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: <Color>[pink, blue],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    height: 40.h,
                    width: 40.h,
                    child: Padding(
                      padding: EdgeInsets.only(top: 2.h, left: 10.w),
                      child: Icon(arrow, size: 25.w, color: white),
                    )),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => gifttingForm(
                              id: id,
                              image: image,
                              name: name,
                            )),
                  );
                },
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  text(context, ' طلب اهداء', 14, white,
                      fontWeight: FontWeight.bold),
                  text(
                    context,
                    'اطلب اهداءك الان من مشهورك المفضل',
                    10,
                    darkWhite,
                  ),
                ],
              ),
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: border),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  height: 70.h,
                  width: 70.w,
                  child: Center(
                      child: GradientIcon(
                          copun,
                          40.0.w,
                          const LinearGradient(
                              colors: <Color>[pink, blue],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight))))
            ],
          ),
        ),
        const Divider(
          color: darkWhite,
        ),
        SizedBox(
          height: 80.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                child: Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: <Color>[pink, blue],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                        borderRadius:
                            BorderRadius.all(const Radius.circular(70))),
                    height: 40.h,
                    width: 40.h,
                    child: Padding(
                      padding: EdgeInsets.only(top: 2.h, left: 10.w),
                      child: Icon(arrow, size: 25.w, color: white),
                    )),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => advForm(
                              id: id,
                              image: image,
                              name: name,
                            )),
                  );
                },
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  text(context, ' طلب اعلان', 14, white,
                      fontWeight: FontWeight.bold),
                  text(
                    context,
                    'اطلب اعلانك الان من مشهورك المفضل',
                    10,
                    darkWhite,
                  ),
                ],
              ),
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: border),
                      borderRadius:
                           BorderRadius.all( Radius.circular(10.r))),
                  alignment: Alignment.centerRight,
                  height: 70.h,
                  width: 70.w,
                  child: Center(
                      child: GradientIcon(
                          ad,
                          40.0.w,
                          const LinearGradient(
                              colors: <Color>[pink, blue],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight))))
            ],
          ),
        ),
        const Divider(color: darkWhite),
        SizedBox(
          height: 80.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                child: Container(
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: <Color>[pink, blue],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                        borderRadius: BorderRadius.all(Radius.circular(50.r))),
                    height: 40.h,
                    width: 40.h,
                    child: Padding(
                      padding: EdgeInsets.only(top: 2.h, left: 10.w),
                      child: Icon(arrow, size: 25.w, color: white),
                    )),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => advArea(
                              id: id,
                            )),
                  );
                },
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  text(context, 'طلب مساحة اعلانية', 14, white,
                      fontWeight: FontWeight.bold),
                  text(
                    context,
                    '                اطلب مساحتك الاعلانية الان',
                    10,
                    darkWhite,
                  ),
                ],
              ),
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: border),
                      borderRadius: BorderRadius.all(Radius.circular(10.r))),
                  alignment: Alignment.centerRight,
                  height: 70.h,
                  width: 70.w,
                  child: Center(
                      child: GradientIcon(
                          adArea,
                          40.0.w,
                          const LinearGradient(
                              colors: <Color>[pink, blue],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight))))
            ],
          ),
        ),
      ]),
    );
  }

  ///privacy policy for the celebrity
  showDialogFunc(context, title, adDes, giftDes, areaDes) {
    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: white,
              ),
              padding: EdgeInsets.only(top: 15.h, right: 20.w, left: 20.w),
              height: 380.h,
              width: 380.w,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  textDirection: TextDirection.rtl,
                  children: [
                    ///Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ///text
                        text(context, 'تفاصيل سياسة التعامل', 14, grey!),
                      ],
                    ),
                    SizedBox(
                      height: 15.h,
                    ),

                    ///Adv Title
                    text(context, 'سياسة الاعلان', 16, black,
                        fontWeight: FontWeight.bold),
                    SizedBox(
                      height: 5.h,
                    ),

                    ///Adv Details
                    text(
                      context,
                      adDes,
                      14,
                      ligthtBlack,
                    ),

                    ///---------------------
                    SizedBox(
                      height: 15.h,
                    ),

                    ///---------------------

                    ///Gifting Title
                    text(context, 'سياسة الاهداء', 16, black,
                        fontWeight: FontWeight.bold),
                    SizedBox(
                      height: 5.h,
                    ),

                    ///Gifting Details
                    text(
                      context,
                      giftDes,
                      14,
                      ligthtBlack,
                    ),

                    ///---------------------
                    SizedBox(
                      height: 15.h,
                    ),

                    ///---------------------

                    ///Area Title
                    text(context, 'سياسة المساحة الاعلانية', 16, black,
                        fontWeight: FontWeight.bold),
                    SizedBox(
                      height: 5.h,
                    ),

                    ///Area Details
                    text(
                      context,
                      areaDes,
                      14,
                      ligthtBlack,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
