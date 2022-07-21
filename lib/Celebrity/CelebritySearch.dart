import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

import '../ModelAPI/ModelsAPI.dart';
import 'HomeScreen/celebrity_home_page.dart';

typedef OnSearchChanged = Future<List<String>> Function(String);

class CelebritySearch extends SearchDelegate {
  // onSubmitted: (String _) {
  //   widget.delegate.showResults(context);
  // },
  List<getAllCelebrities> _oldFilters = [];
  final List<getAllCelebrities> allCelbrity;
  List<getAllCelebrities>? listSearch;
  String? pagIndex;

  final OnSearchChanged onSearchChanged;

  CelebritySearch({required this.allCelbrity, required this.onSearchChanged})
      : super(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
        );

  // CelebritySearch(
  //   this.allCelbrity, this.onSearchChanged, {
  //   String hintText = "البحث عن مشهور",
  // }) : super(
  //         keyboardType: TextInputType.text,
  //         textInputAction: TextInputAction.search,
  //         // searchFieldDecorationTheme:
  //       );
  // CelebritySearch(this.list);

  @override
  List<Widget>? buildActions(BuildContext context) {
    // Action of app bar
    return [
      IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (query.isEmpty) {
              Navigator.pop(context);
            } else {
              query = "";
              showSuggestions(context);
            }
          })
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // الايقون الموجودة قبل المربع النصي
    return IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    saveToRecentSearchesCelebrity(query);
    List<getAllCelebrities> _results;
    _results = allCelbrity.where((getAllCelebrities name) {
      final nameLower = name.name!.toLowerCase();
      final queryLower = query.toLowerCase();
      return queryLower.compareTo(nameLower) == 0;
    }).toList();
    print(_results.length);
    return _results.length == 0
        ? Center(
            child: text(context, "لاتوجد نتائج عن البحث", 14, Colors.grey),
          )
        : Text('');
  }

  @override
  void showResults(BuildContext context) {
    List<getAllCelebrities> _results;
    _results = allCelbrity.where((getAllCelebrities name) {
      final nameLower = name.name!.toLowerCase();
      final queryLower = query.toLowerCase();
      return queryLower.compareTo(nameLower) == 0;
    }).toList();
    if (_results.length == 0) {
      Center(
        child: text(context, "لاتوجد نتائج عن البحث", 14, Colors.grey),
      );
    } else {
      showSuggestions(context);
      goTopagepush(
          context,
          CelebrityHome(
            pageUrl: '$pagIndex',
          ));
    }
    super.showResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    listSearch = query.isEmpty
        ? //allCelbrity
        //_oldFilters
        []
        : allCelbrity.where((getAllCelebrities name) {
            // print('name ${name.name}');
            final nameLower = name.name!.toLowerCase();
            final queryLower = query.toLowerCase();
            // print('nameLower  ${nameLower}');
            // print('queryLower ${queryLower}');
            return nameLower.startsWith(queryLower);
          }).toList();
    return buildSuggetion(listSearch!);
  }

  Widget buildSuggetion(List<getAllCelebrities> suggestions) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          // suggestions.isEmpty
          //     ? Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Padding(
          //       padding: EdgeInsets.only(right: 22.w, top: 15.h),
          //       child: Align(
          //           alignment: Alignment.topRight,
          //           child: Text(
          //             "عمليات البحث الأخيرة",
          //             style: TextStyle(
          //                 fontSize: 17.sp,
          //                 color: black,
          //                 fontFamily: 'Cairo'),
          //           )),
          //     ),
          //     Padding(
          //       padding: EdgeInsets.only(left: 22.w, top: 15.h),
          //       child: Align(
          //           alignment: Alignment.topLeft,
          //           child: Text(
          //             'مسح',
          //             style: TextStyle(
          //                 fontSize: 17.sp,
          //                 color: black,
          //                 fontFamily: 'Cairo'),
          //           )),
          //     ),
          //   ],
          // )
          //     : SizedBox(),
          Expanded(
            child: ListView.builder(
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = suggestions[index];
                  final queryText = suggestion.name?.substring(0, query.length);
                  final remainingText =
                      suggestion.name?.substring(query.length);
                  return ListTile(
                    minLeadingWidth: 5.w,
                    onTap: () {
                      query = suggestion.name!;
                      pagIndex = suggestion.pageUrl;
                      showResults(context);
                    },
                    leading: Icon(
                        //suggestions.isEmpty ? Icons.history :
                        Icons.search),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                              text: queryText,
                              style: Theme.of(context).textTheme.titleMedium,
                              children: [
                                TextSpan(
                                    text: remainingText,
                                    style: const TextStyle(color: Colors.grey)),
                              ]),
                        ),
                        Icon(
                          Icons.north_west,
                          color: grey,
                          size: 22.sp,
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    double size = MediaQuery.of(context).size.width;
    return ThemeData(
      primarySwatch: Colors.grey,
      appBarTheme: const AppBarTheme(
        backgroundColor: purple,
        iconTheme: IconThemeData(color: Colors.white),
        actionsIconTheme: IconThemeData(color: white),
        centerTitle: true,
        elevation: 15,
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(
            decoration: TextDecoration.none,
            color: Colors.white,
            fontSize: 13.sp,
            fontFamily: 'Cairo'),
        titleMedium: TextStyle(
            decoration: TextDecoration.none,
            color: Colors.black87,
            fontSize: 13.sp,
            fontFamily: 'Cairo'),
      ),
      inputDecorationTheme: InputDecorationTheme(
          isDense: true,
          filled: true,
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 15.sp,
          ),
          fillColor: Colors.white12,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(
              color: purple.withOpacity(0.6),
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(
              color: purple.withOpacity(0.6),
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(
              color: purple.withOpacity(0.6),
              width: 1.0,
            ),
          ),
          errorStyle: TextStyle(color: Colors.red, fontSize: 13.0.sp),
          contentPadding:
              EdgeInsets.only(left: size / 3, top: 5.h, bottom: 5.h)),
    );
  }

  @override
  String get searchFieldLabel => "البحث عن مشهور";

//--------------------------------------------------------------------
  getHistory() {
    return FutureBuilder<List<String>>(
      future: onSearchChanged != null ? onSearchChanged(query) : null,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          //_oldFilters=snapshot.data!;
          return ListView.builder(
            itemCount: _oldFilters.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(Icons.restore),
                title: Text("${_oldFilters[index].name}"),
                onTap: () => close(context, _oldFilters[index]),
              );
            },
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}

//get data---------------------------------------------------------------------------
