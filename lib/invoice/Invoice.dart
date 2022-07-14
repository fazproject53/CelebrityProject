import 'package:celepraty/Celebrity/Requests/Gift/GiftApi.dart';

import '../Celebrity/blockList.dart';

class InvoiceModel {
  bool? success;
  Data? data;
  Message? message;

  InvoiceModel({this.success, this.data, this.message});

  InvoiceModel.fromJson(Map<String, dynamic> json) {
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
  List<Billings>? billings;
  int? status;
  String? taxnumber;
  String? phone;

  Data({this.billings, this.status, this.phone, this.taxnumber});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['billings'] != null) {
      billings = <Billings>[];
      json['billings'].forEach((v) {
        billings!.add(new Billings.fromJson(v));
      });
    }
    status = json['status'];
    taxnumber = json["tax-number"];
    phone = json['phone-number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.billings != null) {
      data['billings'] = this.billings!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['phone-number'] = this.phone;
    data['tax-number'] = this.taxnumber;
    return data;
  }
}

class Billings {
  int? id;
  String? billingId;
  Celebrity? celebrity;
  User? user;
  String? date;
  Gender? adType;
  Order? order;
  Gender? paymentMehtod;
  int? price;
  String? priceAfterTax;

  Billings(
      {this.id,
        this.billingId,
        this.celebrity,
        this.user,
        this.date,
        this.adType,
        this.order,
        this.paymentMehtod,
        this.price,
        this.priceAfterTax});

  Billings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    billingId = json['billing_id'];
    celebrity = json['celebrity'] != null
        ? new Celebrity.fromJson(json['celebrity'])
        : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    date = json['date'];
    adType =
    json['ad_type'] != null ? new Gender.fromJson(json['ad_type']) : null;
    order = json['order'] != null ? new Order.fromJson(json['order']) : null;
    paymentMehtod = json['payment_mehtod'] != null
        ? new Gender.fromJson(json['payment_mehtod'])
        : null;
    price = json['price'];
    priceAfterTax = json['price_after_tax'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['billing_id'] = this.billingId;
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
    if (this.order != null) {
      data['order'] = this.order!.toJson();
    }
    if (this.paymentMehtod != null) {
      data['payment_mehtod'] = this.paymentMehtod!.toJson();
    }
    data['price'] = this.price;
    data['price_after_tax'] = this.priceAfterTax;
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
  //City? city;
  Gender? gender;
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
        //this.city,
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

  Celebrity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    name = json['name'];
    image = json['image'];
    email = json['email'];
    phonenumber = json['phonenumber'];
    country =
    json['country'] != null ? new Country.fromJson(json['country']) : null;
   // city = json['city'] != null ? new City.fromJson(json['city']) : null;
    gender = json['gender'] != null ? new Gender.fromJson(json['gender']) : null;
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
    //data['city'] = this.city;
    data['gender'] = this.gender;
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

class Order {
  int? id;
  Celebrity? celebrity;
  User? user;
  String? date;
  Gender? adType;
  Gender? status;
  Gender? giftType;
  int? price;
  String? description;
  Null? celebrityPromoCode;
  Gender? adOwner;
  Gender? advertisingAdType;
  Gender? adFeature;
  Gender? adTiming;
  String? file;
  Occasion? occation;
  String? advertisingName;
  String? advertisingLink;
  Gender? platform;
  Null? rejectReson;

  Order(
      {this.id,
        this.celebrity,
        this.user,
        this.date,
        this.adType,
        this.status,
        this.price,
        this.description,
        this.celebrityPromoCode,
        this.adOwner,
        this.advertisingAdType,
        this.adFeature,
        this.adTiming,
        this.file,
        this.occation,
        this.giftType,
        this.advertisingName,
        this.advertisingLink,
        this.platform,
        this.rejectReson});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    celebrity = json['celebrity'] != null
        ? new Celebrity.fromJson(json['celebrity'])
        : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    date = json['date'];
    adType =
    json['ad_type'] != null ? new Gender.fromJson(json['ad_type']) : null;
    giftType =
    json['gift_type'] != null ? new Gender.fromJson(json['gift_type']) : null;
    status =
    json['status'] != null ? new Gender.fromJson(json['status']) : null;
    price = json['price'];
    description = json['description'];
    celebrityPromoCode = json['celebrity_promo_code'];
    adOwner =
    json['ad_owner'] != null ? new Gender.fromJson(json['ad_owner']) : null;
    advertisingAdType = json['advertising_ad_type'] != null
        ? new Gender.fromJson(json['advertising_ad_type'])
        : null;
    adFeature = json['ad_feature'] != null
        ? new Gender.fromJson(json['ad_feature'])
        : null;
    adTiming = json['ad_timing'] != null
        ? new Gender.fromJson(json['ad_timing'])
        : null;
    occation = json['occasion'] != null
        ? new Occasion.fromJson(json['occasion'])
        : null;
    file = json['file'];
    advertisingName = json['advertising_name'];
    advertisingLink = json['advertising_link'];
    platform =
    json['platform'] != null ? new Gender.fromJson(json['platform']) : null;

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
    if (this.giftType != null) {
      data['gift_type'] = this.giftType!.toJson();
    }
    if (this.status != null) {
      data['status'] = this.status!.toJson();
    }
    data['price'] = this.price;
    data['description'] = this.description;
    data['celebrity_promo_code'] = this.celebrityPromoCode;
    if (this.adOwner != null) {
      data['ad_owner'] = this.adOwner!.toJson();
    }
    if (this.advertisingAdType != null) {
      data['advertising_ad_type'] = this.advertisingAdType!.toJson();
    }
    if (this.adFeature != null) {
      data['ad_feature'] = this.adFeature!.toJson();
    }
    if (this.adTiming != null) {
      data['ad_timing'] = this.adTiming!.toJson();
    }
    if (this.occation != null) {
      data['occasion'] = this.occation!.toJson();
    }
    data['file'] = this.file;
    data['advertising_name'] = this.advertisingName;
    data['advertising_link'] = this.advertisingLink;
    if (this.platform != null) {
      data['platform'] = this.platform!.toJson();
    }
    data['reject_reson'] = this.rejectReson;
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