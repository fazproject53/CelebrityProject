import 'package:celepraty/Models/Methods/classes/GradientIcon.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:celepraty/Users/Exploer/viewData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'ExploerApi.dart';
import 'showViduo.dart';
import 'package:http/http.dart' as http;

class Explower extends StatefulWidget {
  const Explower({Key? key}) : super(key: key);

  @override
  State<Explower> createState() => _ExplowerState();
}

class _ExplowerState extends State<Explower> {
  bool isSelect = false;
  int liksCounter = 100;
  bool hasMore = true;
  bool isLoading = false;
  int page = 1;
  int pageCount = 2;
  bool empty = false;
  bool isConnectSection = true;
  bool timeoutException = true;
  bool serverExceptions = true;
  ScrollController scrollController = ScrollController();
  List<Explorer> oldCelebraty = [];
  VideoPlayerController? _controller;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      // _controller = VideoPlayerController.network(
      //     'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
      //   ..initialize().then((_) {
      //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      //     setState(() {});
      //   });
      fetchAnotherExplorer();
    });

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
              scrollController.offset &&
          hasMore == false) {
        // print('getNew Data');
        fetchAnotherExplorer();
      }
    });
  }

//refresh list------------------------------------------------------------------
  Future refresh() async {
    setState(() {
      hasMore = true;
      isLoading = false;
      page = 1;
      oldCelebraty.clear();
    });
    fetchAnotherExplorer();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: AppBarNoIcon("اكسبلور"),
          body: RefreshIndicator(
            onRefresh: refresh,
            child: isConnectSection == false
                ? Align(
                    alignment: Alignment.center,
                    child: internetConnection(context, reload: () {
                      setState(() {
                        refresh();
                        isConnectSection = true;
                      });
                    }),
                  )
                : timeoutException == false
                    ? Align(
                        alignment: Alignment.center,
                        child: checkTimeOutException(context, reload: () {
                          setState(() {
                            refresh();
                            timeoutException = true;
                          });
                        }),
                      )
                    : serverExceptions == false
                        ? Align(
                            alignment: Alignment.center,
                            child: checkServerException(context, reload: () {
                              setState(() {
                                refresh();
                                serverExceptions = true;
                              });
                            }),
                          )
                        : Padding(
                            padding: EdgeInsets.all(12.h),
                            child: empty
                                ? noData(context)
                                : Column(
                                    children: [
//icon and text-----------------------------------------------------
                                      Expanded(
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                            Expanded(
                                                flex: 1,
                                                child: text(
                                                    context,
                                                    "اكسبلور المشاهير",
                                                    18,
                                                    black)),
//filter----------------------------------------------
                                            //  Expanded(
                                            //   flex:1,
                                            //   child: gradientContainer(
                                            //     double.infinity,
                                            //     Row(
                                            //       children: [
                                            //         Expanded(
                                            //             flex:2,
                                            //             child: Padding(
                                            //               padding:  EdgeInsets.only(right:8.0,bottom: 2),
                                            //               child: text(context, "فرز حسب", 13, textBlack),
                                            //             )),
                                            //         Expanded(
                                            //
                                            //           child: Padding(
                                            //             padding:  EdgeInsets.only(left:8.0,bottom: 2),
                                            //             child: Icon(
                                            //               filter,
                                            //               size: 25.sp,
                                            //             ),
                                            //           ),
                                            //         )
                                            //       ],
                                            //     ),
                                            //     gradient: true,
                                            //     color: blue,
                                            //     height: 30,
                                            //   ),
                                            // )
                                          ])),
//view data-----------------------------------------------------

                                      Expanded(
                                          flex: 6,
                                          child: empty
                                              ? noData(context)
                                              : CustomScrollView(
                                                  controller: scrollController,
                                                  slivers: [
                                                    SliverGrid(
                                                        gridDelegate:
                                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                                crossAxisCount:
                                                                    2, //عدد العناصر في كل صف
                                                                crossAxisSpacing: 13
                                                                    .h, // المسافات الراسية
                                                                childAspectRatio:
                                                                    0.70, //حجم العناصر
                                                                mainAxisSpacing: 13
                                                                    .w //المسافات الافقية

                                                                ),
                                                        delegate:
                                                            SliverChildBuilderDelegate(
                                                          (BuildContext context,
                                                              int index) {
                                                            return viewCard(
                                                                oldCelebraty,
                                                                index);
                                                          },
                                                          childCount:
                                                              oldCelebraty
                                                                  .length,
                                                        )),

//show loading when get data from api--------------------------------------------------------------------------------------------
                                                    SliverList(
                                                        delegate:
                                                            SliverChildBuilderDelegate(
                                                      (BuildContext context,
                                                          int index) {
                                                        return isLoading &&
                                                                pageCount >=
                                                                    page &&
                                                                oldCelebraty
                                                                    .isNotEmpty
                                                            ? showLode()
                                                            : const SizedBox();
                                                      },
                                                      childCount: 1,
                                                    )),
                                                  ],
                                                ))
                                    ],
                                  )),
          )),
    );
  }

//----------------view data method-------------------------------------------------------------------------------
  Widget viewCard(List<Explorer> oldCelebraty, int index) {
    return InkWell(
      onTap: () {
        goTopagepush(
            context,
            ShowVideo(
                videoURL: oldCelebraty[index].image!,
                videoLikes: oldCelebraty[index].likes!));
      },
      child: Card(
          elevation: 10,
          //color: black,
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              //color: black,
              borderRadius: BorderRadius.all(Radius.circular(4.r)),
              // image: DecorationImage(
              //   image: AssetImage(
              //     videoImage,
              //   ),
              //   fit: BoxFit.cover,
              // )
            ),
            child: _controller!=null&& _controller!.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  )
                : const Center(child: CircularProgressIndicator()),

            // VideoPlayer(
            //
            //     VideoPlayerController.network(
            //
            //       oldCelebraty[index].image!,)
            //   ..initialize()),

//             Column(
//               children: [
// //صوره المشهور+الاسم+التصنيف------------------------------------------
// //               Expanded(
// //                 flex: 2,
// //                 child: Align(
// //                     alignment: Alignment.topRight,
// //                     child: ListTile(
// //                       title: text(context, "ليجسي ليجسي", 15, white),
// //                       subtitle: text(context, "مطرب", 12, white),
// //                     )),
// //               ),
// //play viduo--------------------------------------------------------
//
//                 // Expanded(
//                 //   flex: 1,
//                 //   child: Align(
//                 //     alignment: Alignment.center,
//                 //     child: CircleAvatar(
//                 //       backgroundColor: white.withOpacity(0.12),
//                 //       radius: 25.h,
//                 //       child: IconButton(
//                 //           onPressed: () {
//                 //           setState(() {
//                 //             goTopagepush(context, viewData());});
//                 //           },
//                 //           icon: GradientIcon(playViduo, 35.sp, gradient())),
//                 //     ),
//                 //   ),
//                 // ),
//
// //like icon------------------------------------------
// //                 Expanded(
// //                   child: Padding(
// //                     padding: EdgeInsets.only(left: 10.r, right: 10.r),
// //                     child: Align(
// //                       alignment: Alignment.bottomLeft,
// //                       child: CircleAvatar(
// //                         backgroundColor: white.withOpacity(0.0),
// //                         radius: 20.h,
// //                         child: IconButton(
// //                            onPressed: () {
// //                           //   setState(() {
// //                           //     isSelect = !isSelect;
// //                           //   });
// //                           //   if (isSelect) {
// //                           //     setState(() {
// //                           //       liksCounter++;
// //                           //     });
// //                           //   }
// //                            },
// //                           icon: GradientIcon(Icons.visibility, 27.sp, gradient()),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //share----------------------------------------------------------------------
// //               Padding(
// //                 padding: EdgeInsets.only(left: 10.r, right: 10.r),
// //                 child: Align(
// //                   alignment: Alignment.bottomLeft,
// //                   child: CircleAvatar(
// //                     backgroundColor: white.withOpacity(0.0),
// //                     radius: 20.h,
// //                     child: IconButton(
// //                       onPressed: () {
// //                         setState(() {
// //                           isSelect = !isSelect;
// //                         });
// //                         if (isSelect) {
// //                           setState(() {
// //                             liksCounter++;
// //                           });
// //                         }
// //                       },
// //                       icon: GradientIcon(
// //                           isSelect ? like : disLike, 27.sp, gradient()),
// //                     ),
// //                   ),
// //                 ),
// //               ),
//
// //conuter of like number------------------------------------------
//                 Expanded(
//                   child: Directionality(
//                     textDirection: TextDirection.ltr,
//                     child: Align(
//                       alignment: Alignment.bottomLeft,
//                       child: Row(
//                         children: [
//                           IconButton(
//                             onPressed: () {
//                               //   setState(() {
//                               //     isSelect = !isSelect;
//                               //   });
//                               //   if (isSelect) {
//                               //     setState(() {
//                               //       liksCounter++;
//                               //     });
//                               //   }
//                             },
//                             icon: GradientIcon(
//                                 Icons.play_arrow, 35.sp, gradient()),
//                           ),
//                           text(context, "${oldCelebraty[index].views}", 15,
//                               white,
//                               fontWeight: FontWeight.bold),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
          )),
    );
  }

  //pagination---------------------------------------------------------------------------------
  fetchAnotherExplorer() async {
    // try {
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
    });

    print('pageApi $pageCount pagNumber $page');
    if (page == 1) {
      loadingRequestDialogue(context);
    }
    try {
      final response = await http.get(
          Uri.parse('https://mobile.celebrityads.net/api/explorer?page=$page'));
      if (response.statusCode == 200) {
        final body = response.body;
        TrendExplorer explorer = TrendExplorer.fromJson(jsonDecode(body));
        var newItem = explorer.data!.explorer!;
        pageCount = explorer.data!.pageCount!;
        print('length ${newItem.length}');
        if (!mounted) return;
        setState(() {
          if (newItem.isNotEmpty) {
            hasMore = newItem.isEmpty;
            oldCelebraty.addAll(newItem);
            isLoading = false;
            if (page == 1) {
              Navigator.pop(context);
            }
            page++;
          } else if (newItem.isEmpty && page == 1) {
            if (page == 1) {
              Navigator.pop(context);
            }
            setState(() {
              empty = true;
            });
          }
        });
        print(body);
        return explorer;
      } else {
        setState(() {
          serverExceptions = false;
        });
        return 'serverExceptions';
      }
    } catch (e) {
      if (e is SocketException) {
        Navigator.pop(context);
        setState(() {
          isConnectSection = false;
        });
        return 'SocketException';
      } else if (e is TimeoutException) {
        Navigator.pop(context);
        setState(() {
          timeoutException = false;
        });
        return 'TimeoutException';
      } else {
        Navigator.pop(context);

        setState(() {
          serverExceptions = false;
        });
        return 'serverExceptions';
      }
    }
  }

  Widget showLode() {
    return Padding(
      padding: EdgeInsets.only(top: 13.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 190.w,
            height: 200.h,
            child: Shimmer(
                enabled: true,
                gradient: LinearGradient(
                  tileMode: TileMode.mirror,
                  // begin: Alignment(0.7, 2.0),
                  //end: Alignment(-0.69, -1.0),
                  colors: [mainGrey, Colors.white],
                  stops: const [0.1, 0.88],
                ),
                child: Card()),
          ),
          SizedBox(
            width: 190.w,
            height: 200.h,
            child: Shimmer(
                enabled: true,
                gradient: LinearGradient(
                  tileMode: TileMode.mirror,
                  // begin: Alignment(0.7, 2.0),
                  //end: Alignment(-0.69, -1.0),
                  colors: [mainGrey, Colors.white],
                  stops: const [0.1, 0.88],
                ),
                child: const Card()),
          ),
        ],
      ),
    );
  }
}
