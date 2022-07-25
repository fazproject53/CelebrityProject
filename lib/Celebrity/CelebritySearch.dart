import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Account/LoggingSingUpAPI.dart';
import 'HomeScreen/celebrity_home_page.dart';

class CelebritySearch extends SearchDelegate {
  List<String> _oldFilters = [];
  List<dynamic> allCelbrity;

  String? pagIndex;

  CelebritySearch({required this.allCelbrity
      // , required this.onSearchChanged
      })
      : super(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
        );

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
    List _results;
    _results = allCelbrity.where((name) {
      final nameLower = name.name!.toLowerCase();
      final queryLower = query.toLowerCase();
      return queryLower.compareTo(nameLower) == 0;
    }).toList();
    print(_results.length);
    return _results.length == 0
        ? Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.height / 4,
                child: Lottie.asset('assets/lottie/noSearch.json')),
          Center(child: text(context, "لاتوجد نتائج عن البحث", 15, Colors.grey)),


        ],)
        : Text('');
  }

  @override
  void showResults(BuildContext context) {
    // saveToRecentSearchesCelebrity(query);
    List _results;
    _results = allCelbrity.where((name) {
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
    getRecentSearchesCelebrity().then((value) {
      _oldFilters = value;
    });

    List listSearch = allCelbrity.where((name) {
      // print('name ${name.name}');
      final nameLower = name.name!.toLowerCase();
      final queryLower = query.toLowerCase();
      // print('nameLower  ${nameLower}');
      return nameLower.startsWith(queryLower);
    }).toList();
    return query.isEmpty && _oldFilters.isEmpty
        ? const SizedBox()
        : query.isEmpty && _oldFilters.isNotEmpty
            ? buildHistorySuggetion(context, _oldFilters)
            : buildSuggetion(listSearch);
  }

  Widget buildSuggetion(List suggestions) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
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
                    leading: const Icon(Icons.search),
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

  Widget buildHistorySuggetion(context, List suggestions) {
    print('history suggestions $suggestions');
    return suggestions.isEmpty && query == ''
        ? const SizedBox()
        : Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: [
                Row(
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
                          child: GestureDetector(
                            onTap: () {
                              // removeHistory();
                              query = '';
                              //  super.showSuggestions(context);
                              failureDialog(
                                context,
                                'هل تريد حذف سجل البحث؟',
                                "assets/lottie/Failuer.json",
                                'مسح',
                                () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  Navigator.pop(context);
                                  removeHistory();
                                  query = '';
                                  super.showSuggestions(context);
                                },
                              );
                            },
                            child: Text(
                              'مسح',
                              style: TextStyle(
                                  fontSize: 17.sp,
                                  color: black,
                                  fontFamily: 'Cairo'),
                            ),
                          )),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: suggestions.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          minLeadingWidth: 5.w,
                          // onTap: () {
                          //   query = suggestions[index];
                          //   //pagIndex = suggestions[index].;
                          //   showResults(context);
                          // },
                          leading: const Icon(Icons.history),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              text(context, suggestions[index], 15, grey!),
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
  String get searchFieldLabel => "البحث عن مشهور";

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
            color: Colors.grey[400],
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

  Future<List<String>> getRecentSearchesCelebrity() async {
    final pref = await SharedPreferences.getInstance();
    // var allSearches = pref.getString(key) ?? [];
    final allSearches = pref.getStringList("recentSearches") ?? [];
    print('allSearches= $allSearches');
    return allSearches;
  }

//save To Recent Searches Celebrity--------------------------------------------------------
  saveToRecentSearchesCelebrity(String searchText) async {
    if (searchText == null) return; //Should not be null
    final pref = await SharedPreferences.getInstance();

    //Use `Set` to avoid duplication of recentSearches
    Set<String> allSearches =
        pref.getStringList("recentSearches")?.toSet() ?? {};

    //Place it at first in the set
    allSearches = {searchText, ...allSearches};
    pref.setStringList("recentSearches", allSearches.toList());
  }

//remove history-----------------------------------------------------------------
  void removeHistory() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'recentSearches';
    bool de = await prefs.remove(key);
    print('delete history $de');
  }
}
