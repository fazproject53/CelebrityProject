import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:http/http.dart' as http;

class IntroData {
  bool? success;
  List<Data>? data;
  Message? message;

  IntroData({this.success, this.data, this.message});

  IntroData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    message =
        json['message'] != null ? Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (message != null) {
      data['message'] = message!.toJson();
    }
    return data;
  }
}

class Data {
  String? title;
  String? titleEn;
  String? text;
  String? textEn;
  String? image;

  Data({this.title, this.titleEn, this.text, this.textEn, this.image});

  Data.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    titleEn = json['title_en'];
    text = json['text'];
    textEn = json['text_en'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['title'] = title;
    data['title_en'] = titleEn;
    data['text'] = text;
    data['text_en'] = textEn;
    data['image'] = image;
    return data;
  }
}

class Message {
  String? en;
  String? ar;

  Message({this.en, this.ar});

  Message.fromJson(Map<String, dynamic> json) {
    en = json['en'];
    ar = json['ar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['en'] = en;
    data['ar'] = ar;
    return data;
  }
}
//-------------------------------------------------------------
Future<IntroData> getIntroData() async {
  try{
  final response =
      await http.get(Uri.parse("http://mobile.celebrityads.net/api/sliders"));

  if (response.statusCode == 200) {
    final body = response.body;
    IntroData header_ = IntroData.fromJson(jsonDecode(body));
    print("------------Reading Intro from network");
    return header_;
  } else {
    return Future.error('حدثت مشكله في السيرفر');
  }
  }catch (e) {
    if (e is SocketException) {
      return Future.error('تحقق من اتصالك بالانترنت');
    } else if (e is TimeoutException) {
      return Future.error('TimeoutException');
    } else {
      return Future.error('حدثت مشكله في السيرفر');
    }
  }
}
