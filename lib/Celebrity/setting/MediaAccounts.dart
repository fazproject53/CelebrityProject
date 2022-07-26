class Media {
  bool? success;
  Data? data;
  Message? message;

  Media({this.success, this.data, this.message});

  Media.fromJson(Map<String, dynamic> json) {
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
  int? status;
  String? facebook;
  String? snapchat;
  String? twitter;
  String? instagram;
  String? tiktok;

  Data(
      {this.status,
        this.facebook,
        this.snapchat,
        this.twitter,
        this.instagram,
        this.tiktok});

  Data.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    facebook = json['facebook'];
    snapchat = json['snapchat'];
    twitter = json['twitter'];
    instagram = json['instagram'];
    tiktok = json['tiktok'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['facebook'] = this.facebook;
    data['snapchat'] = this.snapchat;
    data['twitter'] = this.twitter;
    data['instagram'] = this.instagram;
    data['tiktok'] = this.tiktok;
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
