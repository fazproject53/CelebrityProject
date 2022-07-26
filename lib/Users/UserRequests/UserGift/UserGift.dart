import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../Account/LoggingSingUpAPI.dart';
import 'UserGiftApi.dart';
import 'UserGiftDetials.dart';

class UserGift extends StatefulWidget {
  const UserGift({Key? key}) : super(key: key);

  @override
  State<UserGift> createState() => _UserGiftState();
}

class _UserGiftState extends State<UserGift>
    with AutomaticKeepAliveClientMixin {
  String token = '';
  bool isConnectSection = true;
  bool timeoutException = true;
  bool serverExceptions = true;
  bool _isFirstLoadRunning = false;
  bool hasMore = true;
  bool isLoading = false;
  int page = 1;
  int pageCount = 2;
  bool empty = false;
  int? newItemLength;
  List<GiftOrders> oldAdvertisingOrder = [];
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    DatabaseHelper.getToken().then((value) {
      setState(() {
        token = value;
        getUserGift(token);
      });
    });
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
              scrollController.offset &&
          hasMore == false) {
        print('getNew Data');
        getUserGift(token);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: refreshRequest,
        child: isConnectSection == false
            ? Center(
                child: internetConnection(context, reload: () {
                  setState(() {
                    refreshRequest();
                    isConnectSection = true;
                  });
                }),
              )
            : timeoutException == false
                ? Center(
                    child: checkTimeOutException(context, reload: () {
                      setState(() {
                        refreshRequest();
                        timeoutException = true;
                      });
                    }),
                  )
                : serverExceptions == false
                    ? Center(
                        child: checkServerException(context, reload: () {
                          setState(() {
                            refreshRequest();
                            serverExceptions = true;
                          });
                        }),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:empty
                            ? noData(context)
                            : _isFirstLoadRunning == false && page == 1
                            ? firstLode(double.infinity, 160)
                            : ListView.builder(
                                controller: scrollController,
                                itemCount: oldAdvertisingOrder.length + 1,
                                itemBuilder: (context, i) {
                                  if (oldAdvertisingOrder.length > i) {
                                    return InkWell(
                                        onTap: () {
                                          goToPagePushRefresh(
                                              context,
                                              UserGiftDetials(
                                                i: i,
                                                price: oldAdvertisingOrder[i]
                                                    .price,
                                                description:
                                                    oldAdvertisingOrder[i]
                                                        .description,
                                                advTitle: oldAdvertisingOrder[i]
                                                    .occasion
                                                    ?.name,
                                                orderId:
                                                    oldAdvertisingOrder[i].id,
                                                celebrityName:
                                                    oldAdvertisingOrder[i]
                                                        .celebrity
                                                        ?.name!,
                                                celebrityId:
                                                    oldAdvertisingOrder[i]
                                                        .celebrity
                                                        ?.id!,
                                                celebrityImage:
                                                    oldAdvertisingOrder[i]
                                                        .celebrity
                                                        ?.image!,
                                                celebrityPagUrl:
                                                    oldAdvertisingOrder[i]
                                                        .celebrity
                                                        ?.pageUrl!,
                                                state: oldAdvertisingOrder[i]
                                                    .status
                                                    ?.id,
                                                rejectResonName:
                                                    oldAdvertisingOrder[i]
                                                        .rejectReson
                                                        ?.name!,
                                                rejectResonId:
                                                    oldAdvertisingOrder[i]
                                                        .rejectReson
                                                        ?.id,
                                                token: token,
                                                from: oldAdvertisingOrder[i]
                                                    .from!,
                                                to: oldAdvertisingOrder[i].to!,
                                                occasion: oldAdvertisingOrder[i]
                                                    .occasion
                                                    ?.name!,
                                              ), then: (value) {
                                            if (clickUserGift) {
                                              setState(() {
                                                refreshRequest();
                                                clickUserGift = false;
                                              });
                                            }
                                          });
                                        },
                                        child: Column(
                                          children: [
                                            getGiftOrder(
                                                i, oldAdvertisingOrder),
                                          ],
                                        ));
                                  } else {
                                    return isLoading &&
                                            pageCount >= page &&
                                            oldAdvertisingOrder.isNotEmpty
                                        ? lodeOneData()
                                        : const SizedBox();
                                  }
                                })));
  }

  Widget getGiftOrder(int i, List<GiftOrders>? giftOrders) {
    return container(
        160,
        double.infinity,
        18,
        18,
        Colors.white,
        Column(
          children: [
//image------------------------------------------------------------------------------------

            Expanded(
              flex: 2,
              child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.h)),
                  ),
//status-----------------------------------------------------------------------------------
                  child: Stack(
                    children: [
// image------------------------------------------------------------------------------
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10.h)),
                        child: Image.network(
                          giftOrders![i].occasion!.image!,
                          color: black.withOpacity(0.4),
                          colorBlendMode: BlendMode.darken,
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.sync_problem,
                                    size: 25.r,
                                    color: pink,
                                  ),
                                  text(
                                    context,
                                    '  اضغط لاعادة تحميل الصورة',
                                    12,
                                    Colors.grey,
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),

//status-----------------------------------------------------------------------------------
                      Padding(
                        padding: EdgeInsets.all(8.0.r),
                        child: Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                                padding: EdgeInsets.only(right: 10.w),
                                child: text(
                                  context,
                                  giftOrders[i].status!.name!,
                                  18,
                                  white,
                                  fontWeight: FontWeight.bold,
                                ))),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
// occasion name---------------------------------------------------------------------------------

                          Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      right: 16.w, bottom: 10.h),
                                  child: text(
                                    context,
                                    "اهداء ل" + giftOrders[i].occasion!.name!,
                                    18,
                                    white,
                                    fontWeight: FontWeight.bold,
                                  ))),
//date and icon---------------------------------------------------------------------------------
                          const Spacer(),
                          Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding:
                                    EdgeInsets.only(right: 16.w, bottom: 10.h),
                                child: text(
                                  context,
                                  giftOrders[i].date!,
                                  18,
                                  white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),

                          SizedBox(width: 10.w),
                        ],
                      )
                    ],
                  )),
            ),
          ],
        ),
        bottomLeft: 10,
        bottomRight: 10,
        topLeft: 10,
        topRight: 10,
        marginB: 15,
        blur: 5,
        marginT: 5);
  }

//get Advertising Orders------------------------------------------------------------------------
  getUserGift(String token) async {
    print('pageApi $pageCount pagNumber $page');
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
      _isFirstLoadRunning = false;
    });

    String url =
        "https://mobile.celebrityads.net/api/user/GiftOrders?page=$page";

    try {
      final respons = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });

      if (respons.statusCode == 200) {
        final body = respons.body;
        UserGiftOrds advertising = UserGiftOrds.fromJson(jsonDecode(body));
        var newItem = advertising.data!.giftOrders!;
        pageCount = advertising.data!.pageCount!;
        print('length ${newItem.length}');
        if (!mounted) return;
        setState(() {
          if (newItem.isNotEmpty) {
            hasMore = newItem.isEmpty;
            oldAdvertisingOrder.addAll(newItem);
            isLoading = false;
            newItemLength = newItem.length;
            _isFirstLoadRunning = true;
            page++;
          } else if (newItem.isEmpty && page == 1) {
            _isFirstLoadRunning = true;
            empty = true;
          }
        });
      }
    } catch (e) {
      if (e is SocketException) {
        setState(() {
          isConnectSection = false;
        });
      } else if (e is TimeoutException) {
        setState(() {
          timeoutException = false;
        });
      } else {
        setState(() {
          serverExceptions = false;
        });
      }
    }
  } //refreshRequest-----------------------------------------------------------------

  Future refreshRequest() async {
    setState(() {
      hasMore = true;
      isLoading = false;
      page = 1;
      oldAdvertisingOrder.clear();
    });
    getUserGift(token);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
