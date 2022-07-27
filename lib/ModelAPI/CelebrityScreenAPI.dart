
class introModel {
  bool? success;
  Data? data;
  Message? message;

  introModel({this.success, this.data, this.message});

  introModel.fromJson(Map<String, dynamic> json) {
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
  Celebrity? celebrity;
  int? newsPageCount;
  List<News>? news;
  Price? prices;
  int? studioPageCount;
  List<Studio>? studio;
  List<AdSpaceOrders>? adSpaceOrders;
  int? status;

  Data(
      {this.celebrity,
        this.newsPageCount,
        this.news,
        this.studioPageCount,
        this.studio,
        this.adSpaceOrders,
        this.status,
      this.prices});

  Data.fromJson(Map<String, dynamic> json) {
    celebrity = json['celebrity'] != null
        ? new Celebrity.fromJson(json['celebrity'])
        : null;
    newsPageCount = json['news_page_count'];
    if (json['news'] != null) {
      news = <News>[];
      json['news'].forEach((v) {
        news!.add(new News.fromJson(v));
      });
    }

    prices = json['celebrity-price'] != null
        ? new Price.fromJson(json['celebrity-price'])
        : null;


    studioPageCount = json['studio_page_count'];

    if (json['studio'] != null) {
      studio = <Studio>[];
      json['studio'].forEach((v) {
        studio!.add(new Studio.fromJson(v));
      });
    }
    if (json['adSpaceOrders'] != null) {
      adSpaceOrders = <AdSpaceOrders>[];
      json['adSpaceOrders'].forEach((v) {
        adSpaceOrders!.add(new AdSpaceOrders.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.celebrity != null) {
      data['celebrity'] = this.celebrity!.toJson();
    }
    data['news_page_count'] = this.newsPageCount;
    if (this.news != null) {
      data['news'] = this.news!.map((v) => v.toJson()).toList();
    }
    data['studio_page_count'] = this.studioPageCount;
    if (this.studio != null) {
      data['studio'] = this.studio!.map((v) => v.toJson()).toList();
    }
    if (this.adSpaceOrders != null) {
      data['adSpaceOrders'] =
          this.adSpaceOrders!.map((v) => v.toJson()).toList();
    }
    if (this.prices != null) {
      data['celebrity-price'] = this.prices!.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

class Price {
  int? id;
  int? adSpacePrice;
  int? giftVoicePrice;
  int? giftImagePrice;
  int? giftVedioPrice;
  int? advertisingPriceFrom;
  int? advertisingPriceTo;

  Price(
      {this.id,
        this.adSpacePrice,
        this.giftVoicePrice,
        this.giftImagePrice,
        this.giftVedioPrice,
        this.advertisingPriceFrom,
        this.advertisingPriceTo});

  Price.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    adSpacePrice = json['ad_space_price'];
    giftVoicePrice = json['gift_voice_price'];
    giftImagePrice = json['gift_image_price'];
    giftVedioPrice = json['gift_vedio_price'];
    advertisingPriceFrom = json['advertising_price_from'];
    advertisingPriceTo = json['advertising_price_to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ad_space_price'] = this.adSpacePrice;
    data['gift_voice_price'] = this.giftVoicePrice;
    data['gift_image_price'] = this.giftImagePrice;
    data['gift_vedio_price'] = this.giftVedioPrice;
    data['advertising_price_from'] = this.advertisingPriceFrom;
    data['advertising_price_to'] = this.advertisingPriceTo;
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
  City? city;
  City? gender;
  String? description;
  String? pageUrl;
  String? snapchat;
  String? tiktok;
  String? youtube;
  String? instagram;
  String? twitter;
  String? facebook;
  String? store;
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
        this.store,
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
    city = json['city'] != null ? new City.fromJson(json['city']) : null;
    gender = json['gender'] != null ? new City.fromJson(json['gender']) : null;
    description = json['description'];
    pageUrl = json['page_url'];
    snapchat = json['snapchat'];
    tiktok = json['tiktok'];
    youtube = json['youtube'];
    instagram = json['instagram'];
    twitter = json['twitter'];
    facebook = json['facebook'];
    store = json['store'];
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
    data['store'] = this.store;
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
  int? id;
  String? name;
  String? nameEn;

  City({this.id, this.name, this.nameEn});

  City.fromJson(Map<String, dynamic> json) {
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

class News {
  int? id;
  String? description;

  News({this.id, this.description});

  News.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    return data;
  }
}

class Studio {
  int? id;
  String? title;
  String? description;
  String? image;
  String? type;
  int? likes;
  int? views;

  Studio(
      {this.id,
        this.title,
        this.description,
        this.image,
        this.type,
        this.likes,
        this.views});

  Studio.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    type = json['type'];
    likes = json['likes'];
    views = json['views'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['image'] = this.image;
    data['type'] = this.type;
    data['likes'] = this.likes;
    data['views'] = this.views;
    return data;
  }
}

class AdSpaceOrders {
  int? id;
  Celebrity? celebrity;
  User? user;
  String? date;
  City? adType;
  City? status;
  int? price;
  String? image;
  String? link;


  AdSpaceOrders(
      {this.id,
        this.celebrity,
        this.user,
        this.date,
        this.adType,
        this.status,
        this.price,
        this.image,
        this.link,
     });

  AdSpaceOrders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    celebrity = json['celebrity'] != null
        ? new Celebrity.fromJson(json['celebrity'])
        : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    date = json['date'];
    adType =
    json['ad_type'] != null ? new City.fromJson(json['ad_type']) : null;
    status = json['status'] != null ? new City.fromJson(json['status']) : null;
    price = json['price'];
    image = json['image'];
    link = json['link'];

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
    data['image'] = this.image;
    data['link'] = this.link;

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
  City? city;
  Null? gender;
  City? accountStatus;
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
    city = json['city'] != null ? new City.fromJson(json['city']) : null;
    gender = json['gender'];
    accountStatus = json['account_status'] != null
        ? new City.fromJson(json['account_status'])
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
    data['gender'] = this.gender;
    if (this.accountStatus != null) {
      data['account_status'] = this.accountStatus!.toJson();
    }
    data['type'] = this.type;
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