import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

List<int> getPagNumber = [];

class Section {
  bool? success;
  List<DataSection>? data;
  MessageSection? message;

  Section({this.success, this.data, this.message});

  Section.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <DataSection>[];
      json['data'].forEach((v) {
        data!.add(new DataSection.fromJson(v));
      });
    }
    message =
    json['message'] != null ? new MessageSection.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    return data;
  }
}

class DataSection {
  String? sectionName;
  String? title;
  String? titleEn;
  String? image;
  String? link;
  int? categoryId;
  int? active;

  DataSection(
      {this.sectionName,
        this.title,
        this.titleEn,
        this.image,
        this.link,
        this.categoryId,
        this.active});

  DataSection.fromJson(Map<String, dynamic> json) {
    sectionName = json['section_name'];
    title = json['title'];
    titleEn = json['title_en'];
    image = json['image'];
    link = json['link'];
    categoryId = json['category_id'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['section_name'] = this.sectionName;
    data['title'] = this.title;
    data['title_en'] = this.titleEn;
    data['image'] = this.image;
    data['link'] = this.link;
    data['category_id'] = this.categoryId;
    data['active'] = this.active;
    return data;
  }
}

class MessageSection {
  String? en;
  String? ar;

  MessageSection({this.en, this.ar});

  MessageSection.fromJson(Map<String, dynamic> json) {
    en = json['en'];
    ar = json['ar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en'] = this.en;
    data['ar'] = this.ar;
    return data;
  }
}

// partners =========================================================================================================================================================

class Partner {
  bool? success;
  DataPartner? data;
  MessagePartner? message;

  Partner({this.success, this.data, this.message});

  Partner.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new DataPartner.fromJson(json['data']) : null;
    message = json['message'] != null
        ? new MessagePartner.fromJson(json['message'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    return data;
  }
}

class DataPartner {
  int? active;
  List<Partners>? partners;
  int? pageCount;

  DataPartner({this.active, this.partners, this.pageCount});

  DataPartner.fromJson(Map<String, dynamic> json) {
    active = json['active'];
    if (json['partners'] != null) {
      partners = <Partners>[];
      json['partners'].forEach((v) {
        partners!.add(new Partners.fromJson(v));
      });
    }
    pageCount = json['page_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['active'] = this.active;
    if (this.partners != null) {
      data['partners'] = this.partners!.map((v) => v.toJson()).toList();
    }
    data['page_count'] = this.pageCount;
    return data;
  }
}

class Partners {
  String? link;
  String? image;

  Partners({this.link, this.image});

  Partners.fromJson(Map<String, dynamic> json) {
    link = json['link'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['link'] = this.link;
    data['image'] = this.image;
    return data;
  }
}

class MessagePartner {
  String? en;
  String? ar;

  MessagePartner({this.en, this.ar});

  MessagePartner.fromJson(Map<String, dynamic> json) {
    en = json['en'];
    ar = json['ar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en'] = this.en;
    data['ar'] = this.ar;
    return data;
  }
}

// header ============================================================================================================================================

class header {
  bool? success;
  HeaderData? data;
  HeaderMessage? message;

  header({this.success, this.data, this.message});

  header.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new HeaderData.fromJson(json['data']) : null;
    message = json['message'] != null
        ? new HeaderMessage.fromJson(json['message'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    return data;
  }
}

class HeaderData {
  int? active;
  List<Header>? header;
  int? pageCount;

  HeaderData({this.active, this.header, this.pageCount});

  HeaderData.fromJson(Map<String, dynamic> json) {
    active = json['active'];
    if (json['header'] != null) {
      header = <Header>[];
      json['header'].forEach((v) {
        header!.add(new Header.fromJson(v));
      });
    }
    pageCount = json['page_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['active'] = this.active;
    if (this.header != null) {
      data['header'] = this.header!.map((v) => v.toJson()).toList();
    }
    data['page_count'] = this.pageCount;
    return data;
  }
}

class Header {
  String? image;

  Header({this.image});

  Header.fromJson(Map<String, dynamic> json) {
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    return data;
  }
}

class HeaderMessage {
  String? en;
  String? ar;

  HeaderMessage({this.en, this.ar});

  HeaderMessage.fromJson(Map<String, dynamic> json) {
    en = json['en'];
    ar = json['ar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en'] = this.en;
    data['ar'] = this.ar;
    return data;
  }
}

// links =================================================================================================================

class link {
  bool? success;
  LinkData? data;
  LinkMessage? message;

  link({this.success, this.data, this.message});

  link.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new LinkData.fromJson(json['data']) : null;
    message = json['message'] != null
        ? new LinkMessage.fromJson(json['message'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    return data;
  }
}

class LinkData {
  int? active;
  List<Links>? links;
  int? pageCount;

  LinkData({this.active, this.links, this.pageCount});

  LinkData.fromJson(Map<String, dynamic> json) {
    active = json['active'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(new Links.fromJson(v));
      });
    }
    pageCount = json['page_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['active'] = this.active;
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v.toJson()).toList();
    }
    data['page_count'] = this.pageCount;
    return data;
  }
}

class Links {
  String? link;
  String? image;

  Links({this.link, this.image});

  Links.fromJson(Map<String, dynamic> json) {
    link = json['link'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['link'] = this.link;
    data['image'] = this.image;
    return data;
  }
}

class LinkMessage {
  String? en;
  String? ar;

  LinkMessage({this.en, this.ar});

  LinkMessage.fromJson(Map<String, dynamic> json) {
    en = json['en'];
    ar = json['ar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en'] = this.en;
    data['ar'] = this.ar;
    return data;
  }
}

// categories ====================================================================================================================================

class Category {
  bool? success;
  DataCategory? data;
  MessageCategory? message;

  Category({this.success, this.data, this.message});

  Category.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data =
        json['data'] != null ? new DataCategory.fromJson(json['data']) : null;
    message = json['message'] != null
        ? new MessageCategory.fromJson(json['message'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    return data;
  }
}

class DataCategory {
  int? pageCount;
  List<Celebrities>? celebrities;

  DataCategory({this.pageCount, this.celebrities});

  DataCategory.fromJson(Map<String, dynamic> json) {
    pageCount = json['page_count'];
    if (json['celebrities'] != null) {
      celebrities = <Celebrities>[];
      json['celebrities'].forEach((v) {
        celebrities!.add(new Celebrities.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page_count'] = this.pageCount;
    if (this.celebrities != null) {
      data['celebrities'] = this.celebrities!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Celebrities {
  int? id;
  String? username;
  String? name;
  String? image;
  String? email;
  String? phonenumber;
  Country? country;
  City? city;
  Gender? gender;
  String? description;
  String? pageUrl;
  String? snapchat;
  String? tiktok;
  String? youtube;
  String? instagram;
  String? twitter;
  String? facebook;
  City? category;
  String? brand;
  String? advertisingPolicy;
  String? giftingPolicy;
  String? adSpacePolicy;

  Celebrities(
      {this.id,
      this.username,
      this.name,
      this.image,
      this.email,
      this.phonenumber,
      this.country,
      this.city,
      this.gender,
      this.description,
      this.pageUrl,
      this.snapchat,
      this.tiktok,
      this.youtube,
      this.instagram,
      this.twitter,
      this.facebook,
      this.category,
      this.brand,
      this.advertisingPolicy,
      this.giftingPolicy,
      this.adSpacePolicy});

  Celebrities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    name = json['name'];
    image = json['image'];
    email = json['email'];
    phonenumber = json['phonenumber'];
    country =
        json['country'] != null ? new Country.fromJson(json['country']) : null;
    city = json['city'] != null ? new City.fromJson(json['city']) : null;
    gender =
        json['gender'] != null ? new Gender.fromJson(json['gender']) : null;
    description = json['description'];
    pageUrl = json['page_url'];
    snapchat = json['snapchat'];
    tiktok = json['tiktok'];
    youtube = json['youtube'];
    instagram = json['instagram'];
    twitter = json['twitter'];
    facebook = json['facebook'];
    category =
        json['category'] != null ? new City.fromJson(json['category']) : null;
    brand = json['brand'];
    advertisingPolicy = json['advertising_policy'];
    giftingPolicy = json['gifting_policy'];
    adSpacePolicy = json['ad_space_policy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['name'] = this.name;
    data['image'] = this.image;
    data['email'] = this.email;
    data['phonenumber'] = this.phonenumber;
    if (this.country != null) {
      data['country'] = this.country!.toJson();
    }
    if (this.city != null) {
      data['city'] = this.city!.toJson();
    }
    if (this.gender != null) {
      data['gender'] = this.gender!.toJson();
    }
    data['description'] = this.description;
    data['page_url'] = this.pageUrl;
    data['snapchat'] = this.snapchat;
    data['tiktok'] = this.tiktok;
    data['youtube'] = this.youtube;
    data['instagram'] = this.instagram;
    data['twitter'] = this.twitter;
    data['facebook'] = this.facebook;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    data['brand'] = this.brand;
    data['advertising_policy'] = this.advertisingPolicy;
    data['gifting_policy'] = this.giftingPolicy;
    data['ad_space_policy'] = this.adSpacePolicy;
    return data;
  }
}

class Country {
  String? name;
  String? nameEn;
  String? flag;

  Country({this.name, this.nameEn, this.flag});

  Country.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    nameEn = json['name_en'];
    flag = json['flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['name_en'] = this.nameEn;
    data['flag'] = this.flag;
    return data;
  }
}

class City {
  String? name;
  String? nameEn;

  City({this.name, this.nameEn});

  City.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    nameEn = json['name_en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['name_en'] = this.nameEn;
    return data;
  }
}

class Gender {
  int? id;
  String? name;
  String? nameEn;

  Gender({this.id, this.name, this.nameEn});

  Gender.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameEn = json['name_en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['name_en'] = this.nameEn;
    return data;
  }
}

class MessageCategory {
  String? en;
  String? ar;

  MessageCategory({this.en, this.ar});

  MessageCategory.fromJson(Map<String, dynamic> json) {
    en = json['en'];
    ar = json['ar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en'] = this.en;
    data['ar'] = this.ar;
    return data;
  }
}

// the fetch functions ===================================================================================

Future<link> fetchLinks() async {
  try {
    final response =
        await http.get(Uri.parse('http://mobile.celebrityads.net/api/links'));

    if (response.statusCode == 200) {
      final body = response.body;

      link link_ = link.fromJson(jsonDecode(body));
      print("------------Reading link from network");
      return link_;
    } else {
      return Future.error('حدثت مشكله في السيرفر');
    }
  } catch (e) {
    if (e is SocketException) {
      return Future.error('تحقق من اتصالك بالانترنت');
    } else if (e is TimeoutException) {
      return Future.error('TimeoutException');
    } else {
      return Future.error('حدثت مشكله في السيرفر');
    }
  }
}

//---------------------------------------------------------------------------
Future<header> fetchHeader() async {
  try {
    final response =
        await http.get(Uri.parse('http://mobile.celebrityads.net/api/header'));

    if (response.statusCode == 200) {
      final body = response.body;

      header header_ = header.fromJson(jsonDecode(body));
      print("Reading header from network------------");
      return header_;
    } else {
      return Future.error('حدثت مشكله في السيرفر');
    }
  } catch (e) {
    if (e is SocketException) {
      return Future.error('تحقق من اتصالك بالانترنت');
    } else if (e is TimeoutException) {
      return Future.error('TimeoutException');
    } else {
      return Future.error('حدثت مشكله في السيرفر');
    }
  }
}

//--------------------------------------------------------------------
Future<Partner> fetchPartners() async {
  try {
    final response = await http
        .get(Uri.parse('http://mobile.celebrityads.net/api/partners'));

    if (response.statusCode == 200) {
      final body = response.body;
      Partner partner = Partner.fromJson(jsonDecode(body));
      print("Reading Partners from network------------ ");
      return partner;
    } else {
      return Future.error('حدثت مشكله في السيرفر');
    }
  } catch (e) {
    if (e is SocketException) {
      return Future.error('تحقق من اتصالك بالانترنت');
    } else if (e is TimeoutException) {
      return Future.error('TimeoutException');
    } else {
      return Future.error('حدثت مشكله في السيرفر');
    }
  }
}

//------------------------------------------------------------------------
Future<Category> fetchCategories(int id, int pagNumber) async {
  try {
    final response = await http.get(Uri.parse(
        'http://mobile.celebrityads.net/api/category/celebrities/$id?page=$pagNumber'));
    if (response.statusCode == 200) {
      final body = response.body;
      Category category = Category.fromJson(jsonDecode(body));
      print("Reading category from network------------ ");
      getPagNumber.add(1);
      print(body);
      return category;
    } else {
      return Future.error('حدثت مشكله في السيرفر');
    }
  } catch (e) {
    if (e is SocketException) {
      return Future.error('تحقق من اتصالك بالانترنت');
    } else if (e is TimeoutException) {
      return Future.error('TimeoutException');
    } else {
      return Future.error('حدثت مشكله في السيرفر');
    }
  }
}
