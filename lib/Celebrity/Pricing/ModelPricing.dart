class Pricing {
  bool? success;
  Data? data;
  Message? message;

  Pricing({this.success, this.data, this.message});

  Pricing.fromJson(Map<String, dynamic> json) {
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
  Price? price;
  List<Comments>? comments;
  int? status;

  Data({this.price, this.comments, this.status});

  Data.fromJson(Map<String, dynamic> json) {
    price = json['price'] != null ? new Price.fromJson(json['price']) : null;
    if (json['comments'] != null) {
      comments = <Comments>[];
      json['comments'].forEach((v) {
        comments!.add(new Comments.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.price != null) {
      data['price'] = this.price!.toJson();
    }
    if (this.comments != null) {
      data['comments'] = this.comments!.map((v) => v.toJson()).toList();
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

class Comments {
  int? id;
  String? name;
  String? value;
  String? valueEn;

  Comments({this.id, this.name, this.value, this.valueEn});

  Comments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    value = json['value'];
    valueEn = json['value_en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['value'] = this.value;
    data['value_en'] = this.valueEn;
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