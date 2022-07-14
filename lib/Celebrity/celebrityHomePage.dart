import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:card_swiper/card_swiper.dart';
import 'package:celepraty/Account/Singup.dart';
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

  int currentIndex = 0;
  bool isConnectSection = true;
  DatabaseHelper h = DatabaseHelper();
  Future<Section>? sections;
  Future<link>? futureLinks;
  Future<header>? futureHeader;
  Future<Partner>? futurePartners;
  bool isLoading = true;
  int page = 1;
  @override
  void initState() {
    sections = getSectionsData();
    futureLinks = fetchLinks();
    futureHeader = fetchHeader();
    futurePartners = fetchPartners();

    super.initState();
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
        return Future.error('حدثت مشكله في السيرفر');
      }
    } catch (e) {
      if (e is SocketException) {
        setState(() {
          isConnectSection = false;
        });
        return Future.error('تحقق من اتصالك بالانترنت');
      } else if (e is TimeoutException) {
        return Future.error('TimeoutException');
      } else {
        return Future.error('حدثت مشكله في السيرفر');
      }
    }
  }

//---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return isConnectSection == false
        ? internetConnection(context, reload: () {
            setState(() {
              onRefresh();
              isConnectSection = true;
            });
          })
        : Directionality(
            textDirection: TextDirection.rtl,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(primaryColor: purple),
              home: Scaffold(
                  // appBar: homePageAppBar('', context,
                  //     action: [
                  //       Row(
                  //         children: [
                  //           SizedBox(width: 20.w,),
                  //           SizedBox(
                  //               height: 105.h,
                  //               width: 190.w,
                  //               child: const Image(
                  //                 image: AssetImage(
                  //                   "assets/image/final-logo.png",
                  //                 ),
                  //                 fit: BoxFit.cover,
                  //               )),
                  //           Container(
                  //             width: 190.w,
                  //             decoration: BoxDecoration(
                  //               // color: red,
                  //               borderRadius:
                  //                   BorderRadius.all(Radius.circular(5.r)),
                  //               border: Border.all(
                  //                   color: Colors.grey.withOpacity(0.3),
                  //                   width: 1),
                  //             ),
                  //             child: Row(
                  //               children: [
                  //                 SizedBox(
                  //                   width: 5.w,
                  //                 ),
                  //                 const Icon(
                  //                   Icons.search,
                  //                   color: Colors.grey,
                  //                 ),
                  //                 SizedBox(
                  //                   width: 5.w,
                  //                 ),
                  //                 text(context, 'مالذي تبحث عنه؟', 12,
                  //                     Colors.grey)
                  //               ],
                  //             ),
                  //           ),
                  //
                  //         ],
                  //       )
                  //     ],
                  //     leading: IconButton(
                  //       padding: EdgeInsets.only(right: 20.w),
                  //       icon: const Icon(Icons.add),
                  //       color: Colors.black,
                  //       onPressed: () {
                  //         Navigator.pop(context);
                  //       },
                  //     )),

//-------------------------------------------------------------------------------------
                  body: RefreshIndicator(
                    onRefresh: onRefresh,
                    child: SingleChildScrollView(
                      child: Padding(
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
                                //throw snapshot.error.toString();
                                if (snapshot.error.toString() ==
                                    'تحقق من اتصالك بالانترنت') {
                                  return Center(
                                      child: SizedBox(
                                          height: 200.h,
                                          width: 200.w,
                                          child: internetConnection(context)));
                                } else {
                                  return const Center(child: Text(''));
                                }
                                //---------------------------------------------------------------------------
                              } else if (snapshot.hasData) {
                                return Column(
                                  children: [
                                    for (int sectionIndex = 0;
                                        sectionIndex <
                                            snapshot.data!.data!.length;
                                        sectionIndex++)
                                      Column(
                                        children: [
//category--------------------------------------------------------------------------

                                          if (snapshot.data!.data![sectionIndex]
                                                  .sectionName ==
                                              'category')
                                            categorySection(
                                                snapshot
                                                    .data
                                                    ?.data![sectionIndex]
                                                    .categoryId,
                                                snapshot.data
                                                    ?.data![sectionIndex].title,
                                                snapshot
                                                    .data
                                                    ?.data![sectionIndex]
                                                    .active),

//header--------------------------------------------------------------------------
                                          if (snapshot.data!.data![sectionIndex]
                                                  .sectionName ==
                                              'header')
                                            headerSection(snapshot.data
                                                ?.data![sectionIndex].active),
//links--------------------------------------------------------------------------
                                          if (snapshot.data!.data![sectionIndex]
                                                  .sectionName ==
                                              'links')
                                            linksSection(snapshot.data
                                                ?.data![sectionIndex].active),
//Advertising-banner--------------------------------------------------------------------------
                                          if (snapshot.data!.data![sectionIndex]
                                                  .sectionName ==
                                              'Advertising-banner')
                                            advertisingBannerSection(snapshot
                                                .data
                                                ?.data![sectionIndex]
                                                .active),
//join-us--------------------------------------------------------------------------
                                          if (snapshot.data!.data![sectionIndex]
                                                  .sectionName ==
                                              'join-us')
                                            joinUsSection(snapshot.data
                                                ?.data![sectionIndex].active),
//new_section---------------------------------------------------------------------------
                                          if (snapshot.data!.data![sectionIndex]
                                                  .sectionName ==
                                              'new_section')
                                            newSection(
                                                snapshot.data
                                                    ?.data![sectionIndex].link,
                                                snapshot.data
                                                    ?.data![sectionIndex].image,
                                                snapshot
                                                    .data
                                                    ?.data![sectionIndex]
                                                    .active),
//news ---------------------------------------------------------------------------
                                          if (snapshot.data!.data![sectionIndex]
                                                  .sectionName ==
                                              'news')
                                            newsSection(
                                                snapshot.data
                                                    ?.data![sectionIndex].link,
                                                snapshot.data
                                                    ?.data![sectionIndex].image,
                                                snapshot
                                                    .data
                                                    ?.data![sectionIndex]
                                                    .active),
//partners--------------------------------------------------------------------------
                                          if (snapshot.data!.data![sectionIndex]
                                                  .sectionName ==
                                              'partners')
                                            partnersSection(snapshot.data
                                                ?.data![sectionIndex].active),
                                        ],
                                      )
                                  ],
                                );
                              } else {
                                return const Center(child: Text('Empty data'));
                              }
                            } else {
                              return Center(
                                  child: Text(
                                      'State: ${snapshot.connectionState}'));
                            }
                          },
                        ),
                      ),
                    ),
                  )),
            ),
          );
  }

//"${snapshot.data.data.header[1].title}",------------------------------Slider image-------------------------------------------
  Widget imageSlider(List image) {
    return Swiper(
      itemBuilder: (context, index) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              //color: red,
              image: DecorationImage(
            image: NetworkImage(
              image[index],
            ),
            fit: BoxFit.cover,
          )),
        );
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
    );
  }

//+ icon + logo ------------------------------------------------------------
  Widget heroLogo() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //mainAxisSize: MainAxisSize.min,
        children: [
          currentuser == 'user'
              ? Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  child: SizedBox(
                      height: 60.h,
                      width: 60.w,
                      child: InkWell(
                        child: GradientIcon(Icons.add, 40, gradient()),
                        onTap: () {
                          goTopagepush(context, buildAdvOrder());
                        },
                      )),
                )
              : const SizedBox(),
          const Spacer(),
          // Padding(
          //   padding: EdgeInsets.only(top: 10.h, right: 10.w, left: 10.w),
          //   child: SizedBox(
          //       height: 105.h,
          //       width: 190.w,
          //       child: const Image(
          //         image: AssetImage(
          //           "assets/image/final-logo.png",
          //         ),
          //         fit: BoxFit.cover,
          //       )),
          // ),
        ]);
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
        child: Container(
      decoration: BoxDecoration(
          //color: red,
          image: DecorationImage(image: NetworkImage(image), fit: BoxFit.fill)),
      width: 105.w,
      child: InkWell(
        onTap: () async {
          var url = link;
          await launch(url.toString(), forceWebView: true);
        },
      ),
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
      child: Card(
        //color: blue,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(3.0.r),
          child: Image(
              fit: BoxFit.contain,
              image: NetworkImage(image),
              height: 26.h,
              width: 160.w),
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
                        text(context, "منصة المشاهير", 21, white,
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
                            child: text(context, "انضم الان", 17, black,
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
                return SizedBox(
                  height: 300.h,
                );
              } else if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  if (snapshot.error.toString() == 'تحقق من اتصالك بالانترنت') {
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
                                      left: 7.0.w,
                                      right: 7.0.w,
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
                                                                          Icons
                                                                              .sync_problem,
                                                                          size:
                                                                              25.r,
                                                                          color:
                                                                              pink,
                                                                        ),
                                                                        text(
                                                                          context,
                                                                          '  اضغط لاعادة تحميل الصورة',
                                                                          12,
                                                                          Colors
                                                                              .grey,
                                                                        )
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
                                                                'عرض الكل',
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
                      child: Center(child: Text('لايوجد مشاهير لعرضهم حاليا')));
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
                return const Center();
              } else if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  if (snapshot.error.toString() == 'تحقق من اتصالك بالانترنت') {
                    return const Center(child: Text(''));
                  } else {
                    return const Center(child: Text(''));
                  }
                  //---------------------------------------------------------------------------
                } else if (snapshot.hasData) {
                  for (int headerIndex = 0;
                      headerIndex < snapshot.data!.data!.header!.length;
                      headerIndex++) {
                    image.add(snapshot.data!.data!.header![headerIndex].image!);
                  }

                  return Column(
                    children: [
                      SizedBox(
                          height: 350.h,
                          width: double.infinity,
                          child: Stack(
                            children: [
//slider image----------------------------------------------------
                              imageSlider(image),
//icon+ logo------------------------------------------------------
                              heroLogo()
                            ],
                          )),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  );
                } else {
                  return const Center(
                      child: Text('لايوجد سلايدر لعرضهم حاليا'));
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
                return const Center();
              } else if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  if (snapshot.error.toString() == 'تحقق من اتصالك بالانترنت') {
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
                      // child: Text('لايوجد لينك لعرضهم حاليا')
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

  advertisingBannerSection(int? active) {
    return active == 1
        ? Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0.h, horizontal: 3.5.w),
            child: InkWell(
              onTap: () async {
                var url = 'https://www.faz.education/';
                await launch(url, forceWebView: true);
              },
              child: SizedBox(
                  width: double.infinity,
                  height: 196.h,
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4.r),
                      ),
                      child: Image.asset(
                        'assets/image/Famous.jpg',
                        fit: BoxFit.cover,
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
                              child: jouinFaums("انضم الان كنجم",
                                  "اضم الينا الان\nوكن جزء منا", "انضم كنجم")),
                          SizedBox(
                            width: 32.w,
                          ),
                          Expanded(
                              child: jouinFaums(
                                  "انضم الان كمستخدم",
                                  "اضم الينا الان\nوكن جزء منا",
                                  "انضم كمستخدم")),
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
                return const Center();
              } else if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  if (snapshot.error.toString() == 'تحقق من اتصالك بالانترنت') {
                    return const Center(child: Text(''));
                  } else {
                    return const Center(child: Text(''));
                  }
//---------------------------------------------------------------------------
                } else if (snapshot.hasData) {
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 8.w, left: 8.w),
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: text(context, "الرعاة الرسميين", 18, black,
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
                            child: Padding(
                              padding: EdgeInsets.only(left: 0.h, right: 0.h),
                              child: ListView.builder(
                                  itemCount:
                                      snapshot.data!.data!.partners!.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, i) {
                                    return sponsors(
                                        snapshot
                                            .data!.data!.partners![i].image!,
                                        snapshot.data!.data!.partners![i].link!,
                                        i);
                                  }),
                            )),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  );
                } else {
                  return const Center(
                      child: Text('لايوجد رعاة رسمين لعرضهم حاليا'));
                }
              } else {
                return Center(
                    child: Text('State: ${snapshot.connectionState}'));
              }
            }))
        : const SizedBox();
  }

//new section----------------------------------------------------------------------
  newsSection(String? link, String? image, int? active) {
    return active == 1
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 10.h),
            child: SizedBox(
              width: double.infinity,
              height: 150.h,
              child: InkWell(
                onTap: () async {
                  var url = 'https://www.faz.education/';
                  await launch(url, forceWebView: true);
                },
                child: gradientContainerNoborder(
                    double.infinity,
                    ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4.r),
                        ),
                        child: Image.asset(
                          'assets/image/news.jpg',
                          fit: BoxFit.cover,
                        )),
                    blurRadius: 1),
              ),
            ),
          )
        : const SizedBox();
  }

//new section----------------------------------------------------------------------
  newSection(String? link, String? image, int? active) {
    return active == 1
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 10.h),
            child: SizedBox(
              width: double.infinity,
              height: 150.h,
              child: InkWell(
                onTap: () async {
                  var url = link.toString();
                  await launch(url.toString(), forceWebView: true);
                },
                child: gradientContainerNoborder(
                    double.infinity,
                    ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4.r),
                        ),
                        child: Image.network(
                          image!,
                          fit: BoxFit.cover,
                        )),
                    blurRadius: 1),
              ),
            ),
          )
        : const SizedBox();
  }

//loading methode---------------------------------------------------------------------------
  Widget lodeing() {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Shimmer(
              gradient: LinearGradient(
                tileMode: TileMode.mirror,
                // begin: Alignment(0.7, 2.0),
                //end: Alignment(-0.69, -1.0),
                colors: [mainGrey, Colors.white],
                stops: const [0.1, 0.88],
              ),
              enabled: isLoading,
              child: ListView.builder(
                itemBuilder: (_, __) => Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    shape(360),
                    SizedBox(
                      height: 10.w,
                    ),
                    shapeRow(61),
                    SizedBox(height: 10.h),
                    shape(10, width: 90.w),
                    SizedBox(height: 10.h),
                    shapeRow(180),
                    SizedBox(height: 10.h),
                    shape(10, width: 90.w),
                    shapeRow(180),
                    SizedBox(height: 10.h),
                    shape(196),
                    SizedBox(height: 10.h),
                    shape(10, width: 90.w),
                    shapeRow(180),
                    SizedBox(height: 10.h),
                    shape(250),
                  ],
                ),
                itemCount: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

//-------------------------------------------------------------------------------------
  shape(int j, {double? width}) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(0.r))),
          width: width ?? double.infinity,
          height: j.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 2.0.h),
        ),
      ],
    );
  }

//-------------------------------------------------------------------------------------

  shapeRow(int j) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
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

  Future onRefresh() async {
    setState(() {
      sections = getSectionsData();
      futureLinks = fetchLinks();
      futureHeader = fetchHeader();
      futurePartners = fetchPartners();
    });
  }
}
