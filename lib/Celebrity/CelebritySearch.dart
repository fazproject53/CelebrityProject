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

class CelebritySearch extends SearchDelegate {
  // onSubmitted: (String _) {
  //   widget.delegate.showResults(context);
  // },

  final List<getAllCelebrities> allCelbrity;
  List<getAllCelebrities>? listSearch;
  String? pagIndex;
  CelebritySearch(
    this.allCelbrity, {
    String hintText = "البحث عن مشهور",
  }) : super(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
          // searchFieldDecorationTheme:
        );
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
  Widget buildResults(BuildContext context) => Container(
      //child: Center(child: Text(query),),
      );

  @override
  void showResults(BuildContext context) {
    goTopagepush(
        context,
        CelebrityHome(
          pageUrl: '$pagIndex',
        ));
    print(query);
    //showSuggestions(context);
    super.showResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    listSearch = query.isEmpty
        ?
        allCelbrity
        //[]
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

  Widget buildSuggetion(List<getAllCelebrities> suggestions, {int? pagindex}) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          query.isEmpty
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 22.w, top: 15.h),
                      child: Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            "عمليات البحث الأخيرة",
                            style: TextStyle(
                                fontSize: 17.sp,
                                color: black,
                                fontFamily: 'Cairo'),
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 22.w, top: 15.h),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'مسح',
                            style: TextStyle(
                                fontSize: 17.sp,
                                color: black,
                                fontFamily: 'Cairo'),
                          )),
                    ),
                  ],
                )
              : SizedBox(),
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
                      pagIndex =suggestion.pageUrl;
                      showResults(context);
                    },
                    leading: Icon(query.isEmpty ? Icons.history : Icons.search),
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
}

//get data---------------------------------------------------------------------------
