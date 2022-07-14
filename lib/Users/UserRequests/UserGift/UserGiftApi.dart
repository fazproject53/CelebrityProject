import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../Celebrity/DiscountCodes/ModelDiscountCode.dart';

String serverUrl = "https://mobile.celebrityads.net/api";
Future<UserGiftOrds> getUserGift(String token) async {
  print('user UserGift token: $token');

  String url = "$serverUrl/user/GiftOrders";
  //try{
  final respons = await http.get(Uri.parse(url), headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token'
  });

  if (respons.statusCode == 200) {
    final body = respons.body;
    UserGiftOrds userAdvGiftOrds = UserGiftOrds.fromJson(jsonDecode(body));
    print('*************************************************');
    print(respons.body.runtimeType);
    print(respons.body);
    print('*************************************************');

    return userAdvGiftOrds;
  } else {
    throw Exception('Failed to load Advertising request');
  }
  //} catch (e) {
  // print(e.toString());
  //}
  //return null;
}

//------------------------------------------------------------------
class UserGiftOrds {
  bool? success;
  Data? data;
  Message? message;

  UserGiftOrds({this.success, this.data, this.message});

  UserGiftOrds.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message =
    json['message'] != null ? new Message.fromJson(json['message']) : null;
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

class Data {
  List<GiftOrders>? giftOrders;
  int? status;

  Data({this.giftOrders, this.status});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['GiftOrders'] != null) {
      giftOrders = <GiftOrders>[];
      json['GiftOrders'].forEach((v) {
        giftOrders!.add(new GiftOrders.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.giftOrders != null) {
      data['GiftOrders'] = this.giftOrders!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class GiftOrders {
  int? id;
  Celebrity? celebrity;
  User? user;
  String? date;
  Gender? adType;
  Gender? status;
  int? price;
  Occasion? occasion;
  Gender? giftType;
  String? description;
  String? from;
  String? to;
  Gender? rejectReson;

  GiftOrders(
      {this.id,
        this.celebrity,
        this.user,
        this.date,
        this.adType,
        this.status,
        this.price,
        this.occasion,
        this.giftType,
        this.description,
        this.from,
        this.to,
        this.rejectReson});

  GiftOrders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    celebrity = json['celebrity'] != null
        ? new Celebrity.fromJson(json['celebrity'])
        : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    date = json['date'];
    adType =
    json['ad_type'] != null ? new Gender.fromJson(json['ad_type']) : null;
    status =
    json['status'] != null ? new Gender.fromJson(json['status']) : null;
    price = json['price'];
    occasion = json['occasion'] != null
        ? new Occasion.fromJson(json['occasion'])
        : null;
    giftType = json['gift_type'] != null
        ? new Gender.fromJson(json['gift_type'])
        : null;
    description = json['description'];
    from = json['from'];
    to = json['to'];

    rejectReson = json['reject_reson'] != null
        ? new Gender.fromJson(json['reject_reson'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.celebrity != null) {
      data['celebrity'] = this.celebrity!.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['date'] = this.date;
    if (this.adType != null) {
      data['ad_type'] = this.adType!.toJson();
    }
    if (this.status != null) {
      data['status'] = this.status!.toJson();
    }
    data['price'] = this.price;
    if (this.occasion != null) {
      data['occasion'] = this.occasion!.toJson();
    }
    if (this.giftType != null) {
      data['gift_type'] = this.giftType!.toJson();
    }
    data['description'] = this.description;
    data['from'] = this.from;
    data['to'] = this.to;

    if (this.rejectReson != null) {
      data['reject_reson'] = this.rejectReson!.toJson();
    }
    return data;
  }
}

class Celebrity {
  int? id;
  String? username;
  String? name;
  String? image;
  String? email;
  String? phonenumber;
  Country? country;
  String? description;
  String? pageUrl;
  String? snapchat;
  String? tiktok;
  String? youtube;
  String? instagram;
  String? twitter;
  String? facebook;
  Category? category;
  String? brand;
  String? advertisingPolicy;
  String? giftingPolicy;
  String? adSpacePolicy;

  Celebrity(
      {this.id,
        this.username,
        this.name,
        this.image,
        this.email,
        this.phonenumber,
        this.country,
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

  Celebrity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    name = json['name'];
    image = json['image'];
    email = json['email'];
    phonenumber = json['phonenumber'];
    country =
    json['country'] != null ? new Country.fromJson(json['country']) : null;
    description = json['description'];
    pageUrl = json['page_url'];
    snapchat = json['snapchat'];
    tiktok = json['tiktok'];
    youtube = json['youtube'];
    instagram = json['instagram'];
    twitter = json['twitter'];
    facebook = json['facebook'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
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

class Category {
  String? name;
  String? nameEn;

  Category({this.name, this.nameEn});

  Category.fromJson(Map<String, dynamic> json) {
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

class User {
  int? id;
  String? username;
  String? name;
  String? image;
  String? email;
  String? phonenumber;
  Country? country;
  Category? city;
  Gender? gender;
  Gender? accountStatus;
  String? type;

  User(
      {this.id,
        this.username,
        this.name,
        this.image,
        this.email,
        this.phonenumber,
        this.country,
        this.city,
        this.gender,
        this.accountStatus,
        this.type});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    name = json['name'];
    image = json['image'];
    email = json['email'];
    phonenumber = json['phonenumber'];
    country =
    json['country'] != null ? new Country.fromJson(json['country']) : null;
    city = json['city'] != null ? new Category.fromJson(json['city']) : null;
    gender =
    json['gender'] != null ? new Gender.fromJson(json['gender']) : null;
    accountStatus = json['account_status'] != null
        ? new Gender.fromJson(json['account_status'])
        : null;
    type = json['type'];
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
    if (this.accountStatus != null) {
      data['account_status'] = this.accountStatus!.toJson();
    }
    data['type'] = this.type;
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

class Occasion {
  int? id;
  String? name;
  String? nameEn;
  String? image;

  Occasion({this.id, this.name, this.nameEn, this.image});

  Occasion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameEn = json['name_en'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['name_en'] = this.nameEn;
    data['image'] = this.image;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en'] = this.en;
    data['ar'] = this.ar;
    return data;
  }
}