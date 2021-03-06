import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:card_swiper/card_swiper.dart';
import 'package:celepraty/Account/Singup.dart';
import 'package:celepraty/Celebrity/CelebritySearch.dart';
import 'package:celepraty/Celebrity/ShowMoreCelebraty.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:celepraty/Models/Methods/classes/GradientIcon.dart';
import 'package:celepraty/Users/CreateOrder/buildAdvOrder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Account/LoggingSingUpAPI.dart';
import '../MainScreen/main_screen_navigation.dart';
import '../ModelAPI/ModelsAPI.dart';
import '../Models/Variables/Variables.dart';
import 'HomeScreen/celebrity_home_page.dart';
import 'package:shimmer/shimmer.dart';

class celebrityHomePage extends StatefulWidget {
  const celebrityHomePage({Key? key}) : super(key: key);

  @override
  _celebrityHomePageState createState() => _celebrityHomePageState();
}

class _celebrityHomePageState extends State<celebrityHomePage>
    with AutomaticKeepAliveClientMixin {
  Map<int, Future<Category>> category = HashMap<int, Future<Category>>();
  Future<Section>? sections;
  Future<link>? futureLinks;
  Future<header>? futureHeader;
  Future<Partner>? futurePartners;
  List<dynamic> allCellbrity = [];
  bool isLoading = true;
  bool isConnectSection = true;
  bool timeoutException = true;
  bool serverExceptions = true;
  bool endLode = false;
  int page = 1;
  int currentIndex = 0;
  @override
  void initState() {
    sections = getSectionsData();
    futureLinks = fetchLinks();
    futureHeader = fetchHeader();
    futurePartners = fetchPartners();
    getAllCelebrity().then((value) {
      if (mounted) {
        setState(() {
          allCellbrity = value!;
          endLode = true;
        });
      }
    });

    super.initState();
  }
//---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Directionality(
        textDirection: TextDirection.rtl,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primaryColor: purple),
          home: Scaffold(
            body: RefreshIndicator(
              color: white,
              backgroundColor: purple,
              onRefresh: onRefresh,
              child: isConnectSection == false
                  ? Center(
                child: internetConnection(context, reload: () {
                  setState(() {
                    onRefresh();
                    isConnectSection = true;
                  });
                }),
              )
                  : timeoutException == false
                  ? Center(
                child: checkTimeOutException(context, reload: () {
                  setState(() {
                    onRefresh();
                    timeoutException = true;
                  });
                }),
              )
                  : serverExceptions == false
                  ? Center(
                child: checkServerException(context, reload: () {
                  setState(() {
                    onRefresh();
                    serverExceptions = true;
                  });
                }),
              )
                  : SingleChildScrollView(
                child: Column(
                  children: [
                    search(),
                    Padding(
                      padding: EdgeInsets.only(bottom: 15.0.h),
                      child: FutureBuilder<Section>(
                        future: sections,
                        builder: (BuildContext context,
                            AsyncSnapshot<Section> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: lodeing());
                          } else if (snapshot.connectionState ==
                              ConnectionState.active ||
                              snapshot.connectionState ==
                                  ConnectionState.done) {
                            if (snapshot.hasError) {
                              if (snapshot.error.toString() ==
                                  'SocketException') {
                                return Center(
                                    child: SizedBox(
                                        height: 200.h,
                                        width: 200.w,
                                        child: internetConnection(
                                            context, reload: () {
                                          setState(() {
                                            onRefresh();
                                            isConnectSection = true;
                                          });
                                        })));
                              } else {
                                return const Center(
                                    child: Text(
                                        '?????? ?????? ???? ?????????? ?????????????? ????????????????'));
                              }
                              //---------------------------------------------------------------------------
                            } else if (snapshot.hasData) {
                              return Column(
                                children: [
                                  for (int sectionIndex = 0;
                                  sectionIndex <
                                      snapshot
                                          .data!.data!.length;
                                  sectionIndex++)
                                    Column(
                                      children: [
//category--------------------------------------------------------------------------

                                        if (snapshot
                                            .data!
                                            .data![sectionIndex]
                                            .sectionName ==
                                            'category')
                                          categorySection(
                                              snapshot
                                                  .data
                                                  ?.data![
                                              sectionIndex]
                                                  .categoryId,
                                              snapshot
                                                  .data
                                                  ?.data![
                                              sectionIndex]
                                                  .title,
                                              snapshot
                                                  .data
                                                  ?.data![
                                              sectionIndex]
                                                  .active),

//header--------------------------------------------------------------------------
                                        if (snapshot
                                            .data!
                                            .data![sectionIndex]
                                            .sectionName ==
                                            'header')
                                          headerSection(snapshot
                                              .data
                                              ?.data![sectionIndex]
                                              .active),
//links--------------------------------------------------------------------------
                                        if (snapshot
                                            .data!
                                            .data![sectionIndex]
                                            .sectionName ==
                                            'links')
                                          linksSection(snapshot
                                              .data
                                              ?.data![sectionIndex]
                                              .active),
//Advertising-banner--------------------------------------------------------------------------
                                        if (snapshot
                                            .data!
                                            .data![sectionIndex]
                                            .sectionName ==
                                            'Advertising-banner')
                                          advertisingBannerSection(
                                            snapshot
                                                .data
                                                ?.data![
                                            sectionIndex]
                                                .active,
                                            snapshot
                                                .data
                                                ?.data![
                                            sectionIndex]
                                                .imageMobile,
                                            snapshot
                                                .data
                                                ?.data![
                                            sectionIndex]
                                                .link,
                                          ),
//join-us--------------------------------------------------------------------------
                                        if (snapshot
                                            .data!
                                            .data![sectionIndex]
                                            .sectionName ==
                                            'join-us')
                                          joinUsSection(snapshot
                                              .data
                                              ?.data![sectionIndex]
                                              .active),
//new_section---------------------------------------------------------------------------
                                        if (snapshot
                                            .data!
                                            .data![sectionIndex]
                                            .sectionName ==
                                            'new_section')
                                          newSection(
                                              snapshot
                                                  .data
                                                  ?.data![
                                              sectionIndex]
                                                  .active,
                                              snapshot
                                                  .data
                                                  ?.data![
                                              sectionIndex]
                                                  .imageMobile,
                                              snapshot
                                                  .data
                                                  ?.data![
                                              sectionIndex]
                                                  .link),
//news ---------------------------------------------------------------------------
                                        if (snapshot
                                            .data!
                                            .data![sectionIndex]
                                            .sectionName ==
                                            'news')
                                          newsSection(
                                              snapshot
                                                  .data
                                                  ?.data![
                                              sectionIndex]
                                                  .active,
                                              snapshot
                                                  .data
                                                  ?.data![
                                              sectionIndex]
                                                  .imageMobile,
                                              snapshot
                                                  .data
                                                  ?.data![
                                              sectionIndex]
                                                  .link),
//partners--------------------------------------------------------------------------
                                        if (snapshot
                                            .data!
                                            .data![sectionIndex]
                                            .sectionName ==
                                            'partners')
                                          partnersSection(snapshot
                                              .data
                                              ?.data![sectionIndex]
                                              .active),
                                      ],
                                    )
                                ],
                              );
                            } else {
                              return const Center(
                                  child: Text('Empty data'));
                            }
                          } else {
                            return Center(
                                child: Text(
                                    'State: ${snapshot.connectionState}'));
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )


    );
  }

//search history------------------------------
  Future<void> _showSearch() async {
    endLode
        ? await showSearch(

            context: context,
            delegate: CelebritySearch(
              allCelbrity: allCellbrity,

            ),

          )
        : print('lllllllllloding');
  }

  @override
  bool get wantKeepAlive => true;

  Future<Section> getSectionsData() async {
    try {
      var getSections = await http
          .get(Uri.parse("http://mobile.celebrityads.net/api/sections"));
      if (getSections.statusCode == 200) {
        final body = getSections.body;

        Section sections = Section.fromJson(jsonDecode(body));

        for (int i = 0; i < sections.data!.length; i++) {
          if (sections.data?[i].sectionName == 'category') {
            category.putIfAbsent(sections.data![i].categoryId!,
                () => fetchCategories(sections.data![i].categoryId!, page));
            setState(() {});
          }
        }
        return sections;
      } else {
        return Future.error('serverExceptions');
      }
    } catch (e) {
      if (e is SocketException) {
        setState(() {
          isConnectSection = false;
        });
        return Future.error('SocketException');
      } else if (e is TimeoutException) {
        setState(() {
          timeoutException = false;
        });
        return Future.error('TimeoutException');
      } else {
        setState(() {
          serverExceptions = false;
        });
        return Future.error('serverExceptions');
      }
    }
  }

//------------------------------Slider image-------------------------------------------
  Widget imageSlider(List image) {
    return InkWell(
      onTap: () async {
        print('cliiiiiiiiiiiked');
        var url = 'https://www.celebritycruises.com/';
        await launch(url.toString(), forceWebView: true);
      },
      child: Swiper(
        itemBuilder: (context, index) {
          return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.r),
                ),
              ),
              child: Stack(
                children: [
// image------------------------------------------------------------------------------
                  ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.r),
                    ),
                    child: Image.network(
                      image[index],
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Center(
                            child: Lottie.asset('assets/lottie/grey.json',
                                height: 70.h, width: 70.w));
                      },
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return Center(
                            child: Icon(
                          error,
                          size: 50.r,
                          color: red,
                        ));
                      },
                    ),
                  ),
                ],
              ));
        },
        onIndexChanged: (int index) {
          setState(() {
            currentIndex = index;
          });
        },

        indicatorLayout: PageIndicatorLayout.COLOR,
        autoplay: true,
        //axisDirection: AxisDirection.right,
        itemCount: image.length,
        pagination: const SwiperPagination(),
        control: SwiperControl(
            color: grey, padding: EdgeInsets.only(left: 20.w, right: 5.w)),
      ),
    );
  }

//explorer bottom image--------------------------------------------------------------
  Widget drowButtom(list, int length) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        showButton(list[2].image, list[2].link),
        SizedBox(
          width: 10.w,
        ),
        showButton(list[1].image, list[1].link),
        SizedBox(
          width: 10.w,
        ),
        showButton(list[0].image, list[2].link),
      ],
    );
  }

//--------------------------------------------------------------------------
  Widget showButton(String image, String link) {
    return Expanded(
        child: InkWell(
      onTap: () async {
        var url = link;
        await launch(url.toString(), forceWebView: true);
      },
      child: Container(
          width: 105.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(5.r),
            ),
          ),
          child: Stack(
            children: [
// image------------------------------------------------------------------------------
              ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.r),
                ),
                child: Image.network(
                  image,
                  // color: black.withOpacity(0.4),
                  // colorBlendMode: BlendMode.darken,
                  fit: BoxFit.fill,
                  height: double.infinity,
                  width: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(
                        child: Lottie.asset('assets/lottie/grey.json',
                            height: 70.h, width: 70.w));
                  },
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return Center(
                        child: Icon(
                      error,
                      size: 30.r,
                      color: red,
                    ));
                  },
                ),
              ),
            ],
          )),
    ));
  }

  Widget jouinFaums(String title, String contint, String buttomText) {
    return gradientContainerNoborder(
        184.5,
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 26.h,
            ),
            text(context, title, 18, white, fontWeight: FontWeight.bold),
            SizedBox(
              height: 11.h,
            ),
            text(context, contint, 14, white, fontWeight: FontWeight.bold),
            SizedBox(
              height: 26.h,
            ),
            container(
              28.92,
              87,
              0,
              0,
              black_,
              Center(
                  child: text(context, buttomText, 10, white,
                      fontWeight: FontWeight.bold)),
              bottomLeft: 10,
              bottomRight: 10,
              topLeft: 10,
              topRight: 10,
              pL: 10,
              pR: 10,
            ),
            SizedBox(
              height: 44.h,
            ),
          ],
        ));
  }

//-------------------------------------------------------------------------------
  Widget sponsors(String image, String link, int index) {
    return InkWell(
      onTap: () async {
        var url = link;
        await launch(url, forceWebView: true);
      },
      child: SizedBox(
        height: 90.h,
        width: 180.w,
        child: Card(
          //color: blue,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3.0.r),
            child: Image.network(
              image,
              fit: BoxFit.contain,
              height: 90.h,
              width: 180.w,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Center(
                    child: Lottie.asset('assets/lottie/grey.json',
                        height: 70.h, width: 70.w));
              },
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return Center(
                    child: Icon(
                  error,
                  size: 40.r,
                  color: red,
                ));
              },
            ),
          ),
        ),
      ),
    );
  }

  //-------------------------------------------------------------
  Widget advPanel() {
    return gradientContainerNoborder(
        double.infinity,
        Row(
          children: [
            //logo-----------------------------------------
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Transform.rotate(
                  angle: 45,
                  child: container(
                    80,
                    90,
                    0,
                    0,
                    white,
                    Transform.rotate(
                        angle: -45,
                        child: Image(
                          image: const AssetImage("assets/image/log.png"),
                          fit: BoxFit.cover,
                          height: 52.h,
                          width: 52.w,
                        )),
                    bottomLeft: 25,
                    bottomRight: 25,
                    topLeft: 25,
                    topRight: 25,
                  ),
                ),
              ),
            ),
//join now+text--------------------------------------------------------------
            Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.only(left: 28.w, right: 28.w),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //text----------------------------------------
                        text(context, "???????? ????????????????", 21, white,
                            fontWeight: FontWeight.bold),
                        SizedBox(
                          height: 10.h,
                        ),
                        //buttom----------------------------------------
                        container(
                          34,
                          101,
                          0,
                          0,
                          yallow,
                          Center(
                              child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SingUp()));
                            },
                            child: text(context, "???????? ????????", 17, black,
                                fontWeight: FontWeight.bold),
                          )),
                          bottomLeft: 19,
                          bottomRight: 19,
                          topLeft: 19,
                          topRight: 19,
                          pL: 10,
                          pR: 10,
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ),
        height: 120.h,
        blurRadius: 1);
  }

//categorySection---------------------------------------------------------------------------
  categorySection(int? categoryId, String? title, int? active) {
    return active == 1
        ? FutureBuilder(
            future: category[categoryId],
            builder: ((context, AsyncSnapshot<Category> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: EdgeInsets.only(
                      left: 5.0.w, right: 5.0.w, top: 60.h, bottom: 4.h),
                  child: SizedBox(
                    height: 300.h,
                    child: Shimmer(
                        enabled: true,
                        gradient: LinearGradient(
                          tileMode: TileMode.mirror,
                          colors: [mainGrey, Colors.white],
                          stops: const [0.1, 0.88],
                        ),
                        child: shapeRow(300, width: 230.w)),
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  if (snapshot.error.toString() == '???????? ???? ???????????? ??????????????????') {
                    return const Center(child: Text(''));
                  } else {
                    return const Center(child: Text(''));
                  }
                  //---------------------------------------------------------------------------
                } else if (snapshot.hasData) {
                  return snapshot.data!.data!.celebrities!.isNotEmpty
                      ? SizedBox(
                          height: 300.h,
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: InkWell(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
//category name-----------------------------------------------------------
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 5.0.w,
                                      right: 5.0.w,
                                      top: 20.h,
                                      bottom: 4.h),
                                  child: text(context, title!, 20, black,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 10.h),
                                    child: ListView.builder(
                                        // controller: scrollController,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: snapshot.data!.data!
                                                .celebrities!.length +
                                            1,
                                        itemBuilder:
                                            (context, int itemPosition) {
                                          if (snapshot.data!.data!.celebrities!
                                              .isEmpty) {
                                            return const SizedBox();
                                          }
                                          if (itemPosition <
                                              snapshot.data!.data!.celebrities!
                                                  .length) {
//show more -----------------------------------------------------------------------
                                            return SizedBox(
                                              width: 180.w,
                                              child: InkWell(
                                                  onTap: () {
                                                    goTopagepush(
                                                        context,
                                                        CelebrityHome(
                                                          pageUrl: snapshot
                                                              .data!
                                                              .data!
                                                              .celebrities![
                                                                  itemPosition]
                                                              .pageUrl!,
                                                        ));
                                                  },
                                                  child: Card(
                                                    elevation: 2,
                                                    child: Container(
                                                        decoration: decoration(
                                                            snapshot
                                                                .data!
                                                                .data!
                                                                .celebrities![
                                                                    itemPosition]
                                                                .image!),
                                                        child: Stack(
                                                          children: [
// image------------------------------------------------------------------------------
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    10.r),
                                                              ),
                                                              child:
                                                                  Image.network(
                                                                snapshot
                                                                    .data!
                                                                    .data!
                                                                    .celebrities![
                                                                        itemPosition]
                                                                    .image!,
                                                                color: black
                                                                    .withOpacity(
                                                                        0.4),
                                                                colorBlendMode:
                                                                    BlendMode
                                                                        .darken,
                                                                fit: BoxFit
                                                                    .cover,
                                                                height: double
                                                                    .infinity,
                                                                width: double
                                                                    .infinity,
                                                                loadingBuilder:
                                                                    (context,
                                                                        child,
                                                                        loadingProgress) {
                                                                  if (loadingProgress ==
                                                                      null) {
                                                                    return child;
                                                                  }
                                                                  return Center(
                                                                      child: Lottie.asset(
                                                                          'assets/lottie/grey.json',
                                                                          height: 70
                                                                              .h,
                                                                          width:
                                                                              70.w));
                                                                },
                                                                errorBuilder: (BuildContext
                                                                        context,
                                                                    Object
                                                                        exception,
                                                                    StackTrace?
                                                                        stackTrace) {
                                                                  return Center(
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Icon(
                                                                          error,
                                                                          size:
                                                                              40.r,
                                                                          color:
                                                                              red,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment: Alignment
                                                                  .bottomRight,
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(10.0
                                                                            .w),
                                                                child: text(
                                                                    context,
                                                                    snapshot.data!.data!.celebrities![itemPosition].name ==
                                                                            ''
                                                                        ? "name"
                                                                        : snapshot
                                                                            .data!
                                                                            .data!
                                                                            .celebrities![
                                                                                itemPosition]
                                                                            .name!,
                                                                    18,
                                                                    white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                  )
                                                  //:Container(color: Colors.green,),
                                                  ),
                                            );
//if found more celebraty---------------------------------------------------------------------
                                          } else {
                                            //  lode mor data if pag mor than 2
                                            return snapshot.data!.data!
                                                        .pageCount! >
                                                    1
                                                ? SizedBox(
                                                    width: 150.w,
                                                    child: InkWell(
                                                      onTap: () {
                                                        goTopagepush(
                                                            context,
                                                            ShowMoreCelebraty(
                                                              title,
                                                              categoryId,
                                                            ));
                                                      },
                                                      child: Card(
                                                        color:
                                                            Colors.transparent,
                                                        elevation: 0,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          side:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .grey,
                                                                  width: 1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.r),
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const Spacer(),
                                                            //Icon More---------------------------------------------------------------------------

                                                            Center(
                                                              child:
                                                                  CircleAvatar(
                                                                child: Center(
                                                                  child: Icon(
                                                                    Icons
                                                                        .arrow_forward_ios,
                                                                    color:
                                                                        white,
                                                                    size: 30.r,
                                                                  ),
                                                                ),
                                                                radius: 30.r,
                                                                backgroundColor:
                                                                    purple
                                                                        .withOpacity(
                                                                            0.3),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 15.h,
                                                            ),

                                                            //lode more text----------------------
                                                            text(
                                                                context,
                                                                '?????? ????????',
                                                                14,
                                                                black
                                                                    .withOpacity(
                                                                        0.8),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            SizedBox(
                                                              height: 15.h,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox();
                                          }
                                        }),
                                  ),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                              ],
                            )),
                          ))
                      : const SizedBox();
                } else {
                  return const Center(
                      child: Center(child: Text('???????????? ???????????? ???????????? ??????????')));
                }
              } else {
                return Center(
                    child: Text('State: ${snapshot.connectionState}'));
              }
            }))
        : const SizedBox();
  }
//headerSection---------------------------------------------------------------------------

  headerSection(int? active) {
    List<String> image = [];
    return active == 1
        ? FutureBuilder(
            future: futureHeader,
            builder: ((context, AsyncSnapshot<header> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return waitingData(310, double.infinity);
              } else if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  if (snapshot.error.toString() == '???????? ???? ???????????? ??????????????????') {
                    return const Center(
                        child: Text('???????? ???? ???????????? ??????????????????'));
                  } else {
                    return const Center(child: Text(''));
                  }
                  //---------------------------------------------------------------------------
                } else if (snapshot.hasData) {
                  for (int headerIndex = 0;
                      headerIndex < snapshot.data!.data!.header!.length;
                      headerIndex++) {
                    image.add(
                        snapshot.data!.data!.header![headerIndex].imageMobile!);
                  }

                  return Column(
                    children: [
                      SizedBox(
                          height: 310.h,
                          width: double.infinity,
                          child: Stack(
                            children: [
//slider image----------------------------------------------------
                              imageSlider(image),
//icon+ logo------------------------------------------------------
                            ],
                          )),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  );
                } else {
                  return const Center(
                      child: Text('???????????? ???????????? ???????????? ??????????'));
                }
              } else {
                return Center(
                    child: Text('State: ${snapshot.connectionState}'));
              }
            }))
        : const SizedBox();
  }
//linksSection---------------------------------------------------------------------------

  linksSection(int? active) {
    return active == 1
        ? FutureBuilder(
            future: futureLinks,
            builder: ((context, AsyncSnapshot<link> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: EdgeInsets.only(top: 10.h, right: 5.w, left: 5.w),
                  child: SizedBox(
                    height: 70.h,
                    child: Shimmer(
                        enabled: true,
                        gradient: LinearGradient(
                          tileMode: TileMode.mirror,
                          colors: [mainGrey, Colors.white],
                          stops: const [0.1, 0.88],
                        ),
                        child: shapeRow(70)),
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  if (snapshot.error.toString() == '???????? ???? ???????????? ??????????????????') {
                    return const Center(child: Text(''));
                  } else {
                    return const Center(child: Text(''));
                  }
                  //---------------------------------------------------------------------------
                } else if (snapshot.hasData) {
                  return Column(
                    children: [
                      SizedBox(
                          height: 70.h,
                          width: MediaQuery.of(context).size.width / 1.02,
                          child: drowButtom(snapshot.data?.data?.links,
                              snapshot.data!.data!.links!.length)),
                      SizedBox(
                        height: 30.h,
                      ),
                    ],
                  );
                } else {
                  return const Center(
                      // child: Text('???????????? ???????? ???????????? ??????????')
                      );
                }
              } else {
                return Center(
                    child: Text('State: ${snapshot.connectionState}'));
              }
            }))
        : const SizedBox();
  }
//advertisingBannerSection---------------------------------------------------------------------------

  advertisingBannerSection(int? active, String? imageUrl, String? link) {
    return active == 1
        ? Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0.h, horizontal: 5.w),
            child: InkWell(
              onTap: () async {
                var url = link;
                await launch(url!, forceWebView: true);
              },
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(4.r),
                    ),
                    color: white,
                  ),
                  width: double.infinity,
                  height: 196.h,
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4.r),
                      ),
                      child: Image.network(
                        imageUrl!,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return waitingData(196, double.infinity);
                        },
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return Center(
                            child: Icon(
                              error,
                              size: 40.r,
                              color: red!,
                            ),
                          );
                        },
                        fit: BoxFit.fill,
                      ))),
            ),
          )
        : const SizedBox();
  }
//joinUsSection---------------------------------------------------------------------------

  joinUsSection(int? active) {
    return active != 1
        ? Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: [
                SizedBox(
                    width: double.infinity,
                    height: 226.5.h,
                    child: Padding(
                      padding: EdgeInsets.only(left: 13.0.w, right: 13.0.w),
                      child: Row(
                        children: [
                          Expanded(
                              child: jouinFaums("???????? ???????? ????????",
                                  "?????? ?????????? ????????\n?????? ?????? ??????", "???????? ????????")),
                          SizedBox(
                            width: 32.w,
                          ),
                          Expanded(
                              child: jouinFaums(
                                  "???????? ???????? ??????????????",
                                  "?????? ?????????? ????????\n?????? ?????? ??????",
                                  "???????? ??????????????")),
                        ],
                      ),
                    )),
                SizedBox(
                  height: 24.h,
                ),
              ],
            ))
        : const SizedBox();
  }
//partnersSection---------------------------------------------------------------------------

  partnersSection(int? active) {
    return active == 1
        ? FutureBuilder(
            future: futurePartners,
            builder: ((context, AsyncSnapshot<Partner> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return linkShap(90, width: 175);
              } else if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  if (snapshot.error.toString() == '???????? ???? ???????????? ??????????????????') {
                    return const Center(child: Text(''));
                  } else {
                    return const Center(child: Text(''));
                  }
//---------------------------------------------------------------------------
                } else if (snapshot.hasData) {
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 5.w, left: 5.w),
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: text(context, "???????????? ????????????????", 18, black,
                                fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: SizedBox(
                            width: double.infinity,
                            height: 90.h,
                            child: ListView.builder(
                                itemCount:
                                    snapshot.data!.data!.partners!.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, i) {
                                  return sponsors(
                                      snapshot.data!.data!.partners![i].image!,
                                      snapshot.data!.data!.partners![i].link!,
                                      i);
                                })),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  );
                } else {
                  return const Center(
                      child: Text('???????????? ???????? ?????????? ???????????? ??????????'));
                }
              } else {
                return Center(
                    child: Text('State: ${snapshot.connectionState}'));
              }
            }))
        : const SizedBox();
  }

//new section----------------------------------------------------------------------
  newsSection(int? active, String? imageUrl, String? link) {
    return active == 1
        ? imageUrl == ''
            ? const SizedBox()
            : Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 10.0.h, horizontal: 5.w),
                child: InkWell(
                  onTap: () async {
                    var url = link;
                    await launch(url!, forceWebView: true);
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4.r),
                        ),
                        color: white,
                      ),
                      width: double.infinity,
                      height: 196.h,
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4.r),
                          ),
                          child: Image.network(
                            imageUrl!,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return waitingData(196, double.infinity);
                            },
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return Icon(
                                error,
                                size: 40.r,
                                color: red!,
                              );
                            },
                            fit: BoxFit.cover,
                          ))),
                ),
              )
        : const SizedBox();
  }

//new section----------------------------------------------------------------------
  newSection(int? active, String? imageUrl, String? link) {
    return active == 1
        ? imageUrl == ''
            ? const SizedBox()
            : Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 10.0.h, horizontal: 5.w),
                child: InkWell(
                  onTap: () async {
                    var url = link;
                    await launch(url!, forceWebView: true);
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4.r),
                        ),
                        color: white,
                      ),
                      width: double.infinity,
                      height: 196.h,
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4.r),
                          ),
                          child: Image.network(
                            imageUrl!,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return waitingData(196, double.infinity);
                            },
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return Center(
                                child: Icon(
                                  error,
                                  size: 40.r,
                                  color: red!,
                                ),
                              );
                            },
                            fit: BoxFit.cover,
                          ))),
                ),
              )
        : const SizedBox();
  }

//loading methode---------------------------------------------------------------------------
  Widget lodeing() {
    return SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Shimmer(
            enabled: true,
            gradient: LinearGradient(
              tileMode: TileMode.mirror,
              colors: [mainGrey, Colors.white],
              stops: const [0.1, 0.88],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                waitingData(360, double.infinity),
                //SizedBox(height: 5.h),
                Padding(
                  padding: EdgeInsets.only(top: 10.h, right: 5.w, left: 5.w),
                  child: SizedBox(
                    height: 70.h,
                    child: Shimmer(
                        enabled: true,
                        gradient: LinearGradient(
                          tileMode: TileMode.mirror,
                          colors: [mainGrey, Colors.white],
                          stops: const [0.1, 0.88],
                        ),
                        child: shapeRow(70)),
                  ),
                ),
                SizedBox(height: 30.h),
                linkShap(180.0),
                SizedBox(height: 10.h),
                // linkShap(180.0),
                // SizedBox(height: 10.h),
                // linkShap(196.0),
              ],
            )));
  }

//-------------------------------------------------------------------------------------

  shapeRow(double j, {double width = 354}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5.r))),
            width: width.w,
            height: j.h,
          ),
        ),
        SizedBox(
          width: 10.w,
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5.r))),
            width: 354.w,
            height: j.h,
          ),
        ),
        SizedBox(
          width: 10.w,
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5.r))),
            width: 354.w,
            height: j.h,
          ),
        )
      ],
    );
  }

  linkShap(double height, {double width = 354}) {
    return Padding(
      padding: EdgeInsets.all(10.h),
      child: SizedBox(
        height: height.h,
        child: Shimmer(
            enabled: true,
            gradient: LinearGradient(
              tileMode: TileMode.mirror,
              colors: [mainGrey, Colors.white],
              stops: const [0.1, 0.88],
            ),
            child: shapeRow(height, width: width)),
      ),
    );
  }

  Future onRefresh() async {
    setState(() {
      sections = getSectionsData();
      futureLinks = fetchLinks();
      futureHeader = fetchHeader();
      futurePartners = fetchPartners();
      getAllCelebrity();
    });
  }

  Widget search() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: SizedBox(
          height: 70.h,
          // color: red,
          //margin: EdgeInsets.only(top: 15.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 4,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                      height: 105.h,
                      width: 190.w,
                      child: const Image(
                        image: AssetImage(
                          "assets/image/final-logo.png",
                        ),
                        fit: BoxFit.cover,
                      )),
                ),
              ),
              SizedBox(
                width: 5.w,
              ),

              currentuser == 'user'
                  ? Expanded(
                      flex: 1,
                      child: InkWell(
                        child: GradientIcon(Icons.add, 40, gradient()),
                        onTap: () {
                          goTopagepush(context, buildAdvOrder());
                        },
                      ))
                  : const SizedBox(),
              InkWell(
                child: GradientIcon(Icons.search, 35.sp, gradient()),
                onTap: () {
                  endLode ? _showSearch() : print('loding');
                },
              ),
              //
            ],
          ),
        ),
      ),
    );
  }

  //--------------------------------------------------------
  getAllCelebrity() async {
    try {
      var getSections = await http
          .get(Uri.parse("https://mobile.celebrityads.net/api/celebrities"));
      if (getSections.statusCode == 200) {
        final body = getSections.body;
        AllCelebrities celebrity = AllCelebrities.fromJson(jsonDecode(body));
        setState(() {
          endLode = true;
        });
        return celebrity.data!.celebrities;
      } else {
        return Future.error('serverExceptions');
      }
    } catch (e) {
      if (e is SocketException) {
        isConnectSection = false;
        return Future.error('SocketException');
      } else if (e is TimeoutException) {
        timeoutException = false;
        return Future.error('TimeoutException');
      } else {
        serverExceptions = false;
        return Future.error('serverExceptions');
      }
    }
  }

  //get Recent Searches Celebrity--------------------------------------------------------

}
